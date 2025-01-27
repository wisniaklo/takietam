#!/usr/bin/env bash



#!/bin/bash

# Wyświetlenie menu z opcjami
echo "Wybierz jedną z opcji:"
echo "1. Post install- zainstalowanie potrzebnych pakietów"
echo "2. Instalacja Desktop GUI"
echo "3. Odinstaluj Desktop GUI"
echo "4. Install BiglyBT"
echo "5. Install Desktop"
echo "exit"

# Odczytanie wyboru użytkownika
read -p "Twój wybór: " wybor


# Sprawdzenie poprawności wyboru
while [[ "$wybor" != "1" && "$wybor" != "2" && "$wybor" != "3" && "$wybor" != "4" && "$wybor" != "5" && "$wybor" != "exit" ]]; do
  echo "Niepoprawny wybór. Wybierz liczbę od 1 do 5 lub exit."
  read -p "Twój wybór: " wybor
done

# Wykonanie komend w zależności od wyboru
case $wybor in
  1)
    echo "Wybrano opcję pierwszą"
    # Tutaj umieść komendy dla opcji pierwszej
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
    ;;
  2)
    echo "Wybrano opcję drugą"
    # Tutaj umieść komendy dla opcji drugiej
      apt-get update
      apt-get -y upgrade
      #apt-get install -y slim
      apt-get install lxqt
      apt-get install sddm
      #apt-get install -y task-lxqt-desktop
      reboot
    ;;
  3)
    echo "Wybrano opcję trzecią"
    # Tutaj umieść komendy dla opcji trzeciej
      apt-get update
      apt-get -y upgrade
      apt-get remove slim lxqt
      apt-get clean -y
      apt-get autoclean -y
      apt-get autoremove --purge -y
      reboot
    ;;
  4)
    echo "Wybrano opcję trzecią"
    # Tutaj umieść komendy dla opcji trzeciej
      wget https://files.biglybt.com/installer/BiglyBT_Installer.sh
      chmod +x BiglyBT_Installer.sh
      ./BiglyBT_Installer.sh
      rm BiglyBT_Installer.sh

      /etc/systemd/system/nazwa_serwisu.service
    ;;
  5)
    echo "Wybrano opcję trzecią"
    # Tutaj umieść komendy dla opcji trzeciej
      apt-get install -y icewm
      apt-get install -y firefox pcmandfm
      apt-get install -y nitrogen
      apt-get install -y ubuntu-wallpapers-jammy
      apt-get install -y xterm
      apt-get install -y lxterminal
      apt-get install -y xinit
      startx
      apt-get clean -y
      apt-get autoclean -y
      apt-get autoremove --purge -y
    ;;
  6)
    echo "Wybrano opcję czwartą"
    # Tutaj umieść komendy dla opcji czwartej
      exit
    ;;
esac
