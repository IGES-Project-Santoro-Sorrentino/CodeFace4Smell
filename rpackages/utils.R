# utils.R

filter.installed.packages <- function(packageList) {
  if ("-f" %in% commandArgs(trailingOnly = TRUE)) {
    return(packageList)
  } else {
    return(packageList[!(packageList %in% installed.packages()[,1])])
  }
}

remove.installed.packages <- function(pack) {
  for (lib in .libPaths()) {
    tryCatch({
      remove.packages(pack, lib)
      message(sprintf("✔ Removed previously installed package: %s", pack))
    }, error = function(e) {})
  }
}

reinstall.package.from.github <- function(package, url) {
  missing_pkgs <- filter.installed.packages(c(package))
  if (length(missing_pkgs) == 0) {
    remove.installed.packages(package)
  }
  if (!requireNamespace("devtools", quietly = TRUE)) {
    install.packages("devtools", repos = "https://cloud.r-project.org", dependencies = TRUE)
  }
  devtools::install_github(url)
}
