# CitySeva - Configuration Reference Guide

## Overview

This guide explains all configuration files and how to customize CitySeva for your environment.

## Backend Configuration

### `.env` (Local Configuration - DO NOT COMMIT)

This file contains sensitive configuration variables for your backend. It's created from `.env.example`.

```bash
# Database Connection
MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net/cityseva

# Server Configuration
PORT=3000                    # Backend API port
NODE_ENV=development        # development or production

# CORS Configuration
CORS_ORIGIN=*              # Allow all origins (change for production)
```

**Security Tips:**
- Never commit `.env` to version control
- Use strong passwords for MongoDB
- Restrict `CORS_ORIGIN` to your frontend domain in production
- Use environment secrets on production servers

### `package.json`

Node.js project configuration and dependencies.

**Key Dependencies:**
- `express` - Web framework
- `mongoose` - MongoDB ODM
- `cors` - Cross-Origin Resource Sharing
- `dotenv` - Environment variable management

**Scripts:**
```bash
npm start    # Start production server
npm test     # Run tests (if configured)
```

### `index.js`

Main Express server file that:
1. Initializes Express app
2. Enables CORS middleware
3. Configures JSON parsing
4. Sets up API routes
5. Connects to MongoDB
6. Starts listening on specified port

## Frontend Configuration

### `pubspec.yaml`

Flutter project configuration and dependencies.

**Key Dependencies:**
- `provider` - State management
- `http` - HTTP client for API calls
- `geolocator` - GPS location services
- `image_picker` - Photo capture
- `shared_preferences` - Local data storage

**Platforms:**
```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.0.0'  # Enables web support
```

### `lib/services/api_service.dart` (NEW)

HTTP client that communicates with the backend API.

**Configuration:**
```dart
static const String _baseUrl = 'http://localhost:3000/api';
static const Duration _timeout = Duration(seconds: 15);
```

**Update for Production:**
```dart
static const String _baseUrl = 'https://your-backend-domain.com/api';
```

### `lib/main.dart`

Application entry point that:
1. Initializes Flutter bindings
2. Sets up device orientation (portrait only)
3. Configures status bar styling
4. Sets up state management with Provider
5. Defines Material theme

### `lib/utils/app_theme.dart`

Centralized theme configuration for the app.

**Customize:**
- Colors and color schemes
- Typography and fonts
- Component sizes
- Animation durations

### `lib/providers/complaint_provider.dart`

State management for complaint-related data.

**Manages:**
- Complaint list state
- Filtering and sorting
- API interaction
- Caching strategy

## Web Platform Configuration

### `web/index.html`

Main HTML entry point for the Flutter web app.

**Configuration Points:**
- App title and metadata
- PWA manifest reference
- Loading screen UI
- Flutter initialization script

### `web/manifest.json`

Progressive Web App (PWA) configuration.

```json
{
  "name": "CitySeva",
  "short_name": "CitySeva",
  "start_url": "/cityseva/",
  "display": "standalone",      // Full-screen app experience
  "theme_color": "#2A6B82",     // Browser UI color
  "background_color": "#ffffff" // Splash screen color
}
```

**Key Fields:**
- `start_url` - Path where app is hosted
- `display` - App appearance (standalone = app-like)
- `icons` - PWA icons for home screen
- `theme_color` - Browser toolbar color

## Docker Configuration

### `Dockerfile`

Containerizes the Node.js backend.

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### `docker-compose.yml`

Orchestrates multiple services (backend + MongoDB).

**Services:**
1. **backend** - Node.js API server
2. **mongodb** - MongoDB database (optional)

**Networks & Volumes:**
- `cityseva-network` - Automatic service discovery
- `mongodb_data` - Persistent database storage

## Database Configuration

### MongoDB Collections

#### `users`
```javascript
{
  id: String,           // Unique user ID
  name: String,
  email: String,        // Index: unique
  phone: String,
  role: String,         // 'citizen' | 'authority' | 'government'
  avatarPath: String,
  createdAt: Date,      // Auto-generated
  updatedAt: Date       // Auto-generated
}
```

#### `complaints`
```javascript
{
  id: String,                       // Index: unique
  userId: String,                   // FK to users
  title: String,
  description: String,
  department: Number,
  address: String,
  latitude: Number,
  longitude: Number,
  imagePaths: [String],
  status: Number,                   // 0=open 1=assigned 2=resolved
  statusHistory: [
    {
      status: Number,
      timestamp: String,
      note: String
    }
  ],
  assignedTo: String,               // FK to users (authority)
  authorityNote: String,
  completionImagePath: String,
  createdAt: Date,
  updatedAt: Date
}
```

#### `feedbacks`
```javascript
{
  id: String,                       // Index: unique
  complaintId: String,              // FK to complaints
  userId: String,                   // FK to users
  rating: Number,                   // 1-5
  completedOnTime: Boolean,
  comment: String,
  createdAt: Date
}
```

## Environment Variables Reference

| Variable | Scope | Type | Required | Example |
|----------|-------|------|----------|---------|
| `MONGO_URI` | Backend | URL | Yes | `mongodb+srv://user:pass@host/db` |
| `PORT` | Backend | Number | No | `3000` |
| `NODE_ENV` | Backend | String | No | `development` |
| `CORS_ORIGIN` | Backend | String | No | `http://localhost:3000` |

## Performance Configuration

### Backend Optimization

In `index.js`, you can configure:
```javascript
// Limit JSON payload size
app.use(express.json({ limit: '10mb' }));

// Connection pooling
mongoose.connect(uri, {
  maxPoolSize: 10,
  minPoolSize: 5
});
```

### Frontend Optimization

In `lib/services/api_service.dart`:
```dart
// Adjust timeout for slow networks
static const Duration _timeout = Duration(seconds: 30);

// Add retry logic
static const int _maxRetries = 3;
```

## Security Checklist

- [ ] Never commit `.env` file
- [ ] Use strong MongoDB passwords
- [ ] Enable IP whitelist in MongoDB Atlas
- [ ] Use HTTPS in production
- [ ] Restrict CORS origins
- [ ] Validate all user input on backend
- [ ] Implement JWT authentication
- [ ] Add rate limiting to API
- [ ] Enable HTTPS only cookies
- [ ] Implement CSRF protection

## Deployment Checklists

### Backend Deployment
- [ ] Set `NODE_ENV=production`
- [ ] Update `MONGO_URI` to production database
- [ ] Configure `CORS_ORIGIN` to frontend domain
- [ ] Set `PORT` environment variable
- [ ] Enable security headers
- [ ] Set up monitoring/logging
- [ ] Configure backups for MongoDB

### Web Deployment
- [ ] Build: `flutter build web --release`
- [ ] Update `api_service.dart` base URL
- [ ] Deploy `build/web` to hosting
- [ ] Test API connectivity
- [ ] Monitor browser console for errors
- [ ] Enable caching headers
- [ ] Set up CI/CD pipeline

## Troubleshooting Configuration Issues

### Issue: "Cannot find module"
- Ensure `node_modules` exists: `npm install`
- Check package name spelling in `package.json`

### Issue: "MongoDB connection failed"
- Verify `MONGO_URI` is correct
- Check MongoDB Atlas IP whitelist
- Ensure network connection to MongoDB Atlas

### Issue: CORS errors in browser
- Check `CORS_ORIGIN` includes frontend URL
- Verify backend is running
- Clear browser cache

### Issue: Slow API responses
- Check MongoDB query performance
- Increase `_timeout` in `api_service.dart`
- Monitor backend logs for errors
- Check network latency

## Further Reading

- [Express.js Configuration](https://expressjs.com/en/api/app.html)
- [Mongoose Schema Guide](https://mongoosejs.com/docs/guide.html)
- [Flutter Configuration](https://flutter.dev/docs/deployment/pubspec)
- [Flutter Web Configuration](https://flutter.dev/docs/get-started/web)
- [PWA Configuration](https://web.dev/add-manifest/)

---

**Last Updated**: March 28, 2024
