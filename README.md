# Pokemon Showdown Docker Setup

This Docker setup runs the official Pokemon Showdown server on an Ubuntu base image.

## Prerequisites

- Docker installed ([Install Docker](https://docs.docker.com/get-docker/))
- Docker Compose installed ([Install Docker Compose](https://docs.docker.com/compose/install/))
- At least 1GB of disk space

## Quick Start

### Option 1: Using Docker Compose (Recommended)

```bash
# Build the image
docker-compose build

# Start the server
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the server
docker-compose down
```

### Option 2: Using Docker Directly

```bash
# Build the image
docker build -t pokemon-showdown .

# Run the container
docker run -d \
  --name pokemon-showdown-server \
  -p 8000:8000 \
  -v $(pwd)/logs:/app/logs \
  -v $(pwd)/config:/app/config \
  pokemon-showdown

# View logs
docker logs -f pokemon-showdown-server

# Stop the container
docker stop pokemon-showdown-server
docker rm pokemon-showdown-server
```

## Configuration

### Modifying Server Settings

1. After the container starts, config files will be created in `./config/`
2. Edit `config/config.js` to customize server settings:
   - Port number
   - Server name
   - Max connections
   - Password settings

3. Restart the container for changes to take effect:
   ```bash
   docker-compose restart
   ```

### Ports

- **Default**: 8000 (HTTP)
- To use a different port, edit `docker-compose.yml` and change:
  ```yaml
  ports:
    - "YOUR_PORT:8000"
  ```

## Volumes

The Docker setup creates these volumes:

- `./logs` - Server logs
- `./config` - Configuration files
- `./data` - Data persistence (replays, user data, etc.)

## Connecting to the Server

Once running, connect to:
```
http://localhost:8000
```

Or from another machine:
```
http://YOUR_SERVER_IP:8000
```

## Useful Commands

```bash
# View real-time logs
docker-compose logs -f

# Execute command in container
docker-compose exec pokemon-showdown node pokemon-showdown --help

# Restart server
docker-compose restart

# View container status
docker-compose ps

# Clean up (remove container and images)
docker-compose down --rmi all
```

## Troubleshooting

### Port Already in Use
If port 8000 is already in use:
1. Edit `docker-compose.yml`
2. Change the first port number in the `ports` section
3. Rebuild and restart: `docker-compose up -d --build`

### Permission Issues
The container runs as non-root user `showdown` for security. If you need to modify files:
```bash
sudo chown -R $USER:$USER ./logs ./config ./data
```

### Low Memory
Increase the memory limit in `docker-compose.yml`:
```yaml
deploy:
  resources:
    limits:
      memory: 1G
```

### Container Won't Start
Check logs for errors:
```bash
docker-compose logs pokemon-showdown
```

## Updates

To update to the latest Pokemon Showdown version:

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## Performance Tips

1. **Use named volumes for better I/O**: Currently using bind mounts; consider Docker named volumes for high-traffic servers
2. **Monitor resources**:
   ```bash
   docker stats pokemon-showdown-server
   ```
3. **Enable swap if needed** on your host machine
4. **Use nginx reverse proxy** for multiple servers or load balancing

## Security Notes

- Container runs as non-root user
- No default passwords set (configure in `config/config.js`)
- Use a firewall to restrict access if needed
- Keep Docker and images updated

## Resources

- [Pokemon Showdown GitHub](https://github.com/smogon/pokemon-showdown)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
