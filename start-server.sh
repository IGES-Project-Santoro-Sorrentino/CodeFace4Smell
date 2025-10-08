#!/bin/bash

pip3 install -e .

service mysql start
if [ $? -ne 0 ]; then
	echo "Failed to start MySQL service"
	exit 1
fi

# Avvia il servizio Node.js in background
cd ./id_service
if [ $? -ne 0 ]; then
	echo "Failed to change directory to ./id_service"
	exit 1
fi

if [ "$1" = "test" ]; then
	node id_service.js ../codeface_testing.conf > $HOME/id_service.log 2>&1 &
	echo "Running in test mode"
else
	node id_service.js ../codeface.conf > $HOME/id_service.log 2>&1 &
	echo "Running in normal mode"
fi

# node id_service.js ../codeface.conf > $HOME/id_service.log 2>&1 &
if [ $? -ne 0 ]; then
	echo "Failed to start Node.js service"
	exit 1
fi