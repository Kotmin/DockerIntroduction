# Development Container with Volume Binding

This example demonstrates how to run a FastAPI application in development mode with volume binding for hot reload functionality.

## What This Example Shows

- Development container with hot reload
- Volume binding for live code changes
- Docker Compose for development
- Environment-specific configuration
- Development vs production differences

## Files

- `app.py` - FastAPI application with debug endpoint
- `requirements.txt` - Dependencies including watchfiles for hot reload
- `Dockerfile` - Development-optimized container
- `docker-compose.dev.yml` - Compose file for development
- `run-dev.sh` - Script demonstrating different run methods

## How to Run

### Method 1: Direct Docker Run (Basic Volume Mount)
```bash
# Build the image
docker build -t dev-fastapi .

# Run with volume mount for hot reload
docker run -d -p 8000:8000 -v $(pwd)/app.py:/app/app.py:ro --name dev-app dev-fastapi
```

### Method 2: Full Directory Mount
```bash
# Run with entire directory mounted
docker run -d -p 8000:8000 -v $(pwd):/app --name dev-app dev-fastapi
```

### Method 3: Docker Compose (Recommended)
```bash
# Using Docker Compose
docker-compose -f docker-compose.dev.yml up -d
```

### Method 4: Using the Script
```bash
# Run the automated script
./run-dev.sh
```

## Testing Hot Reload

1. **Start the container** using any method above
2. **Test the application**:
   ```bash
   curl http://localhost:8000/
   curl http://localhost:8000/debug
   ```
3. **Edit `app.py`** - modify the debug endpoint message
4. **Watch the logs**: `docker logs -f dev-app`
5. **Test again** - changes should be reflected immediately

## Key Development Concepts

### Volume Binding
- `-v $(pwd)/app.py:/app/app.py:ro` - Mounts host file into container
- `:ro` flag makes it read-only in container
- Changes on host are immediately visible in container

### Hot Reload
- `--reload` flag in uvicorn enables hot reload
- `watchfiles` dependency monitors file changes
- No need to rebuild container for code changes

### Development vs Production

| Aspect | Development | Production |
|--------|-------------|------------|
| Base Image | `python:3.12-slim` | `python:3.12-slim` |
| User | Non-root | Non-root |
| Hot Reload | Enabled | Disabled |
| Debug Info | Verbose | Minimal |
| Restart Policy | Manual | Automatic |

## Volume Types Demonstrated

### Bind Mounts
```bash
# Single file mount
-v $(pwd)/app.py:/app/app.py:ro

# Directory mount
-v $(pwd):/app
```

### Named Volumes (in docker-compose.dev.yml)
```yaml
volumes:
  - ./app.py:/app/app.py:ro
```

## Environment Variables

The app uses `ENVIRONMENT` variable:
- `development` - Enables hot reload, debug info
- `production` - Optimized for performance

## Docker Compose Benefits

1. **Service Definition**: Clear service configuration
2. **Volume Management**: Easy volume configuration
3. **Environment Variables**: Centralized configuration
4. **Health Checks**: Built-in health monitoring
5. **Restart Policies**: Automatic container restart

## Development Workflow

1. **Code Changes**: Edit files in your IDE
2. **Automatic Reload**: Container detects changes
3. **Instant Testing**: Changes reflected immediately
4. **Debug Logs**: Monitor with `docker logs -f dev-app`

## Best Practices for Development

1. **Use Volume Mounts**: For live code changes
2. **Enable Hot Reload**: For faster development
3. **Use Docker Compose**: For complex setups
4. **Monitor Logs**: For debugging
5. **Clean Up**: Stop containers when done

## Troubleshooting

### Container Not Starting
```bash
# Check logs
docker logs dev-app

# Check if port is in use
docker ps -a
```

### Hot Reload Not Working
```bash
# Verify volume mount
docker inspect dev-app | grep -A 5 "Mounts"

# Check file permissions
ls -la app.py
```

### Port Conflicts
```bash
# Use different port
docker run -p 8001:8000 ...
```

## Clean Up

```bash
# Stop and remove container
docker stop dev-app
docker rm dev-app

# Remove image
docker rmi dev-fastapi

# Using Docker Compose
docker-compose -f docker-compose.dev.yml down
```

## Next Steps

- Learn about container logging
- Explore cron jobs in containers
- Understand volume types and persistence
- Study GUI applications in containers

## Further Learning

- [Docker Volumes Documentation](https://docs.docker.com/storage/volumes/)
- [Docker Compose for Development](https://docs.docker.com/compose/development/)
- [FastAPI Development](https://fastapi.tiangolo.com/tutorial/development/)
