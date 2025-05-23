#!/bin/sh

echo "Providing common binaries and libraries"

echo "mysql-server mysql-server/root_password password" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password" | sudo debconf-set-selections

# sudo DEBIAN_FRONTEND=noninteractive apt-get -qqy install sinntp texlive default-jdk \
# 	mysql-common mysql-client \
# 	mysql-server python-dev exuberant-ctags nodejs git subversion \
# 	sloccount graphviz doxygen libxml2-dev libcurl4-openssl-dev \
# 	libmysqlclient-dev libcairo2-dev libxt-dev libcairo2-dev libmysqlclient-dev \
# 	astyle xsltproc libxml2 libxml2-dev python build-essential libyaml-dev \
# 	gfortran python-setuptools python-pkg-resources python-numpy python-matplotlib \
# 	python-libxml2 python-lxml python-notify python-lxml gcc libarchive12 python-pip \
# 	libxml2-dev libcurl4-openssl-dev xorg-dev libx11-dev libgles2-mesa-dev \
# 	libglu1-mesa-dev libxt-dev libpoppler-dev libpoppler-glib-dev python-mock screen

sudo apt-get update && apt-get install -y \
    texlive doxygen graphviz default-jdk \
    mysql-server mysql-client libmysqlclient-dev \
    python3 python3-dev python3-pip python3-numpy python3-matplotlib \
    python3-lxml python3-setuptools python3-yaml python3-mock \
    build-essential gcc gfortran libxml2-dev libcurl4-openssl-dev \
    libcairo2-dev libxt-dev \
    nodejs git subversion sloccount ctags screen \
    xorg-dev libglu1-mesa-dev libgles2-mesa-dev \
    libpoppler-dev libpoppler-glib-dev libarchive-dev

