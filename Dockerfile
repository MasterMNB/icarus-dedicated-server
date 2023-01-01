FROM ubuntu:22.04

# Default Environment Vars
ENV USER=container HOME=/home/container

# Get prereq packages
RUN dpkg --add-architecture i386
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    ca-certificates \
    lib32gcc-s1 \
    curl \
    gnupg2 \
    software-properties-common \
    wine \
    wine64

RUN adduser -D -h /home/container container

USER container
WORKDIR /home/container

# Create various folders
RUN mkdir -p /root/icarus/drive_c/icarus \
             ./game/icarus

# Copy run script
COPY ./runicarus.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Install SteamCMD
RUN curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C /home/container/steamcmd -zx

CMD ["/bin/bash", "/runicarus.sh"]
