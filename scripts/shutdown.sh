#!/bin/bash
set -e

# Attach and send shutdown command
echo "[INFO] Sending c_shutdown() to dst_master..."
docker exec dst_master screen -S "dontstarve" -p 0 -X stuff $'c_shutdown()\n'

# Wait for the container to stop
echo "[INFO] Waiting for dst_master to stop..."
while docker ps --format '{{.Names}}' | grep -q '^dst_master$'; do
    sleep 1
done

echo "[INFO] Container stopped. Running docker-compose down..."
/usr/local/bin/docker-compose down
