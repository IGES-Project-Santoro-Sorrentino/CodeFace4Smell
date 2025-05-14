#!/bin/bash

# Avvia il servizio Node.js in background
cd /vagrant/id_service
node id_service.js ../codeface.conf > /home/vagrant/id_service.log 2>&1 &