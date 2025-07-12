# install_base_packages.R

install.packages("remotes", dependencies = TRUE)


options(repos = c(CRAN = "https://packagemanager.posit.co/cran/2018-01-04"))

packages <- c(
  "ggplot2", "tm", "tm.plugin.mail", "optparse", "zoo", "xts",
  "lubridate", "xtable", "reshape", "stringr", "yaml", "plyr",
  "scales", "gridExtra", "RMySQL", "RJSONIO", "RCurl", "mgcv", "shiny",
  "dtw", "httpuv", "png", "rjson", "lsa", "testthat", "arules", "data.table",
  "ineq"
)

# not_installed <- packages[!packages %in% rownames(installed.packages())]

not_installed_packages <- c()
for (pkg in packages) {
  if (!pkg %in% rownames(installed.packages())) {
    not_installed_packages <- c(not_installed_packages, pkg)
  }
}

install.packages(not_installed_packages, dependencies = TRUE)

not_installed <- packages[!not_installed_packages %in% rownames(installed.packages())]

if (length(not_installed) > 0) {
  stop(
    sprintf(
      "❌ I seguenti pacchetti NON sono stati installati correttamente: %s",
      paste(not_installed, collapse = ", ")
    )
  )
}

options(repos = c(CRAN = "https://cran.r-project.org"))

if (!"NLP" %in% rownames(installed.packages())) {
  remotes::install_version("NLP", version = "0.2-0")
  if (!"NLP" %in% rownames(installed.packages())) {
    stop("❌ Package 'NLP' failed to install correctly")
  }
}

if (!"igraph" %in% rownames(installed.packages())) {
  remotes::install_version("igraph", version = "1.2.6")
  if (!"igraph" %in% rownames(installed.packages())) {
      stop("❌ Package 'igraph' failed to install correctly")
  }
}

remotes::install_version("wordnet", version = "0.1-16")
if (!"wordnet" %in% rownames(installed.packages())) {
    stop("❌ Package 'wordnet' failed to install correctly")
}

message("✔ Base packages installed")
