# ⚡ Quick Fix for Render Docker Error

## The Problem
Render is trying to use Docker instead of Java build.

## The Fix (2 minutes)

### Step 1: Update Render Service Settings

1. Go to https://dashboard.render.com
2. Click on your `meditrack-backend` service
3. Click **Settings** tab

4. **IMPORTANT - Change these settings:**

   **Runtime:**
   - Make sure it says `Java` (NOT Docker)
   - If you see Docker, change it to Java

   **Root Directory:**
   - Set to: `backend`

   **Build Command:**
   - Set to: `mvn clean package -DskipTests`

   **Start Command:**
   - Set to: `java -jar target/*.jar`

5. **Scroll down to Environment Variables** and make sure these are set:
   ```
   SPRING_PROFILES_ACTIVE = prod
   SERVER_PORT = 10000
   DB_URL = jdbc:postgresql://[YOUR-SUPABASE-HOST]:5432/postgres
   DB_USERNAME = postgres
   DB_PASSWORD = [YOUR-PASSWORD]
   JWT_SECRET = [YOUR-32-CHAR-SECRET]
   ```

6. **Click "Save Changes"**

### Step 2: Redeploy

1. Go to **Manual Deploy** tab
2. Click **Deploy latest commit**
3. Wait for build (should show Maven build, not Docker)

### Step 3: Verify

Check build logs - you should see:
```
==> Building...
==> Installing dependencies with Maven
==> Building application...
```

**NOT:**
```
==> Building Docker image...
==> Looking for Dockerfile...
```

## If It Still Tries Docker

1. **Delete the service** (Settings → Delete Service)
2. **Create new Web Service**
3. **When creating, explicitly select:**
   - Runtime: `Java`
   - Root Directory: `backend`
   - Build Command: `mvn clean package -DskipTests`
   - Start Command: `java -jar target/*.jar`

## Also Fixed

- ✅ Updated `frontend/.env` - Added `/api` to backend URL
- ✅ Created `render.yaml` at root (tells Render to use Java)
- ✅ Created `.dockerignore` at root (ignores Docker)

---

**This should fix it! The key is making sure Runtime = Java, not Docker. 🚀**

