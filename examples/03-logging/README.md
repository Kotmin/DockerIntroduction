# Container Logging

This example demonstrates comprehensive logging in Docker containers, including different log levels, log management, and various ways to access container logs.

## What This Example Shows

- Application logging with different levels
- File-based and stdout logging
- Docker log drivers and configuration
- Log rotation and management
- Real-time log monitoring
- Error logging and debugging

## Files

- `app.py` - FastAPI application with comprehensive logging
- `requirements.txt` - Dependencies
- `Dockerfile` - Container with logging configuration
- `docker-compose.logging.yml` - Compose with log driver configuration
- `logging-demo.sh` - Script demonstrating log access methods

## How to Run

### Method 1: Direct Docker Run
```bash
# Build the image
docker build -t logging-fastapi .

# Create logs directory
mkdir -p logs

# Run with volume mount for persistent logs
docker run -d -p 8000:8000 -v $(pwd)/logs:/app/logs --name logging-app logging-fastapi
```

### Method 2: Docker Compose (Recommended)
```bash
# Using Docker Compose with logging configuration
docker-compose -f docker-compose.logging.yml up -d
```

### Method 3: Using the Script
```bash
# Run the automated logging demonstration
./logging-demo.sh
```

## Testing Logging

### Generate Different Log Levels
```bash
# Basic endpoint (info logs)
curl http://localhost:8000/

# Logs endpoint (all levels)
curl http://localhost:8000/logs

# Work simulation (progress logs)
curl http://localhost:8000/simulate-work

# Error endpoint (error logs)
curl http://localhost:8000/error
```

## Log Access Methods

### 1. Docker Logs Command
```bash
# View all logs
docker logs logging-app

# Follow logs in real-time
docker logs -f logging-app

# View last 50 lines
docker logs --tail 50 logging-app

# View logs with timestamps
docker logs -t logging-app

# View logs since specific time
docker logs --since 5m logging-app
```

### 2. File-based Logs
```bash
# View application logs
cat logs/app.log

# Follow file logs
tail -f logs/app.log

# Search logs
grep "ERROR" logs/app.log
```

### 3. Docker Compose Logs
```bash
# View all service logs
docker-compose -f docker-compose.logging.yml logs

# Follow logs
docker-compose -f docker-compose.logging.yml logs -f

# View specific service logs
docker-compose -f docker-compose.logging.yml logs logging-fastapi
```

## Log Levels Demonstrated

| Level | Description | Usage |
|-------|-------------|-------|
| DEBUG | Detailed information | Development debugging |
| INFO | General information | Normal operations |
| WARNING | Warning messages | Potential issues |
| ERROR | Error messages | Error conditions |
| CRITICAL | Critical errors | System failures |

## Log Configuration

### Application Logging
```python
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),  # stdout
        logging.FileHandler('/app/logs/app.log')  # file
    ]
)
```

### Docker Log Driver
```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"    # Rotate when 10MB
    max-file: "3"      # Keep 3 files
```

## Log Management Strategies

### 1. Log Rotation
- **Docker**: Built-in rotation with `json-file` driver
- **Application**: Use `RotatingFileHandler`
- **System**: Use `logrotate` for system logs

### 2. Log Aggregation
- **ELK Stack**: Elasticsearch, Logstash, Kibana
- **Fluentd**: Lightweight log collector
- **Cloud Services**: AWS CloudWatch, Google Cloud Logging

### 3. Log Analysis
- **Grep**: Basic text search
- **jq**: JSON log parsing
- **ELK**: Advanced search and visualization

## Production Logging Best Practices

### 1. Structured Logging
```python
import json
import logging

# Structured log entry
log_entry = {
    "timestamp": datetime.now().isoformat(),
    "level": "INFO",
    "service": "fastapi",
    "message": "User login",
    "user_id": "12345"
}
logger.info(json.dumps(log_entry))
```

### 2. Log Levels in Production
- **DEBUG**: Disabled in production
- **INFO**: Normal operations
- **WARNING**: Monitor closely
- **ERROR**: Alert immediately
- **CRITICAL**: Page on-call

### 3. Log Security
- **Sanitize**: Remove sensitive data
- **Encrypt**: Secure log transmission
- **Retention**: Set appropriate retention policies

## Monitoring and Alerting

### 1. Log Monitoring
```bash
# Monitor error logs
docker logs -f logging-app | grep ERROR

# Monitor specific patterns
docker logs -f logging-app | grep "CRITICAL\|ERROR"
```

### 2. Log Analysis
```bash
# Count error occurrences
docker logs logging-app | grep -c ERROR

# Extract specific information
docker logs logging-app | jq '.message'
```

### 3. Alerting Setup
- **Prometheus**: Metrics collection
- **Grafana**: Visualization and alerting
- **PagerDuty**: Incident management

## Troubleshooting

### Common Issues

1. **Logs Not Appearing**
   ```bash
   # Check if container is running
   docker ps
   
   # Check container logs
   docker logs logging-app
   ```

2. **Log File Permissions**
   ```bash
   # Check file permissions
   ls -la logs/
   
   # Fix permissions
   chmod 755 logs/
   ```

3. **Log Rotation Issues**
   ```bash
   # Check log file sizes
   du -h logs/*
   
   # Manual log rotation
   docker restart logging-app
   ```

## Clean Up

```bash
# Stop and remove container
docker stop logging-app
docker rm logging-app

# Remove image
docker rmi logging-fastapi

# Using Docker Compose
docker-compose -f docker-compose.logging.yml down

# Clean up logs
rm -rf logs/
```

## Next Steps

- Learn about cron jobs in containers
- Explore volume types and persistence
- Study GUI applications in containers
- Understand Docker Compose for multi-service applications

## Further Learning

- [Docker Logging Drivers](https://docs.docker.com/config/containers/logging/)
- [Python Logging Best Practices](https://docs.python.org/3/howto/logging.html)
- [ELK Stack Tutorial](https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started.html)
- [Fluentd Documentation](https://docs.fluentd.org/)
