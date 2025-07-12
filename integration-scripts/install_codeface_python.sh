#!/bin/sh

echo "Installing Python 3 and pip"

echo "Providing codeface python"

pip3 install --upgrade -q setuptools
pip3 install --upgrade -q mock
pip3 install --upgrade -q wheel

# Only development mode works
# install fails due to R scripts accessing unbundled resources!
# TODO Fix the R scripts
#python3 setup.py -q develop
#pip3 install -e .