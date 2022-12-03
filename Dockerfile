FROM ubuntu:22.04

# Default Environment Vars
ENV SERVERNAME="Icarus Server"
ENV PORT=17777
ENV QUERYPORT=27015
# Required for Wine to install vc_redist
ENV WINEPREFIX=/home/steam/vcredist
ENV WINEARCH=win32
ENV WINEPATH=/
# Default User/Group ID
ENV STEAM_USERID=1000
ENV STEAM_GROUPID=1000

# Get prereq packages
RUN dpkg --add-architecture i386
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    ca-certificates \
    lib32gcc-s1 \
    sudo \
    curl \
    wget \
    gnupg2 \
    software-properties-common \
    xvfb \
    wine \
    wine32 \
    wine64

# Create various folders
RUN mkdir -p /root/icarus/drive_c/icarus \ 
             /game/icarus \
             /home/steam/steamcmd \
             /home/steam/vcredist

# Download and install vc redist 2022
RUN wget https://aka.ms/vs/17/release/vc_redist.x64.exe
RUN chmod +x vc_redist.x64.exe
RUN wineboot --init && \
    sleep 5 && \
    xvfb-run -a wine vc_redist.x64.exe /quiet /norestart

# Copy run script
COPY runicarus.sh /
RUN chmod +x /runicarus.sh

# Create Steam user

RUN groupadd -g "${STEAM_GROUPID}" steam \
  && useradd --create-home --no-log-init -u "${STEAM_USERID}" -g "${STEAM_GROUPID}" steam
RUN chown -R "${STEAM_USERID}":"${STEAM_GROUPID}" /home/steam
RUN chown -R "${STEAM_USERID}":"${STEAM_GROUPID}" /game/icarus
RUN chown -R "${STEAM_USERID}":"${STEAM_GROUPID}" /tmp/wine*

# Install SteamCMD
RUN curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C /home/steam/steamcmd -zx

ENTRYPOINT ["/bin/bash"]
CMD ["/runicarus.sh"]