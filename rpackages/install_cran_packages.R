# install_cran_packages.R
options(repos = c(CRAN = "https://packagemanager.posit.co/cran/2018-01-04"))

packages <- c(
  "statnet", "corrgram", "logging"
)

install.packages(packages, dependencies = TRUE )

not_installed <- packages[!packages %in% rownames(installed.packages())]

if (length(not_installed) > 0) {
  stop(
    sprintf(
      "❌ I seguenti pacchetti NON sono stati installati correttamente: %s",
      paste(not_installed, collapse = ", ")
    )
  )
}

# remotes::install_version("devtools", version = "1.13.6")
# if (!"devtools" %in% rownames(installed.packages())) {
#     stop("❌ Package 'devtools' failed to install correctly")
# }

message("✔ CRAN packages installed")
