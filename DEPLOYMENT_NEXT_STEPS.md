# 🚀 Deployment Next Steps - Action Required

Your code is now prepared for deployment! Here's what to do next:

## ✅ What's Been Done

1. ✅ Git repository initialized
2. ✅ All code committed
3. ✅ Deployment configuration files created
4. ✅ Helper scripts created

## 📋 Step-by-Step Deployment

### Step 1: Push to GitHub (Required)

**Option A: Create New Repository on GitHub**
1. Go to https://github.com/new
2. Create a new repository (e.g., "MediTrack")
3. **DO NOT** initialize with README, .gitignore, or license
4. Copy the repository URL

**Option B: Use Existing Repository**
- If you already have a GitHub repository, use that URL

**Then run:**
```bash
# Add your GitHub repository as remote
git remote add origin https://github.com/YOUR_USERNAME/MediTrack.git

# Push your code
git branch -M main
git push -u origin main
```

**Or use the helper script:**
```bash
./setup-github.sh
```

---

### Step 2: Set Up Database (Supabase) - 5 minutes

1. **Go to https://supabase.com**
   - Sign up for free account
   - Click "New Project"
   - Enter project name and database password
   - Select a region close to you
   - Click "Create new project"
   - Wait 2-3 minutes for setup

2. **Get Database Connection String**
   - Go to **Settings** → **Database**
   - Scroll to "Connection string"
   - Select "URI" tab
   - Copy the connection string
   - Format: `postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres`

3. **Run Database Migrations**
   - Go to **SQL Editor** in Supabase dashboard
   - Click "New query"
   - Copy and paste contents of `backend/src/main/resources/db/migration/V1__create_tables.sql`
   - Click "Run" (or press Cmd/Ctrl + Enter)
   - Repeat for:
     - `V2__fix_user_roles_enum.sql`
     - `V3__fix_reminder_enums.sql`

4. **Convert Connection String to JDBC Format**
   - Supabase gives: `postgresql://postgres:password@host:5432/postgres`
   - JDBC needs: `jdbc:postgresql://host:5432/postgres?user=postgres&password=password`
   - Or use: `jdbc:postgresql://host:5432/postgres` with separate username/password

---

### Step 3: Deploy Backend (Render) - 5 minutes

1. **Go to https://render.com**
   - Sign up/login with GitHub
   - Click "New +" → "Web Service"
   - Connect your GitHub account if not already
   - Select your repository
   - Click "Connect"

2. **Configure Service**
   - **Name**: `meditrack-backend` (or any name)
   - **Region**: Choose closest to you
   - **Branch**: `main`
   - **Root Directory**: `backend`
   - **Runtime**: `Java`
   - **Build Command**: `mvn clean package -DskipTests`
   - **Start Command**: `java -jar target/*.jar`

3. **Add Environment Variables**
   Click "Advanced" → "Add Environment Variable" and add:

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

   **Generate JWT Secret:**
   ```bash
   openssl rand -base64 32
   ```
   Or use: https://www.allkeysgenerator.com/Random/Security-Encryption-Key-Generator.aspx

4. **Deploy**
   - Click "Create Web Service"
   - Wait for build (5-10 minutes first time)
   - Copy the service URL (e.g., `https://meditrack-backend.onrender.com`)

5. **Test Backend**
   ```bash
   curl https://your-backend.onrender.com/api/health
   ```

---

### Step 4: Deploy Frontend (Vercel) - 3 minutes

1. **Go to https://vercel.com**
   - Sign up/login with GitHub
   - Click "Add New Project"
   - Import your GitHub repository
   - Select repository and click "Import"

2. **Configure Project**
   - **Framework Preset**: Create React App
   - **Root Directory**: `frontend`
   - **Build Command**: `npm run build` (auto-detected)
   - **Output Directory**: `build` (auto-detected)

3. **Add Environment Variable**
   - Go to "Environment Variables"
   - Add:
     ```
     REACT_APP_API_URL = https://your-backend.onrender.com/api
     ```
   - Replace `your-backend.onrender.com` with your actual backend URL

4. **Deploy**
   - Click "Deploy"
   - Wait for build (2-3 minutes)
   - Copy the frontend URL (e.g., `https://meditrack.vercel.app`)

---

### Step 5: Update Backend CORS - 2 minutes

1. **Go back to Render dashboard**
2. **Edit your backend service**
3. **Update Environment Variables:**
   ```
   FRONTEND_URL = https://your-frontend.vercel.app
   CORS_ALLOWED_ORIGINS = https://your-frontend.vercel.app
   ```
4. **Save and redeploy** (or it will auto-redeploy)

---

### Step 6: Test Your Deployment ✅

1. **Visit your frontend URL**
2. **Try to register a new user**
3. **Check browser console** for any errors
4. **Test login**
5. **Test creating a family member**
6. **Test adding medications**

---

## 🔑 Important Notes

### JWT Secret Generation
```bash
# On Mac/Linux
openssl rand -base64 32

# Or use online generator
# https://www.allkeysgenerator.com/Random/Security-Encryption-Key-Generator.aspx
```

### Database Connection String Format

**Supabase gives you:**
```
postgresql://postgres:password@db.xxxxx.supabase.co:5432/postgres
```

**For JDBC (Spring Boot), use:**
```
jdbc:postgresql://db.xxxxx.supabase.co:5432/postgres
```

And set separately:
- `DB_USERNAME=postgres`
- `DB_PASSWORD=your-password`

### Free Tier Limitations

- **Render**: Free tier sleeps after 15 minutes of inactivity (first request will be slow)
- **Vercel**: Unlimited deployments, 100GB bandwidth/month
- **Supabase**: 500MB database, 2GB bandwidth

---

## 🆘 Troubleshooting

### Backend won't start?
- Check all environment variables are set
- Check database connection string format
- View logs in Render dashboard

### Frontend can't connect to backend?
- Check `REACT_APP_API_URL` is correct
- Check CORS settings in backend
- Check browser console for errors

### Database connection fails?
- Verify Supabase project is active
- Check connection string format
- Ensure migrations ran successfully

---

## 📞 Quick Reference

**Your URLs will be:**
- Frontend: `https://your-project.vercel.app`
- Backend: `https://your-backend.onrender.com`
- Database: Managed by Supabase

**Environment Variables Needed:**

**Backend (Render):**
- `SPRING_PROFILES_ACTIVE=prod`
- `SERVER_PORT=10000`
- `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`
- `JWT_SECRET`
- `FRONTEND_URL`
- `CORS_ALLOWED_ORIGINS`

**Frontend (Vercel):**
- `REACT_APP_API_URL`

---

## ✅ Checklist

- [ ] Code pushed to GitHub
- [ ] Supabase database created
- [ ] Database migrations run
- [ ] Backend deployed to Render
- [ ] Backend environment variables set
- [ ] Frontend deployed to Vercel
- [ ] Frontend environment variable set
- [ ] Backend CORS updated
- [ ] Application tested

---

**You're all set! Follow the steps above to deploy your application! 🚀**

For more details, see:
- [QUICK_DEPLOY.md](./QUICK_DEPLOY.md) - Quick 5-minute guide
- [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) - Complete detailed guide
- [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md) - Step-by-step checklist

