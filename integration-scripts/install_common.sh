#!/bin/sh

echo "Providing common binaries and libraries"

echo "mysql-server mysql-server/root_password password" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password" | sudo debconf-set-selections

sudo apt-get update && apt-get install -y --no-install-recommends \
    texlive doxygen graphviz default-jdk\
    mysql-server mysql-client libmysqlclient-dev \
    python3 python3-dev python3-pip python3-numpy python3-matplotlib \
    python3-lxml python3-setuptools python3-yaml python3-mock \
    build-essential gcc gfortran libxml2-dev libcurl4-openssl-dev \
    libcairo2-dev libxt-dev \
    nodejs git subversion sloccount ctags screen \
    xorg-dev libglu1-mesa-dev libgles2-mesa-dev \
    libpoppler-dev libpoppler-glib-dev libarchive-dev


