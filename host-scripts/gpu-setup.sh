#!/bin/bash
## Enable GPU Passthrough on proxmox 
### Add nvidia repos
cat <<'EOF' | sudo tee -a /etc/apt/sources.list > /dev/null
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
EOF


sudo apt update

sudo apt install -y linux-headers-$(uname -r) build-essential dkms
sudo apt install -y nvidia-driver firmware-misc-nonfree

sudo reboot

### Test that gpu shows on VM
nvidia-smi

### Instal nvidia container toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
 | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit.gpg

curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
 | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit.gpg] https://#g' \
 | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt update
sudo apt install -y nvidia-container-toolkit


sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

## Test by running this container on the host
docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi
