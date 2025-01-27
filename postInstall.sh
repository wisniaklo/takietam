#!/usr/bin/env bash

apt-get update
apt-get -y upgrade
apt-get install -y curl
apt-get install -y sudo
apt-get install -y wget
#apt-get install -y mc
apt-get install -y qemu-guest-agent 
apt-get install -y nano
apt-get clean -y
apt-get autoclean -y
apt-get autoremove --purge -y
fstrim -av
