#!/bin/sh

echo "Providing R libraries"

apt-get update && sudo apt-get install -y \
    dirmngr \
    gnupg \
    apt-transport-https \
    libcurl4-openssl-dev \
    libxml2-dev \
    libssl-dev \
    locales

# apt-get update && apt-get install -y --no-install-recommends \
#     r-base r-base-dev \
#     libssl-dev libxml2-dev libgit2-dev \
#     libx11-dev libssh2-1-dev libclang-dev pkg-config\
#     && apt-get clean && rm -rf /var/lib/apt/lists/*

echo "Setting locale..."
locale-gen en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8

echo "🔑 Adding CRAN GPG key and repository for R 4.x..."
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 'E298A3A825C0D65DFD57CBB651716619E084DAB9'
add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/'

echo "📦 Installing R..."
sudo apt-get update && sudo apt-get install -y r-base

# echo "Installing R libraries from CRAN"

# Rscript packages.R

