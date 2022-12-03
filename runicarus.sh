echo ====================
echo ==  ICARUS SERVER ==
echo ====================

echo Server Name : $SERVERNAME
echo Game Port   : $PORT
echo Query Por   : $QUERYPORT
echo Steam UID   : $STEAM_USERID
echo Steam GID   : $STEAM_GROUPID

groupmod -g "${STEAM_GROUPID}" steam \
  && usermod -u "${STEAM_USERID}" -g "${STEAM_GROUPID}" steam

export WINEPREFIX=/home/steam/icarus
export WINEARCH=win64
export WINEPATH=/game/icarus

echo ''
echo Initializing Wine...
echo ''
sudo -u steam wineboot --init > /dev/null 2>&1

echo ==============================================================
echo Updating/downloading game through steam
echo ==============================================================
sudo -u steam /home/steam/steamcmd/steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir /game/icarus \
    +login anonymous \
    +app_update 2089300 \
    +quit

echo ==============================================================
echo Starting Server - Buckle up prospectors!
echo ==============================================================
sudo -u steam wine /game/icarus/Icarus/Binaries/Win64/IcarusServer-Win64-Shipping.exe -Log -UserDir='C:\icarus' -SteamServerName="${SERVERNAME}" -PORT="${PORT}" -QueryPort="${QUERYPORT}"