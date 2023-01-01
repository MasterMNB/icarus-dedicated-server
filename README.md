# icarus-dedicated-server for pterodactyl still in DEV STATE!
This dedicated server will automatically download/update to the latest available server version when started. The dedicated server runs in Ubuntu 22.04 and wine

### Pterodactyl config
[Help here](https://pterodactyl.io/community/config/eggs/creating_a_custom_egg.html)

### Environment Vars
- SERVERNAME : The name of the server on the server browser (You must specify this, the SessionName in the ServerSettings.ini file is always ignored)
- SERVER_PORT : The game port (not specifying it will default to 17777)
- QUERY_PORT : The query port (not specifying it will default to 27015)

### Ports
The server requires 2 UDP Ports, the game port (Default 17777) and the query port (Default 27015)
They can be changed by specifying the PORT and QUERYPORT env vars respectively.

### Volumes
- The server binaries are stored at /home/container/game/icarus
- The server saves are stored at /home/container/.wine/drive_c/icarus

## IF you want to start it without Pterodactyl

### Example Docker Run
```
docker run -p 17777:17777/udp -p 27015:27015/udp -v data:/home/container/.wine/drive_c/icarus -v game:/home/container/game/icarus -e SERVERNAME=AmazingServer mastermnb/icarus-dedicated-server-dev:latest
```
### Example Docker Compose
```
version: "3.8"

services:
 
  icarus:
    container_name: icarus-dedicated
    image: mastermnb/icarus-dedicated-server-dev:latest
    hostname: icarus-dedicated
    init: true
    restart: "unless-stopped"
    networks:
      host:
    ports:
      - 17777:17777/udp
      - 27015:27015/udp
    volumes:
      - data:/home/container/.wine/drive_c/icarus
      - game:/home/container/game/icarus
    environment:
      - SERVERNAME=AmazingServer
      - SERVER_PORT=17777
      - QUERY_PORT=27015
volumes:
  data: {}
  game: {}
 
networks:
  host: {}
```

### Config
Under the data volume in the file:  
Saved\Config\WindowsServer\ServerSettings.ini  
More Infos to configure:  
https://github.com/RocketWerkz/IcarusDedicatedServer/wiki/Server-Config-&-Launch-Parameters

## KNOWN ISSUES
There is currently an issue with connections to steam to register the server in the in-game browser.
This is not something that I can fix, RocketWerkz will need to make the steam server creation timeout higher or configurable before this will work reliably.
If your server is not appearing in the list, check the logs, if you have the following message then this issue may be affecting you.
**LogOnline: Warning: OSS: Async task 'FOnlineAsyncTaskSteamCreateServer bWasSuccessful: 0' failed in 15.016910 seconds**
This issue occurs more often with lower end hardware.

## License
MIT License
