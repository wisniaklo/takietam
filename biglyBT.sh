
#!/usr/bin/env bash

apt-get update
apt-get -y upgrade
apt-get install -y curl
apt-get install -y sudo
apt-get install -y mc
apt-get install -y wget

adduser nas
usermod -aG sudo nas
sudo -u nas apt-get install -y biglybt

apt-get -y autoremove
apt-get -y autoclean
