#! /bin/sh

# Copyright Siemens AG 2013
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# This script sets up a self-contained version of the shiny server,
# downloading a dedicated version of the latest node.js and then
# installing the modified shiny-server from
# https://github.com/JohannesEbke/shiny-server/tree/no-su
# with all dependencies in the node.js directory.
# It also creates a shiny-server-pack.tar.gz for distribution.

# This script must be run on a server where HTTP and HTTPS connections
# to the internet are possible. For installation on other systems,
# copy the shiny-server-pack.tar.gz and untar it in the prosoda project
# directory.

# Detect architecture and set appropriate Node.js version
if [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ]; then
    export ARCH=arm64
    export NODEVER=10.24.1  # Use Node.js v10 for compatibility with original shiny-server
else
    export ARCH=x64
    export NODEVER=0.10.13
fi
export NODEVERSION=node-v${NODEVER}-linux-$ARCH

# --------
set -e
set -u

# Clean up any previous failed installations
if [ -d "$NODEVERSION" ]; then
    echo "Cleaning up previous installation..."
    rm -rf "$NODEVERSION"
fi
if [[ ! -e $NODEVERSION.tar.gz ]]; then
  if [ "$ARCH" = "arm64" ]; then
    # For ARM64, use the Node.js v10 distribution format
    wget https://nodejs.org/dist/v$NODEVER/node-v$NODEVER-linux-arm64.tar.gz -O ${NODEVERSION}.tar.gz
  else
    # For x64, use the original format
    wget http://nodejs.org/dist/v$NODEVER/${NODEVERSION}.tar.gz
  fi
fi

#rm -rf $NODEVERSION
tar xzf ${NODEVERSION}.tar.gz

# Set PATH to use the downloaded Node.js version
export PATH="$PWD/$NODEVERSION/bin:$PATH"

# Configure npm to handle permission issues
npm config set cache /tmp/.npm-cache
npm config set prefix /tmp/.npm-global

# Verify we're using the correct Node.js version
echo "Using Node.js version: $(node --version)"
echo "Using npm version: $(npm --version)"

# Install shiny-server with appropriate npm flags for newer Node.js versions
if [ "$ARCH" = "arm64" ]; then
    # For ARM64, use a Node.js version that's compatible with the original shiny-server
    echo "Installing shiny-server for ARM64..."
    npm install -g --unsafe-perm --no-optional --prefix /tmp/.npm-global https://github.com/JohannesEbke/shiny-server/archive/no-su.tar.gz
else
    # For older Node.js versions, use the original command
    npm install -g --unsafe-perm --no-optional --prefix /tmp/.npm-global https://github.com/JohannesEbke/shiny-server/archive/no-su.tar.gz
fi

# Copy shiny-server to the Node.js bin directory for easy access
if [ -f "/tmp/.npm-global/bin/shiny-server" ]; then
    cp /tmp/.npm-global/bin/shiny-server $NODEVERSION/bin/
    echo "Shiny-server installed successfully!"
else
    echo "Error: shiny-server installation failed"
    exit 1
fi

tar czf shiny-server-pack.tar.gz $NODEVERSION shiny-server-pack.sh
