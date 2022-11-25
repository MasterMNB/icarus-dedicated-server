export WINEPREFIX=/root/icarus
export WINEARCH=win64
export WINEPATH=/game/icarus
wineboot --init

/home/steam/steamcmd/steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir /game/icarus \
    +login anonymous \
    +app_update 2089300 \
    +quit

xvfb-run -a wine /game/icarus/Icarus/Binaries/Win64/IcarusServer-Win64-Shipping.exe -Log -UserDir='C:\icarus' -SteamServerName="$SERVERNAME" -PORT="$PORT" -QueryPort="$QUERYPORT"