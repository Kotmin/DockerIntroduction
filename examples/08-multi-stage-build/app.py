from fastapi import FastAPI
import os
import sys
from datetime import datetime
import json

app = FastAPI(title="Multi-Stage Build Demo", version="1.0.0")

@app.get("/")
async def root():
    return {
        "message": "Multi-Stage Build Demo",
        "timestamp": datetime.now().isoformat(),
        "environment": os.getenv("ENVIRONMENT", "production"),
        "python_version": sys.version,
        "build_info": {
            "stage": "runtime",
            "optimized": True,
            "size_optimized": True
        }
    }

@app.get("/health")
async def health():
    return {
        "status": "healthy",
        "service": "multi-stage-fastapi",
        "timestamp": datetime.now().isoformat()
    }

@app.get("/build-info")
async def build_info():
    """Get information about the build process"""
    return {
        "build_stage": "runtime",
        "python_version": sys.version,
        "environment": os.getenv("ENVIRONMENT", "production"),
        "optimizations": [
            "Multi-stage build",
            "Minimal runtime image",
            "No build dependencies",
            "Security hardened"
        ],
        "timestamp": datetime.now().isoformat()
    }

@app.get("/dependencies")
async def dependencies():
    """Show runtime dependencies"""
    return {
        "runtime_dependencies": [
            "fastapi",
            "uvicorn",
            "python"
        ],
        "build_dependencies_removed": [
            "build-essential",
            "gcc",
            "g++",
            "make",
            "pkg-config",
            "development packages"
        ],
        "image_size_optimized": True,
        "timestamp": datetime.now().isoformat()
    }
