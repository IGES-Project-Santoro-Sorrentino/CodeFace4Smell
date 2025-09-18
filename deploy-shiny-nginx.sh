#!/bin/bash

# Comprehensive Shiny + nginx Deployment Script
# This replaces the problematic shiny-server with a modern nginx-based solution
# AND uses the existing CodeFace dashboard instead of creating a new one

set -e

echo "=== Deploying Modern Nginx Infrastructure ==="

# Load configuration
source deploy.conf

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Step 1: Installing required R packages...${NC}"
# Use the project's package installation script
Rscript rpackages/install_shiny_packages.R
echo -e "${GREEN}✓ R package installation completed${NC}"

echo -e "${GREEN}Step 2: Setting up configuration file...${NC}"
# Check that configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}✗ Configuration file not found at $CONFIG_FILE${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Configuration file found at $CONFIG_FILE${NC}"

echo -e "${GREEN}Step 3: Creating Shiny apps directory...${NC}"
mkdir -p "$SHINY_APPS_DIR"

echo -e "${GREEN}Step 4: Using existing CodeFace dashboard...${NC}"

# Check for dashboard in expected location
if [ ! -d "$DASHBOARD_PATH" ]; then
    echo -e "${RED}✗ CodeFace dashboard not found at $DASHBOARD_PATH${NC}"
    exit 1
fi

EXISTING_DASHBOARD="$DASHBOARD_PATH"
echo -e "${GREEN}✓ Found dashboard at: $EXISTING_DASHBOARD${NC}"

# Create a symlink to the dashboard
ln -sf "$EXISTING_DASHBOARD" "$SHINY_APPS_DIR/codeface-dashboard"

echo -e "${GREEN}Step 5: Using existing startup scripts...${NC}"
# Scripts are now part of the project

echo -e "${GREEN}Step 6: Installing and configuring nginx...${NC}"
# Check if nginx is installed, install if not
if ! command -v nginx &> /dev/null; then
    echo -e "${YELLOW}nginx not found, installing...${NC}"
    apt-get update && apt-get install -y nginx
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ nginx installed successfully${NC}"
    else
        echo -e "${RED}✗ Failed to install nginx${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ nginx is already installed${NC}"
fi

# Create nginx directories if they don't exist
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled
mkdir -p /var/www

# Check that nginx.conf exists
if [ ! -f "$NGINX_MAIN_CONF" ]; then
    echo -e "${RED}✗ nginx.conf not found at $NGINX_MAIN_CONF${NC}"
    exit 1
fi
echo -e "${GREEN}✓ nginx.conf found${NC}"

# Copy nginx configuration from project
cp nginx.shinyserver.conf "$NGINX_CONF"

echo -e "${GREEN}Step 7: Enabling nginx site...${NC}"
ln -sf "$NGINX_CONF" "$NGINX_ENABLED"

echo -e "${GREEN}Step 8: Testing nginx configuration...${NC}"
nginx -t
echo -e "${GREEN}✓ Nginx configuration is valid${NC}"

echo -e "${GREEN}Step 9: Starting services using start-services.sh...${NC}"
# Use the dedicated startup script
bash start-services.sh

echo -e "${GREEN}✓ All services started successfully${NC}"

echo "Ready"
