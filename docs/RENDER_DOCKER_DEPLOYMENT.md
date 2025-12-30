# 🐳 Docker Deployment on Render

This guide explains how to deploy the MediTrack application using Docker on Render.

## Architecture

The application consists of:

- **Backend**: Spring Boot application (Java 17)
- **Frontend**: React application (Node.js 18)
- **Database**: PostgreSQL
- **Cache**: Redis

## Prerequisites

1. **Render Account**: Sign up at https://render.com
2. **GitHub Repository**: Your code should be on GitHub
3. **Environment Variables**: Prepare all required environment variables

## Deployment Steps

### Option 1: Using Render Blueprint (Recommended)

1. **Connect Repository to Render**

   - Go to https://dashboard.render.com
   - Click **New +** → **Blueprint**
   - Connect your GitHub repository
   - Select the repository containing this code

2. **Render will automatically detect `render.yaml`**

   - It will create all services defined in the blueprint
   - Backend (Docker)
   - Frontend (Docker)
   - PostgreSQL Database
   - Redis Cache

3. **Configure Environment Variables**

   - After services are created, go to each service's Settings
   - Add the required environment variables (see below)

4. **Deploy**
   - Render will automatically deploy when you push to the main branch
   - Or manually trigger deployment from the dashboard

### Option 2: Manual Service Creation

#### Step 1: Deploy Backend

1. **Create Web Service**

   - Go to Render Dashboard
   - Click **New +** → **Web Service**
   - Connect your GitHub repository

2. **Configure Backend Service**

   - **Name**: `meditrack-backend`
   - **Region**: Choose closest region
   - **Branch**: `main`
   - **Root Directory**: Leave empty (Dockerfile is in backend/)
   - **Runtime**: `Docker`
   - **Dockerfile Path**: `backend/Dockerfile`
   - **Docker Context**: `backend`

3. **Environment Variables** (Add in Settings → Environment):

   ```
   SPRING_PROFILES_ACTIVE=prod
   SERVER_PORT=10000
   DB_URL=jdbc:postgresql://[DB_HOST]:5432/meditrack
   DB_USERNAME=meditrack_user
   DB_PASSWORD=[YOUR_DB_PASSWORD]
   JWT_SECRET=[GENERATE_32_CHAR_SECRET]
   REDIS_HOST=[REDIS_HOST]
   REDIS_PORT=6379
   MAIL_HOST=smtp.gmail.com
   MAIL_USERNAME=[YOUR_EMAIL]
   MAIL_PASSWORD=[YOUR_APP_PASSWORD]
   TWILIO_ACCOUNT_SID=[YOUR_TWILIO_SID]
   TWILIO_AUTH_TOKEN=[YOUR_TWILIO_TOKEN]
   TWILIO_PHONE_NUMBER=[YOUR_TWILIO_NUMBER]
   FRONTEND_URL=https://meditrack-frontend.onrender.com
   CORS_ALLOWED_ORIGINS=https://meditrack-frontend.onrender.com
   ```

4. **Deploy**
   - Click **Create Web Service**
   - Wait for build and deployment

#### Step 2: Create PostgreSQL Database

1. **Create Database**

   - Click **New +** → **PostgreSQL**
   - **Name**: `meditrack-db`
   - **Database Name**: `meditrack`
   - **User**: `meditrack_user`
   - **Plan**: Starter (or higher)

2. **Get Connection Details**
   - After creation, go to Database → **Connections**
   - Copy the **Internal Database URL**
   - Use this for `DB_URL` in backend environment variables

#### Step 3: Create Redis Cache

1. **Create Redis**

   - Click **New +** → **Redis**
   - **Name**: `meditrack-redis`
   - **Plan**: Starter (or higher)

2. **Get Connection Details**
   - After creation, copy the **Internal Redis URL**
   - Use the hostname for `REDIS_HOST` in backend

#### Step 4: Deploy Frontend

1. **Create Web Service**

   - Click **New +** → **Web Service**
   - Connect your GitHub repository

2. **Configure Frontend Service**

   - **Name**: `meditrack-frontend`
   - **Region**: Same as backend
   - **Branch**: `main`
   - **Root Directory**: Leave empty
   - **Runtime**: `Docker`
   - **Dockerfile Path**: `frontend/Dockerfile`
   - **Docker Context**: `frontend`

3. **Environment Variables**:

   ```
   REACT_APP_API_URL=https://meditrack-backend.onrender.com/api
   ```

4. **Deploy**
   - Click \*\*Create Web Service`
   - Wait for build and deployment

## Environment Variables Reference

### Backend Environment Variables

| Variable                 | Description                | Example                                   |
| ------------------------ | -------------------------- | ----------------------------------------- |
| `SPRING_PROFILES_ACTIVE` | Spring profile             | `prod`                                    |
| `SERVER_PORT`            | Server port                | `10000`                                   |
| `DB_URL`                 | PostgreSQL connection URL  | `jdbc:postgresql://host:5432/meditrack`   |
| `DB_USERNAME`            | Database username          | `meditrack_user`                          |
| `DB_PASSWORD`            | Database password          | `your_password`                           |
| `JWT_SECRET`             | JWT secret key (32+ chars) | Generate random string                    |
| `REDIS_HOST`             | Redis hostname             | `meditrack-redis.onrender.com`            |
| `REDIS_PORT`             | Redis port                 | `6379`                                    |
| `MAIL_HOST`              | SMTP host                  | `smtp.gmail.com`                          |
| `MAIL_USERNAME`          | Email username             | `your-email@gmail.com`                    |
| `MAIL_PASSWORD`          | Email app password         | `your-app-password`                       |
| `TWILIO_ACCOUNT_SID`     | Twilio account SID         | Your Twilio SID                           |
| `TWILIO_AUTH_TOKEN`      | Twilio auth token          | Your Twilio token                         |
| `TWILIO_PHONE_NUMBER`    | Twilio phone number        | `+1234567890`                             |
| `FRONTEND_URL`           | Frontend URL               | `https://meditrack-frontend.onrender.com` |
| `CORS_ALLOWED_ORIGINS`   | CORS allowed origins       | `https://meditrack-frontend.onrender.com` |

### Frontend Environment Variables

| Variable            | Description     | Example                                      |
| ------------------- | --------------- | -------------------------------------------- |
| `REACT_APP_API_URL` | Backend API URL | `https://meditrack-backend.onrender.com/api` |

## Database Setup

After the database is created:

1. **Flyway will automatically run migrations** on first backend startup
2. **Dummy data will be inserted** via migration `V4__insert_dummy_data.sql`
3. **Test user**: `user@example.com` / `password123`

## Service URLs

After deployment, your services will be available at:

- **Backend**: `https://meditrack-backend.onrender.com`
- **Frontend**: `https://meditrack-frontend.onrender.com`
- **API Health Check**: `https://meditrack-backend.onrender.com/api/health`

## Health Checks

Both services include health check endpoints:

- **Backend**: `/api/health`
- **Frontend**: `/health`

Render will automatically monitor these endpoints.

## Troubleshooting

### Backend Issues

1. **Build Fails**

   - Check Dockerfile syntax
   - Verify Java version (17)
   - Check Maven dependencies

2. **Application Won't Start**

   - Check environment variables
   - Verify database connection
   - Check logs in Render dashboard

3. **Database Connection Errors**
   - Use **Internal Database URL** (not external)
   - Verify database is running
   - Check credentials

### Frontend Issues

1. **Build Fails**

   - Check Node.js version (18)
   - Verify all dependencies in package.json
   - Check for build errors in logs

2. **API Connection Errors**
   - Verify `REACT_APP_API_URL` is set correctly
   - Check CORS settings in backend
   - Ensure backend is running

### Common Issues

1. **Port Configuration**

   - Render sets `PORT` environment variable
   - Backend uses `SERVER_PORT` (defaults to 10000)
   - Frontend uses port 80 (nginx)

2. **Environment Variables Not Working**

   - Variables are set at build time for React
   - Must rebuild after changing `REACT_APP_*` variables
   - Backend variables can be changed without rebuild

3. **CORS Errors**
   - Verify `CORS_ALLOWED_ORIGINS` includes frontend URL
   - Check `FRONTEND_URL` matches actual frontend URL
   - Ensure no trailing slashes

## Updating Deployment

### Automatic Deployments

- Push to `main` branch triggers automatic deployment
- Render monitors GitHub for changes

### Manual Deployments

1. Go to service dashboard
2. Click **Manual Deploy**
3. Select commit to deploy

## Monitoring

- **Logs**: Available in each service's dashboard
- **Metrics**: CPU, Memory, Network usage
- **Health Checks**: Automatic monitoring of health endpoints

## Cost Estimation

- **Starter Plan**: $7/month per service
- **Backend**: $7/month
- **Frontend**: $7/month
- **PostgreSQL**: $7/month
- **Redis**: $7/month
- **Total**: ~$28/month

## Next Steps

1. **Set up custom domains** (optional)
2. **Configure SSL** (automatic with Render)
3. **Set up monitoring alerts**
4. **Configure backups** for database
5. **Set up CI/CD** (already configured via GitHub)

## Support

- **Render Docs**: https://render.com/docs
- **Docker Docs**: https://docs.docker.com
- **Application Logs**: Available in Render dashboard

---

**Your application is now deployed! 🚀**
