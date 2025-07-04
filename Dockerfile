FROM debian:latest

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
  tar -xvzf steamcmd_linux.tar.gz

COPY ./run-dedicated-server.sh /home/dst/run-dedicated-server.sh

RUN chown -R dst:dst /home/dst 

USER dst

ENTRYPOINT ["/home/dst/run-dedicated-server.sh"]
