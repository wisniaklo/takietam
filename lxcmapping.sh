#!/usr/bin/env bash

# Funkcja do dodawania wierszy do pliku konfiguracyjnego LXC (z kontrolą duplikatów)
dodaj_wiersze_lxc() {
  local sciezka_pliku="$1"
  local dodawane_wiersze=$(cat << EOF
#####################################################
###                 MAP UID i GID                 ###
#####################################################

# uid map: from uid 0 map 1000 uids (in the ct) to the range starting 100000 (on the host), so 0..999 (ct) → 100000..100999 (host)
lxc.idmap: u 0 100000 1000
lxc.idmap: g 0 100000 1000
# we map 1 uid starting from uid 1000 onto 1000, so 1000 → 1000
lxc.idmap: u 1000 1000 1
lxc.idmap: g 1000 1000 1
# we map the rest of 65535 from 1001 upto 101001, so 1001..65535 → 101001..165535
lxc.idmap: u 1001 101001 64535
lxc.idmap: g 1001 101001 64535

#####################################################
###               MOUNT POINTS                    ###
#####################################################

mp0: /mnt/pve/torrent,mp=/mnt/download

#####################################################
EOF
)

  if grep -qF "$dodawane_wiersze" "$sciezka_pliku"; then
    echo "Wiersze dla LXC już istnieją w pliku $sciezka_pliku. Nie dodaję duplikatów."
  else
    echo "$dodawane_wiersze" >> "$sciezka_pliku"
    echo "Wiersze dla LXC zostały dodane do pliku $sciezka_pliku."
  fi
}

# Funkcja do dodawania wiersza root:1000:1 do subuid/subgid (z kontrolą duplikatów)
dodaj_subuid_subgid() {
  local sciezka_pliku="$1"
  local wiersz="root:1000:1"

  if grep -qF "$wiersz" "$sciezka_pliku"; then
    echo "Wiersz '$wiersz' już istnieje w pliku $sciezka_pliku. Nie dodaję duplikatu."
  else
    echo "$wiersz" >> "$sciezka_pliku"
    echo "Wiersz '$wiersz' został dodany do pliku $sciezka_pliku."
  fi
}


# Obsługa argumentów i prośba o nazwę pliku LXC
if [ -z "$1" ]; then
  read -p "Podaj nazwę pliku konfiguracyjnego LXC (np. 101.conf): " nazwa_pliku_lxc
  if [ -z "$nazwa_pliku_lxc" ]; then
    echo "Nie podano nazwy pliku LXC."
    exit 1
  fi
else
  nazwa_pliku_lxc="$1"
fi

sciezka_pliku_lxc="/etc/pve/lxc/$nazwa_pliku_lxc"

# Sprawdzenie, czy plik LXC istnieje
if [ ! -f "$sciezka_pliku_lxc" ]; then
  echo "Plik $sciezka_pliku_lxc nie istnieje."
  exit 1
fi

# Dodawanie wierszy do pliku konfiguracyjnego LXC
dodaj_wiersze_lxc "$sciezka_pliku_lxc"

# Dodawanie wiersza do /etc/subuid i /etc/subgid
dodaj_subuid_subgid "/etc/subuid"
dodaj_subuid_subgid "/etc/subgid"

exit 0
