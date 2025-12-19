# 🔧 Vercel Deployment Fix

## Issue
Error: `Environment Variable "REACT_APP_API_URL" references Secret "api_url", which does not exist.`

## Solution

The `vercel.json` file was referencing a Vercel secret that doesn't exist. I've fixed it by removing the secret reference. Now you need to set the environment variable directly in Vercel dashboard.

## Steps to Fix

### Option 1: Set Environment Variable in Vercel Dashboard (Recommended)

1. **Go to your Vercel project dashboard**
   - Visit https://vercel.com/dashboard
   - Click on your MediTrack project

2. **Navigate to Settings**
   - Click on **Settings** tab
   - Click on **Environment Variables** in the left sidebar

3. **Add Environment Variable**
   - Click **Add New**
   - **Key**: `REACT_APP_API_URL`
   - **Value**: `https://your-backend.onrender.com/api`
     - Replace `your-backend.onrender.com` with your actual backend URL
   - **Environment**: Select all (Production, Preview, Development)
   - Click **Save**

4. **Redeploy**
   - Go to **Deployments** tab
   - Click the three dots (⋯) on your latest deployment
   - Click **Redeploy**
   - Or push a new commit to trigger automatic redeploy

### Option 2: Use Vercel CLI

```bash
# Install Vercel CLI (if not installed)
npm i -g vercel

# Login to Vercel
vercel login

# Link your project
cd frontend
vercel link

# Set environment variable
vercel env add REACT_APP_API_URL

# When prompted, enter your backend URL:
# https://your-backend.onrender.com/api

# Redeploy
vercel --prod
```

### Option 3: Set During Project Creation

If you're creating a new project:

1. When importing your GitHub repository
2. In the **Environment Variables** section
3. Add:
   - **Key**: `REACT_APP_API_URL`
   - **Value**: `https://your-backend.onrender.com/api`

## Verify It's Working

1. After redeploying, visit your Vercel URL
2. Open browser DevTools (F12)
3. Go to **Console** tab
4. Check for any API connection errors
5. Try to register/login - it should connect to your backend

## Common Backend URLs

- **Render**: `https://your-app.onrender.com/api`
- **Railway**: `https://your-app.up.railway.app/api`
- **Custom domain**: `https://api.yourdomain.com/api`

## Important Notes

- Environment variables starting with `REACT_APP_` are embedded at build time
- You must **redeploy** after adding/changing environment variables
- The variable is case-sensitive: `REACT_APP_API_URL` (not `react_app_api_url`)
- Make sure your backend URL includes `/api` at the end

## Troubleshooting

### Still getting errors?

1. **Check environment variable is set:**
   - Go to Vercel Dashboard → Settings → Environment Variables
   - Verify `REACT_APP_API_URL` exists

2. **Check the value:**
   - Make sure it's your full backend URL with `/api`
   - Example: `https://meditrack-backend.onrender.com/api`

3. **Redeploy:**
   - Environment variables are only applied on new builds
   - You must redeploy after adding/changing them

4. **Check build logs:**
   - Go to Deployments → Click on your deployment
   - Check the build logs for any errors

5. **Test backend URL:**
   ```bash
   curl https://your-backend.onrender.com/api/health
   ```
   Should return a response (even if it's an error, it means backend is reachable)

## Quick Fix Summary

✅ **Fixed**: Removed secret reference from `vercel.json`  
✅ **Action Required**: Add `REACT_APP_API_URL` in Vercel dashboard  
✅ **Then**: Redeploy your project  

---

**After fixing, your deployment should work! 🚀**

