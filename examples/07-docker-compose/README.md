# Docker Compose Multi-Service Application

This example demonstrates a complete multi-service application using Docker Compose, including FastAPI, PostgreSQL, Redis, and Nginx, with version comparison and best practices.

## What This Example Shows

- Multi-service Docker Compose application
- Service dependencies and health checks
- Database and cache integration
- Reverse proxy configuration
- Version comparison (v3.8 vs v2.4)
- Production-ready setup

## Files

- `app.py` - FastAPI application with database and Redis integration
- `requirements.txt` - Python dependencies
- `Dockerfile` - FastAPI container definition
- `docker-compose.yml` - Modern Compose configuration (v3.8)
- `docker-compose.legacy.yml` - Legacy Compose configuration (v2.4)
- `nginx.conf` - Nginx reverse proxy configuration
- `compose-demo.sh` - Demonstration script

## How to Run

### Method 1: Modern Docker Compose (Recommended)
```bash
# Start all services
docker-compose up -d

# View service status
docker-compose ps

# View logs
docker-compose logs -f
```

### Method 2: Legacy Docker Compose
```bash
# Start with legacy configuration
docker-compose -f docker-compose.legacy.yml up -d
```

### Method 3: Using the Script
```bash
# Run the automated demonstration
./compose-demo.sh
```

## Services Architecture

### 1. FastAPI Application
- **Port**: 8000
- **Purpose**: Main application API
- **Dependencies**: PostgreSQL, Redis
- **Health Check**: HTTP endpoint

### 2. PostgreSQL Database
- **Port**: 5432 (internal)
- **Purpose**: Primary data storage
- **Volume**: `postgres_data`
- **Health Check**: `pg_isready`

### 3. Redis Cache
- **Port**: 6379 (internal)
- **Purpose**: Caching and session storage
- **Volume**: `redis_data`
- **Health Check**: `redis-cli ping`

### 4. Nginx Reverse Proxy
- **Port**: 80
- **Purpose**: Load balancing and SSL termination
- **Dependencies**: FastAPI
- **Health Check**: HTTP endpoint

## Testing the Application

### Health Checks
```bash
# FastAPI health
curl http://localhost:8000/health

# Through Nginx proxy
curl http://localhost/health
```

### Database Operations
```bash
# Database info
curl http://localhost:8000/database

# Store data
curl -X POST http://localhost:8000/data \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello Docker Compose!"}'

# Retrieve data
curl http://localhost:8000/data
```

### Redis Operations
```bash
# Redis info
curl http://localhost:8000/redis
```

## Docker Compose Versions

### Modern Version (v3.8)
```yaml
version: '3.8'

services:
  fastapi:
    build: .
    ports:
      - "8000:8000"
    depends_on:
      postgres:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

**Features:**
- Health check conditions
- Service dependencies
- Resource limits
- Better networking
- Swarm mode support

### Legacy Version (v2.4)
```yaml
version: '2.4'

services:
  fastapi:
    build: .
    ports:
      - "8000:8000"
    depends_on:
      - postgres
```

**Features:**
- Basic service definition
- Simple dependencies
- Limited health checks
- No resource limits

## Service Dependencies

### Dependency Chain
```
nginx → fastapi → postgres
                → redis
```

### Health Check Flow
1. **PostgreSQL**: `pg_isready` ensures database is ready
2. **Redis**: `redis-cli ping` ensures cache is ready
3. **FastAPI**: HTTP health endpoint ensures API is ready
4. **Nginx**: HTTP health check ensures proxy is ready

## Volume Management

### Named Volumes
```yaml
volumes:
  postgres_data:
    driver: local
  redis_data:
    driver: local
```

### Volume Usage
- **PostgreSQL**: Persistent database storage
- **Redis**: Persistent cache storage
- **FastAPI**: Stateless application

## Network Configuration

### Internal Network
- Services communicate via service names
- No external access to internal services
- Automatic DNS resolution

### External Access
- **FastAPI**: `localhost:8000`
- **Nginx**: `localhost:80`
- **Database**: Internal only
- **Redis**: Internal only

## Environment Variables

### Application Configuration
```yaml
environment:
  - ENVIRONMENT=production
  - DB_HOST=postgres
  - DB_NAME=demo
  - DB_USER=demo
  - DB_PASSWORD=demo
  - REDIS_HOST=redis
  - REDIS_PORT=6379
```

### Database Configuration
```yaml
environment:
  - POSTGRES_DB=demo
  - POSTGRES_USER=demo
  - POSTGRES_PASSWORD=demo
```

## Production Considerations

### 1. Security
- **Secrets Management**: Use Docker secrets or external secret management
- **Network Security**: Implement proper firewall rules
- **SSL/TLS**: Configure HTTPS termination
- **Authentication**: Implement proper authentication

### 2. Performance
- **Resource Limits**: Set CPU and memory limits
- **Load Balancing**: Configure multiple FastAPI instances
- **Caching**: Implement proper caching strategies
- **Database Optimization**: Configure PostgreSQL for production

### 3. Monitoring
- **Health Checks**: Comprehensive health monitoring
- **Logging**: Centralized logging with ELK stack
- **Metrics**: Prometheus and Grafana integration
- **Alerting**: Set up alerting for failures

### 4. Backup
- **Database Backup**: Regular PostgreSQL backups
- **Volume Backup**: Backup named volumes
- **Configuration Backup**: Version control for configurations

## Scaling Services

### Horizontal Scaling
```bash
# Scale FastAPI to 3 instances
docker-compose up -d --scale fastapi=3

# Scale with load balancer
docker-compose up -d --scale fastapi=3 --scale nginx=2
```

### Vertical Scaling
```yaml
services:
  fastapi:
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '1.0'
        reservations:
          memory: 512M
          cpus: '0.5'
```

## Troubleshooting

### Common Issues

1. **Service Not Starting**
   ```bash
   # Check service logs
   docker-compose logs fastapi
   
   # Check service status
   docker-compose ps
   ```

2. **Database Connection Issues**
   ```bash
   # Check database logs
   docker-compose logs postgres
   
   # Test database connection
   docker-compose exec postgres psql -U demo -d demo
   ```

3. **Redis Connection Issues**
   ```bash
   # Check Redis logs
   docker-compose logs redis
   
   # Test Redis connection
   docker-compose exec redis redis-cli ping
   ```

### Debugging Commands
```bash
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs fastapi

# Execute commands in container
docker-compose exec fastapi bash

# Check service health
docker-compose ps

# View network configuration
docker network ls
docker network inspect compose_default
```

## Clean Up

```bash
# Stop and remove services
docker-compose down

# Remove volumes
docker-compose down -v

# Remove images
docker-compose down --rmi all

# Remove everything
docker-compose down -v --rmi all --remove-orphans
```

## Next Steps

- Learn about multi-stage builds for optimization
- Explore container orchestration with Kubernetes
- Study advanced networking configurations
- Understand production deployment strategies

## Further Learning

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Compose Best Practices](https://docs.docker.com/compose/production/)
- [Multi-Container Applications](https://docs.docker.com/get-started/07_multi_container/)
- [Docker Swarm](https://docs.docker.com/engine/swarm/)
