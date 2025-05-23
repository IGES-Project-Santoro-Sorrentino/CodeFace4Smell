#!/bin/sh

apt-get update -qq
apt-get install -y --no-install-recommends software-properties-common

echo "Adding R cran repositories"
sudo add-apt-repository -y ppa:marutter/rrutter
sudo add-apt-repository -y ppa:marutter/c2d4u
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

# echo "Adding node.js repository"
# sudo add-apt-repository -y ppa:chris-lea/node.js

sudo apt-get update -qq

