# 🔧 Render Environment Variables Configuration Guide

This guide explains all environment variables needed for deploying Meditrack on Render.

---

## 📋 Table of Contents

1. [Backend Service Environment Variables](#backend-service-environment-variables)
2. [Frontend Service Environment Variables](#frontend-service-environment-variables)
3. [Auto-Generated Variables](#auto-generated-variables)
4. [How to Set Environment Variables](#how-to-set-environment-variables)
5. [Example Values](#example-values)

---

## 🔙 Backend Service Environment Variables

### Required Variables

#### 1. **SPRING_PROFILES_ACTIVE**

- **Description**: Spring Boot profile to activate
- **Value**: `prod`
- **Purpose**: Enables production configuration
- **Example**: `prod`

#### 2. **SERVER_PORT**

- **Description**: Port for the Spring Boot application (fallback)
- **Value**: `10000`
- **Purpose**: Used if `PORT` (set by Render) is not available
- **Note**: Render automatically sets `PORT` in Docker containers, but this is a fallback
- **Example**: `10000`

#### 3. **DB_URL** ⚠️ **REQUIRED**

- **Description**: PostgreSQL database connection URL
- **Format**: Either JDBC format (`jdbc:postgresql://...`) or standard PostgreSQL format (`postgresql://...`)
- **Purpose**: Database connection string
- **How to get**: After creating the database in Render, go to **Database** → **Connections** → Copy **Internal Database URL**
- **Example (JDBC format)**: `jdbc:postgresql://dpg-xxxxx-a.oregon-postgres.render.com:5432/meditrack`
- **Example (PostgreSQL format)**: `postgresql://demo_user:password@dpg-xxxxx-a.oregon-postgres.render.com/meditrack`
- **⚠️ Important**:
  - Use **Internal Database URL** (not External) for better performance
  - ✅ **Automatic Conversion**: The application automatically converts Render's standard PostgreSQL format to JDBC format
  - You can use either format - both will work automatically
  - If using PostgreSQL format (`postgresql://...`), the username and password are extracted automatically
  - If `DB_USERNAME` and `DB_PASSWORD` are not set separately, they will be extracted from the connection string

#### 4. **DB_USERNAME** ⚠️ **REQUIRED**

- **Description**: PostgreSQL database username
- **How to get**: From Render database dashboard or connection string
- **Example**: `meditrack_user` or `postgres`

#### 5. **DB_PASSWORD** ⚠️ **REQUIRED**

- **Description**: PostgreSQL database password
- **How to get**: From Render database dashboard (click "Show" to reveal)
- **Example**: `your-secure-password-here`
- **⚠️ Security**: Never commit this to git!

#### 6. **JWT_SECRET** ⚠️ **REQUIRED**

- **Description**: Secret key for signing JWT tokens (minimum 32 characters)
- **Purpose**: Used to sign and verify authentication tokens
- **How to generate**:

  ```bash
  # Linux/Mac
  openssl rand -base64 32

  # Or use online generator
  # https://www.allkeysgenerator.com/Random/Security-Encryption-Key-Generator.aspx
  ```

- **Example**: `aB3dE5fG7hI9jK1lM3nO5pQ7rS9tU1vW3xY5zA7bC9dE1fG3hI5jK7lM9nO1pQ3`
- **⚠️ Security**: Must be at least 32 characters. Never commit to git!

#### 7. **REDIS_HOST** ⚠️ **REQUIRED**

- **Description**: Redis server hostname
- **How to get**: After creating Redis service, go to **Redis** → **Connections** → Copy **Internal Redis URL**
- **Format**: Extract hostname from connection string
- **Example**: `meditrack-redis.oregon-redis.render.com` or `redis-xxxxx.oregon-redis.render.com`
- **Note**: Use **Internal Redis URL** (not External) for better performance

#### 8. **REDIS_PORT**

- **Description**: Redis server port
- **Value**: `6379` (default Redis port)
- **Example**: `6379`

#### 9. **REDIS_PASSWORD** (Optional)

- **Description**: Redis password (if authentication is enabled)
- **Default**: Empty (no password)
- **Note**: Render free tier Redis typically doesn't require a password
- **Example**: Leave empty or set if your Redis instance requires it

#### 10. **FRONTEND_URL** ⚠️ **REQUIRED**

- **Description**: Full URL of the frontend application
- **Purpose**: Used for email links, redirects, and OTP verification links
- **Format**: `https://your-frontend.onrender.com`
- **Example**: `https://meditrack-frontend.onrender.com`
- **⚠️ Important**: Set this **after** deploying the frontend service

#### 11. **CORS_ALLOWED_ORIGINS** ⚠️ **REQUIRED**

- **Description**: Comma-separated list of allowed frontend origins for CORS
- **Purpose**: Allows frontend to make API requests
- **Format**: `https://frontend-url-1,https://frontend-url-2`
- **Example**: `https://meditrack-frontend.onrender.com`
- **⚠️ Important**:
  - Set this **after** deploying the frontend service
  - Must match the frontend URL exactly (including `https://`)
  - Can include multiple origins separated by commas

### Optional Variables (Email & SMS)

#### 12. **MAIL_HOST** (Optional)

- **Description**: SMTP server hostname for sending emails
- **Default**: `smtp.gmail.com`
- **Purpose**: Email notifications (password reset, OTP, etc.)
- **Example**: `smtp.gmail.com` or `smtp.sendgrid.net`

#### 13. **MAIL_PORT** (Optional)

- **Description**: SMTP server port
- **Default**: `587`
- **Example**: `587` (TLS) or `465` (SSL)

#### 14. **MAIL_USERNAME** (Optional)

- **Description**: SMTP username (usually your email address)
- **Example**: `your-email@gmail.com`

#### 15. **MAIL_PASSWORD** (Optional)

- **Description**: SMTP password or app-specific password
- **Example**: `your-app-password`
- **⚠️ Security**: Never commit to git!

#### 16. **TWILIO_ACCOUNT_SID** (Optional)

- **Description**: Twilio account SID for SMS notifications
- **Purpose**: SMS reminders and OTP verification
- **Example**: `ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

#### 17. **TWILIO_AUTH_TOKEN** (Optional)

- **Description**: Twilio authentication token
- **Example**: `your-twilio-auth-token`
- **⚠️ Security**: Never commit to git!

#### 18. **TWILIO_PHONE_NUMBER** (Optional)

- **Description**: Twilio phone number for sending SMS
- **Format**: E.164 format (e.g., +1234567890)
- **Example**: `+1234567890`

#### 19. **JWT_EXPIRATION** (Optional)

- **Description**: JWT token expiration time in milliseconds
- **Default**: `86400000` (24 hours)
- **Example**: `86400000` (24 hours) or `3600000` (1 hour)

#### 20. **OTP_EXPIRATION_MINUTES** (Optional)

- **Description**: OTP expiration time in minutes
- **Default**: `10`
- **Example**: `10`

---

## 🎨 Frontend Service Environment Variables

### Required Variables

#### 1. **REACT_APP_API_URL** ⚠️ **REQUIRED**

- **Description**: Base URL for the backend API
- **Format**: `https://your-backend.onrender.com/api`
- **Purpose**: Frontend uses this to make API calls
- **Example**: `https://meditrack-backend.onrender.com/api`
- **⚠️ Important**:
  - Must include `/api` at the end
  - Must use `https://` (not `http://`)
  - Set this **after** deploying the backend service

---

## 🔄 Auto-Generated Variables

Render automatically sets these variables - **DO NOT** set them manually:

### Backend Service

- **PORT**: Automatically set by Render (usually `10000` for Docker)
  - Your Spring Boot app should use: `server.port: ${PORT:${SERVER_PORT:8081}}`
  - This ensures it works with Render's port assignment

### Database Service

Render automatically provides these (if using `sync: false` in `render.yaml`, you need to set them manually):

- **DB_URL**: Internal database connection URL
- **DB_USERNAME**: Database username
- **DB_PASSWORD**: Database password

**Note**: In `render.yaml`, we use `sync: false` for database variables, which means you need to set them manually in the Render dashboard.

### Redis Service

Render automatically provides:

- **REDIS_HOST**: Internal Redis hostname
- **REDIS_PORT**: Redis port (usually `6379`)

**Note**: In `render.yaml`, we use `sync: false` for `REDIS_HOST`, which means you need to set it manually.

---

## 📝 How to Set Environment Variables

### Method 1: Using Render Dashboard (Recommended)

1. **Go to Render Dashboard**: https://dashboard.render.com
2. **Select your service** (e.g., `meditrack-backend`)
3. **Go to**: **Environment** tab
4. **Click**: **Add Environment Variable**
5. **Enter**:
   - **Key**: Variable name (e.g., `DB_URL`)
   - **Value**: Variable value (e.g., `jdbc:postgresql://...`)
6. **Click**: **Save Changes**
7. **Redeploy**: Render will automatically redeploy with new variables

### Method 2: Using `render.yaml` (Blueprint)

The `render.yaml` file already defines environment variables with `sync: false`, which means:

- Variables are **declared** in the Blueprint
- But **values must be set manually** in the dashboard
- This is more secure (secrets aren't in git)

**To use `sync: true`** (not recommended for secrets):

```yaml
envVars:
  - key: DB_URL
    sync: true # Syncs from database service automatically
```

---

## 💡 Example Values

### Backend Service - Complete Example

```bash
# Spring Boot Configuration
SPRING_PROFILES_ACTIVE=prod
SERVER_PORT=10000

# Database (from Render PostgreSQL service)
DB_URL=jdbc:postgresql://dpg-xxxxx-a.oregon-postgres.render.com:5432/meditrack
DB_USERNAME=meditrack_user
DB_PASSWORD=your-secure-password-here

# JWT
JWT_SECRET=aB3dE5fG7hI9jK1lM3nO5pQ7rS9tU1vW3xY5zA7bC9dE1fG3hI5jK7lM9nO1pQ3
JWT_EXPIRATION=86400000

# Redis (from Render Redis service)
REDIS_HOST=meditrack-redis.oregon-redis.render.com
REDIS_PORT=6379
REDIS_PASSWORD=

# Frontend URLs (set after frontend deployment)
FRONTEND_URL=https://meditrack-frontend.onrender.com
CORS_ALLOWED_ORIGINS=https://meditrack-frontend.onrender.com

# Email (Optional - for email notifications)
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password

# Twilio (Optional - for SMS notifications)
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your-twilio-auth-token
TWILIO_PHONE_NUMBER=+1234567890

# OTP (Optional)
OTP_EXPIRATION_MINUTES=10
```

### Frontend Service - Complete Example

```bash
# Backend API URL (set after backend deployment)
REACT_APP_API_URL=https://meditrack-backend.onrender.com/api
```

---

## 🔐 Security Best Practices

1. **Never commit secrets to git**

   - Use `sync: false` in `render.yaml` for sensitive variables
   - Set secrets only in Render dashboard

2. **Use strong JWT secrets**

   - Minimum 32 characters
   - Use cryptographically secure random generators
   - Example: `openssl rand -base64 32`

3. **Use Internal URLs**

   - Use **Internal Database URL** (not External) for `DB_URL`
   - Use **Internal Redis URL** (not External) for `REDIS_HOST`
   - Internal URLs are faster and more secure (not exposed to internet)

4. **Rotate secrets regularly**
   - Change `JWT_SECRET` periodically
   - Update database passwords if compromised

---

## 📋 Deployment Checklist

### Step 1: Deploy Database

- [ ] Create PostgreSQL database in Render
- [ ] Copy **Internal Database URL**
- [ ] Extract `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`

### Step 2: Deploy Redis

- [ ] Create Redis service in Render
- [ ] Copy **Internal Redis URL**
- [ ] Extract `REDIS_HOST`

### Step 3: Deploy Backend

- [ ] Set `SPRING_PROFILES_ACTIVE=prod`
- [ ] Set `SERVER_PORT=10000`
- [ ] Set `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`
- [ ] Generate and set `JWT_SECRET`
- [ ] Set `REDIS_HOST`, `REDIS_PORT`
- [ ] Set `FRONTEND_URL` (placeholder: `https://meditrack-frontend.onrender.com`)
- [ ] Set `CORS_ALLOWED_ORIGINS` (placeholder: `https://meditrack-frontend.onrender.com`)
- [ ] (Optional) Set email/SMS variables
- [ ] Deploy and copy backend URL

### Step 4: Deploy Frontend

- [ ] Set `REACT_APP_API_URL=https://your-backend.onrender.com/api`
- [ ] Deploy and copy frontend URL

### Step 5: Update Backend CORS

- [ ] Update `FRONTEND_URL` with actual frontend URL
- [ ] Update `CORS_ALLOWED_ORIGINS` with actual frontend URL
- [ ] Redeploy backend

---

## 🆘 Troubleshooting

### Backend won't start?

1. **Check all required variables are set**:

   - `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`
   - `JWT_SECRET`
   - `REDIS_HOST`

2. **Check database connection string format**:

   - ✅ Both formats are supported:
     - JDBC format: `jdbc:postgresql://host:port/db`
     - PostgreSQL format: `postgresql://user:pass@host:port/db` (automatically converted)
   - If conversion fails, check the logs for conversion errors

3. **Check logs in Render dashboard**:
   - Go to **Logs** tab
   - Look for connection errors

### Frontend can't connect to backend?

1. **Check `REACT_APP_API_URL`**:

   - Must include `/api` at the end
   - Must use `https://` (not `http://`)

2. **Check CORS configuration**:

   - `CORS_ALLOWED_ORIGINS` must match frontend URL exactly
   - Include `https://` prefix

3. **Check browser console**:
   - Look for CORS errors
   - Check network tab for failed requests

### Database connection fails?

1. **Use Internal Database URL** (not External)
2. **Check connection string format** (JDBC format)
3. **Verify database is running** in Render dashboard
4. **Check firewall/network settings**

---

## 📚 Additional Resources

- [Render Environment Variables Documentation](https://render.com/docs/environment-variables)
- [Render Blueprint Specification](https://render.com/docs/blueprint-spec)
- [Spring Boot Externalized Configuration](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config)

---

## ✅ Quick Reference

### Minimum Required Variables (Backend)

```bash
SPRING_PROFILES_ACTIVE=prod
SERVER_PORT=10000
DB_URL=jdbc:postgresql://...
DB_USERNAME=...
DB_PASSWORD=...
JWT_SECRET=...
REDIS_HOST=...
REDIS_PORT=6379
FRONTEND_URL=https://...
CORS_ALLOWED_ORIGINS=https://...
```

### Minimum Required Variables (Frontend)

```bash
REACT_APP_API_URL=https://.../api
```

---

**Last Updated**: Based on current `render.yaml` configuration
