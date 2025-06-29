#!/bin/bash

PWD=$(pwd)

# Update system
sudo yum update -y

# Enable Docker in Amazon Linux Extras and install it
sudo amazon-linux-extras enable docker
sudo yum install -y docker

# Start Docker service
sudo service docker start

# Enable Docker to start on boot
sudo systemctl enable docker

# Add current user to the docker group
sudo usermod -aG docker $USER

# Install Docker Compose (latest stable version)
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -oP '"tag_name": "\K[^"]+')
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version

echo "✅ Docker and Docker Compose installed successfully."
echo "ℹ️ Please log out and log back in for group changes to take effect (or run: newgrp docker)."

sudo yum install -y git

newgrp docker

echo $TOKEN > ./DSTClusterConfig/cluster_token.txt

sudo ./init-systemd.sh
