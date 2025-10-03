from fastapi import FastAPI
import os
import redis
import psycopg2
from datetime import datetime
import json

app = FastAPI(title="Docker Compose Demo", version="1.0.0")

# Database connection
def get_db_connection():
    try:
        conn = psycopg2.connect(
            host=os.getenv("DB_HOST", "postgres"),
            database=os.getenv("DB_NAME", "demo"),
            user=os.getenv("DB_USER", "demo"),
            password=os.getenv("DB_PASSWORD", "demo")
        )
        return conn
    except Exception as e:
        print(f"Database connection error: {e}")
        return None

# Redis connection
def get_redis_connection():
    try:
        r = redis.Redis(
            host=os.getenv("REDIS_HOST", "redis"),
            port=int(os.getenv("REDIS_PORT", "6379")),
            decode_responses=True
        )
        r.ping()  # Test connection
        return r
    except Exception as e:
        print(f"Redis connection error: {e}")
        return None

@app.get("/")
async def root():
    return {
        "message": "Docker Compose Demo",
        "timestamp": datetime.now().isoformat(),
        "environment": os.getenv("ENVIRONMENT", "development"),
        "services": ["fastapi", "postgres", "redis", "nginx"]
    }

@app.get("/health")
async def health():
    """Health check for all services"""
    health_status = {
        "fastapi": "healthy",
        "database": "unknown",
        "redis": "unknown",
        "timestamp": datetime.now().isoformat()
    }
    
    # Check database
    db_conn = get_db_connection()
    if db_conn:
        health_status["database"] = "healthy"
        db_conn.close()
    else:
        health_status["database"] = "unhealthy"
    
    # Check Redis
    redis_conn = get_redis_connection()
    if redis_conn:
        health_status["redis"] = "healthy"
    else:
        health_status["redis"] = "unhealthy"
    
    return health_status

@app.get("/database")
async def database_info():
    """Get database information"""
    conn = get_db_connection()
    if not conn:
        return {"error": "Database connection failed"}
    
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT version();")
        version = cursor.fetchone()[0]
        
        cursor.execute("SELECT current_database(), current_user;")
        db_info = cursor.fetchone()
        
        return {
            "status": "connected",
            "version": version,
            "database": db_info[0],
            "user": db_info[1],
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        return {"error": str(e)}
    finally:
        conn.close()

@app.get("/redis")
async def redis_info():
    """Get Redis information"""
    r = get_redis_connection()
    if not r:
        return {"error": "Redis connection failed"}
    
    try:
        info = r.info()
        return {
            "status": "connected",
            "version": info.get("redis_version"),
            "uptime": info.get("uptime_in_seconds"),
            "memory": info.get("used_memory_human"),
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        return {"error": str(e)}

@app.post("/data")
async def store_data(data: dict):
    """Store data in both database and Redis"""
    result = {
        "database": "failed",
        "redis": "failed",
        "timestamp": datetime.now().isoformat()
    }
    
    # Store in database
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor()
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS demo_data (
                    id SERIAL PRIMARY KEY,
                    data JSONB,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """)
            cursor.execute("INSERT INTO demo_data (data) VALUES (%s)", (json.dumps(data),))
            conn.commit()
            result["database"] = "success"
        except Exception as e:
            result["database"] = f"error: {str(e)}"
        finally:
            conn.close()
    
    # Store in Redis
    r = get_redis_connection()
    if r:
        try:
            r.set(f"data:{datetime.now().isoformat()}", json.dumps(data))
            result["redis"] = "success"
        except Exception as e:
            result["redis"] = f"error: {str(e)}"
    
    return result

@app.get("/data")
async def get_data():
    """Get data from both database and Redis"""
    result = {
        "database": [],
        "redis": [],
        "timestamp": datetime.now().isoformat()
    }
    
    # Get from database
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor()
            cursor.execute("SELECT data, created_at FROM demo_data ORDER BY created_at DESC LIMIT 10")
            rows = cursor.fetchall()
            result["database"] = [{"data": row[0], "created_at": row[1].isoformat()} for row in rows]
        except Exception as e:
            result["database"] = [{"error": str(e)}]
        finally:
            conn.close()
    
    # Get from Redis
    r = get_redis_connection()
    if r:
        try:
            keys = r.keys("data:*")
            for key in keys[:10]:  # Limit to 10 items
                data = r.get(key)
                result["redis"].append({"key": key, "data": data})
        except Exception as e:
            result["redis"] = [{"error": str(e)}]
    
    return result

@app.get("/services")
async def services_info():
    """Get information about all services"""
    return {
        "fastapi": {
            "status": "running",
            "port": 8000,
            "environment": os.getenv("ENVIRONMENT", "development")
        },
        "postgres": {
            "host": os.getenv("DB_HOST", "postgres"),
            "port": 5432,
            "database": os.getenv("DB_NAME", "demo")
        },
        "redis": {
            "host": os.getenv("REDIS_HOST", "redis"),
            "port": int(os.getenv("REDIS_PORT", "6379"))
        },
        "nginx": {
            "status": "proxy",
            "port": 80
        }
    }
