FROM ubuntu:22.04

# Get prereq packages
RUN dpkg --add-architecture i386
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    ca-certificates \
    lib32gcc-s1 \
    curl \
    wget \
    gnupg2 \
    software-properties-common \
    xvfb \
    wine \
    wine32 \
    wine64

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

# Download and install vc redist 2022
RUN wget https://aka.ms/vs/17/release/vc_redist.x64.exe
RUN chmod +x vc_redist.x64.exe

ENV WINEPREFIX=/root/vcredist
ENV WINEARCH=win32
ENV WINEPATH=/

RUN mkdir -p /root/vcredist
RUN wineboot --init ; sleep 5 ; xvfb-run -a wine vc_redist.x64.exe /quiet /norestart

# Copy run script
COPY runicarus.sh .
RUN chmod +x /runicarus.sh

# Create Icarus Saves folder
RUN mkdir -p /root/icarus/drive_c/icarus

CMD ["/runicarus.sh"]