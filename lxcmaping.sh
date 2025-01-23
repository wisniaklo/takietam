#!/bin/bash

# Sprawdzenie, czy podano nazwę pliku jako argument
if [ -z "$1" ]; then
  echo "Użycie: $0 <nazwa_pliku>"
  exit 1
fi

nazwa_pliku="$1"
sciezka_pliku="/etc/pve/lxc/$nazwa_pliku"

# Sprawdzenie, czy plik istnieje
if [ ! -f "$sciezka_pliku" ]; then
  echo "Plik $sciezka_pliku nie istnieje."
  exit 1
fi

# Dodawane wiersze
dodawane_wiersze=$(cat << EOF
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

# Dodanie wierszy do pliku
echo "$dodawane_wiersze" >> "$sciezka_pliku"

echo "Wiersze zostały dodane do pliku $sciezka_pliku."

exit 0
