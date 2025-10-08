# CodeFace Dashboard App
# Main entry point for the dashboard application

# Source the global configuration
source("global.r")

# Source the UI and server
source("ui.r")
source("server.r")

# Run the Shiny app
shinyApp(ui = ui, server = server)
