#!/usr/bin/env bash

# Wyświetlenie menu z opcjami
echo "Wybierz jedną z opcji:"
echo "1. Post install - zainstalowanie potrzebnych pakietów"
echo "2. Instalacja Desktop GUI (LXQt)"
echo "3. Odinstaluj Desktop GUI (LXQt)"
echo "4. Instalacja BiglyBT"
echo "5. Instalacja Desktop (IceWM)"
echo "exit"

# Odczytanie wyboru użytkownika
read -p "Twój wybór: " wybor

# Sprawdzenie poprawności wyboru
while [[ ! "$wybor" =~ ^[1-5]$ ]] && [[ "$wybor" != "exit" ]]; do
    echo "Niepoprawny wybór. Wybierz liczbę od 1 do 5 lub exit."
    read -p "Twój wybór: " wybor
done

# Wykonanie komend w zależności od wyboru
case "$wybor" in
    1)
        echo "Wybrano opcję pierwszą (Post install)"
        apt-get update
        apt-get -y upgrade
        apt-get install -y curl sudo wget qemu-guest-agent nano
        apt-get clean
        apt-get autoclean
        apt-get autoremove --purge -y
        fstrim -av
        ;;
    2)
        echo "Wybrano opcję drugą (Instalacja Desktop GUI - LXQt)"
        apt-get update
        apt-get -y upgrade
        apt-get install -y lxqt sddm
        reboot
        ;;
    3)
        echo "Wybrano opcję trzecią (Odinstaluj Desktop GUI - LXQt)"
        apt-get update
        apt-get -y upgrade
        apt-get remove --purge -y lxqt sddm
        apt-get clean
        apt-get autoclean
        apt-get autoremove --purge -y
        reboot
        ;;
    4)
        echo "Wybrano opcję czwartą (Instalacja BiglyBT)"
        apt-get update
        apt-get -y install default-jre
        wget https://files.biglybt.com/installer/BiglyBT_Installer.sh
        chmod +x BiglyBT_Installer.sh
        sudo 
        apt-get install -y biglybt

        cat << EOF > /etc/systemd/system/biglybt.service
[Unit]
Description=BiglyBT service
After=network.target

[Service]
Type=simple
User=nas # Dodano, aby usługa działała jako użytkownik nas
ExecStart=/home/nas/biglybt/biglybt
Restart=always

[Install]
WantedBy=multi-user.target
EOF
        sudo systemctl daemon-reload
        sudo systemctl enable biglybt
        sudo systemctl start biglybt
        ;;
    5)
        echo "Wybrano opcję piątą (Instalacja Desktop - IceWM)"
        apt-get update
        apt-get -y install icewm firefox pcmandfm nitrogen ubuntu-wallpapers-jammy xterm lxterminal xinit
        #Dodanie startx do bashrc
        echo "if [ -z \"\$DISPLAY\" ] && [ \$(tty) = /dev/tty1 ]; then startx; fi" >> ~/.bashrc
        ;;
    exit)
        echo "Koniec skryptu."
        exit 0
        ;;
    *) # Domyślny przypadek (nigdy nie powinien wystąpić dzięki pętli while)
        echo "Nieznana opcja."
        exit 1
        ;;
esac
