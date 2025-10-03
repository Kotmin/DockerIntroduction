from fastapi import FastAPI
import os
import logging
import sys
from datetime import datetime
import time
import random

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler('/app/logs/app.log')
    ]
)

logger = logging.getLogger(__name__)

app = FastAPI(title="Logging FastAPI Container", version="1.0.0")

@app.get("/")
async def root():
    logger.info("Root endpoint accessed")
    return {
        "message": "Hello from Logging Container!",
        "timestamp": datetime.now().isoformat(),
        "environment": os.getenv("ENVIRONMENT", "development")
    }

@app.get("/health")
async def health():
    logger.info("Health check performed")
    return {"status": "healthy", "service": "logging-fastapi"}

@app.get("/info")
async def info():
    logger.info("Info endpoint accessed")
    return {
        "app_name": "Logging FastAPI Container",
        "version": "1.0.0",
        "python_version": os.sys.version,
        "environment": os.getenv("ENVIRONMENT", "development"),
        "log_level": logging.getLogger().level
    }

@app.get("/logs")
async def get_logs():
    """Endpoint to demonstrate different log levels"""
    logger.debug("This is a DEBUG message")
    logger.info("This is an INFO message")
    logger.warning("This is a WARNING message")
    logger.error("This is an ERROR message")
    logger.critical("This is a CRITICAL message")
    
    return {
        "message": "Various log levels have been generated",
        "timestamp": datetime.now().isoformat()
    }

@app.get("/simulate-work")
async def simulate_work():
    """Simulate some work with logging"""
    logger.info("Starting work simulation")
    
    work_duration = random.randint(1, 5)
    logger.info(f"Work will take {work_duration} seconds")
    
    for i in range(work_duration):
        logger.info(f"Working... step {i+1}/{work_duration}")
        time.sleep(1)
    
    logger.info("Work simulation completed")
    return {
        "message": "Work simulation completed",
        "duration": work_duration,
        "timestamp": datetime.now().isoformat()
    }

@app.get("/error")
async def generate_error():
    """Generate an error for logging demonstration"""
    logger.error("Intentional error generated for demonstration")
    try:
        result = 1 / 0
    except ZeroDivisionError as e:
        logger.exception("Division by zero error occurred")
        raise e
