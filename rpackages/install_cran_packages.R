# install_cran_packages.R

source("rpackages/utils.R")

cran_packages <- c(
  "statnet", "ggplot2", "tm", "optparse", "igraph", "zoo", "xts",
  "lubridate", "xtable", "reshape", "wordnet", "stringr", "yaml", "plyr",
  "scales", "gridExtra", "RMySQL", "RCurl", "mgcv", "shiny", "dtw", "httpuv",
  "corrgram", "logging", "png", "rjson", "lsa", "RJSONIO", "devtools"
)

options(repos = c(CRAN = "https://packagemanager.posit.co/cran/2018-01-04"))

install.packages(cran_packages, repos = "https://cloud.r-project.org", dependencies = TRUE)
# # to_install_cran <- filter.installed.packages(cran_packages)

# if (length(cran_packages) > 0) {
  
# }

library(devtools)

message("✔ CRAN packages installed")
