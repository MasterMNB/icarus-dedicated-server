echo ====================
echo ==  ICARUS SERVER ==
echo ====================

echo Server Name: %SERVERNAME
echo Game Port  : %PORT
echo Query Port : %QUERYPORT

export WINEPREFIX=/root/icarus
export WINEARCH=win64
export WINEPATH=/game/icarus

echo ==============================================================
echo Initialization of Wine
echo ==============================================================
wineboot --init > /dev/null 2>&1

echo ==============================================================
echo Updating/downloading game through steam
echo ==============================================================
/home/steam/steamcmd/steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir /game/icarus \
    +login anonymous \
    +app_update 2089300 \
    +quit
    
echo ==============================================================
echo Starting Server - Buckle up prospectors!
echo ==============================================================
xvfb-run -a wine /game/icarus/Icarus/Binaries/Win64/IcarusServer-Win64-Shipping.exe -Log -UserDir='C:\icarus' -SteamServerName="$SERVERNAME" -PORT="$PORT" -QueryPort="$QUERYPORT"