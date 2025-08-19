#!/bin/sh

export CPPSTATS_VERSION=0.9.4

echo "Providing cppstats $CPPSTATS_VERSION"

mkdir -p vendor/
cd vendor/

wget --quiet https://codeload.github.com/clhunsen/cppstats/tar.gz/v$CPPSTATS_VERSION -O /tmp/cppstats.tar.gz
tar -xvf /tmp/cppstats.tar.gz
export CPPSTATS=$PWD/cppstats-$CPPSTATS_VERSION/
# Use the existing cppstats.sh script instead of creating a custom wrapper
chmod +x $CPPSTATS/cppstats.sh
wget --quiet https://github.com/srcML/srcML/releases/download/v1.0.0/srcml_1.0.0-1_ubuntu18.04.tar.gz -O /tmp/srcML.tar.gz
tar -xvf /tmp/srcML.tar.gz
# cp -rf $PWD/srcML/* $CPPSTATS/lib/srcml/linux/

sudo ln -sf $CPPSTATS/cppstats.sh /usr/local/bin/cppstats
#
sudo ln -s /usr/bin/python3 /usr/bin/python

cd ..
