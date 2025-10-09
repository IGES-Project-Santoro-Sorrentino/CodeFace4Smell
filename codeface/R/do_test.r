#! /usr/bin/env Rscript
## Helper scripts to dispatch and evaluate R unit/integration tests

suppressPackageStartupMessages(library(testthat))
suppressPackageStartupMessages(library(stringr))

do.tests <- function(dir) {
    cat(str_c("Running tests in directory: ", dir, "\n"))
    
    # Use tryCatch to handle errors more gracefully
    res <- tryCatch({
        test_dir(dir, reporter = "summary")
    }, error = function(e) {
        cat(str_c("ERROR running tests in '", dir, "': ", e$message, "\n"))
        return(list(failures = list(e$message)))
    })
    
    if (!is.null(res$failures) && length(res$failures) > 0) {
        cat(str_c("Some R tests failed for directory '", dir, "'\n"))

        for (i in 1:length(res$failures)) {
            cat(str_c("Failing test ", i, ": ", res$failures[[i]], "\n"))
        }

        return(FALSE)
    }
    cat(str_c("All tests passed in directory: ", dir, "\n"))
    return(TRUE)
}

res <- sapply(c("./", "cluster/"), function(dir) {
    do.tests(dir)
})

if (!all(res)) {
    stop("Error exiting because of test failures")
}
