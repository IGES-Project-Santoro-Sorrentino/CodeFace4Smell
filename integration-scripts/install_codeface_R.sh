#!/bin/sh

echo "Providing R libraries"

apt-get update && sudo apt-get install -yy \
    dirmngr \
    gnupg \
    apt-transport-https \
    libcurl4-openssl-dev \
    libxml2-dev \
    libgit2-dev \
    libssl-dev \
    libglpk-dev \
    locales \
    r-base \
    r-base-dev \
    libx11-dev \
    libssh2-1-dev \
    r-bioc-biocinstaller \
    zlib1g-dev

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
# sudo apt-get update && sudo apt-get install -qqy r-base r-base-dev r-cran-ggplot2 r-cran-tm \
# 	r-cran-tm.plugin.mail r-cran-optparse r-cran-igraph r-cran-zoo r-cran-xts \
# 	r-cran-lubridate r-cran-xtable r-cran-reshape r-cran-wordnet \
# 	r-cran-stringr r-cran-yaml r-cran-plyr r-cran-scales r-cran-gridExtra \
# 	r-cran-scales r-cran-RMySQL r-cran-RJSONIO r-cran-RCurl r-cran-mgcv \
# 	r-cran-shiny r-cran-dtw r-cran-httpuv r-cran-png \
# 	r-cran-rjson r-cran-lsa r-cran-testthat r-cran-arules r-cran-data.table \
# 	r-cran-ineq libx11-dev libssh2-1-dev r-bioc-biocinstaller

# Rscript packages.R

