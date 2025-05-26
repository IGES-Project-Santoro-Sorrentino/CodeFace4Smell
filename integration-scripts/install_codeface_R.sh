#!/bin/sh

echo "Providing R libraries"


apt-get update && apt-get install -y --no-install-recommends \
    r-base r-base-dev \
    libssl-dev libxml2-dev libgit2-dev \
    libx11-dev libssh2-1-dev libclang-dev pkg-config\
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# echo "Installing R libraries from CRAN"

# Rscript packages.R

