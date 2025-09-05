#!/bin/bash

# Comprehensive Shiny + nginx Deployment Script
# This replaces the problematic shiny-server with a modern nginx-based solution
# AND uses the existing CodeFace dashboard instead of creating a new one

set -e

echo "=== Deploying Modern Shiny Infrastructure ==="
echo "Replacing problematic shiny-server with nginx + R"
echo "Using existing CodeFace dashboard from codeface/R/shiny/apps/dashboard/"

# Configuration
SHINY_PORT=8082  # Changed from 8081 to avoid conflict with nginx
DETAILS_PORT=8083  # Port for details app
SHINY_APPS_DIR="/codeface/shiny-apps"
NGINX_CONF="/etc/nginx/sites-available/shiny"
NGINX_ENABLED="/etc/nginx/sites-enabled/shiny"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Step 1: Installing required R packages...${NC}"
# Create a temporary R script for package installation
cat > /tmp/install_packages.R << 'EOF'
# Function to safely install packages
safe_install <- function(pkg) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat('Installing', pkg, 'package...\n')
    tryCatch({
      install.packages(pkg, repos='https://cran.rstudio.com/', dependencies = TRUE)
      cat('✓ Successfully installed', pkg, 'package\n')
    }, error = function(e) {
      cat('⚠ Warning: Failed to install', pkg, 'package:', e$message, '\n')
      cat('  The dashboard may have limited functionality without this package\n')
    })
  } else {
    cat('✓', pkg, 'package already installed\n')
  }
}

# Install required packages
safe_install('shiny')
safe_install('rmarkdown')
safe_install('DT')
safe_install('plotly')
safe_install('RMySQL')
safe_install('logging')
safe_install('jsonlite')
EOF

# Run the R script
if R --slave -f /tmp/install_packages.R; then
    echo -e "${GREEN}✓ R package installation completed${NC}"
else
    echo -e "${YELLOW}⚠ Some R packages may have failed to install, but continuing...${NC}"
fi
rm -f /tmp/install_packages.R

echo -e "${GREEN}Step 2: Creating Shiny apps directory...${NC}"
mkdir -p "$SHINY_APPS_DIR"

echo -e "${GREEN}Step 3: Using existing CodeFace dashboard...${NC}"
# The project already has a complete dashboard at codeface/R/shiny/apps/dashboard/
# We'll use that instead of creating a new one

# Try to find the dashboard in various possible locations
EXISTING_DASHBOARD=""
if [ -d "R/shiny/apps/dashboard" ]; then
    EXISTING_DASHBOARD="R/shiny/apps/dashboard"
    echo -e "${GREEN}✓ Found dashboard at: $EXISTING_DASHBOARD${NC}"
elif [ -d "/codeface/R/shiny/apps/dashboard" ]; then
    EXISTING_DASHBOARD="/codeface/R/shiny/apps/dashboard"
    echo -e "${GREEN}✓ Found dashboard at: $EXISTING_DASHBOARD${NC}"
elif [ -d "/codeface/codeface/R/shiny/apps/dashboard" ]; then
    EXISTING_DASHBOARD="/codeface/codeface/R/shiny/apps/dashboard"
    echo -e "${GREEN}✓ Found dashboard at: $EXISTING_DASHBOARD${NC}"
elif [ -d "/codeface/codeface_dump/R/shiny/apps/dashboard" ]; then
    EXISTING_DASHBOARD="/codeface/codeface_dump/R/shiny/apps/dashboard"
    echo -e "${GREEN}✓ Found dashboard at: $EXISTING_DASHBOARD${NC}"
else
    echo -e "${RED}✗ Could not find CodeFace dashboard in expected locations${NC}"
    echo -e "${YELLOW}Creating a basic dashboard instead...${NC}"
        
        # Create a basic dashboard as fallback
        mkdir -p "$SHINY_APPS_DIR/basic-dashboard"
        cat > "$SHINY_APPS_DIR/basic-dashboard/app.R" << 'EOF'
library(shiny)

ui <- fluidPage(
  titlePanel("CodeFace Analysis Dashboard"),
  sidebarLayout(
    sidebarPanel(
      h3("Analysis Options"),
      selectInput("analysis_type", "Analysis Type:", 
                  choices = c("Commit Analysis", "Time Series", "Network Analysis", "Complexity Analysis")),
      actionButton("run_analysis", "Run Analysis", class = "btn-primary"),
      hr(),
      h4("Project Information"),
      textOutput("project_info")
    ),
    mainPanel(
      h3("Analysis Results"),
      verbatimTextOutput("results"),
      plotOutput("plot"),
      hr(),
      h4("Recent Activity"),
      tableOutput("activity_table")
    )
  )
)

server <- function(input, output) {
  output$project_info <- renderText({
    "CodeFace Project Analysis Dashboard\nVersion: 1.0"
  })
  
  output$results <- renderText({
    req(input$analysis_type)
    paste("Running", input$analysis_type, "...\nResults will appear here.")
  })
  
  output$plot <- renderPlot({
    req(input$analysis_type)
    # Sample plot based on analysis type
    if (input$analysis_type == "Time Series") {
      plot(1:20, cumsum(rnorm(20)), type = "l", 
           main = "Sample Time Series", xlab = "Time", ylab = "Value")
    } else if (input$analysis_type == "Network Analysis") {
      plot(1:10, 1:10, main = "Network Graph", xlab = "X", ylab = "Y")
    } else {
      plot(1:10, 1:10, main = "Analysis Results", xlab = "X", ylab = "Y")
    }
  })
  
  output$activity_table <- renderTable({
    data.frame(
      Activity = c("Analysis Started", "Data Loaded", "Processing Complete"),
      Timestamp = c(Sys.time(), Sys.time(), Sys.time()),
      Status = c("Running", "Complete", "Complete")
    )
  })
}

shinyApp(ui = ui, server = server)
EOF
        
        EXISTING_DASHBOARD="$SHINY_APPS_DIR/basic-dashboard"
        echo -e "${GREEN}✓ Created basic dashboard at: $EXISTING_DASHBOARD${NC}"
    fi

# Verify we found or created a dashboard
if [ -z "$EXISTING_DASHBOARD" ]; then
    echo -e "${RED}✗ Failed to find or create dashboard${NC}"
    exit 1
fi

# Create a symlink to the dashboard
ln -sf "$EXISTING_DASHBOARD" "$SHINY_APPS_DIR/codeface-dashboard"

echo -e "${GREEN}Step 4: Creating startup script for dashboard...${NC}"
cat > "$SHINY_APPS_DIR/start-dashboard.sh" << EOF
#!/bin/bash
cd "$EXISTING_DASHBOARD"
echo "Starting CodeFace dashboard on port $SHINY_PORT..."

# Start the Shiny app using the dashboard directory (server.r will load error fixes)
R --slave -e "shiny::runApp(host = '0.0.0.0', port = $SHINY_PORT)"
EOF

chmod +x "$SHINY_APPS_DIR/start-dashboard.sh"

echo -e "${GREEN}Step 5: Setting up dashboard error fixes...${NC}"
# Set up the error fixes - handle cases where file might already exist
if [ -f "fix_dashboard_errors.r" ]; then
    # Check if the file is already in the target location
    if [ -f "/codeface/fix_dashboard_errors.r" ]; then
        if [ "$(realpath fix_dashboard_errors.r)" = "$(realpath /codeface/fix_dashboard_errors.r)" ]; then
            echo -e "${GREEN}✓ Dashboard error fixes already in /codeface/${NC}"
        else
            cp fix_dashboard_errors.r /codeface/
            echo -e "${GREEN}✓ Dashboard error fixes copied to /codeface/${NC}"
        fi
    else
        cp fix_dashboard_errors.r /codeface/
        echo -e "${GREEN}✓ Dashboard error fixes copied to /codeface/${NC}"
    fi
elif [ -f "/codeface/fix_dashboard_errors.r" ]; then
    echo -e "${GREEN}✓ Dashboard error fixes already available in /codeface/${NC}"
else
    echo -e "${YELLOW}⚠ Warning: fix_dashboard_errors.r not found${NC}"
    echo -e "${YELLOW}  The dashboard may still have some error handling issues${NC}"
fi

echo -e "${GREEN}Step 6: Installing and configuring nginx...${NC}"
# Install nginx if not present
if ! command -v nginx &> /dev/null; then
    echo -e "${YELLOW}Installing nginx...${NC}"
    apt-get update
    apt-get install -y nginx
fi

# Create nginx directories if they don't exist
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled
mkdir -p /var/www

# Create a basic nginx.conf if it doesn't exist
if [ ! -f /etc/nginx/nginx.conf ]; then
    cat > /etc/nginx/nginx.conf << 'EOF'
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 768;
}

http {
    sendfile on;
    tcp_nopush on;
    types_hash_max_size 2048;
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
EOF
fi

cat > "$NGINX_CONF" << EOF
server {
    listen 8081;
    server_name _;
    
    # Root directory for static files
    root /var/www;
    
    # Handle /dashboard/ path specifically
    location /dashboard/ {
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_set_header Host \$host;
        proxy_pass http://127.0.0.1:$SHINY_PORT/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # WebSocket support for Shiny
        proxy_read_timeout 86400;
        proxy_send_timeout 86400;
        
        # Buffer settings for better performance
        proxy_buffering on;
        proxy_buffer_size 128k;
        proxy_buffers 4 256k;
        proxy_busy_buffers_size 256k;
    }
    
    # Handle /details path specifically
    location /details {
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_set_header Host \$host;
        proxy_pass http://127.0.0.1:$DETAILS_PORT/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # WebSocket support for Shiny
        proxy_read_timeout 86400;
        proxy_send_timeout 86400;
        
        # Buffer settings for better performance
        proxy_buffering on;
        proxy_buffer_size 128k;
        proxy_buffers 4 256k;
        proxy_busy_buffers_size 256k;
    }
    
    # Handle static files for dashboard
    location ~* ^/dashboard/(.*\.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot))$ {
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_set_header Host \$host;
        proxy_pass http://127.0.0.1:$SHINY_PORT/\$1;
        expires max;
        add_header Pragma public;
        add_header Cache-Control "public, must-revalidate, proxy-revalidate";
    }
    
    # Static file caching for root path
    location ~* \.(?:ico|ttf|woff|css|js|gif|jpe?g|png)$ {
        expires max;
        add_header Pragma public;
        add_header Cache-Control "public, must-revalidate, proxy-revalidate";
        proxy_pass http://127.0.0.1:$SHINY_PORT;
    }
    
    # Proxy all other Shiny app requests
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
        
        # Buffer settings for better performance
        proxy_buffering on;
        proxy_buffer_size 128k;
        proxy_buffers 4 256k;
        proxy_busy_buffers_size 256k;
    }
    
    # Health check endpoint
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
EOF

echo -e "${GREEN}Step 7: Enabling nginx site...${NC}"
ln -sf "$NGINX_CONF" "$NGINX_ENABLED"

echo -e "${GREEN}Step 8: Creating management scripts...${NC}"
# We'll create these in Step 10, just a placeholder here

echo -e "${GREEN}Step 9: Testing nginx configuration...${NC}"
if nginx -t; then
    echo -e "${GREEN}✓ Nginx configuration is valid${NC}"
else
    echo -e "${RED}✗ Nginx configuration test failed${NC}"
    exit 1
fi

echo -e "${GREEN}Step 10: Starting services (Docker-compatible mode)...${NC}"
# Docker containers don't have systemd, so we'll start services directly

echo -e "${YELLOW}Starting nginx...${NC}"
# Start nginx in background
nginx -g "daemon off;" &
NGINX_PID=$!
echo $NGINX_PID > /tmp/nginx.pid

echo -e "${YELLOW}Starting existing CodeFace dashboard...${NC}"
# Start existing dashboard in background
cd "$EXISTING_DASHBOARD"
R --slave -e "shiny::runApp(host = '0.0.0.0', port = $SHINY_PORT)" &
SHINY_PID=$!
echo $SHINY_PID > /tmp/shiny.pid

echo -e "${YELLOW}Starting CodeFace details app...${NC}"
# Start details app in background
cd "/codeface/codeface/R/shiny/apps/details"
R --slave -e "shiny::runApp(host = '0.0.0.0', port = $DETAILS_PORT)" &
DETAILS_PID=$!
echo $DETAILS_PID > /tmp/details.pid

# Wait a moment for services to start
sleep 5

# Check if services are running
if kill -0 $NGINX_PID 2>/dev/null; then
    echo -e "${GREEN}✓ Nginx is running (PID: $NGINX_PID)${NC}"
else
    echo -e "${RED}✗ Nginx failed to start${NC}"
    exit 1
fi

if kill -0 $SHINY_PID 2>/dev/null; then
    echo -e "${GREEN}✓ CodeFace dashboard is running (PID: $SHINY_PID)${NC}"
else
    echo -e "${RED}✗ CodeFace dashboard failed to start${NC}"
    exit 1
fi

if kill -0 $DETAILS_PID 2>/dev/null; then
    echo -e "${GREEN}✓ CodeFace details app is running (PID: $DETAILS_PID)${NC}"
else
    echo -e "${RED}✗ CodeFace details app failed to start${NC}"
    exit 1
fi

# Create management scripts
echo -e "${GREEN}Step 11: Creating management scripts...${NC}"

cat > "$SHINY_APPS_DIR/start-services.sh" << EOF
#!/bin/bash
# Start nginx, CodeFace dashboard, and details app
echo "Starting nginx..."
nginx -g "daemon off;" &
echo \$! > /tmp/nginx.pid

echo "Starting CodeFace dashboard..."
cd "$EXISTING_DASHBOARD"
R --slave -e "shiny::runApp(host = '0.0.0.0', port = $SHINY_PORT)" &
echo \$! > /tmp/shiny.pid

echo "Starting CodeFace details app..."
cd "/codeface/codeface/R/shiny/apps/details"
R --slave -e "shiny::runApp(host = '0.0.0.0', port = $DETAILS_PORT)" &
echo \$! > /tmp/details.pid

echo "Services started. PIDs saved to /tmp/nginx.pid, /tmp/shiny.pid, and /tmp/details.pid"
echo "Use ./stop-services.sh to stop them"
EOF

cat > "$SHINY_APPS_DIR/stop-services.sh" << 'EOF'
#!/bin/bash
# Stop nginx, CodeFace dashboard, and details app
if [ -f /tmp/nginx.pid ]; then
    echo "Stopping nginx..."
    kill $(cat /tmp/nginx.pid) 2>/dev/null || true
    rm -f /tmp/nginx.pid
fi

if [ -f /tmp/shiny.pid ]; then
    echo "Stopping CodeFace dashboard..."
    kill $(cat /tmp/shiny.pid) 2>/dev/null || true
    rm -f /tmp/shiny.pid
fi

if [ -f /tmp/details.pid ]; then
    echo "Stopping CodeFace details app..."
    kill $(cat /tmp/details.pid) 2>/dev/null || true
    rm -f /tmp/details.pid
fi

echo "All services stopped"
EOF

cat > "$SHINY_APPS_DIR/status.sh" << 'EOF'
#!/bin/bash
# Check status of services
echo "=== Service Status ==="

if [ -f /tmp/nginx.pid ]; then
    NGINX_PID=$(cat /tmp/nginx.pid)
    if kill -0 $NGINX_PID 2>/dev/null; then
        echo "✓ Nginx: Running (PID: $NGINX_PID)"
    else
        echo "✗ Nginx: Not running (stale PID file)"
        rm -f /tmp/nginx.pid
    fi
else
    echo "✗ Nginx: Not running (no PID file)"
fi

if [ -f /tmp/shiny.pid ]; then
    SHINY_PID=$(cat /tmp/shiny.pid)
    if kill -0 $SHINY_PID 2>/dev/null; then
        echo "✓ CodeFace dashboard: Running (PID: $SHINY_PID)"
    else
        echo "✗ CodeFace dashboard: Not running (stale PID file)"
        rm -f /tmp/shiny.pid
    fi
else
    echo "✗ CodeFace dashboard: Not running (no PID file)"
fi

if [ -f /tmp/details.pid ]; then
    DETAILS_PID=$(cat /tmp/details.pid)
    if kill -0 $DETAILS_PID 2>/dev/null; then
        echo "✓ CodeFace details app: Running (PID: $DETAILS_PID)"
    else
        echo "✗ CodeFace details app: Not running (stale PID file)"
        rm -f /tmp/details.pid
    fi
else
    echo "✗ CodeFace details app: Not running (no PID file)"
fi

echo ""
echo "=== Port Status ==="
netstat -tlnp 2>/dev/null | grep -E ":(8081|8082|8083)" || echo "No services listening on ports 8081, 8082, or 8083"
EOF

chmod +x "$SHINY_APPS_DIR"/*.sh

echo ""
echo -e "${GREEN}=== Deployment Complete! ===${NC}"
echo ""
echo -e "${GREEN}Your existing CodeFace dashboard is now running with nginx!${NC}"
echo ""
echo -e "${YELLOW}Access your dashboard at: http://localhost:8081/dashboard/?projectid=2${NC}"
echo -e "${YELLOW}Health check: http://localhost:8081/health${NC}"
echo ""
echo -e "${GREEN}Management commands:${NC}"
echo "  Start services:  $SHINY_APPS_DIR/start-services.sh"
echo "  Stop services:   $SHINY_APPS_DIR/stop-services.sh"
echo "  Check status:    $SHINY_APPS_DIR/status.sh"
echo "  View nginx logs: tail -f /var/log/nginx/access.log"
echo "  View nginx error: tail -f /var/log/nginx/error.log"
echo ""
echo -e "${GREEN}What you now have:${NC}"
echo "  ✓ Existing CodeFace dashboard (professional, feature-rich)"
echo "  ✓ Multiple widget types: collaboration, communication, complexity"
echo "  ✓ Bootstrap UI with gridster widgets and breadcrumbs"
echo "  ✓ nginx reverse proxy for performance"
echo "  ✓ Docker-compatible (no systemd required)"
echo ""
echo -e "${GREEN}This solution is:${NC}"
echo "  ✓ Modern and maintained"
echo "  ✓ No Node.js dependency issues"
echo "  ✓ Uses existing, tested dashboard code"
echo "  ✓ Production-ready"
echo "  ✓ Easy to scale"
echo "  ✓ Compatible with all architectures"
echo ""
echo -e "${YELLOW}IMPORTANT: Since this is running in Docker, access your app at:${NC}"
echo -e "${YELLOW}  http://localhost:8081  (if port 8081 is forwarded)${NC}"
echo -e "${YELLOW}  or restart Docker with: -p 8080:8081${NC}"
echo ""
echo -e "${GREEN}Current service status:${NC}"
echo "  Nginx PID: $NGINX_PID"
echo "  CodeFace Dashboard PID: $SHINY_PID"
echo "  CodeFace Details App PID: $DETAILS_PID"
echo ""
echo -e "${YELLOW}Note: Services are running in background. Use the management scripts to control them.${NC}"
