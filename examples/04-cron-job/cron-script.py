#!/usr/bin/env python3
"""
Cron job script for data processing and cleanup tasks.
This script demonstrates various cron job patterns in Docker.
"""

import os
import sys
import time
import logging
from datetime import datetime
import json
import requests

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler('/app/logs/cron.log')
    ]
)

logger = logging.getLogger(__name__)

def health_check():
    """Health check for external services"""
    logger.info("Starting health check...")
    
    services = [
        {"name": "API Service", "url": "http://localhost:8000/health"},
        {"name": "Database", "url": "http://localhost:5432"},
    ]
    
    for service in services:
        try:
            response = requests.get(service["url"], timeout=5)
            if response.status_code == 200:
                logger.info(f"✓ {service['name']} is healthy")
            else:
                logger.warning(f"⚠ {service['name']} returned status {response.status_code}")
        except Exception as e:
            logger.error(f"✗ {service['name']} is down: {e}")

def cleanup_temp_files():
    """Clean up temporary files"""
    logger.info("Starting cleanup of temporary files...")
    
    temp_dirs = ["/tmp", "/app/temp"]
    cleaned_files = 0
    
    for temp_dir in temp_dirs:
        if os.path.exists(temp_dir):
            for root, dirs, files in os.walk(temp_dir):
                for file in files:
                    file_path = os.path.join(root, file)
                    try:
                        # Remove files older than 1 hour
                        if os.path.getmtime(file_path) < time.time() - 3600:
                            os.remove(file_path)
                            cleaned_files += 1
                            logger.info(f"Removed old file: {file_path}")
                    except Exception as e:
                        logger.error(f"Failed to remove {file_path}: {e}")
    
    logger.info(f"Cleanup completed. Removed {cleaned_files} files.")

def generate_report():
    """Generate system report"""
    logger.info("Generating system report...")
    
    report = {
        "timestamp": datetime.now().isoformat(),
        "environment": os.getenv("ENVIRONMENT", "development"),
        "python_version": sys.version,
        "working_directory": os.getcwd(),
        "disk_usage": get_disk_usage(),
        "memory_usage": get_memory_usage(),
    }
    
    # Save report
    report_file = f"/app/reports/report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
    os.makedirs(os.path.dirname(report_file), exist_ok=True)
    
    with open(report_file, 'w') as f:
        json.dump(report, f, indent=2)
    
    logger.info(f"Report saved to: {report_file}")
    return report_file

def get_disk_usage():
    """Get disk usage information"""
    try:
        import shutil
        total, used, free = shutil.disk_usage("/")
        return {
            "total": total,
            "used": used,
            "free": free,
            "percent_used": round((used / total) * 100, 2)
        }
    except Exception as e:
        logger.error(f"Failed to get disk usage: {e}")
        return None

def get_memory_usage():
    """Get memory usage information"""
    try:
        with open('/proc/meminfo', 'r') as f:
            meminfo = {}
            for line in f:
                if ':' in line:
                    key, value = line.split(':', 1)
                    meminfo[key.strip()] = value.strip()
        
        total_mem = int(meminfo['MemTotal'].split()[0])
        available_mem = int(meminfo['MemAvailable'].split()[0])
        used_mem = total_mem - available_mem
        
        return {
            "total": total_mem,
            "used": used_mem,
            "available": available_mem,
            "percent_used": round((used_mem / total_mem) * 100, 2)
        }
    except Exception as e:
        logger.error(f"Failed to get memory usage: {e}")
        return None

def backup_data():
    """Backup important data"""
    logger.info("Starting data backup...")
    
    backup_dir = "/app/backups"
    os.makedirs(backup_dir, exist_ok=True)
    
    # Create backup timestamp
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    backup_file = f"{backup_dir}/backup_{timestamp}.tar.gz"
    
    try:
        import tarfile
        
        # Create tar.gz backup
        with tarfile.open(backup_file, "w:gz") as tar:
            tar.add("/app/data", arcname="data")
            tar.add("/app/logs", arcname="logs")
        
        logger.info(f"Backup created: {backup_file}")
        
        # Clean old backups (keep last 5)
        backup_files = sorted([f for f in os.listdir(backup_dir) if f.startswith("backup_")])
        if len(backup_files) > 5:
            for old_backup in backup_files[:-5]:
                os.remove(os.path.join(backup_dir, old_backup))
                logger.info(f"Removed old backup: {old_backup}")
        
    except Exception as e:
        logger.error(f"Backup failed: {e}")

def send_notification(message):
    """Send notification (simulated)"""
    logger.info(f"Notification: {message}")
    
    # In a real scenario, this would send to:
    # - Email (SMTP)
    # - Slack webhook
    # - Discord webhook
    # - SMS (Twilio)
    # - Push notification service
    
    notification = {
        "timestamp": datetime.now().isoformat(),
        "message": message,
        "status": "sent"
    }
    
    # Save notification log
    notification_file = "/app/logs/notifications.log"
    with open(notification_file, 'a') as f:
        f.write(json.dumps(notification) + '\n')

def main():
    """Main cron job function"""
    logger.info("=== Cron Job Started ===")
    logger.info(f"Job type: {os.getenv('CRON_JOB_TYPE', 'default')}")
    
    job_type = os.getenv('CRON_JOB_TYPE', 'default')
    
    try:
        if job_type == 'health_check':
            health_check()
        elif job_type == 'cleanup':
            cleanup_temp_files()
        elif job_type == 'report':
            generate_report()
        elif job_type == 'backup':
            backup_data()
        elif job_type == 'all':
            # Run all tasks
            health_check()
            cleanup_temp_files()
            generate_report()
            backup_data()
        else:
            # Default: run basic tasks
            logger.info("Running default cron tasks...")
            cleanup_temp_files()
            generate_report()
        
        logger.info("=== Cron Job Completed Successfully ===")
        send_notification(f"Cron job {job_type} completed successfully")
        
    except Exception as e:
        logger.error(f"Cron job failed: {e}")
        send_notification(f"Cron job {job_type} failed: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    main()
