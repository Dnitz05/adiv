# Vercel Deployment Guide

This guide walks you through deploying the Smart Divination backend to Vercel production.

## Prerequisites

- [X] Vercel account created: https://vercel.com ✅
- [X] `.env.production` filled with all credentials ✅ (2025-10-05)
- [X] Vercel CLI installed: `npm install -g vercel` ✅ (v46.0.1)

## Step 1: Install Vercel CLI

```bash
npm install -g vercel
```

Verify installation:
```bash
vercel --version
```

## Step 2: Login to Vercel

```bash
vercel login
```

This will open a browser to authenticate. Choose your preferred method (GitHub, GitLab, Bitbucket, Email).

## Step 3: Link Project to Vercel

**Status**: [X] Complete ✅ (2025-10-02)

```bash
cd C:\tarot\smart-divination\backend
vercel link
```

**Completed**:
- ✅ Project linked: `backend`
- ✅ Project ID: `prj_1W7dSxmVE6qwzuX4xaqr9EkoCbAC`
- ✅ Org ID: `team_4XuuNZAQVCaHrPaESHalLBde`
- ✅ `.vercel/project.json` created with org/project IDs
- ✅ GitHub Secrets configured: VERCEL_ORG_ID, VERCEL_PROJECT_ID

## Step 4: Configure Environment Variables in Vercel

**Status**: [X] COMPLETE ✅ (2025-10-05)

**Current Status**: All environment variables configured in Vercel production and preview

### Option A: Via Vercel Dashboard (Recommended)

1. Go to https://vercel.com/dashboard
2. Select your project: **smart-divination-backend**
3. Click **Settings** -> **Environment Variables**
4. Add each variable from your `.env.production`:

| Variable Name | Value | Environments |
|--------------|-------|--------------|
| `SUPABASE_URL` | `https://xxxxx.supabase.co` | Production, Preview |
| `SUPABASE_ANON_KEY` | `eyJhbGci...` (full key) | Production, Preview |
| `SUPABASE_SERVICE_ROLE_KEY` | `eyJhbGci...` (full key) | Production only WARNING |
| `DEEPSEEK_API_KEY` | `sk-...` | Production, Preview |
| `RANDOM_ORG_KEY` | Your key or leave empty | Production (optional) |
| `ENABLE_ICHING` | `false` | Production, Preview |
| `ENABLE_RUNES` | `false` | Production, Preview |
| `NODE_ENV` | `production` | Production |
| `METRICS_PROVIDER` | `console` or `datadog` | Production |
| `METRICS_DEBUG` | `false` | Production |

**If using Datadog**:
| Variable Name | Value | Environments |
|--------------|-------|--------------|
| `DATADOG_API_KEY` | Your API key | Production |
| `DATADOG_SITE` | `datadoghq.com` or `.eu` | Production |
| `DATADOG_SERVICE` | `smart-divination-backend` | Production |
| `DATADOG_ENV` | `production` | Production |
| `DATADOG_METRIC_PREFIX` | `smart_divination` | Production |
| `DATADOG_TAGS` | `env:production,service:backend` | Production |
| `DATADOG_TIMEOUT_MS` | `2000` | Production |

**Important**:
- Select **Production** for production-only secrets (like `SUPABASE_SERVICE_ROLE_KEY`)
- Select **Production, Preview** for variables safe for preview deployments
- Never expose `SERVICE_ROLE_KEY` in preview environments if untrusted

### Option B: Via CLI

```bash
cd C:\tarot\smart-divination\backend

# Add each variable
vercel env add SUPABASE_URL production
# Paste value when prompted

vercel env add SUPABASE_ANON_KEY production
# Paste value

vercel env add SUPABASE_SERVICE_ROLE_KEY production
# Paste value

vercel env add DEEPSEEK_API_KEY production
# Paste value

# Continue for all variables...
```

## Step 5: Configure Build Settings

Vercel should auto-detect Next.js. Verify settings in Dashboard:

1. Go to **Settings** -> **General**
2. **Framework Preset**: Next.js
3. **Build Command**: `npm run build` (or leave default)
4. **Output Directory**: `.next` (default)
5. **Install Command**: `npm ci` (or leave default)
6. **Node.js Version**: 18.x or 20.x

## Step 6: Deploy to Production

**Status**: [X] DEPLOYED ✅ (2025-10-05)

**Current Status**:
- ✅ Backend deployed to production
- ✅ Environment variables configured
- ✅ Production URL: `https://backend-dnitzs-projects.vercel.app`
- ✅ All health checks passing (5/5 tests)

**Deployment completed**:

```bash
cd C:\tarot\smart-divination\backend
vercel --prod
```

This will:
1. Build your application
2. Upload to Vercel
3. Deploy to production URL
4. Output the production URL (e.g., `https://smart-divination.vercel.app`)

**Expected output**:
```
Vercel CLI 46.x.x
(search)  Inspect: https://vercel.com/...
[done]  Production: https://smart-divination.vercel.app [1m]
```

### Subsequent Deployments

For future deployments, simply run:
```bash
vercel --prod
```

Or push to your main branch if you've configured Git integration (see Step 8).

## Step 7: Verify Deployment

**Status**: [X] VERIFIED ✅ (2025-10-05)

Use the automated verification script:

```powershell
cd C:\tarot\scripts
.\verify-deployment.ps1 https://backend-dnitzs-projects.vercel.app
```

**Test results** (2025-10-05):
```
=== Test Summary ===
  [PASS] Health Check           ← Supabase healthy (418ms response)
  [PASS] Metrics Endpoint        ← 403 protected (expected)
  [PASS] Auth Check              ← 401 unauthorized (expected)
  [PASS] Feature Flags           ← 503 I Ching disabled (expected)
  [PASS] Response Time           ← 93ms (< 3s)

Results: 5 passed, 0 warnings, 0 failed
```

### Manual Tests

#### Health Check
```bash
curl https://backend-dnitzs-projects.vercel.app/api/health
```

**Response** (200 OK):
```json
{
  "success": true,
  "data": {
    "status": "degraded",
    "services": [
      {
        "name": "supabase",
        "status": "healthy",
        "responseTime": 418,
        "lastCheck": "2025-10-05T18:09:15.244Z"
      },
      {
        "name": "random_org",
        "status": "degraded",
        "responseTime": 396
      }
    ]
  }
}
```

#### Metrics Endpoint (Protected)
```bash
curl https://backend-dnitzs-projects.vercel.app/api/metrics
```

**Response** (403 Forbidden - expected, endpoint protected):
```json
{
  "error": {
    "code": "FORBIDDEN",
    "message": "Metrics endpoint is protected"
  }
}
```

#### Draw Endpoint (Auth Required)
```bash
curl -X POST https://backend-dnitzs-projects.vercel.app/api/draw/cards \
  -H "Content-Type: application/json" \
  -d '{"spread": "three_card", "question": "Test"}'
```

**Response** (401 Unauthorized - expected):
```json
{
  "error": {
    "code": "UNAUTHENTICATED",
    "message": "Authentication required."
  }
}
```

## Step 8: Configure Git Integration (Optional but Recommended)

Automate deployments on every push:

1. Go to **Settings** -> **Git**
2. **Connect Git Repository**
3. Select your GitHub repository
4. Configure:
   - **Production Branch**: `main` or `master`
   - **Auto-deploy**: [done] Enabled
   - **Preview Deployments**: [done] Enabled for pull requests

Now every push to `main` triggers a production deployment automatically.

## Step 9: Configure Custom Domain (Optional)

1. Go to **Settings** -> **Domains**
2. Add your domain: `api.smartdivination.com`
3. Follow DNS configuration instructions (add A/CNAME records)
4. Wait for DNS propagation (~5-60 minutes)
5. Update Flutter apps to use custom domain

## Step 10: Configure Deployment Protection (Recommended)

1. Go to **Settings** -> **Deployment Protection**
2. Enable **Vercel Authentication** for production
3. Add trusted IP addresses if needed
4. Consider enabling **Vercel Password Protection** for preview deployments

## Monitoring & Logs

### View Logs
1. Go to your project dashboard
2. Click on a deployment
3. Click **Functions** tab
4. Select a function -> View logs in real-time

### View Analytics
1. Go to **Analytics** tab
2. Monitor:
   - Request counts
   - Response times
   - Error rates
   - Geographic distribution

### Set Up Alerts (Optional)
1. Integrate with Datadog, Sentry, or other monitoring tools
2. Configure webhooks for deployment notifications
3. Set up uptime monitoring (e.g., UptimeRobot, Pingdom)

## Troubleshooting

### Build Fails

**Check logs**:
```bash
vercel logs [deployment-url] --follow
```

**Common issues**:
- Missing dependencies: Run `npm ci` locally first
- TypeScript errors: Run `npm run type-check`
- Environment variables not set: Check Vercel dashboard

### 500 Internal Server Error

**Check function logs** in Vercel dashboard under Functions tab.

**Common causes**:
- Missing environment variables
- Supabase connection issues
- DeepSeek API errors

### Cold Start Latency

Vercel functions have cold starts (~1-3 seconds). To mitigate:
- Use Vercel Pro plan for faster cold starts
- Implement API response caching
- Consider warming functions with cron jobs

### Rate Limits

Vercel Free plan limits:
- 100 GB bandwidth/month
- 100 hours compute time/month
- 12 serverless function invocations/second

Monitor usage in dashboard. Upgrade to Pro if needed.

## Rollback a Deployment

If a deployment has issues:

1. Go to **Deployments** tab
2. Find previous working deployment
3. Click **...** -> **Promote to Production**

Or via CLI:
```bash
vercel rollback [deployment-url]
```

## Security Checklist

- [done] Environment variables configured (no secrets in code)
- [done] `SUPABASE_SERVICE_ROLE_KEY` only in production environment
- [done] HTTPS enforced (automatic with Vercel)
- [done] CORS configured properly in API routes
- [done] Rate limiting implemented (see backend middleware)
- [done] Git integration enabled for audit trail

## Cost Estimate

**Free Tier** (Hobby):
- 100 GB bandwidth
- 100 hours compute time
- Sufficient for small-scale beta testing

**Pro Plan** ($20/month):
- 1 TB bandwidth
- Unlimited compute time
- Faster cold starts
- Team collaboration
- Recommended for production launch

**Enterprise** (custom pricing):
- Dedicated infrastructure
- Advanced security features
- SLA guarantees

## Next Steps

**Current Progress**:
1. [X] Vercel CLI installed ✅ (2025-10-02)
2. [X] Project linked ✅ (2025-10-02)
3. [X] .env.production configured locally ✅ (2025-10-05)
4. [X] Add environment variables to Vercel Dashboard ✅ (2025-10-05)
5. [X] Deploy backend: `vercel --prod` ✅ (2025-10-05)
6. [X] Verify endpoints: /api/health, /api/metrics ✅ (2025-10-05)
7. [ ] Create VERCEL_TOKEN for GitHub Actions auto-deploy ⚠️ (optional)
8. [ ] Configure Git integration for auto-deploy on push ⚠️ (optional)
9. [ ] Update Flutter app with production URL ⚠️
10. [ ] QA manual testing ⚠️

**Production URL**: https://backend-dnitzs-projects.vercel.app

**Verification**: Run `.\scripts\verify-deployment.ps1 https://backend-dnitzs-projects.vercel.app`

## References

- [Vercel Documentation](https://vercel.com/docs)
- [Next.js on Vercel](https://vercel.com/docs/frameworks/nextjs)
- [Environment Variables](https://vercel.com/docs/concepts/projects/environment-variables)
- [CLI Reference](https://vercel.com/docs/cli)
