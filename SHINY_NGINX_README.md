# Modern Shiny Deployment with nginx

## Why This Solution is Better Than shiny-server

The original `shiny-server` package has **fundamental compatibility issues** with modern Node.js versions due to:

1. **V8 API Incompatibility**: The `node-proxy` dependency uses very old V8 C++ APIs that don't exist in modern Node.js
2. **Architecture Issues**: Written for Node.js v0.x, which is completely incompatible with v8+ and v10+
3. **Maintenance Problems**: The package hasn't been updated to support modern systems
4. **Compilation Failures**: Cannot compile native addons against modern V8 headers

## Our Solution: nginx + R Direct

Instead of the problematic `shiny-server`, we use:

- **nginx**: High-performance web server (no Node.js dependencies)
- **R directly**: Run Shiny apps with `shiny::runApp()`
- **systemd**: Proper service management
- **Reverse proxy**: nginx forwards requests to R processes

## Benefits

✅ **Modern & Maintained**: nginx is actively developed and production-ready  
✅ **No Dependencies**: No Node.js version compatibility issues  
✅ **Better Performance**: nginx is faster than Node.js-based solutions  
✅ **Architecture Agnostic**: Works on x86_64, ARM64, and all modern systems  
✅ **Easy Scaling**: Add more Shiny apps by creating new services  
✅ **Production Ready**: Used by major companies worldwide

## Architecture

```
Internet → nginx (port 8081) → Shiny App (port 8082)
                ↓
        Static files, caching, SSL
```

## Quick Start

1. **Deploy the infrastructure**:

   ```bash
   ./deploy-shiny-nginx.sh
   ```

2. **Access your app**: Since this runs in Docker, you have two options:

   **Option A: Use existing port 8081** (if already forwarded)
   - Access at: http://localhost:8081

   **Option B: Restart Docker with proper port forwarding**
   ```bash
   # Stop current container
   docker stop codeface4smell
   
   # Run with port forwarding
   docker run -d \
     --name codeface4smell \
     -p 8080:8081 \  # Forward host port 8080 to container port 8081
     -p 8081:8081 \  # Forward host port 8081 to container port 8081
     -p 22:22 \      # Forward SSH if needed
     codeface4smell
   
   # Then access at: http://localhost:8080 or http://localhost:8081
   ```

3. **Check health**: http://localhost:8081/health (or your forwarded port)

## What Gets Created

- `/codeface/shiny-apps/` - Directory for Shiny applications
- `/codeface/shiny-apps/sample-app/` - Sample dashboard app
- `/etc/nginx/sites-available/shiny` - nginx configuration
- `/etc/systemd/system/shiny-app.service` - Service management
- Sample Shiny app with CodeFace analysis dashboard

## Managing Your Shiny Apps

### Start/Stop the Service

```bash
systemctl start shiny-app.service    # Start
systemctl stop shiny-app.service     # Stop
systemctl restart shiny-app.service  # Restart
systemctl status shiny-app.service   # Check status
```

### View Logs

```bash
journalctl -u shiny-app.service -f  # Follow logs
journalctl -u shiny-app.service     # View all logs
```

### Reload nginx

```bash
systemctl reload nginx               # Reload configuration
nginx -t                            # Test configuration
```

## Adding More Shiny Apps

1. **Create new app directory**:

   ```bash
   mkdir -p /codeface/shiny-apps/my-new-app
   # Add your app.R file here
   ```

2. **Create new service** (e.g., `my-new-app.service`):

   ```ini
   [Unit]
   Description=My New Shiny App
   After=network.target

   [Service]
   Type=simple
   User=root
   WorkingDirectory=/codeface/shiny-apps/my-new-app
   ExecStart=/usr/bin/R --slave -e "shiny::runApp(host = '0.0.0.0', port = 8083)"
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```

3. **Update nginx configuration** to route to different ports

## Troubleshooting

### App Not Loading

1. Check if the service is running: `systemctl status shiny-app.service`
2. Check logs: `journalctl -u shiny-app.service -f`
3. Verify port is open: `netstat -tlnp | grep 8082`

### nginx Issues

1. Test configuration: `nginx -t`
2. Check nginx status: `systemctl status nginx`
3. View nginx logs: `tail -f /var/log/nginx/error.log`

### R Package Issues

1. Install missing packages manually:
   ```r
   install.packages(c("shiny", "rmarkdown", "DT", "plotly"),
                    repos="https://cran.rstudio.com/")
   ```

## Performance Tuning

### nginx Optimization

The configuration includes:

- Static file caching
- Proxy buffering
- WebSocket support
- Optimized timeouts

### R Optimization

- Consider using `shiny::runApp(launch.browser = FALSE)` for production
- Use `options(shiny.host = "0.0.0.0")` for external access
- Monitor memory usage with large datasets

## Security Considerations

- The sample app runs as root (for development)
- For production, consider:
  - Running as dedicated user
  - Adding authentication
  - Implementing rate limiting
  - Using HTTPS with SSL certificates

## Comparison with shiny-server

| Feature                   | shiny-server   | nginx + R        |
| ------------------------- | -------------- | ---------------- |
| **Node.js Compatibility** | ❌ Broken      | ✅ None needed   |
| **Architecture Support**  | ❌ x86_64 only | ✅ All platforms |
| **Performance**           | ⚠️ Good        | ✅ Excellent     |
| **Maintenance**           | ❌ Abandoned   | ✅ Active        |
| **Scaling**               | ⚠️ Limited     | ✅ Easy          |
| **Dependencies**          | ❌ Many broken | ✅ Minimal       |

## Conclusion

This nginx-based solution eliminates all the compatibility issues you were experiencing with `shiny-server`. It's:

- **Reliable**: No compilation failures or V8 API issues
- **Modern**: Uses current, maintained software
- **Scalable**: Easy to add more apps and services
- **Production-ready**: Suitable for real-world deployment

You can now focus on building your CodeFace analysis dashboards instead of fighting with outdated Node.js dependencies!
