#!/bin/bash

# Modern Shiny App Deployment Script
# This script deploys Shiny apps using nginx and R directly
# No problematic Node.js dependencies!

set -e

echo "=== Modern Shiny App Deployment ==="
echo "Using nginx + R instead of problematic shiny-server"

# Configuration
SHINY_PORT=8081
SHINY_APPS_DIR="/codeface/shiny-apps"
NGINX_CONF="/etc/nginx/sites-available/shiny"
NGINX_ENABLED="/etc/nginx/sites-enabled/shiny"

# Create Shiny apps directory
mkdir -p "$SHINY_APPS_DIR"

# Install required R packages if not already installed
echo "Installing required R packages..."
R --slave -e "
if (!require(shiny)) install.packages('shiny', repos='https://cran.rstudio.com/')
if (!require(rmarkdown)) install.packages('rmarkdown', repos='https://cran.rstudio.com/')
if (!require(DT)) install.packages('DT', repos='https://cran.rstudio.com/')
if (!require(plotly)) install.packages('plotly', repos='https://cran.rstudio.com/')
"

# Create a sample Shiny app for testing
cat > "$SHINY_APPS_DIR/sample-app/app.R" << 'EOF'
library(shiny)

ui <- fluidPage(
  titlePanel("CodeFace Analysis Dashboard"),
  sidebarLayout(
    sidebarPanel(
      h3("Analysis Options"),
      selectInput("analysis_type", "Analysis Type:", 
                  choices = c("Commit Analysis", "Time Series", "Network Analysis")),
      actionButton("run_analysis", "Run Analysis")
    ),
    mainPanel(
      h3("Results"),
      verbatimTextOutput("results"),
      plotOutput("plot")
    )
  )
)

server <- function(input, output) {
  output$results <- renderText({
    "CodeFace analysis results will appear here.\nThis is a sample dashboard."
  })
  
  output$plot <- renderPlot({
    plot(1:10, 1:10, main = "Sample Plot", xlab = "X", ylab = "Y")
  })
}

shinyApp(ui = ui, server = server)
EOF

# Create a startup script for the Shiny app
cat > "$SHINY_APPS_DIR/start-shiny.sh" << EOF
#!/bin/bash
cd "$SHINY_APPS_DIR/sample-app"
R --slave -e "shiny::runApp(host = '0.0.0.0', port = $SHINY_PORT)"
EOF

chmod +x "$SHINY_APPS_DIR/start-shiny.sh"

# Create nginx configuration
cat > "$NGINX_CONF" << EOF
server {
    listen 80;
    server_name _;
    
    # Root directory for static files
    root /var/www;
    
    # Proxy Shiny app requests
    location / {
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_set_header Host \$host;
        proxy_pass http://127.0.0.1:$SHINY_PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # WebSocket support for Shiny
        proxy_read_timeout 86400;
        proxy_send_timeout 86400;
    }
    
    # Static file caching
    location ~* \.(?:ico|ttf|woff|css|js|gif|jpe?g|png)$ {
        expires max;
        add_header Pragma public;
        add_header Cache-Control "public, must-revalidate, proxy-revalidate";
        proxy_pass http://127.0.0.1:$SHINY_PORT;
    }
}
EOF

# Enable the nginx site
ln -sf "$NGINX_CONF" "$NGINX_ENABLED"

# Test nginx configuration
nginx -t

# Reload nginx
systemctl reload nginx

echo "=== Deployment Complete ==="
echo "Shiny app deployed on port $SHINY_PORT"
echo "Nginx configured and reloaded"
echo ""
echo "To start the Shiny app:"
echo "  cd $SHINY_APPS_DIR"
echo "  ./start-shiny.sh"
echo ""
echo "To access the app: http://localhost"
echo ""
echo "To add more apps, create new directories in $SHINY_APPS_DIR"
echo "and modify the nginx configuration as needed."
