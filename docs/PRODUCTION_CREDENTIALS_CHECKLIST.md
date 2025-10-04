# Production Credentials Checklist

This checklist helps you gather all necessary credentials for production deployment.

## Required Credentials

### 1. Supabase Production Project

**Status**: [ ] Not Started | [ ] In Progress | [ ] Complete

**Steps**:
1. Go to https://supabase.com/dashboard
2. Create a new project (or use existing):
   - **Name**: smart-divination-production
   - **Database Password**: Generate strong password (save securely!)
   - **Region**: Choose closest to your users (e.g., eu-west-1 for Europe)
3. Wait for project initialization (~2 minutes)
4. Go to **Settings** -> **API**
5. Copy these values:
   - [ ] **Project URL**: `https://xxxxx.supabase.co`
   - [ ] **anon/public key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
   - [ ] **service_role key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` WARNING: KEEP SECRET

**Apply Database Schema**:
```bash
# Set Supabase project reference
cd C:\tarot\supabase
supabase link --project-ref YOUR_PROJECT_ID

# Push migrations
supabase db push

# Or manually via SQL Editor:
# 1. Copy content of supabase/migrations/20250101000001_initial_schema.sql
# 2. Paste in Supabase SQL Editor and run
# 3. Copy content of supabase/migrations/20250922090000_session_history_schema.sql
# 4. Paste and run
```

### 2. DeepSeek API Key (AI Interpretations)

**Status**: [ ] Not Started | [ ] In Progress | [ ] Complete

**Steps**:
1. Go to https://platform.deepseek.com/
2. Sign up / Log in
3. Navigate to **API Keys**
4. Click **Create API Key**
5. Give it a name: "Smart Divination Production"
6. Copy the key: `sk-...` WARNING: SAVE IMMEDIATELY (shown only once)
7. Check rate limits for your plan (free tier may be insufficient for production)

**Cost Estimate**: ~$0.001 per interpretation (DeepSeek Chat pricing)

### 3. Random.org API Key (Optional - Signed Randomness)

**Status**: [ ] Not Started | [ ] In Progress | [ ] Complete | [ ] Skip (Optional)

**Steps**:
1. Go to https://api.random.org/dashboard
2. Sign up for a free account
3. Navigate to **API Keys**
4. Note your API key
5. Review quota: Free tier = 1,000 bits/day (sufficient for ~100 draws/day)

**Note**: If not configured, backend falls back to `crypto.randomInt()` (secure but not signed).

### 4. Datadog API Key (Optional - Observability)

**Status**: [ ] Not Started | [ ] In Progress | [ ] Complete | [ ] Skip (Optional)

**Steps**:
1. Go to https://app.datadoghq.com/ (or datadoghq.eu for Europe)
2. Sign up for free trial or paid plan
3. Navigate to **Integrations** -> **APIs**
4. Copy **API Key**
5. Note your **Datadog Site**: `datadoghq.com` or `datadoghq.eu`

**Cost**: Free trial for 14 days, then paid plans start at $15/host/month.

**Alternative**: Set `METRICS_PROVIDER=console` to log metrics to stdout only.

## Filling .env.production

Once you have the credentials, fill them in:

```bash
cd C:\tarot\smart-divination\backend
# Edit .env.production with a text editor
```

**Template**:
```bash
# Supabase Configuration (REQUIRED)
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# DeepSeek AI (REQUIRED for interpretations)
DEEPSEEK_API_KEY=sk-...

# Random.org (OPTIONAL - signed randomness)
RANDOM_ORG_KEY=

# Feature Flags (REQUIRED)
ENABLE_ICHING=false
ENABLE_RUNES=false

# Metrics & Observability (OPTIONAL)
METRICS_PROVIDER=console
METRICS_DEBUG=false
DATADOG_API_KEY=
DATADOG_SITE=datadoghq.com
DATADOG_SERVICE=smart-divination-backend
DATADOG_ENV=production
DATADOG_METRIC_PREFIX=smart_divination
DATADOG_TAGS=env:production,service:backend
DATADOG_TIMEOUT_MS=2000

# API Configuration
NODE_ENV=production
```

## Security Checklist

- [ ] `.env.production` is in `.gitignore`
- [ ] Never commit this file to version control
- [ ] Store a backup in secure vault (1Password, Bitwarden, etc.)
- [ ] Use different credentials for development/staging/production
- [ ] Rotate `SUPABASE_SERVICE_ROLE_KEY` if exposed
- [ ] Monitor DeepSeek API usage to avoid unexpected costs

## Verification

After filling `.env.production`, test locally:

```bash
cd C:\tarot\smart-divination\backend
cp .env.production .env.local
npm run dev

# Test endpoints:
# - http://localhost:3001/api/health (should return 200)
# - POST http://localhost:3001/api/draw/cards (with auth token)
```

If health check passes, you're ready to deploy to Vercel.

## Next Steps

1. [ ] Complete this checklist
2. -> Task 3: Configure GitHub Actions secrets
3. -> Task 4: Deploy to Vercel with production env vars
4. -> Task 5: QA manual with production environment

## Troubleshooting

### Supabase Connection Errors
- Verify project URL is correct (no trailing slash)
- Check that keys are copied completely (very long strings)
- Ensure database migrations have been applied
- Test connection: `npx supabase status`

### DeepSeek API Errors
- Verify key starts with `sk-`
- Check rate limits haven't been exceeded
- Review API documentation: https://platform.deepseek.com/docs

### Environment Not Loading
- Ensure file is named exactly `.env.production` (not `.env.production.txt`)
- Verify no extra spaces around `=` signs
- Check file is in `smart-divination/backend/` directory
