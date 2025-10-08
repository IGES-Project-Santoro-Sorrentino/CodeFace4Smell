#!/bin/sh

echo "Providing R libraries"

apt-get update && apt-get install -yy \
    libxml2-dev \
    libgit2-dev \
    libssl-dev \
    libglpk-dev \
    r-base \
    r-base-dev \
    libx11-dev \
    libssh2-1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libgsl-dev \
    graphviz \
    libmysqlclient-dev \
    libcurl4-openssl-dev \
    libudunits2-dev \
    libgraphviz-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Lista dei pacchetti da verificare
packages=(
    libxml2-dev
    libgit2-dev
    libssl-dev
    libglpk-dev
    r-base
    r-base-dev
    libx11-dev
    libssh2-1-dev
    zlib1g-dev
    libharfbuzz-dev
    libfribidi-dev
    libfreetype6-dev
    libpng-dev
    libgdal-dev
    libgeos-dev
    libproj-dev
    libgsl-dev
    graphviz
    libmysqlclient-dev
    libcurl4-openssl-dev
    libudunits2-dev
    libgraphviz-dev
)

missing=()
for pkg in "${packages[@]}"; do
    dpkg -s "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
done

if [ ${#missing[@]} -ne 0 ]; then
    echo -e "\033[31m❌ I seguenti pacchetti NON sono stati installati correttamente:\033[0m"
    for pkg in "${missing[@]}"; do
        echo "  - $pkg"
    done
    exit 1
else
    echo -e "\033[32m✔ Tutti i pacchetti sono installati correttamente\033[0m"
fi

echo "Setting locale..."
locale-gen en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8

# echo "🔑 Adding CRAN GPG key and repository for R 4.x..."
# apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 'E298A3A825C0D65DFD57CBB651716619E084DAB9'
# add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/'
