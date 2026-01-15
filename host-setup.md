# Proxmox Docker VM setup

## Install Docker VM on Host
[Docker VE helper-script](https://community-scripts.github.io/ProxmoxVE/scripts?id=docker-vm&category=Containers+%26+Docker)
  

## Inital setup through console
```bash
apt update
apt upgrade
apt install openssh-server
systemctl enable ssh
systemctl start ssh
```
### add user
```bash
useradd -m [username]
passwd [username]
usermod -aG sudo [username]

apt install htop zip
```
### configure language and keyboard
```bash
apt update
apt install -y locales
dpkg-reconfigure locales
export LANG=en_GB.UTF-8
update-locale LANG=en_GB.UTF-8

timedatectl set-timezone Europe/London
timedatectl

apt install -y keyboard-configuration
systemctl restart keyboard-setup
cat /etc/default/keyboard
```
### Set root password
```bash
passwd root
```
### Add user to docker group so that sudo isn't required
```bash
usermod -aG docker [username]
groups [username]
# should include: sudo docker#
exit
```

## On remote device
### copy public key to host for created user
```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub [username]@[host]
```
### Then ssh into host using [username]
```bash
ssh [username]@[host]

# test docker groups
docker ps
```

### Install portainer
```bash 
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts
```

### Install nfs-common
```bash
sudo apt install nfs-common
```

### Make Docker configs dir
```bash
sudo mkdir /opt/docker-configs
```
