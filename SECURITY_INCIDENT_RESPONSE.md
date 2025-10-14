# Security incident response - secret exposure

Date: 2025-10-05
Incident: production API keys were committed to the repository during deployment scripting
Status: **CLOSED** - All secrets rotated on 2025-10-06

---

## Summary
- Files affected (cleaned on 2025-10-05): scripts/vercel/setup_env_vars.ps1 and several documentation pages
- Secrets exposed: Supabase URL / anon key / service role key, DeepSeek API key, Random.org API key
- Exposure window: roughly 2 hours in a private repository
- Resolution: All secrets successfully rotated on 2025-10-06

All offending files were sanitised and all exposed credentials have been rotated. New keys are in production.

---

## Immediate actions completed
- Removed hardcoded secrets from scripts and docs
- Updated setup scripts to read values from environment variables only
- Added warnings about manual secret handling in helper scripts
- Logged this incident for follow-up

## Resolution actions completed (2025-10-06)
1. ✅ **Rotated Supabase keys** (anon and service role)
2. ✅ **Rotated DeepSeek API key**
3. ✅ **Rotated Random.org API key**
4. ✅ Updated `.env.production`, GitHub Secrets, and Vercel environment variables with the new values
5. ✅ Redeployed backend (`vercel --prod`) and verified with `scripts/verify-deployment.ps1`
6. ✅ Confirmed Supabase access via health checks and the admin dashboard

All secrets have been successfully rotated and verified.

| Secret                     | Rotated on | Owner |
|---------------------------|------------|-------|
| SUPABASE_ANON_KEY         | 2025-10-06 | Automated rotation |
| SUPABASE_SERVICE_ROLE_KEY | 2025-10-06 | Automated rotation |
| DEEPSEEK_API_KEY          | 2025-10-06 | Automated rotation |
| RANDOM_ORG_KEY            | 2025-10-06 | Automated rotation |

---

## Rotation procedures (reference)

### Supabase
1. Dashboard > Settings > API > Reset anon key
2. Dashboard > Settings > API > Reset service_role key
3. Update `.env.production`, GitHub Secrets, and Vercel env vars
4. Redeploy backend and confirm `scripts/verify-deployment.ps1` passes

### DeepSeek
1. https://platform.deepseek.com/ > API Keys > Revoke old key, create new key
2. Update `.env.production`, GitHub Secrets, and Vercel env vars
3. Redeploy backend and run a test interpretation

### Random.org
1. https://api.random.org/dashboard > API Keys > Generate new key
2. Update `.env.production`, GitHub Secrets, and Vercel env vars
3. Redeploy backend and confirm fallback behaviour

---

## Prevention
- Add pre-commit secret scanning (e.g. git-secrets or detect-secrets)
- Use a secrets manager (1Password CLI, AWS Secrets Manager, etc.) instead of copying values into scripts
- Document a regular rotation cadence (quarterly minimum)
- Review automation scripts before committing

---

## Timeline
| Time         | Event                                  |
|--------------|----------------------------------------|
| 2025-10-05 18:00 | Deployment automation completed    |
| 2025-10-05 18:10 | Secrets committed to repository    |
| 2025-10-05 20:00 | Issue detected                     |
| 2025-10-05 20:15 | Scripts and docs sanitised         |
| 2025-10-05 20:45 | Incident recorded, rotation pending |
| 2025-10-06       | All secrets rotated and verified   |
| 2025-10-06       | Backend redeployed with new keys   |
| 2025-10-06       | Health checks confirmed successful |

**INCIDENT CLOSED** - All exposed credentials have been rotated and are now secure.
