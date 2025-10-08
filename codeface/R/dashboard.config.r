# Minimal dashboard configuration to prevent crashes
# This provides default values when the main config is not available

# Override config.from.args to provide defaults
if (!exists("config.from.args.original")) {
  config.from.args.original <- config.from.args
  
  config.from.args <- function(require.project=FALSE) {
    # Try to load the original config first
    tryCatch({
      config.from.args.original(require.project=require.project)
    }, error = function(e) {
      cat("Warning: Could not load main configuration, using dashboard defaults\n")
      
      # Create minimal config with defaults
      list(
        dbhost = "localhost",
        dbname = "codeface",
        dbuser = "codeface", 
        dbpwd = "codeface",
        dbport = 3306,
        idServiceHostname = "127.0.0.1",
        idServicePort = 8080,
        understand = FALSE,
        sloccount = FALSE,
        project = "dashboard",
        repo = "dashboard",
        tagging = "tag"
      )
    })
  }
}

# Override query.projects to handle missing database gracefully
if (!exists("query.projects.original")) {
  query.projects.original <- query.projects
  
  query.projects <- function(con) {
    tryCatch({
      query.projects.original(con)
    }, error = function(e) {
      cat("Warning: Could not query projects from database, using empty list\n")
      # Return empty projects list
      data.frame(
        id = integer(0),
        name = character(0),
        repo = character(0),
        stringsAsFactors = FALSE
      )
    })
  }
}

cat("Dashboard configuration loaded with fallback defaults\n")
