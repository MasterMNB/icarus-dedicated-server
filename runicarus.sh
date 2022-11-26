export WINEPREFIX=/root/icarus
export WINEARCH=win64
export WINEPATH=/game/icarus
wineboot --init

if [[ -z "$SERVERNAME" ]]; then
  SERVERNAME_VAR="My Icarus Dedicated Server"
else
  SERVERNAME_VAR="$SERVERNAME"
fi

if [[ -z "$PORT" ]]; then
  PORT_VAR="17777"
else
  PORT_VAR="$PORT"
fi

if [[ -z "$QUERYPORT" ]]; then
  QUERYPORT_VAR="27015"
else
  QUERYPORT_VAR="$QUERYPORT"
fi

/home/steam/steamcmd/steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir /game/icarus \
    +login anonymous \
    +app_update 2089300 \
    +quit

xvfb-run -a wine /game/icarus/Icarus/Binaries/Win64/IcarusServer-Win64-Shipping.exe -Log -UserDir='C:\icarus' -SteamServerName="$SERVERNAME_VAR" -PORT="$PORT_VAR" -QueryPort="$QUERYPORT_VAR"