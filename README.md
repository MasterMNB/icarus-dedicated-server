# icarus-dedicated-server
This dedicated server will automatically download/update to the latest available server version when started. The dedicated server runs in Ubuntu 22.04 and wine
[GIT REPO HERE](https://gitlab.com/fred-beauch/icarus-dedicated-server)

## Environment Vars
- SERVERNAME : The name of the server on the server browser (You must specify this, the SessionName in the ServerSettings.ini file is always ignored)
- PORT : The game port (not specifying it will default to 17777)
- QUERYPORT : The query port (not specifying it will default to 27015)

## Ports
The server requires 2 UDP Ports, the game port (Default 17777) and the query port (Default 27015)
They can be changed by specifying the PORT and QUERYPORT env vars respectively.

## Volumes
- The server binaries are stored at /game/icarus
- The server saves are stored at /root/icarus/drive_c/icarus

## Example Docker Run
```
docker run -p 17777:17777/udp -p 27015:27015/udp -v data:/root/icarus/drive_c/icarus -v game:/game/icarus nerodon/icarus-dedicated:latest
```
## Example Docker Compose
```
version: "3.8"

services:
 
  icarus:
    container_name: icarus-dedicated
    image: nerodon/icarus-dedicated:latest
    hostname: icarus-dedicated
    init: true
    restart: "unless-stopped"
    networks:
      host:
    ports:
      - 17777:17777/udp
      - 27015:27015/udp
    volumes:
      - data:/root/icarus/drive_c/icarus
      - game:/game/icarus
    environment:
      - SERVERNAME=AmazingServer
      - PORT=17777
      - QUERYPORT=27015
volumes:
  data: {}
  game: {}
 
networks:
  host: {}
```

## License
MIT License
