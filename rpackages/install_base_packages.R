# install_base_packages.R

# Load the remotes package
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes", repos = "https://cloud.r-project.org")
  install.packages("renv")
}

library(remotes)

# Base packages installation with versions compatible with Ubuntu 18.04 / g++-7
# install_version("R6", version = "2.4.1")

renv::init()

remotes::install_version("R6", version = "2.4.1", repos = "https://cloud.r-project.org")
remotes::install_version("rlang", version = "0.4.10", repos = "https://cloud.r-project.org")
remotes::install_version("glue", version = "1.4.2", repos = "https://cloud.r-project.org")
remotes::install_version("lifecycle", version = "0.2.0", repos = "https://cloud.r-project.org")
remotes::install_version("vctrs", version = "0.3.6", repos = "https://cloud.r-project.org")
remotes::install_version("withr", version = "2.3.0", repos = "https://cloud.r-project.org")

remotes::install_version("xml2", version = "1.3.2", repos = "https://cloud.r-project.org")
remotes::install_version("XML", version = "3.99-0.5", repos = "https://cloud.r-project.org")
remotes::install_version("rJava", version = "0.9-13", repos = "https://cloud.r-project.org")

remotes::install_version("ggplot2", version = "3.3.3", repos = "https://cloud.r-project.org")
remotes::install_version("testthat", version = "3.0.1", repos = "https://cloud.r-project.org")
remotes::install_version("fs", version = "1.5.0", repos = "https://cloud.r-project.org")
remotes::install_version("evaluate", version = "0.14", repos = "https://cloud.r-project.org")

remotes::install_version("usethis", version = "2.0.0", repos = "https://cloud.r-project.org")
remotes::install_version("pkgbuild", version = "1.2.0", repos = "https://cloud.r-project.org")
remotes::install_version("pkgdown", version = "1.6.1", repos = "https://cloud.r-project.org")
remotes::install_version("rcmdcheck", version = "1.3.3", repos = "https://cloud.r-project.org")
remotes::install_version("rversions", version = "2.0.1", repos = "https://cloud.r-project.org")
remotes::install_version("urlchecker", version = "1.0.1", repos = "https://cloud.r-project.org")

remotes::install_version("cli", version = "2.2.0", repos = "https://cloud.r-project.org")
remotes::install_version("desc", version = "1.2.0", repos = "https://cloud.r-project.org")
remotes::install_version("ellipsis", version = "0.3.1", repos = "https://cloud.r-project.org")
remotes::install_version("memoise", version = "1.1.0", repos = "https://cloud.r-project.org")
remotes::install_version("miniUI", version = "0.1.1.1", repos = "https://cloud.r-project.org")
remotes::install_version("pkgload", version = "1.1.0", repos = "https://cloud.r-project.org")
remotes::install_version("profvis", version = "0.3.7", repos = "https://cloud.r-project.org")
remotes::install_version("remotes", version = "2.2.0", repos = "https://cloud.r-project.org")
remotes::install_version("roxygen2", version = "7.1.1", repos = "https://cloud.r-project.org")
remotes::install_version("sessioninfo", version = "1.1.1", repos = "https://cloud.r-project.org")

renv::snapshot()

# install_version("rlang", version = "0.4.10")
# install_version("glue", version = "1.4.2")
# install_version("lifecycle", version = "0.2.0")
# install_version("vctrs", version = "0.3.6")
# install_version("withr", version = "2.3.0")

# install_version("xml2", version = "1.3.2")
# install_version("XML", version = "3.99-0.5")
# install_version("rJava", version = "0.9-13")

# install_version("ggplot2", version = "3.3.3")
# install_version("testthat", version = "3.0.1")
# install_version("fs", version = "1.5.0")
# install_version("evaluate", version = "0.14")

# install_version("usethis", version = "2.0.0")
# install_version("pkgbuild", version = "1.2.0")
# install_version("pkgdown", version = "1.6.1")
# install_version("rcmdcheck", version = "1.3.3")
# install_version("rversions", version = "2.0.1")
# install_version("urlchecker", version = "1.0.1")

# install_version("cli", version = "2.2.0")
# install_version("desc", version = "1.2.0")
# install_version("ellipsis", version = "0.3.1")
# install_version("memoise", version = "1.1.0")
# install_version("miniUI", version = "0.1.1.1")
# install_version("pkgload", version = "1.1.0")
# install_version("profvis", version = "0.3.7")
# install_version("remotes", version = "2.2.0")
# install_version("roxygen2", version = "7.1.1")
# install_version("sessioninfo", version = "1.1.1")

# base_pkgs <- c("R6", "rlang", "glue", "lifecycle", "vctrs", "withr",
#   "xml2", "XML", "rJava", "ggplot2", "testthat",
#   "fs", "evaluate", "usethis", "pkgbuild", "pkgdown", "rcmdcheck", "rversions", 
#   "urlchecker","usethis", "cli", "desc", "ellipsis", "fs", "memoise", "miniUI", 
#   "pkgload", "profvis", "remotes", "rlang", "roxygen2", 
#   "sessioninfo")

# install.packages(base_pkgs, repos = "https://cloud.r-project.org", dependencies = TRUE)

message("✔ Base packages installed")
