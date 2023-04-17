echo ====================
echo ==  ICARUS SERVER ==
echo ====================

echo Server Name : $SERVERNAME
echo Max Players : $MAX_PLAYERS
echo Game Port   : $SERVER_PORT
echo Query Port  : $QUERY_PORT
echo Branch      : $BRANCH
echo Auto update : $AUTOUPDATE
echo Container UID   : $(id -u)
echo Container GID   : $(id -g)

echo ====================
echo Initializing Wine...
wineboot --init > /dev/null 2>&1

echo ==============================================================
echo Updating/downloading game through steam
echo ==============================================================
./steamcmd/steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir /home/container/game/icarus \
    +login "${STEAMUSER}" "${STEAMPASS}" \
    +app_update "${APPID}" -beta "${BRANCH}" validate \
    +quit

echo ==============================================================
echo Testing for files
echo ==============================================================
if [ ! -f "${WINEPATH}/Icarus/Binaries/Win64/IcarusServer-Win64-Shipping.exe" ]; then
  echo Install not found, check internet and volume permissions
  exit
fi

rm -f ${HOME}/pid.file

configPath="${WINEPREFIX}/drive_c/icarus/Saved/Config/WindowsServer"
echo ==============================================================
echo Writing Async Timeout value in Engine.ini to echo $ASYNC_TIMEOUT
echo ==============================================================
if [[ ! -e ${configPath}/Engine.ini ]]; then
  mkdir -p ${configPath}
  touch ${configPath}/Engine.ini
fi

if ! grep -Fxq "[OnlineSubsystemSteam]" ${configPath}/Engine.ini
then
    echo '[OnlineSubsystemSteam]' >> ${configPath}/Engine.ini
    echo 'AsyncTaskTimeout=' >> ${configPath}/Engine.ini
fi

sedCommand='/AsyncTaskTimeout=/c\AsyncTaskTimeout='${ASYNC_TIMEOUT}
sed -i ${sedCommand} ${configPath}/Engine.ini

echo ==============================================================
echo Writing settings  in ServerSettings.ini
echo ==============================================================
settings_file=${configPath}/ServerSettings.ini
if [[ ! -e ${settings_file} ]]; then
  mkdir -p ${configPath}
  touch ${settings_file}
fi

# Declare array of settings
# More infos = https://github.com/RocketWerkz/IcarusDedicatedServer/wiki/Server-Config-&-Launch-Parameters
settings=(
"SessionName=${SERVERNAME}" #This setting currently does nothing, use the -SteamServerName commandline
"JoinPassword=${JOIN_PASSWORD}"
"MaxPlayers=${MAX_PLAYERS}"
"AdminPassword=${ADMIN_PASSWORD}"
"ResumeProspect=${RESUME_PROSPECT}"
"LastProspectName=${LAST_PROSPECT_NAME}"
"LoadProspect=${LOAD_PROSPECT}"
"CreateProspect=${CREATE_PROSPECT}"
"ShutdownIfNotJoinedFor=${SHUTDOWN_NOT_JOINED_FOR}"
"ShutdownIfEmptyFor=${SHUTDOWN_EMPTY_FOR}"
"AllowNonAdminsToLaunchProspects=${NON_ADMINS_LAUNCH}"
"AllowNonAdminsToDeleteProspects=${NON_ADMINS_ABORT}"
)
# Empty the file and write settings
printf "[/Script/Icarus.DedicatedServerSettings]\r\n" > $settings_file
printf "%s\r\n" "${settings[@]}" | grep "=" | grep -v "=\s*$" | awk -v file="$settings_file" '{if(!a[$1]++) print >> file; a[$1]=$0}'

echo ==============================================================
echo Starting Server - Buckle up prospectors!
echo ==============================================================
# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":${HOME}$ ${MODIFIED_STARTUP}"

# turn on bash's job control
set -m

# Run the Server
${MODIFIED_STARTUP} &
echo $! >${HOME}/pid.file &
/update.sh

# bring the primary process back into the foreground
fg %1
