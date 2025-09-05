# Docker Access Guide for Shiny + nginx

## The Problem

Since your Shiny app runs inside a Docker container, you **cannot** access it directly with `localhost` from your host machine. The container has its own network namespace.

## Current Docker Setup

Your container is currently running with:

```bash
docker ps
# Shows: 22/tcp, 8081/tcp, 8100/tcp
```

This means ports 22, 8081, and 8100 are **exposed** inside the container but **not forwarded** to your host machine.

## Solution: Port Forwarding

You need to **forward** ports from the container to your host machine.

### Option 1: Restart Container with Port Forwarding (Recommended)

```bash
# Stop the current container
docker stop codeface4smell

# Remove the old container
docker rm codeface4smell

# Run with proper port forwarding
docker run -d \
  --name codeface4smell \
  -p 8080:8081 \  # Forward host port 8080 to container port 8081
  -p 8081:8081 \  # Forward host port 8081 to container port 8081
  -p 22:22 \      # Forward SSH if needed
  codeface4smell
```

**Then access your app at:**

- **http://localhost:8080** (recommended)
- **http://localhost:8081** (alternative)

### Option 2: Use Docker Port Command (Temporary)

If you don't want to restart the container:

```bash
# Check what ports are currently forwarded
docker port codeface4smell

# If no ports are forwarded, you'll need to restart with Option 1
```

## Port Configuration in Our Solution

Our nginx + Shiny setup uses:

- **nginx**: Listens on port 8081 (inside container)
- **Shiny app**: Runs on port 8082 (inside container)
- **nginx proxies**: Requests from 8081 → 8082

## Access URLs After Port Forwarding

Once you've set up port forwarding:

- **Main app**: http://localhost:8080 (or 8081)
- **Health check**: http://localhost:8080/health
- **Direct Shiny**: http://localhost:8082 (if you forward that too)

## Testing Port Forwarding

```bash
# Check if ports are accessible from host
curl http://localhost:8080/health
curl http://localhost:8081/health

# Check container logs
docker logs codeface4smell

# Check container status
docker exec -it codeface4smell systemctl status nginx
docker exec -it codeface4smell systemctl status shiny-app.service
```

## Common Issues

### "Connection Refused"

- Port not forwarded: Use `docker run -p` to forward ports
- Service not running: Check `systemctl status` inside container

### "Port Already in Use"

- Another service is using that port on your host
- Choose a different host port: `-p 8082:8081`

### "Permission Denied"

- Container needs to run services as root (already configured)
- Check `docker exec -it codeface4smell systemctl status`

## Quick Commands

```bash
# Deploy the Shiny infrastructure
docker exec -it codeface4smell bash -c "cd /codeface && ./deploy-shiny-nginx.sh"

# Check if everything is working
docker exec -it codeface4smell systemctl status nginx
docker exec -it codeface4smell systemctl status shiny-app.service

# View logs
docker exec -it codeface4smell journalctl -u shiny-app.service -f
```

## Summary

1. **You MUST forward ports** to access Docker containers from host
2. **Use `-p 8080:8081`** when starting the container
3. **Access at http://localhost:8080** after port forwarding
4. **nginx handles the routing** from 8081 → 8082 internally

This gives you a clean, modern Shiny infrastructure that's accessible from your host machine!
