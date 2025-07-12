#!/bin/sh

echo "Providing common binaries and libraries"

# echo "mysql-server mysql-server/root_password password" | sudo debconf-set-selections
# echo "mysql-server mysql-server/root_password_again password" | sudo debconf-set-selections

apt-get update && apt-get install -yy --no-install-recommends \
    texlive doxygen graphviz default-jdk default-jre \
    mysql-server mysql-client libmysqlclient-dev \
    python3 python3-dev python3-pip python3-numpy python3-matplotlib \
    python3-lxml python3-setuptools python3-yaml python3-mock \
    build-essential gcc gfortran libxml2-dev libcurl4-openssl-dev \
    libcairo2-dev libxt-dev \
    nodejs git subversion sloccount exuberant-ctags screen \
    xorg-dev libglu1-mesa-dev libgles2-mesa-dev \
    libpoppler-dev libpoppler-glib-dev libarchive-dev r-base default-libmysqlclient-dev

# Lista dei pacchetti da verificare
packages=(
    texlive doxygen graphviz default-jdk default-jre
    mysql-server mysql-client libmysqlclient-dev
    python3 python3-dev python3-pip python3-numpy python3-matplotlib
    python3-lxml python3-setuptools python3-yaml python3-mock
    build-essential gcc gfortran libxml2-dev libcurl4-openssl-dev
    libcairo2-dev libxt-dev
    nodejs git subversion sloccount exuberant-ctags screen
    xorg-dev libglu1-mesa-dev libgles2-mesa-dev
    libpoppler-dev libpoppler-glib-dev libarchive-dev r-base default-libmysqlclient-dev
)

missing=()
for pkg in "${packages[@]}"; do
    dpkg -s "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
done

if [ ${#missing[@]} -ne 0 ]; then
    echo "❌ I seguenti pacchetti NON sono stati installati correttamente:"
    for pkg in "${missing[@]}"; do
        echo "  - $pkg"
    done
    exit 1
else
    echo "✔ Tutti i pacchetti sono installati correttamente"
fi