#!/usr/bin/env Rscript

# CodeFace Shiny Packages Installation Script
# This script installs all required R packages for CodeFace Shiny applications

# Function to install packages with error handling
install_pkg <- function(pkg) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat('Installing', pkg, 'package...\n')
    tryCatch({
      install.packages(pkg, repos='https://cran.rstudio.com/', dependencies = TRUE, quiet = FALSE)
      cat('✓ Successfully installed', pkg, 'package\n')
    }, error = function(e) {
      cat('✗ ERROR installing', pkg, ':', e$message, '\n')
      quit(status = 1)
    })
  } else {
    cat('✓', pkg, 'package already installed\n')
  }
}

# Function to install GitHub packages with error handling
install_github_pkg <- function(repo, pkg_name) {
  if (!require(pkg_name, character.only = TRUE, quietly = TRUE)) {
    cat('Installing', pkg_name, 'from GitHub...\n')
    tryCatch({
      devtools::install_github(repo, quiet = FALSE)
      cat('✓ Successfully installed', pkg_name, 'from GitHub\n')
    }, error = function(e) {
      cat('✗ ERROR installing', pkg_name, 'from GitHub:', e$message, '\n')
      quit(status = 1)
    })
  } else {
    cat('✓', pkg_name, 'package already installed\n')
  }
}

cat('=== Installing CodeFace Shiny Packages ===\n')

# Core Shiny packages
cat('\n--- Installing Core Shiny Packages ---\n')
install_pkg('shiny')
install_pkg('rmarkdown')
install_pkg('DT')
install_pkg('plotly')

# Database packages
cat('\n--- Installing Database Packages ---\n')
install_pkg('RMySQL')
install_pkg('DBI')

# Utility packages
cat('\n--- Installing Utility Packages ---\n')
install_pkg('logging')
install_pkg('jsonlite')
install_pkg('devtools')
install_pkg('httr')
install_pkg('curl')

# Visualization packages
cat('\n--- Installing Visualization Packages ---\n')
install_pkg('ggplot2')
install_pkg('dplyr')
install_pkg('scales')
install_pkg('gridExtra')
install_pkg('RColorBrewer')
install_pkg('lattice')
install_pkg('latticeExtra')

# Text mining packages
cat('\n--- Installing Text Mining Packages ---\n')
install_pkg('tm')
install_pkg('slam')
install_pkg('wordcloud')
install_pkg('SnowballC')

# Network analysis packages
cat('\n--- Installing Network Analysis Packages ---\n')
install_pkg('igraph')
install_pkg('network')
install_pkg('sna')

# Data manipulation packages
cat('\n--- Installing Data Manipulation Packages ---\n')
install_pkg('reshape2')
install_pkg('plyr')
install_pkg('stringr')
install_pkg('lubridate')

# Statistical packages
cat('\n--- Installing Statistical Packages ---\n')
install_pkg('MASS')
install_pkg('stats')
install_pkg('corrplot')
install_pkg('cluster')

# Time series packages
cat('\n--- Installing Time Series Packages ---\n')
install_pkg('zoo')
install_pkg('xts')
install_pkg('forecast')

# Additional utility packages
cat('\n--- Installing Additional Utility Packages ---\n')
install_pkg('RJSONIO')
install_pkg('yaml')
install_pkg('config')
install_pkg('shinyjs')
install_pkg('shinyBS')
install_pkg('shinythemes')

# Install GitHub packages
cat('\n--- Installing GitHub Packages ---\n')
install_github_pkg('wch/shiny-gridster', 'shinyGridster')

# Verify critical packages
cat('\n--- Verifying Critical Packages ---\n')
critical_packages <- c('shiny', 'shinyGridster', 'ggplot2', 'RMySQL', 'logging')

for (pkg in critical_packages) {
  if (require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat('✓', pkg, 'is properly installed and loaded\n')
  } else {
    cat('✗ ERROR:', pkg, 'is not properly installed\n')
    quit(status = 1)
  }
}

cat('\n=== All packages installed successfully! ===\n')
cat('CodeFace Shiny applications are ready to run.\n')
