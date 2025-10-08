#!/bin/sh

# Install Node.js
echo "Installing Node.js..."
sudo apt-get update
sudo apt-get install -y nodejs

# Check if Node.js is installed correctly
node -v || { echo "Node.js installation failed"; exit 1; }

echo "Providing id_service"

cd id_service
npm install --no-bin-links
cd ..

