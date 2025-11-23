#!/bin/bash

# Comprehensive Shiny + nginx Deployment Script
# This replaces the problematic shiny-server with a modern nginx-based solution
# AND uses the existing CodeFace dashboard instead of creating a new one

set -e

echo "=== Deploying Modern Nginx Infrastructure ==="

# Load configuration
source deploy.conf

# Ensure we only perform heavy setup once per container lifetime.
STATE_DIR=/var/lib/codeface
STATE_FILE=$STATE_DIR/dashboard_setup_done
mkdir -p "$STATE_DIR"

if [ -f "$STATE_FILE" ]; then
    echo "Detected existing dashboard setup. Skipping provisioning steps."
    echo "Restarting dashboard-related services..."
    bash start-services.sh
    exit 0
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Step 1: Installing required R packages...${NC}"
Rscript rpackages/install_shiny_packages.R
echo -e "${GREEN}✓ R packages installed${NC}"

echo -e "${GREEN}Step 2: Setting up Shiny apps directory and dashboard...${NC}"
mkdir -p "$SHINY_APPS_DIR"

# Check for dashboard in expected location
if [ ! -d "$DASHBOARD_PATH" ]; then
    echo -e "${RED}✗ CodeFace dashboard not found at $DASHBOARD_PATH${NC}"
    exit 1
fi

# Create symlink to the dashboard
ln -sf "$DASHBOARD_PATH" "$SHINY_APPS_DIR/codeface-dashboard"
echo -e "${GREEN}✓ Dashboard linked successfully${NC}"

echo -e "${GREEN}Step 3: Installing and configuring nginx...${NC}"
# Install nginx if not present
if ! command -v nginx &> /dev/null; then
    echo -e "${YELLOW}Installing nginx...${NC}"
    apt-get update && apt-get install -y nginx || {
        echo -e "${RED}✗ Failed to install nginx${NC}"
        exit 1
    }
fi

# Setup nginx directories and configuration
mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled /var/www
cp nginx.shinyserver.conf "$NGINX_CONF"
ln -sf "$NGINX_CONF" "$NGINX_ENABLED"
echo -e "${GREEN}✓ nginx configured${NC}"

echo -e "${GREEN}Step 4: Testing nginx configuration...${NC}"
nginx -t
echo -e "${GREEN}✓ Nginx configuration valid${NC}"

echo -e "${GREEN}Step 5: Starting services...${NC}"
bash start-services.sh

echo -e "${GREEN}=== Deployment Complete ===${NC}"

touch "$STATE_FILE"
