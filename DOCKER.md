# Docker Setup for CitySeva

If you have Docker installed, you can run the entire project using Docker Compose.

## Prerequisites
- [Docker](https://www.docker.com/products/docker-desktop)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Running with Docker

### Option 1: Use MongoDB Atlas (Recommended for Development)

1. Update your `.env` file with your MongoDB Atlas connection string:
   ```
   MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net/cityseva
   PORT=3000
   CORS_ORIGIN=*
   NODE_ENV=development
   ```

2. Run only the backend service:
   ```bash
   docker-compose up backend
   ```

### Option 2: Use Local MongoDB (for testing)

This will start both Backend and MongoDB services:

```bash
docker-compose up
```

The services will be available at:
- **Backend API**: http://localhost:3000
- **MongoDB**: localhost:27017
  - Username: `admin`
  - Password: `password`

## Docker Compose Services

### Backend Service
- **Image**: Custom Node.js image from `backend/Dockerfile`
- **Port**: 3000
- **Environment**: Configured from `.env`
- **Health Check**: Automatic health monitoring

### MongoDB Service
- **Image**: mongo:6.0
- **Port**: 27017
- **Data Volume**: `mongodb_data` (persists between restarts)
- **Credentials**: admin/password (for local testing only)

## Useful Commands

```bash
# Start services in background
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Remove volumes (careful - deletes data)
docker-compose down -v

# Rebuild images
docker-compose build

# Run specific service
docker-compose up backend
docker-compose up mongodb
```

## Production Deployment

For production, it's recommended to:
1. Use MongoDB Atlas instead of local MongoDB
2. Update `CORS_ORIGIN` to your frontend domain
3. Set `NODE_ENV=production`
4. Use environment variables from your hosting platform

---

**Note**: The Flutter web frontend still needs to be run separately using:
```bash
cd cityseva
flutter run -d chrome
```

Or build for production and deploy to a web server.
