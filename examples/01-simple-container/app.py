from fastapi import FastAPI
import os
from datetime import datetime

app = FastAPI(title="Simple FastAPI Container", version="1.0.0")

@app.get("/")
async def root():
    return {
        "message": "Hello from Docker!",
        "timestamp": datetime.now().isoformat(),
        "environment": os.getenv("ENVIRONMENT", "development")
    }

@app.get("/health")
async def health():
    return {"status": "healthy", "service": "simple-fastapi"}

@app.get("/info")
async def info():
    return {
        "app_name": "Simple FastAPI Container",
        "version": "1.0.0",
        "python_version": os.sys.version,
        "environment": os.getenv("ENVIRONMENT", "development")
    }
