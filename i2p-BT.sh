#!/usr/bin/env bash

apt-get update
apt-get -y upgrade

adduser i2p
usermod -aG sudo i2p

su - i2p
mkdir /home/i2p/i2p
cd /home/i2p/i2p/

apt-get install -y curl
apt-get install -y sudo
apt-get install -y mc
apt-get install -y wget
apt-get install -y default-jdk

wget http://i2pplus.github.io/installers/i2pinstall_2.7.0+.exe
java -jar i2pinstall_2.7.0+.exe -console

apt-get -y autoremove
apt-get -y autoclean
