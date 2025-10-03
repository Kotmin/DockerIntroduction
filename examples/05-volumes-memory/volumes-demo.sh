#!/bin/bash

# Volumes and Memory demonstration script
# This script shows different volume types and memory management

echo "=== Docker Volumes and Memory Examples ==="
echo ""

echo "=== Building the Volumes Image ==="
docker build -t volumes-memory .

echo ""
echo "=== Creating Volume Directories ==="
mkdir -p data logs backups cache temp

echo ""
echo "=== Running Container with Different Volume Types ==="
echo ""

# Stop and remove existing container if it exists
docker stop volumes-app 2>/dev/null || true
docker rm volumes-app 2>/dev/null || true

echo "1. Bind Mounts (Host Directories):"
echo "   - ./data:/app/data"
echo "   - ./logs:/app/logs"
echo "   - ./backups:/app/backups"
echo ""

echo "2. Named Volumes (Docker Managed):"
echo "   - app_cache:/app/cache"
echo "   - app_temp:/app/temp"
echo ""

# Run the container with various volume mounts
docker run -d \
  -p 8000:8000 \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/logs:/app/logs \
  -v $(pwd)/backups:/app/backups \
  -v app_cache:/app/cache \
  -v app_temp:/app/temp \
  -e ENVIRONMENT=production \
  -e MEMORY_LIMIT=512m \
  -e CPU_LIMIT=0.5 \
  --memory=512m \
  --cpus=0.5 \
  --name volumes-app \
  volumes-memory

echo ""
echo "=== Container Status ==="
docker ps --filter name=volumes-app

echo ""
echo "Waiting for container to start..."
sleep 5

echo ""
echo "=== Testing Volume Endpoints ==="
echo "1. Memory information:"
curl -s http://localhost:8000/memory | jq .

echo ""
echo "2. Disk information:"
curl -s http://localhost:8000/disk | jq .

echo ""
echo "3. Volume information:"
curl -s http://localhost:8000/volumes | jq .

echo ""
echo "=== Volume Types Demonstration ==="
echo ""

echo "1. Bind Mounts (Host Directories):"
echo "   - Data persists on host"
echo "   - Direct access from host"
echo "   - Good for development"
echo ""

echo "2. Named Volumes (Docker Managed):"
echo "   - Managed by Docker"
echo "   - Better performance"
echo "   - Good for production"
echo ""

echo "3. Anonymous Volumes:"
echo "   - Temporary storage"
echo "   - Removed with container"
echo "   - Good for temporary data"
echo ""

echo "=== Memory Management ==="
echo ""

echo "1. Container Memory Limits:"
echo "   - --memory=512m (hard limit)"
echo "   - --memory-swap=1g (swap limit)"
echo "   - --oom-kill-disable (disable OOM killer)"
echo ""

echo "2. CPU Limits:"
echo "   - --cpus=0.5 (0.5 CPU cores)"
echo "   - --cpu-shares=512 (relative weight)"
echo "   - --cpuset-cpus=0,1 (specific CPUs)"
echo ""

echo "=== Testing Resource Limits ==="
echo ""

echo "1. Memory allocation test:"
echo "curl -X POST http://localhost:8000/memory/allocate?size_mb=50"
curl -s -X POST http://localhost:8000/memory/allocate?size_mb=50 | jq .

echo ""
echo "2. Disk fill test:"
echo "curl -X POST http://localhost:8000/disk/fill?size_mb=5"
curl -s -X POST http://localhost:8000/disk/fill?size_mb=5 | jq .

echo ""
echo "3. Stress test:"
echo "curl http://localhost:8000/stress"
curl -s http://localhost:8000/stress | jq .

echo ""
echo "=== Volume Management Commands ==="
echo ""

echo "1. List volumes:"
echo "docker volume ls"
docker volume ls

echo ""
echo "2. Inspect volume:"
echo "docker volume inspect app_cache"
docker volume inspect app_cache

echo ""
echo "3. Create volume:"
echo "docker volume create my_volume"
echo ""

echo "4. Remove volume:"
echo "docker volume rm my_volume"
echo ""

echo "=== Docker Compose with Volumes ==="
echo "Using Docker Compose with volume configuration:"
echo "docker-compose -f docker-compose.volumes.yml up -d"
echo ""

echo "=== Volume Best Practices ==="
echo ""

echo "1. Use named volumes for production data"
echo "2. Use bind mounts for development"
echo "3. Set appropriate resource limits"
echo "4. Monitor disk usage"
echo "5. Implement backup strategies"
echo ""

echo "=== Monitoring Commands ==="
echo ""

echo "1. Container stats:"
echo "docker stats volumes-app"
echo ""

echo "2. Volume usage:"
echo "docker system df -v"
echo ""

echo "3. Container resource usage:"
echo "docker exec volumes-app ps aux"
echo ""

echo "=== Cleanup ==="
echo "To stop and remove:"
echo "docker stop volumes-app && docker rm volumes-app"
echo "docker volume rm app_cache app_temp"
echo "docker-compose -f docker-compose.volumes.yml down -v"
