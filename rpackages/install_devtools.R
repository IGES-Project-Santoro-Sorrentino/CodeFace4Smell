install.packages("devtools", repos = "https://cloud.r-project.org")

if (!requireNamespace("devtools", quietly = TRUE)) {
  stop("devtools failed to install")
} else {
  cat("devtools installed successfully\n")
}