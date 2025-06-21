# install_cran_packages.R
options(repos = c(CRAN = "https://packagemanager.posit.co/cran/2018-01-04"))

install.packages(c(
  "statnet", "ggplot2", "tm", "optparse", "igraph", "zoo", "xts",
  "lubridate", "xtable", "reshape", "wordnet", "stringr", "yaml", "plyr",
  "scales", "gridExtra", "RMySQL", "RCurl", "mgcv", "shiny", "dtw", "httpuv",
  "corrgram", "logging", "png", "rjson", "lsa", "RJSONIO", "devtools"
), dependencies = c("Depends", "Imports"))


library(devtools)

message("✔ CRAN packages installed")
