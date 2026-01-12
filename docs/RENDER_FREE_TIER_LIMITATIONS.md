# 🆓 Render Free Tier - Important Limitations

## Overview

Your application is now configured to use Render's **free tier**. This is great for testing and development, but there are important limitations you should be aware of.

## Free Tier Limitations

### Web Services (Backend & Frontend)

✅ **What's Included:**

- Custom domains
- Managed TLS certificates
- Service previews
- Log streams
- Rollbacks (2 most recent deploys)

⚠️ **Limitations:**

1. **Idle Spin-Down**: Services automatically spin down after **15 minutes of inactivity**

   - First request after spin-down takes **up to 1 minute** to wake up
   - This is normal and expected on free tier
   - Consider using a service like UptimeRobot to ping your services periodically

2. **Monthly Usage Limit**: **750 free instance hours per month**

   - If exceeded, all free services are suspended until next month
   - Two services = ~375 hours each per month (~15 days of 24/7 uptime)
   - Monitor usage in Render dashboard

3. **No Scaling**: Single instance only
4. **No Persistent Disks**: Data not persisted between restarts
5. **No Shell Access**: Can't SSH into containers
6. **Traffic Limits**: High outbound traffic may cause suspension

### PostgreSQL Database

✅ **What's Included:**

- 1 GB storage
- Full PostgreSQL functionality

⚠️ **Critical Limitations:**

1. **30-Day Expiration**: Database expires **30 days after creation**

   - ⚠️ **Data will be deleted after 30 days**
   - You have a **14-day grace period** to upgrade to paid plan
   - After grace period, data is permanently deleted

2. **No Backups**: Data can be lost
3. **Single Instance**: Only one free database per workspace
4. **Maintenance**: May restart or undergo maintenance at any time

### Redis Cache

✅ **What's Included:**

- Full Redis functionality

⚠️ **Limitations:**

1. **Ephemeral Storage**: **Data is lost on restart**

   - Not suitable for critical data
   - Use only for caching/session storage

2. **No Backups**: Data can be lost
3. **Single Instance**: Only one free Redis per workspace
4. **Maintenance**: May restart at any time

## Recommendations

### For Production Use

If you need:

- ✅ 24/7 uptime (no spin-down)
- ✅ Data persistence
- ✅ Backups
- ✅ Reliable performance

**Consider upgrading to paid plans:**

- **Starter Plan**: $7/month per service
- **PostgreSQL**: $7/month (with backups)
- **Redis**: $7/month (with persistence)

### For Development/Testing

Free tier is perfect for:

- ✅ Learning and experimentation
- ✅ Personal projects
- ✅ Testing deployments
- ✅ Development environments

## Mitigation Strategies

### 1. Prevent Service Spin-Down

Use a free uptime monitoring service to ping your services:

- **UptimeRobot** (https://uptimerobot.com) - Free tier: 50 monitors
- **Pingdom** - Free tier available
- **StatusCake** - Free tier available

Set up monitors to ping:

- `https://meditrack-backend.onrender.com/api/health` (every 5-10 minutes)
- `https://meditrack-frontend.onrender.com/health` (every 5-10 minutes)

### 2. Monitor Database Expiration

- ⚠️ **Set a calendar reminder** for 25 days after database creation
- Export data regularly if needed
- Consider upgrading before expiration

### 3. Handle Redis Data Loss

- Don't store critical data in Redis
- Use Redis only for:
  - Session storage (can be regenerated)
  - Cache (can be rebuilt)
  - Temporary data

### 4. Monitor Usage

- Check Render dashboard regularly
- Monitor instance hours usage
- Stay within 750 hours/month limit

## Cost Comparison

### Free Tier (Current)

- **Cost**: $0/month
- **Limitations**: Spin-down, expiration, no backups

### Paid Tier (Recommended for Production)

- **Backend**: $7/month
- **Frontend**: $7/month
- **PostgreSQL**: $7/month
- **Redis**: $7/month
- **Total**: ~$28/month
- **Benefits**: 24/7 uptime, backups, persistence, support

## Migration Path

If you need to upgrade later:

1. **Go to Render Dashboard**
2. **Select Service** → **Settings** → **Plan**
3. **Upgrade to Starter** ($7/month)
4. **Database**: Upgrade before 30-day expiration
5. **Redis**: Upgrade if you need persistent data

## Important Notes

⚠️ **Database Expiration Warning:**

- Your PostgreSQL database will expire 30 days after creation
- Export your data before expiration if you want to keep it
- Upgrade to paid plan to keep data permanently

⚠️ **Service Spin-Down:**

- First request after 15 minutes of inactivity will be slow
- This is normal on free tier
- Use uptime monitoring to keep services awake

⚠️ **Monthly Limits:**

- Monitor your usage in Render dashboard
- Two services = ~375 hours each per month
- Plan accordingly

## Support

- **Render Docs**: https://render.com/docs
- **Free Tier Info**: https://render.com/free
- **Community**: Render Discord/Forums

---

**Your application is configured for free tier deployment! 🎉**

Remember to:

1. ✅ Set up uptime monitoring to prevent spin-down
2. ✅ Monitor database expiration date
3. ✅ Export data regularly if needed
4. ✅ Consider upgrading for production use
