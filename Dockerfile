FROM ubuntu:22.04

# Default Environment Vars
ENV SERVERNAME=IcarusServer
ENV PORT=17777
ENV QUERYPORT=27015

# Create Steam, Icarus Server and Saves folder
RUN mkdir -p /root/icarus/drive_c/icarus \ 
             /game/icarus \
             /home/steam/steamcmd

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
RUN curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C /home/steam/steamcmd -zx
RUN chown -R steam:steam /home/steam

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

CMD ["/runicarus.sh"]