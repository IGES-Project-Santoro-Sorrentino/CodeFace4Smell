#!/bin/bash

# Esegui setup Python (una tantum)
cd /vagrant
python setup.py develop --user

# Avvia il servizio Node.js in background
cd /vagrant/id_service
node id_service.js ../codeface.conf > /home/vagrant/id_service.log 2>&1 &