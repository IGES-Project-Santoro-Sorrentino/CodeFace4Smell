#!/bin/sh

echo "Providing codeface python"

pip install --upgrade -q setuptools
#pip install -q mock<3

# Only development mode works
# install fails due to R scripts accessing unbundled resources!
# TODO Fix the R scripts
python2.7 setup.py -q develop