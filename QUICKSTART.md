# CitySeva Quick Start Guide

## 🚀 Quick Setup (5 minutes)

### Prerequisites
- Flutter SDK (v3.0+)
- Node.js (v16+)
- MongoDB Atlas account

### Backend Setup
```bash
# 1. Navigate to backend
cd backend

# 2. Install dependencies
npm install

# 3. Create .env file (copy from .env.example and add your MongoDB URI)
cp .env.example .env

# 4. Start server
npm start
# Output: Connected to MongoDB, Server running on port 3000
```

### Frontend Setup
```bash
# 1. Navigate to frontend
cd cityseva

# 2. Get dependencies
flutter pub get

# 3. Run on web
flutter run -d chrome
```

✅ **Done!** App should open in browser at `http://localhost:<port>`

---

## 📱 Available Platforms

- ✅ **Web** (Flutter Web)
- ✅ **Android** (requires Android SDK)
- ✅ **iOS** (requires macOS & Xcode)

To enable/run on different platforms:
```bash
# Check available devices
flutter devices

# Run on specific platform
flutter run -d chrome      # Web
flutter run -d android     # Android
flutter run -d ios         # iOS
```

---

## 🗄️ Database

**MongoDB Atlas** - Cloud-hosted MongoDB (free tier available)

- **Connection String Format**: `mongodb+srv://username:password@cluster.mongodb.net/cityseva`
- **Database Name**: `cityseva`
- **Collections**: Users, Complaints, Feedbacks
- **Status**: Auto-creates collections on first write

---

## 🔗 API Endpoints

**Base URL**: `http://localhost:3000/api`

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/users/:email` | GET | Get user by email |
| `/users` | POST | Create/update user |
| `/complaints` | GET | Get all complaints |
| `/complaints/user/:userId` | GET | Get user's complaints |
| `/complaints` | POST | Create complaint |
| `/complaints/:id` | PUT | Update complaint |
| `/feedbacks` | GET | Get all feedbacks |
| `/feedbacks` | POST | Create feedback |

---

## 🎯 Common Tasks

### Change Backend URL
Edit `lib/services/api_service.dart`:
```dart
static const String _baseUrl = 'http://your-backend-url:3000/api';
```

### Change Backend Port
Edit `backend/.env`:
```
PORT=3001
```

### Deploy Backend
```bash
# Heroku (example)
heroku login
git push heroku main
```

### Build Web for Production
```bash
flutter build web --release
# Output in: build/web/
```

---

## 🐛 Troubleshooting

| Error | Solution |
|-------|----------|
| "Cannot find module 'mongoose'" | Run `npm install` in backend |
| "MongoDB connection error" | Check `.env` MONGO_URI |
| "Port 3000 already in use" | Change PORT in `.env` or kill existing process |
| "CORS error in browser" | Ensure backend is running and URL is correct |
| "Flutter not found" | Install Flutter SDK and add to PATH |

---

## 📚 Full Documentation

See [SETUP.md](./SETUP.md) for complete setup and deployment guide.

---

## 🤝 Project Structure

```
cityseva/
├── lib/
│   ├── main.dart
│   ├── models/           # Data models
│   ├── screens/          # UI screens
│   ├── providers/        # State management (Provider)
│   └── services/
│       ├── api_service.dart      # ✨ Backend API client
│       └── notification_service.dart
└── web/                  # ✨ Web platform files

backend/
├── index.js              # Express server
├── models/               # MongoDB schemas
├── routes/               # API routes
├── .env                  # Config (local only)
└── .env.example          # Config template
```

---

**Last Updated**: March 28, 2024
