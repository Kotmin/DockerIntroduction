# Volumes and Memory Management

This example demonstrates different types of Docker volumes, memory management, resource limits, and monitoring in containerized applications.

## What This Example Shows

- Different volume types (bind mounts, named volumes, anonymous volumes)
- Memory and CPU resource limits
- Volume persistence and data management
- Resource monitoring and stress testing
- Best practices for production deployments

## Files

- `app.py` - FastAPI application with resource monitoring endpoints
- `requirements.txt` - Dependencies including psutil for system monitoring
- `Dockerfile` - Container with volume mount points
- `docker-compose.volumes.yml` - Compose configuration with volumes and resource limits
- `volumes-demo.sh` - Demonstration script

## How to Run

### Method 1: Direct Docker Run
```bash
# Build the image
docker build -t volumes-memory .

# Create directories
mkdir -p data logs backups

# Run with volume mounts and resource limits
docker run -d \
  -p 8000:8000 \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/logs:/app/logs \
  -v $(pwd)/backups:/app/backups \
  -v app_cache:/app/cache \
  -v app_temp:/app/temp \
  --memory=512m \
  --cpus=0.5 \
  --name volumes-app \
  volumes-memory
```

### Method 2: Docker Compose (Recommended)
```bash
# Using Docker Compose with volume configuration
docker-compose -f docker-compose.volumes.yml up -d
```

### Method 3: Using the Script
```bash
# Run the automated demonstration
./volumes-demo.sh
```

## Volume Types

### 1. Bind Mounts (Host Directories)
```bash
# Mount host directory to container
-v /host/path:/container/path

# Example
-v $(pwd)/data:/app/data
```

**Characteristics:**
- Direct access from host
- Data persists on host filesystem
- Good for development
- Performance depends on host filesystem

### 2. Named Volumes (Docker Managed)
```bash
# Create and use named volume
-v volume_name:/container/path

# Example
-v app_data:/app/data
```

**Characteristics:**
- Managed by Docker
- Better performance than bind mounts
- Good for production
- Can be shared between containers

### 3. Anonymous Volumes
```bash
# Temporary volume (removed with container)
-v /container/path

# Example
-v /app/temp
```

**Characteristics:**
- Temporary storage
- Removed when container is removed
- Good for temporary data
- No persistence

## Resource Limits

### Memory Limits
```bash
# Set memory limit
--memory=512m

# Set memory and swap limit
--memory=512m --memory-swap=1g

# Disable OOM killer
--oom-kill-disable
```

### CPU Limits
```bash
# Set CPU limit (0.5 cores)
--cpus=0.5

# Set CPU shares (relative weight)
--cpu-shares=512

# Set specific CPUs
--cpuset-cpus=0,1
```

## Testing Endpoints

### Memory Information
```bash
curl http://localhost:8000/memory
```
Returns detailed memory usage, limits, and cgroup information.

### Disk Information
```bash
curl http://localhost:8000/disk
```
Returns disk usage for all mounted filesystems.

### Volume Information
```bash
curl http://localhost:8000/volumes
```
Returns information about mounted volumes and environment variables.

### Resource Testing
```bash
# Allocate memory
curl -X POST http://localhost:8000/memory/allocate?size_mb=50

# Fill disk space
curl -X POST http://localhost:8000/disk/fill?size_mb=10

# Run stress test
curl http://localhost:8000/stress

# Clean up
curl -X DELETE http://localhost:8000/disk/cleanup
```

## Volume Management

### List Volumes
```bash
# List all volumes
docker volume ls

# List unused volumes
docker volume ls -f dangling=true
```

### Create and Remove Volumes
```bash
# Create volume
docker volume create my_volume

# Remove volume
docker volume rm my_volume

# Remove all unused volumes
docker volume prune
```

### Inspect Volumes
```bash
# Inspect specific volume
docker volume inspect app_cache

# Get volume usage
docker system df -v
```

## Monitoring Resources

### Container Stats
```bash
# Real-time stats
docker stats volumes-app

# One-time stats
docker stats --no-stream volumes-app
```

### Resource Usage
```bash
# CPU and memory usage
docker exec volumes-app ps aux

# Disk usage
docker exec volumes-app df -h

# Memory details
docker exec volumes-app cat /proc/meminfo
```

## Best Practices

### 1. Volume Selection
- **Development**: Use bind mounts for easy access
- **Production**: Use named volumes for better performance
- **Temporary Data**: Use anonymous volumes
- **Shared Data**: Use named volumes with multiple containers

### 2. Resource Limits
- **Memory**: Set appropriate limits to prevent OOM
- **CPU**: Use fractional CPU limits for better resource sharing
- **Storage**: Monitor disk usage and implement cleanup

### 3. Data Persistence
- **Backup Strategy**: Regular backups of important volumes
- **Data Migration**: Plan for volume migration between hosts
- **Monitoring**: Monitor volume usage and performance

### 4. Security
- **Permissions**: Set appropriate file permissions
- **Access Control**: Limit volume access to necessary containers
- **Encryption**: Consider encrypted volumes for sensitive data

## Production Considerations

### 1. High Availability
- **Volume Replication**: Replicate volumes across hosts
- **Backup Strategy**: Automated backups with retention policies
- **Disaster Recovery**: Volume restoration procedures

### 2. Performance
- **Volume Drivers**: Use appropriate volume drivers for your storage
- **Caching**: Implement caching strategies
- **Monitoring**: Monitor volume performance and usage

### 3. Scaling
- **Volume Sharing**: Share volumes between multiple containers
- **Load Balancing**: Distribute data across multiple volumes
- **Resource Allocation**: Allocate resources based on workload

## Troubleshooting

### Common Issues

1. **Volume Not Mounting**
   ```bash
   # Check if volume exists
   docker volume ls
   
   # Check mount points
   docker inspect volumes-app | grep -A 10 "Mounts"
   ```

2. **Permission Issues**
   ```bash
   # Check file permissions
   ls -la data/
   
   # Fix permissions
   chmod 755 data/
   ```

3. **Resource Limits**
   ```bash
   # Check container limits
   docker inspect volumes-app | grep -A 5 "Memory"
   
   # Check resource usage
   docker stats volumes-app
   ```

## Clean Up

```bash
# Stop and remove container
docker stop volumes-app
docker rm volumes-app

# Remove volumes
docker volume rm app_cache app_temp

# Using Docker Compose
docker-compose -f docker-compose.volumes.yml down -v

# Clean up data (optional)
rm -rf data/ logs/ backups/
```

## Next Steps

- Learn about GUI applications in containers
- Study Docker Compose for multi-service applications
- Understand multi-stage builds for optimization
- Explore container networking

## Further Learning

- [Docker Volumes Documentation](https://docs.docker.com/storage/volumes/)
- [Docker Resource Limits](https://docs.docker.com/config/containers/resource_constraints/)
- [Volume Drivers](https://docs.docker.com/engine/extend/plugins_volume/)
- [Container Monitoring](https://docs.docker.com/config/containers/resource_constraints/)
