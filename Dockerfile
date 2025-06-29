FROM ubuntu:latest

# Create specific user to run DST server
RUN useradd -ms /bin/bash/ dst
WORKDIR /home/dst

# Install required packages
RUN set -x && \
  dpkg --add-architecture i386 && \
  apt-get update && apt-get upgrade -y && \
  apt-get install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 wget && \
  # Download Steam CMD (https://developer.valvesoftware.com/wiki/SteamCMD#Downloading_SteamCMD)
  wget -q -O - "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - && \
  chown -R dst:dst ./ && \
  # Cleanup
  apt-get autoremove --purge -y wget && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

USER dst

ENTRYPOINT ["/home/dst/run-dedicated-server.sh"]
