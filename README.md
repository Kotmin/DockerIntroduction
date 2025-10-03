# Docker Tutorial for Juniors

A comprehensive Docker tutorial designed for junior developers, created by a Senior Solution Architect. This tutorial covers essential Docker concepts with working examples and best practices.

## QuickInstall Docker

```bash
sudo apt update -y
sudo apt upgrade -y

sudo apt install -y git
sudo apt install -y curl

curl -fsSL https://get.docker.com | sh
sudo systemctl enable --now docker

docker --version
sudo usermod -aG docker $USER
newgrp docker

```

## QuickInstall docker compose (only when Docker is installed)
```bash
## DOCKER COMPOSE
sudo curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo systemctl restart docker
```

## 🎯 Tutorial Overview

This tutorial provides hands-on examples for learning Docker from basics to advanced concepts. Each example includes working code, comprehensive documentation, and step-by-step instructions.

## 📚 Tutorial Structure

### 1. [Simple Container](examples/01-simple-container/)
**Basic FastAPI container with security best practices**
- Basic Dockerfile structure
- Non-root user security
- Health checks
- Environment variables
- Layer caching optimization

### 2. [Development Container](examples/02-dev-container/)
**Development workflow with volume binding**
- Hot reload with volume mounts
- Development vs production differences
- Docker Compose for development
- Live code changes

### 3. [Container Logging](examples/03-logging/)
**Comprehensive logging strategies**
- Different log levels (DEBUG, INFO, WARNING, ERROR, CRITICAL)
- File-based and stdout logging
- Docker log drivers and rotation
- Log monitoring and analysis

### 4. [Cron Jobs](examples/04-cron-job/)
**Scheduled tasks in containers**
- Cron daemon setup
- Different task types (health checks, cleanup, reports, backups)
- Manual vs automated execution
- Volume persistence for cron data

### 5. [Volumes and Memory](examples/05-volumes-memory/)
**Volume types and resource management**
- Bind mounts vs named volumes vs anonymous volumes
- Memory and CPU resource limits
- Volume persistence strategies
- Resource monitoring and stress testing

### 6. [GUI Applications](examples/06-gui-container/)
**GUI applications in containers (GIMP and Doom)**
- Headless GUI applications
- VNC server setup for remote access
- Virtual display (Xvfb) configuration
- Desktop environment integration

### 7. [Docker Compose](examples/07-docker-compose/)
**Multi-service applications**
- FastAPI + PostgreSQL + Redis + Nginx
- Service dependencies and health checks
- Version comparison (v3.8 vs v2.4)
- Reverse proxy configuration

### 8. [Multi-Stage Builds](examples/08-multi-stage-build/)
**Optimized container builds**
- Single-stage vs multi-stage comparison
- Image size optimization
- Security improvements
- BuildKit features and advanced caching

## 🚀 Quick Start

### Prerequisites
- Docker installed and running
- Basic command line knowledge
- Git for cloning the repository

### Getting Started
```bash
# Clone the repository
git clone <repository-url>
cd DockerIntroduction

# Switch to the dev branch
git checkout dev

# Explore examples
cd examples/01-simple-container
./run-dev.sh
```

## 📖 Learning Path

### Beginner Level
1. **Simple Container** - Start with basic concepts
2. **Development Container** - Learn development workflows
3. **Container Logging** - Understand monitoring

### Intermediate Level
4. **Cron Jobs** - Learn scheduled tasks
5. **Volumes and Memory** - Understand data persistence
6. **GUI Applications** - Explore GUI containers

### Advanced Level
7. **Docker Compose** - Multi-service applications
8. **Multi-Stage Builds** - Production optimization

## 🛠️ Each Example Includes

- **Working Code**: Complete, runnable examples
- **Dockerfile**: Production-ready container definitions
- **Documentation**: Comprehensive README files
- **Scripts**: Automated demonstration scripts
- **Best Practices**: Security and optimization guidelines

## 🔧 Common Commands

### Basic Docker Commands
```bash
# Build an image
docker build -t my-app .

# Run a container
docker run -d -p 8000:8000 --name my-app my-app

# View logs
docker logs my-app

# Stop and remove
docker stop my-app && docker rm my-app
```

### Docker Compose Commands
```bash
# Start services
docker-compose up -d

# View status
docker-compose ps

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## 📊 Example Comparison

| Example | Complexity | Focus Area | Use Case |
|---------|------------|------------|----------|
| Simple Container | ⭐ | Basics | Learning Docker fundamentals |
| Development Container | ⭐⭐ | Development | Daily development workflow |
| Container Logging | ⭐⭐ | Monitoring | Production logging |
| Cron Jobs | ⭐⭐⭐ | Automation | Scheduled tasks |
| Volumes and Memory | ⭐⭐⭐ | Storage | Data persistence |
| GUI Applications | ⭐⭐⭐ | GUI | Desktop applications |
| Docker Compose | ⭐⭐⭐⭐ | Orchestration | Multi-service apps |
| Multi-Stage Builds | ⭐⭐⭐⭐ | Optimization | Production builds |

## 🎓 Learning Objectives

After completing this tutorial, you will understand:

- **Container Basics**: How to create and run containers
- **Development Workflows**: Efficient development with Docker
- **Production Practices**: Security, logging, and monitoring
- **Data Management**: Volumes, persistence, and resource limits
- **Multi-Service Applications**: Docker Compose and orchestration
- **Optimization**: Multi-stage builds and performance tuning

## 🔒 Security Best Practices

All examples follow security best practices:

- **Non-root Users**: Never run as root in containers
- **Minimal Base Images**: Use slim/alpine variants
- **Health Checks**: Monitor container health
- **Resource Limits**: Prevent resource exhaustion
- **Volume Security**: Proper volume permissions

## 📈 Performance Tips

- **Layer Caching**: Optimize Dockerfile layer ordering
- **Multi-stage Builds**: Reduce image sizes
- **Resource Limits**: Set appropriate CPU and memory limits
- **Volume Optimization**: Choose appropriate volume types
- **BuildKit**: Use advanced build features

## 🐛 Troubleshooting

### Common Issues
1. **Port Conflicts**: Use different ports or stop conflicting services
2. **Permission Issues**: Check file permissions and user settings
3. **Volume Mount Issues**: Verify volume paths and permissions
4. **Resource Limits**: Check memory and CPU limits

### Debug Commands
```bash
# Check container status
docker ps -a

# View container logs
docker logs <container-name>

# Execute commands in container
docker exec -it <container-name> bash

# Check resource usage
docker stats
```

## 📚 Additional Resources

### Official Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

### Learning Resources
- [Docker Tutorial](https://docs.docker.com/get-started/)
- [Container Security](https://docs.docker.com/engine/security/)
- [Docker Networking](https://docs.docker.com/network/)

## 🤝 Contributing

This tutorial is designed for junior developers. If you find issues or have suggestions:

1. Check existing issues
2. Create a new issue with detailed description
3. Follow the established patterns in examples
4. Ensure all examples work as documented

## 📝 License

This tutorial is provided for educational purposes. Feel free to use and modify the examples for your learning and projects.

## 🎯 Next Steps

After completing this tutorial:

1. **Practice**: Build your own containers
2. **Explore**: Try different base images and configurations
3. **Deploy**: Learn about container orchestration (Kubernetes)
4. **Monitor**: Implement comprehensive monitoring
5. **Scale**: Learn about horizontal scaling and load balancing

---

**Happy Learning! 🐳**

*This tutorial was created by a Senior Solution Architect for junior developers. Each example is production-ready and follows industry best practices.*