# Cron Jobs in Docker

This example demonstrates how to run scheduled tasks (cron jobs) inside Docker containers, including different scheduling patterns, monitoring, and best practices.

## What This Example Shows

- Cron daemon setup in Docker containers
- Different types of scheduled tasks
- Manual vs automated execution
- Logging and monitoring
- Volume persistence for cron data
- Alternative scheduling approaches

## Files

- `cron-script.py` - Comprehensive cron job script with multiple task types
- `crontab` - Cron schedule configuration
- `requirements.txt` - Python dependencies
- `Dockerfile` - Container with cron daemon setup
- `docker-compose.cron.yml` - Compose configuration for cron
- `cron-demo.sh` - Demonstration script

## How to Run

### Method 1: Direct Docker Run
```bash
# Build the image
docker build -t cron-job .

# Create necessary directories
mkdir -p logs reports backups data temp

# Run with volume mounts
docker run -d \
  -v $(pwd)/logs:/app/logs \
  -v $(pwd)/reports:/app/reports \
  -v $(pwd)/backups:/app/backups \
  -v $(pwd)/data:/app/data \
  --name cron-app \
  --privileged \
  cron-job
```

### Method 2: Docker Compose (Recommended)
```bash
# Using Docker Compose
docker-compose -f docker-compose.cron.yml up -d
```

### Method 3: Using the Script
```bash
# Run the automated demonstration
./cron-demo.sh
```

## Cron Job Types

### 1. Health Check (Every 5 minutes)
- Monitors external services
- Logs service status
- Sends notifications on failures

### 2. Cleanup (Every hour)
- Removes temporary files
- Cleans old logs
- Maintains disk space

### 3. Report Generation (Daily at 2 AM)
- System resource usage
- Performance metrics
- JSON report files

### 4. Data Backup (Daily at 3 AM)
- Creates compressed backups
- Rotates old backups
- Maintains backup history

### 5. All Tasks (Sunday at 4 AM)
- Runs comprehensive maintenance
- Full system check
- Complete backup cycle

## Manual Execution

You can run cron jobs manually for testing:

```bash
# Health check
docker exec cron-app CRON_JOB_TYPE=health_check python3 /app/cron-script.py

# Cleanup
docker exec cron-app CRON_JOB_TYPE=cleanup python3 /app/cron-script.py

# Generate report
docker exec cron-app CRON_JOB_TYPE=report python3 /app/cron-script.py

# Backup
docker exec cron-app CRON_JOB_TYPE=backup python3 /app/cron-script.py

# All tasks
docker exec cron-app CRON_JOB_TYPE=all python3 /app/cron-script.py
```

## Monitoring Cron Jobs

### 1. Container Logs
```bash
# View all logs
docker logs cron-app

# Follow logs in real-time
docker logs -f cron-app
```

### 2. Application Logs
```bash
# View cron job logs
tail -f logs/cron.log

# View notifications
tail -f logs/notifications.log
```

### 3. Cron Daemon Status
```bash
# Check cron daemon
docker exec cron-app service cron status

# View cron schedule
docker exec cron-app crontab -l

# View cron daemon logs
docker exec cron-app tail -f /var/log/cron.log
```

## Cron Schedule Format

```
# Format: minute hour day month dayofweek command
# Examples:

# Every 5 minutes
*/5 * * * * command

# Every hour at minute 0
0 * * * * command

# Daily at 2 AM
0 2 * * * command

# Weekly on Sunday at 4 AM
0 4 * * 0 command

# Monthly on 1st at midnight
0 0 1 * * command
```

## Alternative Scheduling Approaches

### 1. External Cron (Host System)
```bash
# Add to host crontab
*/5 * * * * docker exec cron-app python3 /app/cron-script.py
```

### 2. Kubernetes CronJob
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: cron-job
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: cron-job
            image: cron-job:latest
```

### 3. Task Queue Systems
- **Celery**: Distributed task queue
- **RQ**: Simple Python task queue
- **Apache Airflow**: Workflow orchestration

### 4. Cloud Schedulers
- **AWS EventBridge**: Serverless scheduling
- **Google Cloud Scheduler**: Managed cron service
- **Azure Logic Apps**: Workflow automation

## Best Practices

### 1. Container Design
- **Single Responsibility**: One container, one purpose
- **Non-root User**: Security best practice
- **Health Checks**: Monitor container health
- **Graceful Shutdown**: Handle SIGTERM signals

### 2. Cron Configuration
- **Environment Variables**: Use for configuration
- **Logging**: Comprehensive logging
- **Error Handling**: Proper exception handling
- **Notifications**: Alert on failures

### 3. Data Persistence
- **Volume Mounts**: Persistent data storage
- **Backup Strategy**: Regular backups
- **Log Rotation**: Manage log file sizes
- **Cleanup**: Remove old data

### 4. Monitoring
- **Log Aggregation**: Centralized logging
- **Metrics Collection**: Performance monitoring
- **Alerting**: Failure notifications
- **Dashboard**: Visual monitoring

## Troubleshooting

### Common Issues

1. **Cron Not Running**
   ```bash
   # Check cron daemon status
   docker exec cron-app service cron status
   
   # Check cron logs
   docker exec cron-app tail -f /var/log/cron.log
   ```

2. **Permission Issues**
   ```bash
   # Check file permissions
   docker exec cron-app ls -la /app/cron-script.py
   
   # Fix permissions
   docker exec cron-app chmod +x /app/cron-script.py
   ```

3. **Volume Mount Issues**
   ```bash
   # Check volume mounts
   docker inspect cron-app | grep -A 10 "Mounts"
   
   # Verify directory permissions
   ls -la logs/ reports/ backups/
   ```

## Production Considerations

### 1. High Availability
- **Multiple Instances**: Avoid single points of failure
- **Load Balancing**: Distribute cron jobs
- **Failover**: Automatic recovery

### 2. Scalability
- **Horizontal Scaling**: Multiple containers
- **Resource Limits**: CPU and memory limits
- **Queue Management**: Task queuing systems

### 3. Security
- **Secrets Management**: Secure configuration
- **Network Security**: Isolated networks
- **Access Control**: Role-based permissions

## Clean Up

```bash
# Stop and remove container
docker stop cron-app
docker rm cron-app

# Remove image
docker rmi cron-job

# Using Docker Compose
docker-compose -f docker-compose.cron.yml down

# Clean up data (optional)
rm -rf logs/ reports/ backups/ data/
```

## Next Steps

- Learn about volume types and persistence
- Explore GUI applications in containers
- Study Docker Compose for multi-service applications
- Understand multi-stage builds for optimization

## Further Learning

- [Cron Documentation](https://man7.org/linux/man-pages/man5/crontab.5.html)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Kubernetes CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)
- [Celery Documentation](https://docs.celeryproject.org/)
