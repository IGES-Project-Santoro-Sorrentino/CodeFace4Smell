# install_base_packages.R

options(repos = c(CRAN = "https://cran.r-project.org"), dependencies = TRUE)

packages <- c(
  "ggplot2", "tm", "optparse", "zoo", "xts",
  "lubridate", "xtable", "reshape", "stringr", "yaml", "plyr",
  "scales", "gridExtra", "RMySQL", "RJSONIO", "RCurl", "mgcv", "shiny",
  "dtw", "httpuv", "png", "rjson", "lsa", "testthat", "arules", "data.table",
  "ineq", "igraph", "wordnet", "logging", "statnet", "corrgram", "markovchain", "psych"
)

not_installed_packages <- c()
for (pkg in packages) {
  if (!pkg %in% rownames(installed.packages())) {
    not_installed_packages <- c(not_installed_packages, pkg)
  }
}

install.packages(not_installed_packages)

not_installed <- packages[!not_installed_packages %in% rownames(installed.packages())]

if (length(not_installed) > 0) {
  stop(
    sprintf(
      "❌ I seguenti pacchetti NON sono stati installati correttamente: %s",
      paste(not_installed, collapse = ", ")
    )
  )
}

message("✔ Base packages installed")
