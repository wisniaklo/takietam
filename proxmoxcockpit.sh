#!/usr/bin/env bash

apt-get -y update
apt-get -y upgrade

#Instalacja Cockpit
apt-get -y install cockpit
systemctl enable cockpit.socket

file="/etc/cockpit/disallowed-users"

if [[ -f "$file" ]]; then
  sed -i 's/^root$/#root/' "$file"
  if [[ $? -eq 0 ]]; then
    echo "Wpis 'root' został zmieniony na '#root' w pliku $file."
  else
    echo "Wystąpił błąd podczas zmiany wpisu w pliku $file."
  fi
else
  echo "Plik $file nie istnieje."
fi

#Instalacja Poolsman for Cockpit
echo "deb [arch=all] https://download.poolsman.com/repository/debian/ stable main" | \ 
tee /etc/apt/sources.list.d/poolsman.list > /dev/null
wget -qO- https://download.poolsman.com/keys/poolsman.gpg | \
tee /etc/apt/trusted.gpg.d/poolsman.gpg > /dev/null
apt-get -y update
apt-get -y install poolsman

#Instalacja Identities for Cockpit
curl -sSL https://repo.45drives.com/setup | sudo bash
apt-get update
apt-get install cockpit-identities

#Instalacja Identities for Cockpit
curl -sSL https://repo.45drives.com/setup | sudo bash
apt-get update
apt-get install cockpit-identities
apt-get install cockpit-file-sharing
apt-get install cockpit-navigator
