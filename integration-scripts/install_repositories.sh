#!/bin/sh

apt-get update -qq
# apt-get install -y --no-install-recommends software-properties-common

echo "Adding R cran repositories"
add-apt-repository -y ppa:marutter/rrutter
add-apt-repository -y ppa:marutter/c2d4u
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

# echo "Adding node.js repository"
# sudo add-apt-repository -y ppa:chris-lea/node.js

apt-get update -qq

