#!/usr/bin/env bash

apt-get update
apt-get -y upgrade
apt-get install -y curl
apt-get install -y sudo
apt-get install -y mc
apt-get install -y wget
apt-get install -y default-jdk
apt-get install -y software-properties-common
add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
apt-get update
apt-get install -y qbittorrent-nox

adduser i2p
usermod -aG sudo i2p

mkdir -p /home/i2p/i2p
chown i2p:i2p /home/i2p/i2p

sudo -u i2p wget -P /home/i2p/i2p http://i2pplus.github.io/installers/i2pinstall_2.7.0+.exe
sudo -u i2p sh -c "cd /home/i2p/i2p && java -jar i2pinstall_2.7.0+.exe -console"

sudo -u i2p sed -i 's|^#RUN_AS_USER=.*|RUN_AS_USER="i2p"|' /home/i2p/i2p/i2prouter

sudo -u i2p /home/i2p/i2p/i2prouter install
sudo -u i2p /home/i2p/i2p/i2prouter start

sudo -u i2p qbittorrent-nox

sudo -u i2p cat <<EOF >/home/nas/.config/qBittorrent/qBittorrent.conf
[Preferences]
WebUI\Password_PBKDF2="@ByteArray(vwm+l7qfq+4W/6pmC8JRDg==:KFvmdrcjlqXS7wkfqHRTv6y/D36V+OCrr/FSfeo0ISNEPD1uWsV9+pGyqAPkRadI2IEnnFOmYZ7uWOvi8QPRcg==)"
EOF

systemctl start qbittorrent-nox@i2p
systemctl enable qbittorrent-nox@i2p

apt-get -y autoremove
apt-get -y autoclean
