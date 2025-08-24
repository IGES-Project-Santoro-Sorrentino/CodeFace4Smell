# install_github_packages.R

source("rpackages/utils.R")

github_packages <- list(
  list(name = "tm.plugin.mail", repo = "wolfgangmauerer/tm-plugin-mail/pkg"),
  list(name = "snatm", repo = "wolfgangmauerer/snatm/pkg"),
  list(name = "shinyGridster", repo = "wch/shiny-gridster"),
  list(name = "shinybootstrap2", repo = "rstudio/shinybootstrap2"),
  list(name = "Rgraphviz", repo = "mitchell-joblin/Rgraphviz")
)

for (pkg in github_packages) {
  reinstall.package.from.github(pkg$name, pkg$repo)
  #remotes::install_github(pkg$repo)
}

message("✔ GitHub packages installed")
