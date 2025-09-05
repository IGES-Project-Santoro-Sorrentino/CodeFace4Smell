# install_bioc_packages.R

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", repos = "https://cloud.r-project.org")
}

bioc_packages <- c("BiRewire", "graph", "Rgraphviz")
# to_install_bioc <- filter.installed.packages(bioc_packages)

if (length(bioc_packages) > 0) {
  BiocManager::install(bioc_packages, ask = FALSE, update = FALSE)
}

not_installed <- bioc_packages[!sapply(bioc_packages, requireNamespace, quietly = TRUE)]

if (length(not_installed) == 0) {
  message("✔ All Bioconductor packages installed successfully")
} else {
  stop(
    sprintf(
      "❌ I seguenti pacchetti NON sono stati installati correttamente: %s",
      paste(not_installed, collapse = ", ")
    )
  )
}
