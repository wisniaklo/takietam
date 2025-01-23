#!/usr/bin/env bash



apt-get update
apt-get -y upgrade

adduser i2p
usermod -aG sudo i2p

sudo i2p

mkdir /home/i2p/i2p
cd /home/i2p/i2p/

sudo apt-get install -y curl
sudo apt-get install -y sudo
sudo apt-get install -y mc
sudo apt-get install -y wget
sudo apt-get install -y default-jdk

wget http://i2pplus.github.io/installers/i2pinstall_2.7.0+.exe
java -jar i2pinstall_2.7.0+.exe -console

apt-get -y autoremove
apt-get -y autoclean
