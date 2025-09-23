#!/bin/bash

# Logging demonstration script
# This script shows different ways to access and manage container logs

echo "=== Container Logging Examples ==="
echo ""

echo "=== Building the Logging Image ==="
docker build -t logging-fastapi .

echo ""
echo "=== Running Logging Container ==="
echo "Starting container with logging configuration..."

# Stop and remove existing container if it exists
docker stop logging-app 2>/dev/null || true
docker rm logging-app 2>/dev/null || true

# Create logs directory
mkdir -p logs

# Run the logging container
docker run -d \
  -p 8000:8000 \
  -v $(pwd)/logs:/app/logs \
  -e ENVIRONMENT=production \
  --name logging-app \
  logging-fastapi

echo ""
echo "=== Container Status ==="
docker ps --filter name=logging-app

echo ""
echo "Waiting for container to start..."
sleep 5

echo ""
echo "=== Testing Logging Endpoints ==="
echo "1. Basic endpoint (generates info logs):"
curl -s http://localhost:8000/ | jq .

echo ""
echo "2. Logs endpoint (generates all log levels):"
curl -s http://localhost:8000/logs | jq .

echo ""
echo "3. Work simulation (generates progress logs):"
curl -s http://localhost:8000/simulate-work | jq .

echo ""
echo "=== Container Log Access Methods ==="
echo ""
echo "1. View all logs:"
echo "docker logs logging-app"
echo ""

echo "2. Follow logs in real-time:"
echo "docker logs -f logging-app"
echo ""

echo "3. View last 50 lines:"
echo "docker logs --tail 50 logging-app"
echo ""

echo "4. View logs with timestamps:"
echo "docker logs -t logging-app"
echo ""

echo "5. View logs since specific time:"
echo "docker logs --since 5m logging-app"
echo ""

echo "=== File-based Logs ==="
echo "Container also writes to /app/logs/app.log"
echo "Check the logs directory:"
ls -la logs/

echo ""
echo "View file logs:"
if [ -f logs/app.log ]; then
    echo "Last 10 lines of app.log:"
    tail -10 logs/app.log
else
    echo "No app.log file found yet"
fi

echo ""
echo "=== Docker Compose Logging ==="
echo "Using Docker Compose with logging configuration:"
echo "docker-compose -f docker-compose.logging.yml up -d"
echo ""

echo "=== Log Management ==="
echo "1. Log rotation (configured in docker-compose):"
echo "   - max-size: 10m"
echo "   - max-file: 3"
echo ""

echo "2. Centralized logging (production):"
echo "   - Use ELK stack (Elasticsearch, Logstash, Kibana)"
echo "   - Use Fluentd or Fluent Bit"
echo "   - Use cloud logging services"
echo ""

echo "=== Error Testing ==="
echo "Generate an error to see error logging:"
curl -s http://localhost:8000/error || echo "Error endpoint returned error (expected)"

echo ""
echo "=== Cleanup ==="
echo "To stop and remove:"
echo "docker stop logging-app && docker rm logging-app"
echo "docker-compose -f docker-compose.logging.yml down"
