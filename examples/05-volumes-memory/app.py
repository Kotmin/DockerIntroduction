from fastapi import FastAPI, HTTPException
import os
import psutil
import json
import time
from datetime import datetime
from pathlib import Path
import shutil

app = FastAPI(title="Volumes and Memory Demo", version="1.0.0")

@app.get("/")
async def root():
    return {
        "message": "Volumes and Memory Demo",
        "timestamp": datetime.now().isoformat(),
        "environment": os.getenv("ENVIRONMENT", "development")
    }

@app.get("/memory")
async def get_memory_info():
    """Get detailed memory information"""
    memory = psutil.virtual_memory()
    swap = psutil.swap_memory()
    
    return {
        "virtual_memory": {
            "total": memory.total,
            "available": memory.available,
            "used": memory.used,
            "free": memory.free,
            "percent": memory.percent,
            "cached": getattr(memory, 'cached', 0),
            "buffers": getattr(memory, 'buffers', 0)
        },
        "swap_memory": {
            "total": swap.total,
            "used": swap.used,
            "free": swap.free,
            "percent": swap.percent
        },
        "container_info": {
            "memory_limit": get_memory_limit(),
            "cgroup_memory": get_cgroup_memory()
        }
    }

@app.get("/disk")
async def get_disk_info():
    """Get disk usage information"""
    disk_usage = shutil.disk_usage('/')
    
    # Get detailed disk info for all mounted filesystems
    partitions = []
    for partition in psutil.disk_partitions():
        try:
            partition_usage = psutil.disk_usage(partition.mountpoint)
            partitions.append({
                "device": partition.device,
                "mountpoint": partition.mountpoint,
                "fstype": partition.fstype,
                "total": partition_usage.total,
                "used": partition_usage.used,
                "free": partition_usage.free,
                "percent": (partition_usage.used / partition_usage.total) * 100
            })
        except PermissionError:
            continue
    
    return {
        "root_disk": {
            "total": disk_usage.total,
            "used": disk_usage.used,
            "free": disk_usage.free,
            "percent": (disk_usage.used / disk_usage.total) * 100
        },
        "partitions": partitions
    }

@app.get("/volumes")
async def get_volume_info():
    """Get information about mounted volumes"""
    volumes = []
    
    # Check common volume mount points
    volume_paths = [
        "/app/data",
        "/app/logs", 
        "/app/backups",
        "/tmp",
        "/var/log"
    ]
    
    for path in volume_paths:
        if os.path.exists(path):
            try:
                stat = os.stat(path)
                volumes.append({
                    "path": path,
                    "exists": True,
                    "is_mount": os.path.ismount(path),
                    "size": get_directory_size(path),
                    "files": count_files(path)
                })
            except Exception as e:
                volumes.append({
                    "path": path,
                    "exists": True,
                    "error": str(e)
                })
        else:
            volumes.append({
                "path": path,
                "exists": False
            })
    
    return {
        "volumes": volumes,
        "environment_variables": {
            "ENVIRONMENT": os.getenv("ENVIRONMENT"),
            "MEMORY_LIMIT": os.getenv("MEMORY_LIMIT"),
            "CPU_LIMIT": os.getenv("CPU_LIMIT")
        }
    }

@app.post("/memory/allocate")
async def allocate_memory(size_mb: int = 100):
    """Allocate memory to test memory limits"""
    if size_mb > 1000:  # Safety limit
        raise HTTPException(status_code=400, detail="Size too large (max 1000MB)")
    
    try:
        # Allocate memory
        memory_data = bytearray(size_mb * 1024 * 1024)
        
        # Fill with some data to ensure it's actually allocated
        for i in range(0, len(memory_data), 1024):
            memory_data[i] = 1
        
        return {
            "message": f"Allocated {size_mb}MB of memory",
            "timestamp": datetime.now().isoformat(),
            "memory_used": psutil.virtual_memory().used,
            "memory_percent": psutil.virtual_memory().percent
        }
    except MemoryError:
        raise HTTPException(status_code=507, detail="Insufficient memory")

@app.post("/disk/fill")
async def fill_disk(size_mb: int = 10):
    """Fill disk space to test disk limits"""
    if size_mb > 100:  # Safety limit
        raise HTTPException(status_code=400, detail="Size too large (max 100MB)")
    
    try:
        # Create test file
        test_file = "/app/data/test_file.bin"
        os.makedirs(os.path.dirname(test_file), exist_ok=True)
        
        with open(test_file, 'wb') as f:
            f.write(b'0' * (size_mb * 1024 * 1024))
        
        return {
            "message": f"Created {size_mb}MB test file",
            "file_path": test_file,
            "timestamp": datetime.now().isoformat(),
            "disk_usage": get_directory_size("/app/data")
        }
    except OSError as e:
        raise HTTPException(status_code=507, detail=f"Disk full: {str(e)}")

@app.delete("/disk/cleanup")
async def cleanup_disk():
    """Clean up test files"""
    try:
        test_file = "/app/data/test_file.bin"
        if os.path.exists(test_file):
            os.remove(test_file)
            return {"message": "Test file removed", "timestamp": datetime.now().isoformat()}
        else:
            return {"message": "No test file found", "timestamp": datetime.now().isoformat()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/stress")
async def stress_test():
    """Run a stress test to demonstrate resource usage"""
    start_time = time.time()
    
    # CPU stress
    cpu_start = psutil.cpu_percent()
    for i in range(1000000):
        _ = i * i
    
    # Memory stress
    memory_start = psutil.virtual_memory().percent
    data = []
    for i in range(10000):
        data.append([i] * 100)
    
    end_time = time.time()
    
    return {
        "message": "Stress test completed",
        "duration": end_time - start_time,
        "cpu_usage": psutil.cpu_percent(),
        "memory_usage": psutil.virtual_memory().percent,
        "timestamp": datetime.now().isoformat()
    }

def get_memory_limit():
    """Get container memory limit from cgroups"""
    try:
        with open('/sys/fs/cgroup/memory/memory.limit_in_bytes', 'r') as f:
            return int(f.read().strip())
    except:
        return None

def get_cgroup_memory():
    """Get cgroup memory information"""
    try:
        with open('/sys/fs/cgroup/memory/memory.usage_in_bytes', 'r') as f:
            return int(f.read().strip())
    except:
        return None

def get_directory_size(path):
    """Get directory size in bytes"""
    total_size = 0
    try:
        for dirpath, dirnames, filenames in os.walk(path):
            for filename in filenames:
                filepath = os.path.join(dirpath, filename)
                try:
                    total_size += os.path.getsize(filepath)
                except OSError:
                    pass
        return total_size
    except:
        return 0

def count_files(path):
    """Count files in directory"""
    try:
        count = 0
        for root, dirs, files in os.walk(path):
            count += len(files)
        return count
    except:
        return 0
