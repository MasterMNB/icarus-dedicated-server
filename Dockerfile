FROM ubuntu:22.04

# Get prereq packages
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    ca-certificates \
    lib32gcc-s1 \
    curl \
    wget \
    gnupg2 \
    software-properties-common \
    xvfb

# Install Wine
RUN dpkg --add-architecture i386
RUN wget -O /usr/share/keyrings/winehq.key https://dl.winehq.org/wine-builds/winehq.key 
RUN apt-key add /usr/share/keyrings/winehq.key
RUN add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ impish main' -y

RUN apt-get update \
    && apt install --install-recommends winehq-stable -y

# Install steamcmd
RUN useradd --home-dir /home/steam --create-home steam
RUN mkdir -p /home/steam/steamcmd
RUN curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C /home/steam/steamcmd -zx
RUN chown -R steam:steam /home/steam

# Update steamcmd

RUN mkdir /home/steam/steamcmd/game
RUN mkdir /game
RUN mkdir /data
RUN chown -R steam:steam /game
RUN chown -R steam:steam /data
RUN ln -s /home/steam/steamcmd /game 

USER steam
RUN /home/steam/steamcmd/steamcmd.sh +quit

# Install Icarus Dedicated Server
RUN /home/steam/steamcmd/steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir /game/icarus \
    +login anonymous \
    +app_update 2089300 validate \
    +quit

USER root

COPY runicarus.sh .
RUN chmod +x /runicarus.sh

ENTRYPOINT ["/bin/bash"]
CMD ["/runicarus.sh"]