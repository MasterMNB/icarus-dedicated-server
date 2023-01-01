FROM ubuntu:22.04

# Default Environment Vars
ENV SERVERNAME="Icarus Server"
ENV SERVER_PORT=17777
ENV QUERY_PORT=27015
ENV USER=container HOME=/home/container
ENV STARTUP='IcarusServer-Win64-Shipping.exe -Log -UserDir="C:\icarus" -SteamServerName="${SERVERNAME}" -PORT="${PORT}" -QueryPort="${QUERYPORT}"'

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

# Copy run script
COPY ./runicarus.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ADD USER
RUN useradd --no-log-init -ms /bin/bash container

# Switch USER
USER container
WORKDIR /home/container

# Create folders
RUN mkdir -p ./game/icarus; \
    mkdir -p ./steamcmd

# Install SteamCMD
RUN curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C /home/container/steamcmd -zx

CMD ["/bin/bash", "/runicarus.sh"]
