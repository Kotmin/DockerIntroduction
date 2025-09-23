#!/bin/bash

# Multi-stage build demonstration script
# This script shows the benefits of multi-stage builds

echo "=== Docker Multi-Stage Build Examples ==="
echo ""

echo "=== Building Different Versions ==="
echo ""

echo "1. Single-stage build (NOT optimized):"
echo "Building single-stage image..."
docker build -f Dockerfile.single-stage -t single-stage-demo .

echo ""
echo "2. Multi-stage build (OPTIMIZED):"
echo "Building multi-stage image..."
docker build -f Dockerfile -t multi-stage-demo .

echo ""
echo "3. Advanced multi-stage build (BUILDKIT):"
echo "Building advanced multi-stage image..."
DOCKER_BUILDKIT=1 docker build -f Dockerfile.advanced -t advanced-demo .

echo ""
echo "=== Image Size Comparison ==="
echo ""

echo "Image sizes:"
docker images | grep -E "(single-stage|multi-stage|advanced)" | awk '{print $1, $7}'

echo ""
echo "Detailed size comparison:"
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep -E "(single-stage|multi-stage|advanced)"

echo ""
echo "=== Running Containers ==="
echo ""

# Stop and remove existing containers
docker stop single-stage-app multi-stage-app advanced-app 2>/dev/null || true
docker rm single-stage-app multi-stage-app advanced-app 2>/dev/null || true

echo "Starting single-stage container..."
docker run -d -p 8000:8000 --name single-stage-app single-stage-demo

echo "Starting multi-stage container..."
docker run -d -p 8001:8000 --name multi-stage-app multi-stage-demo

echo "Starting advanced container..."
docker run -d -p 8002:8000 --name advanced-app advanced-demo

echo ""
echo "=== Container Status ==="
docker ps --filter name=single-stage-app
docker ps --filter name=multi-stage-app
docker ps --filter name=advanced-app

echo ""
echo "Waiting for containers to start..."
sleep 5

echo ""
echo "=== Testing Applications ==="
echo ""

echo "1. Single-stage build (port 8000):"
curl -s http://localhost:8000/ | jq .

echo ""
echo "2. Multi-stage build (port 8001):"
curl -s http://localhost:8001/ | jq .

echo ""
echo "3. Advanced build (port 8002):"
curl -s http://localhost:8002/ | jq .

echo ""
echo "=== Build Information ==="
echo ""

echo "1. Single-stage build info:"
curl -s http://localhost:8000/build-info | jq .

echo ""
echo "2. Multi-stage build info:"
curl -s http://localhost:8001/build-info | jq .

echo ""
echo "3. Advanced build info:"
curl -s http://localhost:8002/build-info | jq .

echo ""
echo "=== Multi-Stage Build Benefits ==="
echo ""

echo "1. Size Optimization:"
echo "   - Single-stage: Includes build dependencies"
echo "   - Multi-stage: Only runtime dependencies"
echo "   - Advanced: Optimized with BuildKit"
echo ""

echo "2. Security:"
echo "   - Single-stage: Build tools in runtime"
echo "   - Multi-stage: No build tools in runtime"
echo "   - Advanced: Minimal attack surface"
echo ""

echo "3. Performance:"
echo "   - Single-stage: Larger image, slower startup"
echo "   - Multi-stage: Smaller image, faster startup"
echo "   - Advanced: Optimized with caching"
echo ""

echo "=== BuildKit Features ==="
echo ""

echo "1. Cache Mounts:"
echo "   - pip cache: /root/.cache/pip"
echo "   - apt cache: /var/cache/apt"
echo "   - npm cache: /root/.npm"
echo ""

echo "2. Parallel Builds:"
echo "   - Multiple stages can build in parallel"
echo "   - Better resource utilization"
echo "   - Faster overall build time"
echo ""

echo "3. Advanced Caching:"
echo "   - Layer caching optimization"
echo "   - Build context optimization"
echo "   - Multi-platform builds"
echo ""

echo "=== Docker Compose Multi-Stage ==="
echo "Using Docker Compose for multi-stage builds:"
echo "docker-compose -f docker-compose.multistage.yml up -d"
echo ""

echo "=== Best Practices ==="
echo ""

echo "1. Use multi-stage builds for production"
echo "2. Separate build and runtime stages"
echo "3. Use minimal base images for runtime"
echo "4. Leverage BuildKit features"
echo "5. Implement proper caching"
echo "6. Use .dockerignore for build context"
echo "7. Optimize layer ordering"
echo ""

echo "=== When to Use Multi-Stage Builds ===""
echo ""

echo "1. Production Applications:"
echo "   - Smaller images"
echo "   - Better security"
echo "   - Faster deployments"
echo ""

echo "2. Compiled Applications:"
echo "   - Go, Rust, C++ applications"
echo "   - Node.js with native modules"
echo "   - Python with C extensions"
echo ""

echo "3. CI/CD Pipelines:"
echo "   - Build once, run anywhere"
echo "   - Consistent environments"
echo "   - Reproducible builds"
echo ""

echo "=== Monitoring ==="
echo ""

echo "1. Container resource usage:"
echo "docker stats single-stage-app multi-stage-app advanced-app"
echo ""

echo "2. Image layers:"
echo "docker history single-stage-demo"
echo "docker history multi-stage-demo"
echo ""

echo "3. Build time comparison:"
echo "time docker build -f Dockerfile.single-stage -t single-stage-demo ."
echo "time docker build -f Dockerfile -t multi-stage-demo ."
echo ""

echo "=== Cleanup ==="
echo "To stop and remove:"
echo "docker stop single-stage-app multi-stage-app advanced-app"
echo "docker rm single-stage-app multi-stage-app advanced-app"
echo "docker rmi single-stage-demo multi-stage-demo advanced-demo"
echo "docker-compose -f docker-compose.multistage.yml down"
