# Production Credentials Checklist

This checklist helps you gather all necessary credentials for production deployment.

## Required Credentials

### 1. Supabase Production Project

**Status**: [X] Complete (2025-10-05)

**Completed**:
1. âœ… Project created: vanrixxzaawybszeuivb.supabase.co
2. âœ… Region: (configured)
3. âœ… Database password: Stored securely
4. âœ… Credentials copied:
   - âœ… **Project URL**: `https://vanrixxzaawybszeuivb.supabase.co`
   - âœ… **anon/public key**: Configured in .env.production
   - âœ… **service_role key**: Configured in .env.production (KEPT SECRET)
5. âœ… Added to GitHub Secrets: SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY

**Backend Deployment**:
- âœ… Backend deployed to Vercel: https://backend-gv4a2ueuy-dnitzs-projects.vercel.app
- âœ… Supabase connection verified (418ms response time)
- âœ… All environment variables configured

**Remaining**:
- âŒ Link local repo: `supabase link --project-ref vanrixxzaawybszeuivb`
- âŒ Push migrations: `supabase db push --linked`

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

**Status**: [X] Complete (2025-10-05)

**Completed**:
1. âœ… Account created at https://platform.deepseek.com/
2. âœ… API Key created: sk-... (rotate immediately)
3. âœ… Key saved securely
4. âœ… Configured in .env.production
5. âœ… Added to GitHub Secret: DEEPSEEK_API_KEY

**Cost Estimate**: ~$0.001 per interpretation (DeepSeek Chat pricing)
**Current Plan**: (verify rate limits before launch)

### 3. Random.org API Key (Optional - Signed Randomness)

**Status**: [X] Complete (2025-10-05)

**Completed**:
1. âœ… Account created at https://api.random.org/
2. âœ… API Key: 6ea3503a-15f7-4220-a3b9-6c57b30f7b9f
3. âœ… Configured in .env.production
4. âœ… Added to GitHub Secret: RANDOM_ORG_KEY
5. âœ… Quota reviewed: Free tier = 1,000 bits/day (sufficient for ~100 draws/day)

**Note**: Backend uses this for signed randomness; falls back to `crypto.randomInt()` if unavailable.

### 4. Datadog API Key (Optional - Observability)

**Status**: [X] Skipped (using console logging for now)

**Current Configuration**:
- âœ… METRICS_PROVIDER=console in .env.production
- âœ… DATADOG_SITE configured in GitHub Secrets (for future use)
- âšª DATADOG_API_KEY not configured (using console logs only)

**Alternative Chosen**: Using console logging to stdout (cost-free)
**Future**: Can enable Datadog monitoring post-launch if needed

**Cost**: Free trial for 14 days, then paid plans start at $15/host/month.

## Filling .env.production

**Status**: [X] Complete (2025-10-05)

âœ… File exists at: `C:\tarot\smart-divination\backend\.env.production`
âœ… All credentials configured (see above sections)

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

- [X] `.env.production` is in `.gitignore`
- [X] Never commit this file to version control
- [X] Store a backup in secure vault (credentials in GitHub Secrets)
- [X] Use different credentials for development/staging/production
- [X] Rotate `SUPABASE_SERVICE_ROLE_KEY` if exposed (documented in SECRETS.md)
- [ ] Monitor DeepSeek API usage to avoid unexpected costs (TODO: set up alerts)

## Verification

**Status**: [X] VERIFIED âœ… (2025-10-05)

### Production Deployment
Backend is deployed and verified:
```powershell
cd C:\tarot\scripts
.\verify-deployment.ps1 https://backend-gv4a2ueuy-dnitzs-projects.vercel.app
```

**Results** (2025-10-05):
```
=== Test Summary ===
  [PASS] Health Check           â† Supabase healthy (418ms)
  [PASS] Metrics Endpoint        â† Protected (403 expected)
  [PASS] Auth Check              â† Requires authentication (401)
  [PASS] Feature Flags           â† I Ching disabled (503)
  [PASS] Response Time           â† 93ms (< 3s)

Results: 5 passed, 0 warnings, 0 failed
```

### Local Testing (Optional)
```bash
cd C:\tarot\smart-divination\backend
cp .env.production .env.local
npm run dev

# Test endpoints:
# - http://localhost:3001/api/health (should return 200)
# - POST http://localhost:3001/api/draw/cards (with auth token)
```

## Next Steps

1. [X] Complete this checklist âœ… (2025-10-05)
2. [X] Configure GitHub Actions secrets âœ… (13/13 secrets configured)
3. [X] Deploy to Vercel with production env vars âœ… (https://backend-gv4a2ueuy-dnitzs-projects.vercel.app)
4. [ ] Apply Supabase migrations to production database âš ï¸ **NEXT BLOCKER**
5. [ ] QA manual with production environment

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
