#!/bin/bash
set -euo pipefail

cd /codeface

if [ "${SKIP_CODEFACE_AUTOSTART:-0}" = "1" ]; then
  echo "SKIP_CODEFACE_AUTOSTART=1 -> skipping automatic service startup"
  exec /usr/sbin/sshd -D
fi

echo "Starting CodeFace backend services..."
./start-server.sh

echo "Starting CodeFace dashboard services..."
./start-dashboard.sh

exec /usr/sbin/sshd -D
