echo ====================
echo ==  ICARUS SERVER ==
echo ====================

echo Server Name : $SERVERNAME
echo Game Port   : $SERVER_PORT
echo Query Port  : $QUERY_PORT
echo Container UID   : $(id -u)
echo Container GID   : $(id -g)

echo ====================
export WINEPREFIX=/home/container/icarus
export WINEARCH=win64
export WINEPATH=/home/container/game/icarus

echo Initializing Wine...
wineboot --init > /dev/null 2>&1

echo ==============================================================
echo Updating/downloading game through steam
echo ==============================================================
./steamcmd/steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir /home/container/game/icarus \
    +login anonymous \
    +app_update 2089300 \
    +quit

echo ==============================================================
echo Testing for files
echo ==============================================================
if [ ! -f "./game/icarus/Icarus/Binaries/Win64/IcarusServer-Win64-Shipping.exe" ]; then
  echo Install not found, check internet and volume permissions
  exit
fi

echo ==============================================================
echo Starting Server - Buckle up prospectors!
echo ==============================================================
# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
wine ./game/icarus/Icarus/Binaries/Win64/${MODIFIED_STARTUP}
#wine ./game/icarus/Icarus/Binaries/Win64/IcarusServer-Win64-Shipping.exe -Log -UserDir='C:\icarus' -SteamServerName="${SERVERNAME}" -PORT="${PORT}" -QueryPort="${QUERYPORT}"
