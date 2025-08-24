# Docker Container Setup Guide

## Prerequisites

- Docker installed on your system
- Docker daemon running

## Building the Docker Image

1. **Build from Dockerfile**

   ```bash
   docker build -t codeface4smell .
   ```

## Starting the Container

1. **Accessing the App**

   ```bash
   docker exec codeface4smell /bin/bash
   ```

2. **Lancia codeface**

   ```bash
   ./start_server.sh
   ```

## Stopping and Deleting the Container

1. **Stop the container**

   ```bash
   docker stop codeface4smell
   ```

2. **Delete the Container**
