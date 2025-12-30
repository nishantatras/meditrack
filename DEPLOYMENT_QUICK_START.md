# 🚀 Quick Start: Deploy to Render with Docker

## Prerequisites

- GitHub repository with your code
- Render account (https://render.com)

## Step 1: Push Code to GitHub

```bash
cd /Users/nishantatras/Desktop/Meditrack
git add .
git commit -m "Add Docker configuration for Render deployment"
git push origin main
```

## Step 2: Deploy Using Render Blueprint

1. **Go to Render Dashboard**

   - Visit https://dashboard.render.com
   - Sign in or create account

2. **Create Blueprint**

   - Click **New +** → **Blueprint**
   - Connect your GitHub account (if not already)
   - Select your repository: `nishantatras/Meditrack` (or your repo name)
   - Click **Apply**

3. **Render will create 4 services:**
   - ✅ Backend (Docker)
   - ✅ Frontend (Docker)
   - ✅ PostgreSQL Database
   - ✅ Redis Cache

## Step 3: Configure Environment Variables

After services are created, configure each service:

### Backend Service

Go to `meditrack-backend` → **Settings** → **Environment Variables**

Add these variables:

```
SPRING_PROFILES_ACTIVE=prod
SERVER_PORT=10000
DB_URL=<Use Internal Database URL from database service>
DB_USERNAME=<From database service>
DB_PASSWORD=<From database service>
JWT_SECRET=<Generate a random 32+ character string>
REDIS_HOST=<Use Internal Redis URL from redis service>
REDIS_PORT=6379
MAIL_HOST=smtp.gmail.com
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
TWILIO_ACCOUNT_SID=your-twilio-sid
TWILIO_AUTH_TOKEN=your-twilio-token
TWILIO_PHONE_NUMBER=+1234567890
FRONTEND_URL=https://meditrack-frontend.onrender.com
CORS_ALLOWED_ORIGINS=https://meditrack-frontend.onrender.com
```

**To get Database URL:**

- Go to `meditrack-db` service
- Click **Connections** tab
- Copy **Internal Database URL**
- Use it for `DB_URL`

**To get Redis Host:**

- Go to `meditrack-redis` service
- Copy the hostname from **Internal Redis URL**
- Use it for `REDIS_HOST`

### Frontend Service

Go to `meditrack-frontend` → **Settings** → **Environment Variables**

Add:

```
REACT_APP_API_URL=https://meditrack-backend.onrender.com/api
```

**Important:** Replace `meditrack-backend` with your actual backend service name if different.

## Step 4: Deploy

1. **Backend will deploy automatically** after environment variables are set
2. **Frontend will deploy automatically** after environment variables are set
3. Wait for both to show "Live" status

## Step 5: Verify Deployment

1. **Check Backend Health:**

   ```
   https://meditrack-backend.onrender.com/api/health
   ```

   Should return: `{"status":"UP"}` or similar

2. **Check Frontend:**

   ```
   https://meditrack-frontend.onrender.com
   ```

   Should show your React app

3. **Test Login:**
   - Email: `user@example.com`
   - Password: `password123`
   - (Dummy data is inserted automatically)

## Troubleshooting

### Backend won't start

- Check environment variables are set correctly
- Verify database connection (use Internal URL)
- Check logs in Render dashboard

### Frontend shows API errors

- Verify `REACT_APP_API_URL` is correct
- Check CORS settings in backend
- Ensure backend is running

### Database connection fails

- Use **Internal Database URL** (not external)
- Verify database service is running
- Check credentials match

## Service URLs

After deployment:

- **Backend**: `https://meditrack-backend.onrender.com`
- **Frontend**: `https://meditrack-frontend.onrender.com`
- **API**: `https://meditrack-backend.onrender.com/api`

## Next Steps

1. ✅ Set up custom domain (optional)
2. ✅ Configure email/SMS (if needed)
3. ✅ Set up monitoring alerts
4. ✅ Configure database backups

## Files Created

- ✅ `backend/Dockerfile` - Backend Docker configuration
- ✅ `frontend/Dockerfile` - Frontend Docker configuration
- ✅ `frontend/nginx.conf` - Nginx configuration for React
- ✅ `render.yaml` - Render Blueprint configuration
- ✅ `.dockerignore` - Docker ignore rules
- ✅ Updated `application.yml` - Supports Render's PORT variable

---

**Your app is now ready to deploy! 🎉**

For detailed documentation, see `docs/RENDER_DOCKER_DEPLOYMENT.md`
