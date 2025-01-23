#!/usr/bin/env bash

# Funkcja do dodawania wierszy do pliku (z kontrolą duplikatów - wiersz po wierszu)
dodaj_wiersze() {
  local sciezka_pliku="$1"
  local dodawane_wiersze=("$@") # Przekazujemy wiersze jako tablicę

  # Iteracja po wierszach do dodania
  for wiersz in "${dodawane_wiersze[@]:1}"; do # Pomijamy pierwszy argument (ścieżkę)
    if grep -qF "$wiersz" "$sciezka_pliku"; then
      echo "Wiersz '$wiersz' już istnieje w pliku $sciezka_pliku. Nie dodaję duplikatu."
    else
      echo "$wiersz" >> "$sciezka_pliku"
      echo "Wiersz '$wiersz' został dodany do pliku $sciezka_pliku."
    fi
  done
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

# Dodawanie wierszy do pliku konfiguracyjnego LXC (wiersz po wierszu)
dodaj_wiersze "$sciezka_pliku_lxc" 
"################### MAP UID i GID ###################" \
"# uid map: from uid 0 map 1000 uids (in the ct) to the range starting 100000 (on the host), so 0..999 (ct) → 100000..100999 (host)" \
"lxc.idmap: u 0 100000 1000" \
"lxc.idmap: g 0 100000 1000" \
"# we map 1 uid starting from uid 1000 onto 1000, so 1000 → 1000" \
"lxc.idmap: u 1000 1000 1" \
"lxc.idmap: g 1000 1000 1" \
"# we map the rest of 65535 from 1001 upto 101001, so 1001..65535 → 101001..165535" \
"lxc.idmap: u 1001 101001 64535" \
"lxc.idmap: g 1001 101001 64535" \
"################# MOUNT POINTS ######################" \
"mp0: /mnt/pve/torrent,mp=/mnt/download"

# Dodawanie wiersza do /etc/subuid i /etc/subgid
dodaj_wiersze "/etc/subuid" "root:1000:1"
dodaj_wiersze "/etc/subgid" "root:1000:1"

exit 0
