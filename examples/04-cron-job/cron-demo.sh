#!/bin/bash

# Cron job demonstration script
# This script shows different ways to run cron jobs in Docker

echo "=== Docker Cron Job Examples ==="
echo ""

echo "=== Building the Cron Image ==="
docker build -t cron-job .

echo ""
echo "=== Running Cron Container ==="
echo "Starting container with cron jobs..."

# Stop and remove existing container if it exists
docker stop cron-app 2>/dev/null || true
docker rm cron-app 2>/dev/null || true

# Create necessary directories
mkdir -p logs reports backups data temp

# Run the cron container
docker run -d \
  -v $(pwd)/logs:/app/logs \
  -v $(pwd)/reports:/app/reports \
  -v $(pwd)/backups:/app/backups \
  -v $(pwd)/data:/app/data \
  -e ENVIRONMENT=production \
  --name cron-app \
  --privileged \
  cron-job

echo ""
echo "=== Container Status ==="
docker ps --filter name=cron-app

echo ""
echo "Waiting for container to start..."
sleep 5

echo ""
echo "=== Manual Cron Job Execution ==="
echo "You can run cron jobs manually:"
echo ""

echo "1. Health check:"
echo "docker exec cron-app CRON_JOB_TYPE=health_check python3 /app/cron-script.py"
echo ""

echo "2. Cleanup:"
echo "docker exec cron-app CRON_JOB_TYPE=cleanup python3 /app/cron-script.py"
echo ""

echo "3. Generate report:"
echo "docker exec cron-app CRON_JOB_TYPE=report python3 /app/cron-script.py"
echo ""

echo "4. Backup:"
echo "docker exec cron-app CRON_JOB_TYPE=backup python3 /app/cron-script.py"
echo ""

echo "=== Testing Manual Execution ==="
echo "Running manual health check..."
docker exec cron-app CRON_JOB_TYPE=health_check python3 /app/cron-script.py

echo ""
echo "Running manual cleanup..."
docker exec cron-app CRON_JOB_TYPE=cleanup python3 /app/cron-script.py

echo ""
echo "Running manual report generation..."
docker exec cron-app CRON_JOB_TYPE=report python3 /app/cron-script.py

echo ""
echo "=== Monitoring Cron Jobs ==="
echo "1. View cron logs:"
echo "docker logs cron-app"
echo ""

echo "2. View application logs:"
echo "tail -f logs/cron.log"
echo ""

echo "3. Check cron status inside container:"
echo "docker exec cron-app crontab -l"
echo ""

echo "4. View cron daemon logs:"
echo "docker exec cron-app tail -f /var/log/cron.log"
echo ""

echo "=== Cron Job Schedules ==="
echo "The following cron jobs are configured:"
echo ""

echo "1. Health check: Every 5 minutes"
echo "   */5 * * * * /usr/local/bin/python3 /app/cron-script.py"
echo ""

echo "2. Cleanup: Every hour"
echo "   0 * * * * CRON_JOB_TYPE=cleanup /usr/local/bin/python3 /app/cron-script.py"
echo ""

echo "3. Report: Daily at 2 AM"
echo "   0 2 * * * CRON_JOB_TYPE=report /usr/local/bin/python3 /app/cron-script.py"
echo ""

echo "4. Backup: Daily at 3 AM"
echo "   0 3 * * * CRON_JOB_TYPE=backup /usr/local/bin/python3 /app/cron-script.py"
echo ""

echo "5. All tasks: Sunday at 4 AM"
echo "   0 4 * * 0 CRON_JOB_TYPE=all /usr/local/bin/python3 /app/cron-script.py"
echo ""

echo "=== Alternative Cron Approaches ===""
echo ""

echo "1. Using Docker Compose:"
echo "docker-compose -f docker-compose.cron.yml up -d"
echo ""

echo "2. Using external cron (host system):"
echo "# Add to host crontab:"
echo "*/5 * * * * docker exec cron-app python3 /app/cron-script.py"
echo ""

echo "3. Using Kubernetes CronJob:"
echo "# Create Kubernetes CronJob resource"
echo ""

echo "4. Using external scheduler (Celery, RQ):"
echo "# Use task queue with scheduled tasks"
echo ""

echo "=== Best Practices ===""
echo ""

echo "1. Use specific job types for different tasks"
echo "2. Implement proper error handling and logging"
echo "3. Use environment variables for configuration"
echo "4. Implement health checks and monitoring"
echo "5. Use persistent volumes for data"
echo "6. Consider using external schedulers for complex workflows"
echo ""

echo "=== Cleanup ===""
echo "To stop and remove:"
echo "docker stop cron-app && docker rm cron-app"
echo "docker-compose -f docker-compose.cron.yml down"
