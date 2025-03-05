#!/bin/bash

# Sprawdzenie instalacji parallel
if ! command -v parallel &> /dev/null; then
  echo "Narzędzie parallel nie jest zainstalowane."
  read -p "Czy zainstalować parallel? (Y/n): " install_parallel
  if [[ "$install_parallel" == "Y" || "$install_parallel" == "y" ]]; then
    sudo apt update
    sudo apt install parallel -y
  else
    echo "Instalacja parallel anulowana. Skrypt zakończy działanie."
    exit 1
  fi
fi

# Sprawdzenie instalacji rsync
if ! command -v rsync &> /dev/null; then
  echo "Narzędzie rsync nie jest zainstalowane."
  read -p "Czy zainstalować rsync? (Y/n): " install_rsync
  if [[ "$install_rsync" == "Y" || "$install_rsync" == "y" ]]; then
    sudo apt update
    sudo apt install rsync -y
  else
    echo "Instalacja rsync anulowana. Skrypt zakończy działanie."
    exit 1
  fi
fi

# Interaktywne pytania
read -p "Podaj ścieżkę źródłową: " SOURCE
read -p "Podaj ścieżkę docelową: " DESTINATION
read -p "Podaj liczbę równoległych procesów (domyślnie $(nproc)): " PARALLEL_JOBS
read -p "Synchronizować katalogi czy pliki? (k/p): " SYNC_TYPE
read -p "Użyć kompresji? (Y/n, domyślnie n): " COMPRESSION

# Ustawienie domyślnej liczby procesów, jeśli nie podano
if [ -z "$PARALLEL_JOBS" ]; then
  PARALLEL_JOBS=$(nproc)
fi

# Ustawienie opcji kompresji
RSYNC_OPTIONS="-av --progress"
if [[ "$COMPRESSION" == "Y" || "$COMPRESSION" == "y" ]]; then
  RSYNC_OPTIONS="-avz --progress"
fi

# Wybór metody synchronizacji
if [[ "$SYNC_TYPE" == "k" || "$SYNC_TYPE" == "K" ]]; then
  # Synchronizacja katalogów
  find "$SOURCE" -type d -print0 | parallel -0 -j "$PARALLEL_JOBS" rsync $RSYNC_OPTIONS {} "$DESTINATION"
elif [[ "$SYNC_TYPE" == "p" || "$SYNC_TYPE" == "P" ]]; then
  # Synchronizacja struktury katalogów z zachowaniem atrybutów
  rsync -avd "$SOURCE" "$DESTINATION"
  # Synchronizacja plików
  find "$SOURCE" -type f -print0 | parallel -0 -j "$PARALLEL_JOBS" rsync $RSYNC_OPTIONS {} "$DESTINATION"
else
  echo "Nieprawidłowy wybór. Skrypt zakończy działanie."
  exit 1
fi

echo "Synchronizacja zakończona."
