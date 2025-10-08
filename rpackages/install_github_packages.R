# install_github_packages.R

source("rpackages/utils.R")

github_packages <- list(
  list(name = "tm.plugin.mail", repo = "wolfgangmauerer/tm-plugin-mail/pkg"),
  list(name = "snatm", repo = "wolfgangmauerer/snatm/pkg"),
  list(name = "shinyGridster", repo = "wch/shiny-gridster"),
  list(name = "shinybootstrap2", repo = "rstudio/shinybootstrap2")
  # list(name = "Rgraphviz", repo = "mitchell-joblin/Rgraphviz")
)

for (pkg in github_packages) {
  reinstall.package.from.github(pkg$name, pkg$repo)
}

not_installed <- github_packages[!sapply(github_packages, requireNamespace, quietly = TRUE)]

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


message("✔ GitHub packages installed")
