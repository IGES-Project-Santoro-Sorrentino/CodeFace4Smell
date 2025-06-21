#!/bin/bash

# Avvia il servizio Node.js in background
cd /id_service
node id_service.js ../codeface.conf > $HOME/id_service.log 2>&1 &