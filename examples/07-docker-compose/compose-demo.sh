#!/bin/bash

# Docker Compose demonstration script
# This script shows different Docker Compose versions and features

echo "=== Docker Compose Examples ==="
echo ""

echo "=== Building Images ==="
docker build -t compose-demo .

echo ""
echo "=== Version Comparison ==="
echo ""

echo "1. Modern Docker Compose (v3.8):"
echo "   - Health checks"
echo "   - Service dependencies"
echo "   - Resource limits"
echo "   - Better networking"
echo ""

echo "2. Legacy Docker Compose (v2.4):"
echo "   - Basic service definition"
echo "   - Simple dependencies"
echo "   - Limited health checks"
echo ""

echo "=== Running Modern Compose ==="
echo "Starting services with modern Docker Compose..."

# Stop and remove existing containers
docker-compose -f docker-compose.yml down -v 2>/dev/null || true

# Start services
docker-compose -f docker-compose.yml up -d

echo ""
echo "=== Service Status ==="
docker-compose -f docker-compose.yml ps

echo ""
echo "Waiting for services to start..."
sleep 10

echo ""
echo "=== Testing Services ==="
echo ""

echo "1. FastAPI Health Check:"
curl -s http://localhost:8000/health | jq .

echo ""
echo "2. Database Connection:"
curl -s http://localhost:8000/database | jq .

echo ""
echo "3. Redis Connection:"
curl -s http://localhost:8000/redis | jq .

echo ""
echo "4. Store Data:"
curl -s -X POST http://localhost:8000/data \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello from Docker Compose!", "timestamp": "'$(date -Iseconds)'"}' | jq .

echo ""
echo "5. Retrieve Data:"
curl -s http://localhost:8000/data | jq .

echo ""
echo "6. Services Information:"
curl -s http://localhost:8000/services | jq .

echo ""
echo "=== Nginx Proxy Test ==="
echo "Testing through Nginx proxy..."

echo "1. Health check through proxy:"
curl -s http://localhost/health | jq .

echo ""
echo "2. Services info through proxy:"
curl -s http://localhost/services | jq .

echo ""
echo "=== Docker Compose Features ==="
echo ""

echo "1. Service Dependencies:"
echo "   - FastAPI depends on PostgreSQL and Redis"
echo "   - Nginx depends on FastAPI"
echo "   - Health checks ensure services are ready"
echo ""

echo "2. Volume Management:"
echo "   - PostgreSQL data persistence"
echo "   - Redis data persistence"
echo "   - Named volumes for data"
echo ""

echo "3. Network Isolation:"
echo "   - Services communicate via internal network"
echo "   - External access through exposed ports"
echo "   - Service discovery by name"
echo ""

echo "4. Health Checks:"
echo "   - PostgreSQL: pg_isready"
echo "   - Redis: redis-cli ping"
echo "   - FastAPI: HTTP health endpoint"
echo "   - Nginx: HTTP health check"
echo ""

echo "=== Version Comparison Demo ==="
echo ""

echo "Stopping modern compose..."
docker-compose -f docker-compose.yml down

echo ""
echo "Starting legacy compose..."
docker-compose -f docker-compose.legacy.yml up -d

echo ""
echo "Legacy compose status:"
docker-compose -f docker-compose.legacy.yml ps

echo ""
echo "Testing legacy compose..."
sleep 5
curl -s http://localhost:8000/health | jq .

echo ""
echo "=== Docker Compose Commands ==="
echo ""

echo "1. Start services:"
echo "docker-compose up -d"
echo ""

echo "2. View logs:"
echo "docker-compose logs -f"
echo ""

echo "3. Scale services:"
echo "docker-compose up -d --scale fastapi=3"
echo ""

echo "4. Update services:"
echo "docker-compose up -d --force-recreate"
echo ""

echo "5. Stop services:"
echo "docker-compose down"
echo ""

echo "6. Remove volumes:"
echo "docker-compose down -v"
echo ""

echo "=== Best Practices ===""
echo ""

echo "1. Use modern compose versions (v3.8+)"
echo "2. Implement health checks"
echo "3. Use service dependencies"
echo "4. Configure resource limits"
echo "5. Use named volumes for persistence"
echo "6. Implement proper logging"
echo "7. Use environment variables"
echo "8. Configure networks properly"
echo ""

echo "=== Monitoring ===""
echo ""

echo "1. Service status:"
echo "docker-compose ps"
echo ""

echo "2. Service logs:"
echo "docker-compose logs fastapi"
echo ""

echo "3. Resource usage:"
echo "docker stats"
echo ""

echo "4. Volume usage:"
echo "docker system df -v"
echo ""

echo "=== Cleanup ===""
echo "To stop and remove all services:"
echo "docker-compose -f docker-compose.yml down -v"
echo "docker-compose -f docker-compose.legacy.yml down -v"
