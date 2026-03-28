# CitySeva - Web & MongoDB Setup Guide

## Overview

CitySeva is now configured as a web application with MongoDB integration. The project consists of:
- **Frontend**: Flutter web application
- **Backend**: Node.js/Express API server
- **Database**: MongoDB

## Prerequisites

Before starting, ensure you have installed:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.0+)
- [Node.js](https://nodejs.org/) (v16+)
- [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) account (free tier available)

## Backend Setup

### Step 1: MongoDB Atlas Configuration

1. **Create a MongoDB Atlas Cluster**:
   - Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
   - Sign up or log in to your account
   - Click "Build a Database"
   - Choose the free tier (M0 Sandbox)
   - Select your region
   - Click "Create Deployment"

2. **Create Database User**:
   - Navigate to "Database Access"
   - Click "Add New Database User"
   - Choose "Password" authentication
   - Set username and generate a secure password
   - Role: `readWriteAnyDatabase@admin`
   - Click "Create"

3. **Setup Network Access**:
   - Navigate to "Network Access"
   - Click "Add IP Address"
   - For development: Add `0.0.0.0/0` (allows all IPs)
   - For production: Add your specific IP address
   - Confirm the change

4. **Get Connection String**:
   - Go to "Clusters"
   - Click "Connect"
   - Choose "Drivers" option
   - Copy the connection string (looks like: `mongodb+srv://username:password@cluster0.mongodb.net/?retryWrites=true&w=majority`)

### Step 2: Backend Configuration

1. **Navigate to backend directory**:
   ```bash
   cd backend
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Configure environment variables**:
   - Copy `.env.example` to `.env`:
     ```bash
     cp .env.example .env
     ```
   - Edit `.env` and update with your MongoDB credentials:
     ```
     MONGO_URI=mongodb+srv://your_username:your_password@cluster0.mongodb.net/cityseva?retryWrites=true&w=majority
     PORT=3000
     CORS_ORIGIN=*
     NODE_ENV=development
     ```

### Step 3: Start Backend Server

```bash
npm start
```

You should see:
```
Connected to MongoDB
Server running on port 3000
```

The backend API will be available at `http://localhost:3000`

**API Endpoints**:
- Health: `GET /`
- Users: `GET/POST /api/users`
- Complaints: `GET/POST/PUT /api/complaints`
- Feedbacks: `GET/POST /api/feedbacks`

## Frontend Setup (Web)

### Step 1: Configure API Base URL

Edit `lib/services/api_service.dart` and ensure the correct backend URL:

```dart
static const String _baseUrl = 'http://localhost:3000/api';
```

For production, update this to your deployed backend URL.

### Step 2: Get Flutter Web Dependencies

```bash
cd cityseva

# Enable web platform
flutter config --enable-web

# Get dependencies
flutter pub get
```

### Step 3: Run Flutter Web Application

```bash
# Development mode with hot reload
flutter run -d chrome

# Or release build
flutter build web --release
```

The web application will open in your default browser at `http://localhost:<port>`

## Project Structure

```
CitySeva/
├── backend/
│   ├── index.js              # Express server setup
│   ├── package.json          # Backend dependencies
│   ├── .env                  # Environment variables (local, not in git)
│   ├── .env.example          # Template for .env
│   ├── models/               # MongoDB models
│   │   ├── User.js
│   │   ├── Complaint.js
│   │   └── Feedback.js
│   └── routes/               # API routes
│       ├── users.js
│       ├── complaints.js
│       └── feedbacks.js
│
└── cityseva/
    ├── lib/
    │   ├── main.dart         # Entry point
    │   ├── models/           # Data models
    │   ├── screens/          # UI screens
    │   ├── providers/        # State management
    │   └── services/
    │       ├── api_service.dart      # ✨ NEW: Backend API client
    │       ├── mongodb_service.dart  # Legacy MongoDB API (for reference)
    │       └── notification_service.dart
    └── web/                  # ✨ NEW: Web platform files
        ├── index.html
        └── manifest.json
```

## Key Services

### ApiService (`lib/services/api_service.dart`) - **NEW**

The primary service for communicating with the backend API. It provides methods for:
- **Users**: `getUser()`, `createOrUpdateUser()`
- **Complaints**: `getAllComplaints()`, `getComplaintsByUserId()`, `createComplaint()`, `updateComplaint()`
- **Feedbacks**: `getAllFeedbacks()`, `createFeedback()`
- **Health**: `healthCheck()`

**Usage Example**:
```dart
// Get user
var user = await ApiService.getUser('user@example.com');

// Create complaint
var complaint = await ApiService.createComplaint({
  'id': 'comp_123',
  'userId': 'user_123',
  'title': 'Road damage',
  'description': 'Large pothole on Main Street',
  'latitude': 40.7128,
  'longitude': -74.0060,
  'department': 1,
  'createdAt': DateTime.now().toString(),
});

// Check backend connection
bool isAvailable = await ApiService.healthCheck();
```

## Running Both Frontend & Backend

### Terminal 1 - Start Backend:
```bash
cd backend
npm start
```

### Terminal 2 - Start Frontend:
```bash
cd cityseva
flutter run -d chrome
```

## Deployment

### Backend Deployment (Heroku, Render, etc.)

1. Set environment variables on your hosting platform:
   - `MONGO_URI`: Your MongoDB connection string
   - `PORT`: Server port (usually auto-assigned)
   - `NODE_ENV`: Set to `production`

2. Deploy:
   ```bash
   # Heroku example
   git push heroku main
   ```

### Frontend Web Deployment (Netlify, GitHub Pages, Firebase, etc.)

1. Build the web app:
   ```bash
   flutter build web --release
   ```

2. Deploy the `build/web` directory to your hosting service

3. Update `ApiService._baseUrl` to point to your deployed backend

## Troubleshooting

### Backend Connection Issues

- **Error: "Cannot find module 'mongoose'"**
  ```bash
  npm install
  ```

- **Error: "MongoDB connection error"**
  - Check `.env` file has correct `MONGO_URI`
  - Verify network access in MongoDB Atlas is enabled
  - Ensure database user credentials are correct

### Flutter Web Issues

- **Error: "Unable to connect to backend"**
  - Ensure backend is running on correct port (3000)
  - Check `ApiService._baseUrl` in code
  - Check browser console for CORS errors

- **Port 3000 already in use**
  ```bash
  # Kill process using port 3000 (Linux/Mac)
  lsof -ti:3000 | xargs kill -9
  
  # For Windows, change PORT in .env
  PORT=3001
  ```

### Web Build Issues

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run -d chrome
```

## Database Models

### User
```json
{
  "id": "user_123",
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "role": "citizen|authority|government",
  "avatarPath": "path/to/avatar.jpg"
}
```

### Complaint
```json
{
  "id": "comp_123",
  "userId": "user_123",
  "title": "Road damage",
  "description": "Large pothole",
  "department": 1,
  "address": "123 Main St",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "imagePaths": [],
  "status": 0,
  "createdAt": "2024-03-28T10:30:00.000Z",
  "statusHistory": []
}
```

### Feedback
```json
{
  "id": "feedback_123",
  "complaintId": "comp_123",
  "userId": "user_123",
  "rating": 4,
  "completedOnTime": true,
  "comment": "Good resolution"
}
```

## Next Steps

1. Update the Flutter screens to use `ApiService` instead of `mongodb_service.dart`
2. Add error handling and loading states in your screens
3. Implement proper authentication (JWT tokens)
4. Add image upload functionality to backend
5. Set up notification service integration
6. Deploy to production

## Support & Documentation

- [Flutter Web Documentation](https://flutter.dev/docs/get-started/web)
- [Express.js Documentation](https://expressjs.com/)
- [MongoDB Atlas Documentation](https://docs.atlas.mongodb.com/)
- [Mongoose Documentation](https://mongoosejs.com/)

---

**Last Updated**: March 28, 2024
