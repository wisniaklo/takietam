#!/usr/bin/env bash

apt-get update
apt-get -y upgrade
apt-get install -y curl
apt-get install -y sudo
apt-get install -y mc
apt-get install -y wget
apt-get install -y default-jdk

adduser i2p
usermod -aG sudo i2p

mkdir -p /home/i2p/i2p
chown i2p:i2p /home/i2p/i2p

sudo -u i2p wget -P /home/i2p/i2p http://i2pplus.github.io/installers/i2pinstall_2.7.0+.exe
sudo -u i2p sh -c "cd /home/i2p/i2p && java -jar i2pinstall_2.7.0+.exe -console"

sudo -u i2p sed -i 's|^#RUN_AS_USER=.*|RUN_AS_USER="i2p"|' /home/i2p/i2p/i2prouter

sudo -u i2p /home/i2p/i2p/i2prouter install

apt-get -y autoremove
apt-get -y autoclean
