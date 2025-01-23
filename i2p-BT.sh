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

su - i2p -c "mkdir /home/i2p/i2p"
su - i2p -c "cd /home/i2p/i2p/"

su - i2p -c "wget http://i2pplus.github.io/installers/i2pinstall_2.7.0+.exe"
su - i2p -c "java -jar i2pinstall_2.7.0+.exe -console"

apt-get -y autoremove
apt-get -y autoclean
