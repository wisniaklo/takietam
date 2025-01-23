#!/usr/bin/env bash

# Funkcja do dodawania wierszy (z kontrolą duplikatów)
dodaj_wiersze() {
  local sciezka_pliku="$1"
  local dodawane_wiersze=$(cat << EOF
######################################################################
# uid map: from uid 0 map 1000 uids (in the ct) to the range starting 100000 (on the host), so 0..999 (ct) → 100000..100999 (host)
lxc.idmap: u 0 100000 1000
lxc.idmap: g 0 100000 1000
# we map 1 uid starting from uid 1000 onto 1000, so 1000 → 1000
lxc.idmap: u 1000 1000 1
lxc.idmap: g 1000 1000 1
# we map the rest of 65535 from 1001 upto 101001, so 1001..65535 → 101001..165535
lxc.idmap: u 1001 101001 64535
lxc.idmap: g 1001 101001 64535
# mount points
mp0: /ZF1/Home,mp=/mnt/home
mp1: /ZF1/Data,mp=/mnt/data
######################################################################
EOF
)

  # Sprawdzenie, czy wiersze już istnieją w pliku
  if grep -qF "$dodawane_wiersze" "$sciezka_pliku"; then
    echo "Wiersze już istnieją w pliku $sciezka_pliku. Nie dodaję duplikatów."
  else
    echo "$dodawane_wiersze" >> "$sciezka_pliku"
    echo "Wiersze zostały dodane do pliku $sciezka_pliku."
  fi
}

# Sprawdzenie, czy podano argument
if [ -z "$1" ]; then
  # Prośba o podanie nazwy pliku
  read -p "Podaj nazwę pliku konfiguracyjnego kontenera LXC (np 101.conf): " nazwa_pliku
  if [ -z "$nazwa_pliku" ]; then
    echo "Nie podano nazwy pliku."
    exit 1
  fi
else
  nazwa_pliku="$1"
fi

sciezka_pliku="/etc/pve/lxc/$nazwa_pliku"

# Sprawdzenie, czy plik istnieje
if [ ! -f "$sciezka_pliku" ]; then
  echo "Plik $sciezka_pliku nie istnieje."
  exit 1
fi

# Wywołanie funkcji dodającej wiersze
dodaj_wiersze "$sciezka_pliku"

exit 0
