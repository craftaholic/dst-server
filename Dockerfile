FROM ubuntu:latest

# Create specific user to run DST server
RUN useradd -ms /bin/bash/ dst
WORKDIR /home/dst

# Install required packages
RUN set -x && \
  dpkg --add-architecture i386 && \
  apt-get update && apt-get upgrade -y && \
  apt-get install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 wget && \
  chown -R dst:dst ./ && \
  # Cleanup
  apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ./steamcmd/ && \
  cd ./steamcmd/ && \
  wget "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" && \
  tar -xvzf steamcmd_linux.tar.gz && \
  chown -R dst:dst ./

COPY . .

USER dst
RUN ./steamcmd/steamcmd.sh \
  +force_install_dir "/home/dst/dontstarvetogether_dedicated_server" \
  +@ShutdownOnFailedCommand 1 \
  +@NoPromptForPassword 1 \
  +login anonymous \
  +app_update 343050 validate \
  +quit

ENTRYPOINT ["/home/dst/run-dedicated-server.sh"]
