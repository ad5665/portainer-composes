#!/bin/bash

source .env

# create immich user
sudo groupadd -g 101000 immich
sudo useradd -u 101000 -g 101000 -M -r -s /usr/sbin/nologin immich
# create mnt location
sudo mkdir /mnt/immich

# Add mount point to fstab
cat <<'EOF' | sudo tee -a /etc/fstab > /dev/null
$IMMICH_MOUNT  /mnt/immich  nfs4  rw,_netdev,noatime,hard,x-systemd.automount  0  0
EOF

sudo systemctl daemon-reload
sudo mount -a 
l /mnt/immich/
df -h

# Make immich config dir
sudo mkdir /opt/docker-configs/immich

sudo chown immich:immich /opt/docker-configs/immich -R

## scp postgres backup to host
mv ~/postgres.zip ./
sudo mv ~/postgres.zip ./

sudo unzip ./postgres.zip
sudo mkdir redis
sudo mkdir model-cache
sudo mkdir model-dot-cache
sudo mkdir model-config

sudo chown immich:immich ./* -R
sudo chmod -R 755 ./*
