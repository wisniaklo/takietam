
#!/usr/bin/env bash

apt-get update
apt-get -y upgrade
apt-get install -y curl
apt-get install -y sudo
apt-get install -y mc
apt-get install -y wget
apt-get install -y biglybt

adduser nas
usermod -aG sudo nas

mkdir -p /home/i2p/i2p
chown i2p:i2p /home/i2p/i2p


apt-get -y autoremove
apt-get -y autoclean
