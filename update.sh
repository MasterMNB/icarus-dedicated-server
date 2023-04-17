#wait until server started
while ! [ -f ${HOME}/pid.file ] ; do
    sleep 5
done

#check server version every hour
interval=3600
while [[ "${AUTOUPDATE}" -eq "1" ]] ; do
    now=$(date +%s) # timestamp in seconds
    sleep $((interval - now % interval))

    localversion=$(grep buildid "/home/container/game/icarus/steamapps/appmanifest_${APPID}.acf" | tr '[:blank:]"' ' ' | tr -s ' ' | cut -d\  -f3)
    remoteversion=$(/home/container/steamcmd/steamcmd.sh +login "${STEAMUSER}" "${STEAMPASS}" +app_info_update 1 +app_info_print "${APPID}" +quit | sed -e '/"branches"/,/^}/!d' | sed -n "/\"${BRANCH}\"/,/}/p" | grep -m 1 buildid | tr -cd '[:digit:]')

    echo "Version check"
    echo "Local version: "${localversion}
    echo "Remote version:"${remoteversion}

    if [[ $localversion == +([0-9]) ]] && [[ ${remoteversion} == +([0-9]) ]] && ! [ "$localversion" -eq "$remoteversion" ]  ; then
      echo "restart-container"
      kill `cat ${HOME}/pid.file`
      break
    fi
done