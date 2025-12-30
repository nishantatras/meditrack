# 🔧 Frontend Deployment Fix

## Issue
Error: `Command "npm run build" exited with 1`

## Root Cause
The `api.js` file was using CommonJS `require()` syntax instead of ES6 imports, which causes build failures in React applications.

## Fixes Applied

### 1. Fixed `require()` Usage
**File**: `frontend/src/services/api.js`

**Before:**
```javascript
if (reduxStore) {
  const {logout} = require('../store/slices/authSlice');
  reduxStore.dispatch(logout());
}
```

**After:**
```javascript
import {logout as logoutAction} from '../store/slices/authSlice';

// ... later in code ...
if (reduxStore) {
  reduxStore.dispatch(logoutAction());
}
```

### 2. Updated Vercel Configuration
**File**: `frontend/vercel.json`

Simplified and improved the Vercel configuration to be more explicit about build settings.

## Verification

After these fixes, the build should work. To test locally:

```bash
cd frontend
npm run build
```

The build should complete successfully without errors.

## Common Build Errors & Solutions

### Error: `require is not defined`
- **Cause**: Using CommonJS `require()` in ES6 module
- **Fix**: Replace with ES6 `import` statement

### Error: `Cannot find module`
- **Cause**: Missing dependency or incorrect import path
- **Fix**: Check import paths and run `npm install`

### Error: `Process is not defined`
- **Cause**: Accessing Node.js globals in browser code
- **Fix**: Use `process.env.REACT_APP_*` only (works in build)

### Error: `Unexpected token`
- **Cause**: Syntax error or unsupported JavaScript feature
- **Fix**: Check for typos, ensure Babel is configured correctly

## Environment Variables

Make sure `REACT_APP_API_URL` is set in Vercel:

1. Go to Vercel Dashboard → Your Project → Settings
2. Go to **Environment Variables**
3. Add:
   ```
   REACT_APP_API_URL = https://your-backend.onrender.com/api
   ```
4. Redeploy

## Build Configuration

The `vercel.json` now explicitly specifies:
- **Build Command**: `npm run build`
- **Output Directory**: `build`
- **Install Command**: `npm install`
- **Framework**: `create-react-app`

## Next Steps

1. **Commit the fixes:**
   ```bash
   git add frontend/src/services/api.js frontend/vercel.json
   git commit -m "Fix frontend build: Replace require() with ES6 import"
   git push
   ```

2. **Redeploy on Vercel:**
   - Vercel will automatically detect the push
   - Or manually trigger redeploy from dashboard

3. **Verify Build:**
   - Check Vercel build logs
   - Should see "Build successful"
   - Visit your deployed site

## Testing Locally

Before deploying, test the build locally:

```bash
cd frontend

# Install dependencies (if needed)
npm install

# Run build
npm run build

# If successful, you'll see:
# "The build folder is ready to be deployed."
```

## Still Having Issues?

1. **Check Vercel Build Logs**
   - Go to Vercel Dashboard → Your Project → Deployments
   - Click on the failed deployment
   - Check the build logs for specific errors

2. **Clear Build Cache**
   - In Vercel Dashboard → Settings → General
   - Clear build cache
   - Redeploy

3. **Check Node Version**
   - Vercel should use Node 18+ automatically
   - Can specify in `package.json`:
     ```json
     "engines": {
       "node": ">=18.0.0"
     }
     ```

---

**After these fixes, your frontend should build and deploy successfully! 🚀**


