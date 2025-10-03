#!/bin/bash

# Development container runner script
# This script demonstrates different ways to run a development container

echo "=== Development Container Examples ==="
echo ""

echo "1. Basic development run with volume mount:"
echo "docker run -d -p 8000:8000 -v \$(pwd)/app.py:/app/app.py:ro --name dev-app dev-fastapi"
echo ""

echo "2. Development run with full directory mount:"
echo "docker run -d -p 8000:8000 -v \$(pwd):/app --name dev-app dev-fastapi"
echo ""

echo "3. Development run with environment variables:"
echo "docker run -d -p 8000:8000 -v \$(pwd)/app.py:/app/app.py:ro -e ENVIRONMENT=development --name dev-app dev-fastapi"
echo ""

echo "4. Using Docker Compose (recommended):"
echo "docker-compose -f docker-compose.dev.yml up -d"
echo ""

echo "=== Building the Development Image ==="
docker build -t dev-fastapi .

echo ""
echo "=== Running Development Container ==="
echo "Starting container with volume mount for hot reload..."

# Stop and remove existing container if it exists
docker stop dev-app 2>/dev/null || true
docker rm dev-app 2>/dev/null || true

# Run the development container
docker run -d \
  -p 8000:8000 \
  -v $(pwd)/app.py:/app/app.py:ro \
  -e ENVIRONMENT=development \
  --name dev-app \
  dev-fastapi

echo ""
echo "=== Container Status ==="
docker ps --filter name=dev-app

echo ""
echo "=== Testing the Application ==="
echo "Waiting for container to start..."
sleep 5

echo "Testing endpoints:"
echo "1. Root endpoint:"
curl -s http://localhost:8000/ | jq .

echo ""
echo "2. Health check:"
curl -s http://localhost:8000/health | jq .

echo ""
echo "3. Debug endpoint:"
curl -s http://localhost:8000/debug | jq .

echo ""
echo "=== Hot Reload Test ==="
echo "Now try editing app.py and see the changes reflected automatically!"
echo "Check logs with: docker logs -f dev-app"
echo ""
echo "=== Cleanup ==="
echo "To stop and remove: docker stop dev-app && docker rm dev-app"
