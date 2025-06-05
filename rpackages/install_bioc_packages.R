# install_bioc_packages.R

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", repos = "https://cloud.r-project.org")
}

source("rpackages/utils.R")

bioc_packages <- c("BiRewire", "graph", "Rgraphviz")
# to_install_bioc <- filter.installed.packages(bioc_packages)

if (length(bioc_packages) > 0) {
  BiocManager::install(bioc_packages, ask = FALSE, update = FALSE)
}

message("✔ Bioconductor packages installed")
