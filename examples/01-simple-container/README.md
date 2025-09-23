# Simple FastAPI Container

This example demonstrates how to create and run a simple FastAPI application in a Docker container.

## What This Example Shows

- Basic Dockerfile structure
- Using Python slim base image
- Non-root user security practice
- Health checks
- Environment variables
- Proper layer caching

## Files

- `app.py` - Simple FastAPI application with health and info endpoints
- `requirements.txt` - Python dependencies
- `Dockerfile` - Container definition
- `.dockerignore` - Files to exclude from build context

## How to Run

### Build the Image
```bash
docker build -t simple-fastapi .
```

### Run the Container
```bash
docker run -d -p 8000:8000 --name simple-app simple-fastapi
```

### Test the Application
```bash
# Check if container is running
docker ps

# Test the endpoints
curl http://localhost:8000/
curl http://localhost:8000/health
curl http://localhost:8000/info

# View logs
docker logs simple-app
```

### Clean Up
```bash
docker stop simple-app
docker rm simple-app
docker rmi simple-fastapi
```

## Key Docker Concepts

### Base Image
- `python:3.12-slim` - Minimal Python image for smaller size
- Avoids `python:3.12` (full image) to reduce attack surface

### Security
- Non-root user (`appuser`) - Never run as root in production
- Minimal dependencies - Only what's needed

### Layer Caching
- Copy `requirements.txt` first, then install dependencies
- Copy application code last
- Changes to app code don't invalidate dependency cache

### Health Checks
- Container health monitoring
- Kubernetes/Docker Swarm integration
- Automatic restart on failure

## Environment Variables

The app uses `ENVIRONMENT` variable (defaults to "development"):
```bash
docker run -e ENVIRONMENT=production -p 8000:8000 simple-fastapi
```

## Best Practices Demonstrated

1. **Small Base Images**: Using `-slim` variant
2. **Non-root User**: Security best practice
3. **Layer Optimization**: Dependencies before code
4. **Health Checks**: Production readiness
5. **Environment Variables**: Configuration flexibility
6. **Proper CMD**: Using uvicorn for production

## Next Steps

- Learn about development containers with volume mounting
- Explore multi-stage builds for optimization
- Understand Docker Compose for multi-service applications

## Further Learning

- [Dockerfile Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Python Docker Images](https://hub.docker.com/_/python)
