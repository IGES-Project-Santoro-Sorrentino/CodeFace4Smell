#!/bin/sh

echo "Installing Python 3 and pip"

echo "Providing codeface python"

sudo pip install --upgrade -q setuptools
sudo pip install --upgrade -q mock

# Only development mode works
# install fails due to R scripts accessing unbundled resources!
# TODO Fix the R scripts
sudo python2.7 setup.py -q develop

