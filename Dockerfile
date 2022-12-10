FROM ubuntu:22.04

# Default Environment Vars
ENV SERVERNAME="Icarus Server"
ENV PORT=17777
ENV QUERYPORT=27015
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
    wine \
    wine64

# Create various folders
RUN mkdir -p /root/icarus/drive_c/icarus \ 
             /game/icarus \
             /home/steam/steamcmd

# Copy run script
COPY runicarus.sh /
RUN chmod +x /runicarus.sh

# Create Steam user
RUN groupadd -g "${STEAM_GROUPID}" steam \
  && useradd --create-home --no-log-init -u "${STEAM_USERID}" -g "${STEAM_GROUPID}" steam
RUN chown -R "${STEAM_USERID}":"${STEAM_GROUPID}" /home/steam
RUN chown -R "${STEAM_USERID}":"${STEAM_GROUPID}" /game/icarus

# Install SteamCMD
RUN curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C /home/steam/steamcmd -zx

ENTRYPOINT ["/bin/bash"]
CMD ["/runicarus.sh"]