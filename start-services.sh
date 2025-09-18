#!/bin/bash
# Load configuration
source deploy.conf

# Start nginx, CodeFace dashboard, details app, and plots app
echo "Starting nginx..."
nginx -g "daemon off;" &
echo $! > /tmp/nginx.pid

echo "Starting CodeFace dashboard..."
cd "/codeface/$DASHBOARD_PATH"
echo "Dashboard path: $(pwd)"
R --slave -e "shiny::runApp(host = '0.0.0.0', port = $SHINY_PORT)" &
echo $! > /tmp/shiny.pid

echo "Starting CodeFace details app..."
cd "/codeface/$DETAILS_PATH"
echo "Details path: $(pwd)"
R --slave -e "shiny::runApp(host = '0.0.0.0', port = $DETAILS_PORT)" &
echo $! > /tmp/details.pid

echo "Starting CodeFace plots app..."
cd "/codeface/$PLOTS_PATH"
echo "Plots path: $(pwd)"
R --slave -e "shiny::runApp(host = '0.0.0.0', port = $PLOTS_PORT)" &
echo $! > /tmp/plots.pid

echo "Starting CodeFace timeseries app..."
cd "/codeface/$TIMESERIES_PATH"
echo "Timeseries path: $(pwd)"
R --slave -e "shiny::runApp(host = '0.0.0.0', port = $TIMESERIES_PORT)" &
echo $! > /tmp/timeseries.pid

echo "Starting CodeFace timezones app..."
cd "/codeface/$TIMEZONES_PATH"
echo "Timezones path: $(pwd)"
R --slave -e "shiny::runApp(host = '0.0.0.0', port = $TIMEZONES_PORT)" &
echo $! > /tmp/timezones.pid

echo "Services started. PIDs saved to /tmp/nginx.pid, /tmp/shiny.pid, /tmp/details.pid, and /tmp/plots.pid"
