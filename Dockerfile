FROM ubuntu:22.04

# Default Environment Vars
ENV SERVERNAME="Icarus Server"
ENV SERVER_PORT=17777
ENV QUERY_PORT=27015
ENV ASYNC_TIMEOUT=60
ENV BRANCH=public

ENV USER=container
ENV HOME=/home/${USER}

ENV WINEARCH=win64
ENV WINEPATH=${HOME}/game/icarus
ENV WINEPREFIX=${HOME}/icarus

ENV STARTUP='wine ${WINEPATH}/Icarus/Binaries/Win64/IcarusServer-Win64-Shipping.exe -Log -UserDir="C:\icarus" -SteamServerName="${SERVERNAME}" -PORT="${SERVER_PORT}" -QueryPort="${QUERY_PORT}"'

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
    wine64 \
    && rm -rf /var/lib/apt/lists/*

# Copy run script
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ADD USER
RUN useradd --no-log-init -ms /bin/bash container

# Switch USER
USER container
WORKDIR /home/container

# Create folders
RUN mkdir -p ${WINEPATH}; \
    mkdir -p ${WINEPREFIX}/drive_c/icarus; \
    mkdir -p ./steamcmd

# Install SteamCMD
RUN curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C /home/container/steamcmd -zx

CMD ["/bin/bash", "/entrypoint.sh"]
