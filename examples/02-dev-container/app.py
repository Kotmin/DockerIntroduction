from fastapi import FastAPI
import os
from datetime import datetime
import time

app = FastAPI(title="Development FastAPI Container", version="1.0.0")

@app.get("/")
async def root():
    return {
        "message": "Hello from Development Docker!",
        "timestamp": datetime.now().isoformat(),
        "environment": os.getenv("ENVIRONMENT", "development"),
        "hot_reload": "enabled" if os.getenv("ENVIRONMENT") == "development" else "disabled"
    }

@app.get("/health")
async def health():
    return {"status": "healthy", "service": "dev-fastapi"}

@app.get("/info")
async def info():
    return {
        "app_name": "Development FastAPI Container",
        "version": "1.0.0",
        "python_version": os.sys.version,
        "environment": os.getenv("ENVIRONMENT", "development"),
        "working_directory": os.getcwd()
    }

@app.get("/debug")
async def debug():
    """Debug endpoint to test hot reload"""
    return {
        "message": "This endpoint was modified for hot reload testing",
        "timestamp": datetime.now().isoformat(),
        "process_id": os.getpid()
    }
