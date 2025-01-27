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
        apt-get -y upgrade
        apt-get -y install default-jre
        wget https://files.biglybt.com/installer/BiglyBT_Installer.sh
        chmod +x BiglyBT_Installer.sh
        sudo -u nas ./BiglyBT_Installer.sh
        cat << EOF > /etc/systemd/system/biglybt.service
[Unit]
Description=BiglyBTd (BiglyBT as a system service)
After=network-online.target

[Service]
User=nas
Type=simple
Restart=always
StateDirectory=biglybt

ExecStart=/home/nas/biglybt/biglybt --ui="telnet"
ExecStop=/home/nas/biglybt/biglybt --shutdown
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF
        sudo systemctl daemon-reload
        sudo systemctl enable biglybt
        sudo systemctl start biglybt
        ;;
    5)
        echo "Wybrano opcję piątą (Instalacja Cloudflare WARP)"
        apt-get update
        apt-get -y upgrade
        curl https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(grep VERSION_CODENAME /etc/os-release | cut -d= -f2) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
        apt-get update
        apt-get install cloudflare-warp
        sysctl -w net.ipv4.ip_forward=1
        sudo -u nas warp-cli connector new eyJhIjoiNjJiZmU4MTgxN2IwNDAwN2NlODIyMzMwYTY1NjNiNGQiLCJ0IjoiOGJkYjE0MjQtNjAwZS00ZDY1LTgxZGYtOWExNzJhNjc0OWFmIiwicyI6Ik9EazVNakF6TUdZdE0yTXhNaTAwTUdJeUxXSXpZbVF0WldJeFltWmhZelZrTXpnMSJ9
        sudo -u nas warp-cli connect
        ;;
esac
