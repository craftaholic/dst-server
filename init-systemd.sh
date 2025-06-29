#!/bin/bash

SERVICE_NAME=dst
COMPOSE_BIN=/usr/local/bin/docker-compose  # Change if using `docker compose` plugin

# Create systemd unit file
sudo tee /etc/systemd/system/${SERVICE_NAME}.service > /dev/null <<EOF
[Unit]
Description=Docker Compose Application
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=true
WorkingDirectory=${PWD}
ExecStart=${COMPOSE_BIN} up -d
ExecStop=${COMPOSE_BIN} down
TimeoutStartSec=0
User=ec2-user

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to register the new service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

# Enable the service to start at boot
sudo systemctl enable ${SERVICE_NAME}.service

# Optional: Start it right away
sudo systemctl start ${SERVICE_NAME}.service

echo "✅ Systemd service '${SERVICE_NAME}' set up and enabled."
