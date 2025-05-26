# --- Install required packages ---
# install.packages(c("R6", "rlang", "curl", "fs", "glue", "xml2"), repos = "https://cloud.r-project.org", dependencies = TRUE)

# --- Utility functions ---
filter.installed.packages <- function(packageList) {
    if ("-f" %in% commandArgs(trailingOnly = TRUE)) {
        return(packageList)
    } else {
        return(packageList[!(packageList %in% installed.packages()[,1])])
    }
}

remove.installed.packages <- function(pack) {
    for (path in .libPaths()) {
        tryCatch({
            remove.packages(pack, path)
            cat(sprintf("✔ Removed previously installed package: %s\n", pack))
        }, error = function(e) {})
    }
}

reinstall.package.from.github <- function(package, url) {
    p <- filter.installed.packages(c(package))
    if (length(p) == 0) {
        remove.installed.packages(package)
    }

    if (!requireNamespace("devtools", quietly = TRUE)) {
        install.packages("devtools", repos = "https://cloud.r-project.org")
    }

    devtools::install_github(url)
}

# --- Install CRAN packages ---
cran_packages <- c(
    "statnet", "ggplot2", "tm", "optparse", "igraph", "zoo", "xts",
    "lubridate", "xtable", "reshape", "wordnet", "stringr", "yaml", "plyr",
    "scales", "gridExtra", "RMySQL", "RCurl", "mgcv", "shiny", "dtw", "httpuv",
    "corrgram", "logging", "png", "rjson", "lsa", "RJSONIO", "devtools"
)

to_install <- filter.installed.packages(cran_packages)

if (length(to_install) > 0) {
    install.packages(to_install, repos = "https://cloud.r-project.org", dependencies = TRUE)
}

# --- Install Bioconductor packages ---
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager", repos = "https://cloud.r-project.org")
}

bioc_packages <- c("BiRewire", "graph", "Rgraphviz")
to_bioc <- filter.installed.packages(bioc_packages)

if (length(to_bioc) > 0) {
    BiocManager::install(to_bioc, ask = FALSE, update = FALSE)
}

# --- GitHub packages ---
reinstall.package.from.github("tm.plugin.mail", "wolfgangmauerer/tm-plugin-mail/pkg")
reinstall.package.from.github("snatm", "wolfgangmauerer/snatm/pkg")
reinstall.package.from.github("shinyGridster", "wch/shiny-gridster")
reinstall.package.from.github("shinybootstrap2", "rstudio/shinybootstrap2")
reinstall.package.from.github("Rgraphviz", "mitchell-joblin/Rgraphviz")
