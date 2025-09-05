#!/bin/sh
# Non serve più la variabile versione, uso la cartella locale
echo "Providing local cppstats from ./cppstats-0.8.4-edited"

mkdir -p vendor/
cd vendor/

# Copia la cartella locale cppstats-0.8.4-edited dentro vendor/
cp -a ../cppstats-0.8.4-edited ./

export CPPSTATS=$PWD/cppstats-0.8.4-edited/

# Usa lo script esistente per il wrapper
chmod +x $CPPSTATS/cppstats.py

# Copio cppstats
cp -a $CPPSTATS/cppstats.py /usr/local/bin/cppstats

# Link globale per cppstats
# sudo ln -sf $CPPSTATS/cppstats.py /usr/local/bin/cppstats

# Link python3 -> python
sudo ln -s /usr/bin/python3 /usr/bin/python || true

cd ..