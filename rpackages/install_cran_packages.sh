#!/bin/sh

apt-get update
apt-get install r-cran-ggplot2 r-cran-tm r-cran-optparse r-cran-zoo r-cran-xts \
    r-cran-lubridate r-cran-xtable r-cran-reshape r-cran-stringr r-cran-yaml r-cran-plyr \
    r-cran-scales r-cran-gridextra r-cran-rmysql r-cran-jsonlite r-cran-rcurl r-cran-mgcv \
    r-cran-shiny r-cran-httpuv r-cran-png r-cran-rjson\
    r-cran-testthat r-cran-nlp r-cran-igraph r-cran-rjava -y

# Lista dei pacchetti da verificare
packages=(
    r-cran-ggplot2
    r-cran-tm
    r-cran-optparse
    r-cran-zoo
    r-cran-xts
    r-cran-lubridate
    r-cran-xtable
    r-cran-reshape
    r-cran-stringr
    r-cran-yaml
    r-cran-plyr
    r-cran-scales
    r-cran-gridextra
    r-cran-rmysql
    r-cran-jsonlite
    r-cran-rcurl
    r-cran-mgcv
    r-cran-shiny
    r-cran-httpuv
    r-cran-png
    r-cran-rjson
    r-cran-testthat
    r-cran-nlp
    r-cran-igraph
    r-cran-rjava
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