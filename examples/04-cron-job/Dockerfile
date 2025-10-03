# Cron job Dockerfile
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    ENVIRONMENT=production

# Install system dependencies
RUN apt-get update && apt-get install -y \
    cron \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r cronuser && useradd -r -g cronuser cronuser

# Set working directory
WORKDIR /app

# Create necessary directories
RUN mkdir -p /app/logs /app/reports /app/backups /app/data /app/temp \
    && chown -R cronuser:cronuser /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy cron script
COPY cron-script.py .

# Copy crontab file
COPY crontab /etc/cron.d/cron-jobs

# Set proper permissions for cron
RUN chmod 0644 /etc/cron.d/cron-jobs \
    && chmod +x /app/cron-script.py \
    && crontab /etc/cron.d/cron-jobs

# Create cron log file
RUN touch /var/log/cron.log

# Change ownership to non-root user
RUN chown -R cronuser:cronuser /app

# Switch to non-root user
USER cronuser

# Expose port (optional, for health checks)
EXPOSE 8000

# Create startup script
RUN echo '#!/bin/bash\n\
# Start cron daemon\n\
service cron start\n\
\n\
# Keep container running\n\
tail -f /var/log/cron.log' > /app/start-cron.sh \
    && chmod +x /app/start-cron.sh

# Run the cron daemon
CMD ["/app/start-cron.sh"]
