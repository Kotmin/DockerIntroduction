#!/bin/bash

# GUI Container demonstration script
# This script shows how to run GUI applications in Docker containers

echo "=== Docker GUI Applications Examples ==="
echo ""

echo "=== Building GUI Images ==="
echo "Building GIMP container..."
docker build -f Dockerfile.gimp -t gimp-container .

echo ""
echo "Building Doom container..."
docker build -f Dockerfile.doom -t doom-container .

echo ""
echo "=== Running GUI Containers ==="
echo ""

# Stop and remove existing containers if they exist
docker stop gimp-app doom-app 2>/dev/null || true
docker rm gimp-app doom-app 2>/dev/null || true

echo "1. GIMP Container:"
echo "   - VNC port: 5900"
echo "   - Access via VNC client"
echo ""

# Run GIMP container
docker run -d \
  -p 5900:5900 \
  -v gimp_data:/home/guiuser \
  -e DISPLAY=:0 \
  --name gimp-app \
  --privileged \
  gimp-container

echo "2. Doom Container:"
echo "   - VNC port: 5901"
echo "   - Access via VNC client"
echo ""

# Run Doom container
docker run -d \
  -p 5901:5900 \
  -v doom_data:/home/guiuser \
  -e DISPLAY=:0 \
  --name doom-app \
  --privileged \
  doom-container

echo ""
echo "=== Container Status ==="
docker ps --filter name=gimp-app
docker ps --filter name=doom-app

echo ""
echo "=== Accessing GUI Applications ==="
echo ""

echo "1. Using VNC Client:"
echo "   - GIMP: localhost:5900"
echo "   - Doom: localhost:5901"
echo ""

echo "2. VNC Client Options:"
echo "   - RealVNC Viewer"
echo "   - TightVNC Viewer"
echo "   - TigerVNC Viewer"
echo "   - Web browser (if VNC web client enabled)"
echo ""

echo "3. Command Line VNC:"
echo "   - GIMP: vncviewer localhost:5900"
echo "   - Doom: vncviewer localhost:5901"
echo ""

echo "=== GUI Container Features ==="
echo ""

echo "1. Virtual Display (Xvfb):"
echo "   - Headless X server"
echo "   - Virtual screen resolution"
echo "   - No physical display required"
echo ""

echo "2. VNC Server:"
echo "   - Remote desktop access"
echo "   - Network-based GUI access"
echo "   - Cross-platform compatibility"
echo ""

echo "3. Desktop Environment:"
echo "   - XFCE4 lightweight desktop"
echo "   - Window management"
echo "   - Application launcher"
echo ""

echo "=== Running Applications ==="
echo ""

echo "1. GIMP:"
echo "   - Launch from desktop"
echo "   - Create and edit images"
echo "   - Save files to persistent volume"
echo ""

echo "2. Doom:"
echo "   - Launch from desktop"
echo "   - Classic first-person shooter"
echo "   - Save game progress"
echo ""

echo "=== Docker Compose GUI ==="
echo "Using Docker Compose for GUI applications:"
echo "docker-compose -f docker-compose.gui.yml up -d"
echo ""

echo "=== GUI Container Best Practices ==="
echo ""

echo "1. Security:"
echo "   - Use non-root users"
echo "   - Limit container privileges"
echo "   - Secure VNC connections"
echo ""

echo "2. Performance:"
echo "   - Allocate sufficient memory"
echo "   - Use hardware acceleration when possible"
echo "   - Optimize display settings"
echo ""

echo "3. Persistence:"
echo "   - Use volumes for user data"
echo "   - Backup important files"
echo "   - Configure application settings"
echo ""

echo "=== Alternative GUI Approaches ==="
echo ""

echo "1. X11 Forwarding:"
echo "   - Forward X11 display to host"
echo "   - Requires X server on host"
echo "   - Good for development"
echo ""

echo "2. Web-based GUI:"
echo "   - Use web applications"
echo "   - Browser-based interfaces"
echo "   - No VNC required"
echo ""

echo "3. Remote Desktop:"
echo "   - RDP connections"
echo "   - TeamViewer integration"
echo "   - Cloud-based solutions"
echo ""

echo "=== Troubleshooting ==="
echo ""

echo "1. VNC Connection Issues:"
echo "   - Check port accessibility"
echo "   - Verify container is running"
echo "   - Check firewall settings"
echo ""

echo "2. Display Issues:"
echo "   - Verify Xvfb is running"
echo "   - Check display resolution"
echo "   - Restart container if needed"
echo ""

echo "3. Application Issues:"
echo "   - Check application logs"
echo "   - Verify dependencies"
echo "   - Update container image"
echo ""

echo "=== Monitoring GUI Containers ==="
echo ""

echo "1. Container logs:"
echo "docker logs gimp-app"
echo "docker logs doom-app"
echo ""

echo "2. Resource usage:"
echo "docker stats gimp-app doom-app"
echo ""

echo "3. Volume usage:"
echo "docker volume ls"
echo "docker volume inspect gimp_data"
echo ""

echo "=== Cleanup ==="
echo "To stop and remove:"
echo "docker stop gimp-app doom-app"
echo "docker rm gimp-app doom-app"
echo "docker volume rm gimp_data doom_data"
echo "docker-compose -f docker-compose.gui.yml down -v"
