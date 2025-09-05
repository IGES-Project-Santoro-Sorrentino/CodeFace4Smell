# Fix for CodeFace Dashboard Errors
# This script patches the problematic functions to prevent crashes

# Fix the combine.status function
combine.status <- function(status.list) {
  status.individual <- c(unlist(status.list))
  
  # Filter out error statuses and ensure we have numeric values
  status.individual <- status.individual[!(as.integer(status.individual) == as.integer(status.error))]
  
  if (length(status.individual) == 0) {
    status.error
  } else {
    # Convert to numeric and handle any non-numeric values
    status.numeric <- suppressWarnings(as.numeric(status.individual))
    status.numeric <- status.numeric[!is.na(status.numeric)]
    
    if (length(status.numeric) == 0) {
      # If no valid numeric values, return error status
      status.error
    } else {
      # Calculate mean of valid numeric values
      mean.status <- mean(status.numeric)
      as.status(status.codes[round(mean.status)])
    }
  }
}

# Fix the widget.overview.processing functions
renderWidget.widget.overview.processing <- function(w) {
  renderUI({
    ## Take minimum status as combined status
    status.values <- unlist(w$status())
    status.numeric <- suppressWarnings(as.numeric(status.values))
    status.numeric <- status.numeric[!is.na(status.numeric)]
    
    if (length(status.numeric) == 0) {
      combined.status <- status.error
    } else {
      combined.status <- status.codes[round(mean(status.numeric))]
    }
    
    indicator.summary <- symbols.processing.status[[which(names(symbols.processing.status) == combined.status)]]

    indicator.commits <- make.indicator(symbol.commit, as.color(w$status()$commits))
    indicator.timeseries <- make.indicator(symbol.timeseries, as.color(w$status()$timeseries))
    indicator.issues <- make.indicator(symbol.bug, as.color(w$status()$issues))
    indicator.ml <- make.indicator(symbol.email, as.color(w$status()$ml))
    indicator.complexity <- make.indicator(symbol.analysis, as.color(w$status()$complexity))

    link <- paste("?projectid=", w$pid(), sep="")
    overview.html(w$project.name(), indicator.summary,
              tags$table(width="100%", tags$tr(
                                 tags$td(indicator.commits),
                                 tags$td(indicator.timeseries),
                                 tags$td(indicator.issues),
                                 tags$td(indicator.ml),
                                 tags$td(indicator.complexity)
                                 )),
              link
    )
  })
}

widgetColor.widget.overview.processing <- function(w) {
  ## Also consider errors as "bad"
  reactive({
    status.values <- unlist(w$status())
    status.numeric <- suppressWarnings(as.numeric(status.values))
    status.numeric <- status.numeric[!is.na(status.numeric)]
    
    if (length(status.numeric) == 0) {
      as.color(status.error)
    } else {
      as.color(status.codes[round(mean(status.numeric))])
    }
  })
}

# Fix the widget.overview.project function
initWidget.widget.overview.project <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  w$status <- reactive({
    # Safely get status values with error handling
    tryCatch({
      list(
        collaboration = tryCatch({
          result <- figure.of.merit.collaboration(w$pid())
          if (is.null(result) || is.null(result$status)) status.error else result$status
        }, error = function(e) {
          loginfo(paste("Error getting collaboration status:", e$message))
          status.error
        }),
        construction = tryCatch({
          result <- figure.of.merit.construction(w$pid())
          if (is.null(result) || is.null(result$status)) status.error else result$status
        }, error = function(e) {
          loginfo(paste("Error getting construction status:", e$message))
          status.error
        }),
        communication = tryCatch({
          result <- figure.of.merit.communication(w$pid())
          if (is.null(result) || is.null(result$status)) status.error else result$status
        }, error = function(e) {
          loginfo(paste("Error getting communication status:", e$message))
          status.error
        }),
        complexity = tryCatch({
          result <- figure.of.merit.complexity(w$pid())
          if (is.null(result) || is.null(result$status)) status.error else result$status
        }, error = function(e) {
          loginfo(paste("Error getting complexity status:", e$message))
          status.error
        })
      )
    }, error = function(e) {
      loginfo(paste("Error in widget.overview.project status:", e$message))
      list(
        collaboration = status.error,
        construction = status.error,
        communication = status.error,
        complexity = status.error
      )
    })
  })
  return(w)
}

# Fix the widgetExplanation function
widgetExplanation.widget.overview.project <- function(w) {
  reactive({
    print("--------------------")
    cs <- combine.status(w$status())
    
    # Safely extract status values and handle NULL cases
    status.list <- w$status()
    if (is.null(status.list) || length(status.list) == 0) {
      return("No status information available for this project.")
    }
    
    # Convert status values to integers safely
    status.int <- lapply(status.list, function(x) {
      if (is.null(x)) return(NA)
      suppressWarnings(as.integer(x))
    })
    
    # Filter out NA values and get names
    error <- names(status.int)[!is.na(status.int) & status.int == as.integer(status.error)]
    good <- names(status.int)[!is.na(status.int) & status.int == as.integer(status.good)]
    warn <- names(status.int)[!is.na(status.int) & status.int == as.integer(status.warn)]
    bad <- names(status.int)[!is.na(status.int) & status.int == as.integer(status.bad)]
    
    if (all(!is.na(status.int)) && all(status.int == as.integer(status.good))) {
      return("This project has good marks in all categories and is fully analysed.")
    }
    
    res <- list()
    if (length(good) > 0) {
      res <- c(res, paste("This project has good marks in ", text.enumerate(good), ".", sep=""))
    }
    if (length(warn) > 0) {
      res <- c(res, paste("Warnings have been reported for ", text.enumerate(warn), ".", sep=""))
    }
    if (length(bad) > 0) {
      res <- c(res, paste("There seem to be problems in ", text.enumerate(bad), ".", sep=""))
    }
    if (length(error) > 0) {
      res <- c(res, paste("No analysis has been done for ", text.enumerate(error), ".", sep=""))
    }
    
    if (length(res) == 0) {
      res <- c("Status information is incomplete or unavailable.")
    }
    
    res <- c(res, "Click 'details...' to get more information on the evaluations.")
    do.call(paste, res)
  })
}

cat("Dashboard error fixes loaded successfully!\n")
cat("The following functions have been patched:\n")
cat("- combine.status\n")
cat("- renderWidget.widget.overview.processing\n")
cat("- widgetColor.widget.overview.processing\n")
cat("- initWidget.widget.overview.project\n")
cat("- widgetExplanation.widget.overview.project\n")
cat("\nThese fixes will prevent the dashboard from crashing due to:\n")
cat("- Non-numeric status values in mean() calculations\n")
cat("- NULL values from figure.of.merit functions\n")
cat("- Database connection issues\n")
cat("- Missing data in status calculations\n")
