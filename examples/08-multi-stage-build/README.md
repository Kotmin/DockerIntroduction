# Multi-Stage Docker Builds

This example demonstrates the benefits of multi-stage Docker builds, comparing single-stage vs multi-stage approaches with size optimization, security improvements, and BuildKit features.

## What This Example Shows

- Single-stage vs multi-stage build comparison
- Image size optimization techniques
- Security improvements with multi-stage builds
- BuildKit features and advanced caching
- Production-ready build strategies
- Performance and deployment benefits

## Files

- `app.py` - FastAPI application
- `requirements.txt` - Production dependencies
- `requirements-dev.txt` - Development dependencies
- `Dockerfile.single-stage` - Single-stage build (NOT optimized)
- `Dockerfile` - Multi-stage build (OPTIMIZED)
- `Dockerfile.advanced` - Advanced multi-stage with BuildKit
- `docker-compose.multistage.yml` - Compose configuration for comparison
- `multistage-demo.sh` - Demonstration script

## How to Run

### Method 1: Individual Builds
```bash
# Single-stage build
docker build -f Dockerfile.single-stage -t single-stage-demo .

# Multi-stage build
docker build -f Dockerfile -t multi-stage-demo .

# Advanced multi-stage build
DOCKER_BUILDKIT=1 docker build -f Dockerfile.advanced -t advanced-demo .
```

### Method 2: Docker Compose
```bash
# Build and run all versions
docker-compose -f docker-compose.multistage.yml up -d
```

### Method 3: Using the Script
```bash
# Run the automated demonstration
./multistage-demo.sh
```

## Build Comparison

### Single-Stage Build
```dockerfile
FROM python:3.12

# Install ALL dependencies (including dev)
RUN apt-get update && apt-get install -y \
    build-essential gcc g++ make pkg-config

# Install ALL Python packages
RUN pip install -r requirements.txt -r requirements-dev.txt

# Copy and run application
COPY app.py .
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Problems:**
- Includes build tools in runtime
- Larger image size
- Security vulnerabilities
- Slower startup

### Multi-Stage Build
```dockerfile
# Stage 1: Builder
FROM python:3.12 as builder
RUN apt-get update && apt-get install -y build-essential
RUN pip install -r requirements.txt -r requirements-dev.txt

# Stage 2: Runtime
FROM python:3.12-slim as runtime
COPY --from=builder /opt/venv /opt/venv
COPY app.py .
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Benefits:**
- Only runtime dependencies
- Smaller image size
- Better security
- Faster startup

## Image Size Comparison

### Typical Size Differences
- **Single-stage**: ~800MB - 1.2GB
- **Multi-stage**: ~200MB - 400MB
- **Advanced**: ~150MB - 300MB

### Size Reduction Factors
1. **Base Image**: `python:3.12-slim` vs `python:3.12`
2. **Build Tools**: Removed gcc, g++, make, pkg-config
3. **Dev Dependencies**: Removed pytest, black, flake8
4. **Cache Optimization**: BuildKit cache mounts

## Multi-Stage Build Stages

### Stage 1: Builder
```dockerfile
FROM python:3.12 as builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential gcc g++ make pkg-config

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install all dependencies
RUN pip install -r requirements.txt -r requirements-dev.txt
```

### Stage 2: Runtime
```dockerfile
FROM python:3.12-slim as runtime

# Copy virtual environment from builder
COPY --from=builder /opt/venv /opt/venv

# Copy application code
COPY app.py .

# Run application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
```

## BuildKit Features

### Cache Mounts
```dockerfile
# Cache pip packages
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt

# Cache apt packages
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y curl
```

### Parallel Builds
```dockerfile
# Multiple stages can build in parallel
FROM base as builder1
FROM base as builder2
FROM base as builder3
```

### Advanced Caching
```dockerfile
# Use BuildKit syntax
# syntax=docker/dockerfile:1

# Leverage advanced caching
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/var/cache/apt \
    pip install -r requirements.txt
```

## Security Benefits

### Attack Surface Reduction
- **Single-stage**: Build tools + runtime
- **Multi-stage**: Runtime only
- **Advanced**: Minimal runtime

### Security Scanning
```bash
# Scan for vulnerabilities
docker scan single-stage-demo
docker scan multi-stage-demo
docker scan advanced-demo
```

### Best Practices
1. **Non-root User**: Always use non-root users
2. **Minimal Base**: Use minimal base images
3. **No Build Tools**: Remove build tools from runtime
4. **Security Updates**: Keep base images updated

## Performance Benefits

### Startup Time
- **Single-stage**: Slower (larger image)
- **Multi-stage**: Faster (smaller image)
- **Advanced**: Fastest (optimized)

### Memory Usage
- **Single-stage**: Higher memory usage
- **Multi-stage**: Lower memory usage
- **Advanced**: Optimized memory usage

### Network Transfer
- **Single-stage**: Slower deployment
- **Multi-stage**: Faster deployment
- **Advanced**: Fastest deployment

## When to Use Multi-Stage Builds

### 1. Production Applications
- **Web Applications**: FastAPI, Django, Flask
- **APIs**: REST APIs, GraphQL APIs
- **Microservices**: Containerized services

### 2. Compiled Applications
- **Go Applications**: Static binaries
- **Rust Applications**: Compiled binaries
- **C++ Applications**: Compiled executables

### 3. CI/CD Pipelines
- **Build Once**: Build in CI, run anywhere
- **Consistent Environments**: Same environment everywhere
- **Reproducible Builds**: Deterministic builds

## Best Practices

### 1. Stage Organization
```dockerfile
# Logical stage separation
FROM base as dependencies
FROM base as builder
FROM base as tester
FROM base as runtime
```

### 2. Layer Optimization
```dockerfile
# Copy requirements first
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy application code last
COPY app.py .
```

### 3. Cache Optimization
```dockerfile
# Use BuildKit cache mounts
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt
```

### 4. Security Hardening
```dockerfile
# Use non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser
USER appuser

# Use minimal base image
FROM python:3.12-slim as runtime
```

## Monitoring and Debugging

### Build Analysis
```bash
# Analyze image layers
docker history single-stage-demo
docker history multi-stage-demo

# Compare image sizes
docker images | grep -E "(single-stage|multi-stage|advanced)"
```

### Runtime Monitoring
```bash
# Monitor resource usage
docker stats single-stage-app multi-stage-app advanced-app

# Check container health
docker ps --filter name=single-stage-app
```

### Build Optimization
```bash
# Build with BuildKit
DOCKER_BUILDKIT=1 docker build -f Dockerfile.advanced -t advanced-demo .

# Analyze build cache
docker buildx du
```

## Troubleshooting

### Common Issues

1. **Build Failures**
   ```bash
   # Check build logs
   docker build -f Dockerfile.single-stage -t single-stage-demo . 2>&1 | tee build.log
   
   # Debug specific stage
   docker build --target builder -f Dockerfile -t debug-builder .
   ```

2. **Runtime Issues**
   ```bash
   # Check container logs
   docker logs single-stage-app
   
   # Debug container
   docker exec -it single-stage-app bash
   ```

3. **Size Issues**
   ```bash
   # Analyze image layers
   docker history single-stage-demo --no-trunc
   
   # Check for unnecessary files
   docker run --rm single-stage-demo find / -name "*.pyc" -o -name "__pycache__"
   ```

## Clean Up

```bash
# Stop and remove containers
docker stop single-stage-app multi-stage-app advanced-app
docker rm single-stage-app multi-stage-app advanced-app

# Remove images
docker rmi single-stage-demo multi-stage-demo advanced-demo

# Using Docker Compose
docker-compose -f docker-compose.multistage.yml down

# Clean up build cache
docker buildx prune
```

## Next Steps

- Learn about container orchestration
- Study advanced networking configurations
- Understand production deployment strategies
- Explore container security best practices

## Further Learning

- [Docker Multi-Stage Builds](https://docs.docker.com/develop/dev-best-practices/dockerfile_best-practices/#use-multi-stage-builds)
- [BuildKit Documentation](https://docs.docker.com/build/buildkit/)
- [Docker Security](https://docs.docker.com/engine/security/)
- [Container Optimization](https://docs.docker.com/develop/dev-best-practices/)
