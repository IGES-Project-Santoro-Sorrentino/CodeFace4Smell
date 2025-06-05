# install_github_packages.R

source("rpackages/utils.R")

github_packages <- list(
  list(name = "tm.plugin.mail", repo = "wolfgangmauerer/tm-plugin-mail/pkg@v0.9.0"),
  list(name = "snatm", repo = "wolfgangmauerer/snatm/pkg@v1.1.2"),
  list(name = "shinyGridster", repo = "wch/shiny-gridster@v0.5.4"),
  list(name = "shinybootstrap2", repo = "rstudio/shinybootstrap2@v0.2.3"),
  list(name = "Rgraphviz", repo = "mitchell-joblin/Rgraphviz@v2.34.0")
)

for (pkg in github_packages) {
  # reinstall.package.from.github(pkg$name, pkg$repo)
  devtools::install_github(pkg$repo)
}

message("✔ GitHub packages installed")
