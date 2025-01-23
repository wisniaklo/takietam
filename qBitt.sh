#!/usr/bin/env bash

apt-get update && apt-get -y upgrade

useradd -m -p "" nas
usermod -s /usr/sbin/nologin nas 
usermod -s /bin/bash nas

apt-get install -y curl
apt-get install -y sudo
apt-get install -y mc
apt-get install -y wget
apt-get install -y software-properties-common

add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
apt-get update
apt-get install -y qbittorrent-nox

su - nas -c "qbittorrent-nox" -y

cat <<EOF >/home/nas/.config/qBittorrent/qBittorrent.conf
[Preferences]
WebUI\Password_PBKDF2="@ByteArray(vwm+l7qfq+4W/6pmC8JRDg==:KFvmdrcjlqXS7wkfqHRTv6y/D36V+OCrr/FSfeo0ISNEPD1uWsV9+pGyqAPkRadI2IEnnFOmYZ7uWOvi8QPRcg==)"
EOF

su - root 

systemctl start qbittorrent-nox@nas
systemctl enable qbittorrent-nox@nas

apt-get -y autoremove
apt-get -y autoclean
