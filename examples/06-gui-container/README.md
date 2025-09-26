# GUI Applications in Docker

## Do not use this version until issues are fixed

## Warning used images are pretty memory intensive!!!

This example demonstrates how to run GUI applications (GIMP and Doom) inside Docker containers using VNC for remote access.

## What This Example Shows

- GUI applications in headless containers
- VNC server setup for remote access
- Virtual display (Xvfb) configuration
- Desktop environment integration
- Volume persistence for GUI data
- Cross-platform GUI access

## Files

- `Dockerfile.gimp` - GIMP image with VNC server
- `Dockerfile.doom` - Doom game with VNC server
- `docker-compose.gui.yml` - Compose configuration for GUI apps
- `gui-demo.sh` - Demonstration script

## How to Run

### Method 1: Individual Containers

```bash
# Build GIMP container
docker build -f Dockerfile.gimp -t gimp-container .

# Build Doom container
docker build -f Dockerfile.doom -t doom-container .

# Run GIMP container
docker run -d -p 5900:5900 -v gimp_data:/home/guiuser --name gimp-app --privileged gimp-container

# Run Doom container
docker run -d -p 5901:5900 -v doom_data:/home/guiuser --name doom-app --privileged doom-container
```

### Method 2: Docker Compose (Recommended)

```bash
# Using Docker Compose
docker-compose -f docker-compose.gui.yml up -d
```

### Method 3: Using the Script

```bash
# Run the automated demonstration
./gui-demo.sh
```

## Accessing GUI Applications

### VNC Client Connection

- **GIMP**: Connect to `localhost:5900`
- **Doom**: Connect to `localhost:5901`

### VNC Client Options

1. **RealVNC Viewer** - Professional VNC client
2. **TightVNC Viewer** - Lightweight VNC client
3. **TigerVNC Viewer** - High-performance VNC client
4. **Web Browser** - If VNC web client is enabled

### Command Line Access

```bash
# Install VNC viewer
sudo apt-get install tigervnc-viewer

# Connect to GIMP
vncviewer localhost:5900

# Connect to Doom
vncviewer localhost:5901
```

## GUI Container Architecture

### 1. Virtual Display (Xvfb)

- **Purpose**: Headless X server for GUI applications
- **Resolution**: 1024x768x24 (configurable)
- **Benefits**: No physical display required

### 2. VNC Server

- **Purpose**: Remote desktop access
- **Port**: 5900 (default)
- **Security**: No password (development only)

### 3. Desktop Environment

- **XFCE4**: Lightweight desktop environment
- **Features**: Window management, application launcher
- **Performance**: Optimized for containerized environments

## Applications Included

### GIMP (GNU Image Manipulation Program)

- **Purpose**: Image editing and manipulation
- **Features**: Layers, filters, brushes, text tools
- **Use Cases**: Photo editing, graphic design, digital art

### Doom (Classic Game)

- **Purpose**: First-person shooter game
- **Features**: Classic gameplay, save system
- **Use Cases**: Gaming, nostalgia, testing

## Volume Persistence

### Data Persistence

- **GIMP Data**: Saved in `gimp_data` volume
- **Doom Saves**: Saved in `doom_data` volume
- **User Settings**: Preserved between container restarts

### Volume Management

```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect gimp_data

# Backup volume
docker run --rm -v gimp_data:/data -v $(pwd):/backup ubuntu tar czf /backup/gimp_data.tar.gz -C /data .
```

## Security Considerations

### Container Security

- **Non-root User**: Applications run as `guiuser`
- **Privileged Mode**: Required for GUI access
- **Network Isolation**: VNC ports only

### VNC Security

- **No Password**: Development only (not for production)
- **Local Access**: Bind to localhost only
- **Firewall**: Restrict VNC port access

### Production Security

```bash
# Secure VNC with password
x11vnc -display :0 -passwd mypassword -forever -noxdamage

# SSL/TLS encryption
x11vnc -display :0 -ssl -cert /path/to/cert.pem
```

## Performance Optimization

### Resource Allocation

```bash
# Allocate memory and CPU
docker run -d \
  --memory=2g \
  --cpus=1.0 \
  -p 5900:5900 \
  gimp-container
```

### Display Optimization

```bash
# Higher resolution
Xvfb :0 -screen 0 1920x1080x24

# Hardware acceleration (if available)
Xvfb :0 -screen 0 1024x768x24 +extension GLX
```

## Alternative GUI Approaches

### 1. X11 Forwarding

```bash
# Forward X11 display to host
docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix gimp-container
```

### 2. Web-based GUI

```bash
# Use web applications
docker run -p 8080:8080 web-gui-container
```

### 3. Remote Desktop

```bash
# RDP connection
docker run -p 3389:3389 rdp-container
```

## Troubleshooting

### Common Issues

1. **VNC Connection Failed**

   ```bash
   # Check if container is running
   docker ps

   # Check VNC server logs
   docker logs gimp-app

   # Test port connectivity
   telnet localhost 5900
   ```

2. **Display Issues**

   ```bash
   # Check Xvfb process
   docker exec gimp-app ps aux | grep Xvfb

   # Restart display
   docker exec gimp-app pkill Xvfb
   docker exec gimp-app Xvfb :0 -screen 0 1024x768x24 &
   ```

3. **Application Not Starting**

   ```bash
   # Check application logs
   docker exec gimp-app journalctl -u gimp

   # Verify dependencies
   docker exec gimp-app which gimp
   ```

### Debugging Commands

```bash
# Check container status
docker ps -a

# View container logs
docker logs -f gimp-app

# Execute commands in container
docker exec -it gimp-app bash

# Check resource usage
docker stats gimp-app
```

## Production Considerations

### 1. High Availability

- **Load Balancing**: Multiple VNC servers
- **Failover**: Automatic container restart
- **Monitoring**: Health checks and alerts

### 2. Scalability

- **Horizontal Scaling**: Multiple containers
- **Resource Limits**: CPU and memory limits
- **Session Management**: User session handling

### 3. Security

- **Authentication**: VNC password protection
- **Encryption**: SSL/TLS for VNC connections
- **Network Security**: Firewall rules and VPN

## Clean Up

```bash
# Stop and remove containers
docker stop gimp-app doom-app
docker rm gimp-app doom-app

# Remove images
docker rmi gimp-container doom-container

# Remove volumes
docker volume rm gimp_data doom_data

# Using Docker Compose
docker-compose -f docker-compose.gui.yml down -v
```

## Next Steps

- Learn about Docker Compose for multi-service applications
- Understand multi-stage builds for optimization
- Explore container networking
- Study container orchestration

## Further Learning

- [VNC Documentation](https://www.realvnc.com/en/connect/docs/)
- [Xvfb Documentation](https://www.x.org/releases/X11R7.6/doc/man/man1/Xvfb.1.xhtml)
- [Docker GUI Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Container Security](https://docs.docker.com/engine/security/)
