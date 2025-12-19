# 🔧 Render Deployment Fix

## Issue
Build failed with "Exited with status 1" on Render.com

## Solution

I've fixed the `render.yaml` file. The main issues were:
1. Missing `rootDir: backend` - Render needs to know the backend is in a subdirectory
2. Database references - Simplified to use manual environment variables instead

## Updated Configuration

The `render.yaml` now:
- ✅ Specifies `rootDir: backend` so Render knows where to build
- ✅ Uses `sync: false` for environment variables (you'll set them manually)
- ✅ Removed automatic database creation (use Supabase instead)

## Steps to Deploy on Render

### Option 1: Manual Setup (Recommended - More Control)

1. **Go to https://render.com**
   - Sign up/login with GitHub
   - Click **New +** → **Web Service**

2. **Connect Repository**
   - Connect your GitHub account if not already
   - Select your MediTrack repository
   - Click **Connect**

3. **Configure Service**
   - **Name**: `meditrack-backend` (or any name)
   - **Region**: Choose closest to you
   - **Branch**: `main` (or your default branch)
   - **Root Directory**: `backend` ⚠️ **IMPORTANT**
   - **Runtime**: `Java`
   - **Build Command**: `mvn clean package -DskipTests`
   - **Start Command**: `java -jar target/*.jar`

4. **Add Environment Variables**
   Click **Advanced** → **Add Environment Variable** and add:

   ```
   SPRING_PROFILES_ACTIVE = prod
   SERVER_PORT = 10000
   DB_URL = jdbc:postgresql://db.xxxxx.supabase.co:5432/postgres
   DB_USERNAME = postgres
   DB_PASSWORD = [YOUR-SUPABASE-PASSWORD]
   JWT_SECRET = [GENERATE-32-CHAR-SECRET]
   FRONTEND_URL = [WILL-UPDATE-AFTER-FRONTEND]
   CORS_ALLOWED_ORIGINS = [WILL-UPDATE-AFTER-FRONTEND]
   ```

   **Optional (can leave empty for now):**
   ```
   REDIS_HOST = 
   REDIS_PORT = 6379
   MAIL_HOST = smtp.gmail.com
   MAIL_USERNAME = 
   MAIL_PASSWORD = 
   TWILIO_ACCOUNT_SID = 
   TWILIO_AUTH_TOKEN = 
   TWILIO_PHONE_NUMBER = 
   ```

5. **Deploy**
   - Click **Create Web Service**
   - Wait for build (5-10 minutes first time)
   - Check build logs if it fails

### Option 2: Using render.yaml (After Manual Setup)

If you want to use the `render.yaml` file:
1. Make sure you've set up the service manually first
2. Then you can use the Blueprint feature
3. But for first deployment, manual setup is recommended

## Common Build Issues & Fixes

### Issue 1: "Root Directory" Error
**Fix**: Make sure **Root Directory** is set to `backend` in Render dashboard

### Issue 2: Maven Build Fails
**Possible causes:**
- Java version mismatch (should be Java 17)
- Missing dependencies
- Network issues downloading dependencies

**Fix**: 
- Check build logs in Render dashboard
- Verify Java 17 is selected
- Try building locally first: `cd backend && mvn clean package -DskipTests`

### Issue 3: Database Connection Fails
**Fix**: 
- Verify Supabase database is running
- Check connection string format
- Ensure database migrations have run
- Test connection string locally

### Issue 4: JAR File Not Found
**Fix**: 
- Check build logs - Maven should create JAR in `target/` directory
- Verify build command: `mvn clean package -DskipTests`
- Check start command: `java -jar target/*.jar`

## Environment Variables Guide

### Required Variables

**Database (Supabase):**
```
DB_URL = jdbc:postgresql://db.xxxxx.supabase.co:5432/postgres
DB_USERNAME = postgres
DB_PASSWORD = [YOUR-PASSWORD]
```

**JWT Secret:**
Generate with:
```bash
openssl rand -base64 32
```
Or use: https://www.allkeysgenerator.com/Random/Security-Encryption-Key-Generator.aspx

**Application:**
```
SPRING_PROFILES_ACTIVE = prod
SERVER_PORT = 10000
```

### Optional Variables (Can be empty)

```
REDIS_HOST = 
REDIS_PORT = 6379
MAIL_HOST = smtp.gmail.com
MAIL_USERNAME = 
MAIL_PASSWORD = 
TWILIO_ACCOUNT_SID = 
TWILIO_AUTH_TOKEN = 
TWILIO_PHONE_NUMBER = 
FRONTEND_URL = 
CORS_ALLOWED_ORIGINS = 
```

## Testing the Deployment

1. **Check Build Logs**
   - Go to your service in Render dashboard
   - Click on the latest deployment
   - View build logs

2. **Test Health Endpoint**
   ```bash
   curl https://your-backend.onrender.com/api/health
   ```
   Should return: `{"status":"UP"}`

3. **Check Service Status**
   - In Render dashboard, service should show "Live"
   - Green status indicator

## Database Connection String Format

**From Supabase:**
```
postgresql://postgres:password@db.xxxxx.supabase.co:5432/postgres
```

**For Spring Boot (JDBC format):**
```
jdbc:postgresql://db.xxxxx.supabase.co:5432/postgres
```

And set separately:
- `DB_USERNAME=postgres`
- `DB_PASSWORD=your-password`

## Quick Checklist

- [ ] Root Directory set to `backend`
- [ ] Build Command: `mvn clean package -DskipTests`
- [ ] Start Command: `java -jar target/*.jar`
- [ ] All required environment variables set
- [ ] Database connection string is correct
- [ ] JWT_SECRET is generated and set
- [ ] Build completes successfully
- [ ] Service shows "Live" status

## Still Having Issues?

1. **Check Build Logs**
   - Go to Render dashboard → Your service → Latest deployment
   - Scroll through build logs
   - Look for error messages

2. **Test Locally First**
   ```bash
   cd backend
   mvn clean package -DskipTests
   java -jar target/*.jar
   ```
   If this works locally, it should work on Render

3. **Common Errors:**
   - **"No such file or directory"** → Check Root Directory
   - **"Maven not found"** → Check Runtime is set to Java
   - **"JAR not found"** → Check build completed successfully
   - **"Port already in use"** → Check SERVER_PORT is 10000

4. **Contact Support**
   - Render has good documentation: https://render.com/docs
   - Check their community forum

---

**After fixing, your backend should deploy successfully! 🚀**

