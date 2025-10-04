# Secrets Management Guide

This document details all secrets required for CI/CD pipelines, deployment, and production operation of the Smart Divination platform.

## Security Principles

1. **Never commit secrets to git** - Use `.gitignore` to exclude all files containing secrets
2. **Rotate secrets regularly** - Especially after team member changes or suspected exposure
3. **Use least privilege** - Grant minimal permissions necessary for each secret
4. **Store securely** - Use encrypted secret management (GitHub Secrets, Vercel env vars, 1Password, etc.)

## GitHub Actions Secrets

Configure these secrets in GitHub repository settings -> Secrets and variables -> Actions.

### Android Signing (Required for APK/AAB builds)

| Secret Name | Description | How to Generate |
|------------|-------------|-----------------|
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded keystore file | `base64 -w 0 apps/tarot/android/app/upload-keystore.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password | From `apps/tarot/android/key.properties` (storePassword) |
| `ANDROID_KEY_ALIAS` | Key alias name | From `key.properties` (keyAlias) |
| `ANDROID_KEY_PASSWORD` | Key password | From `key.properties` (keyPassword) |

**Use project-specific credentials:** generate a unique keystore password, alias, and storage path for every production environment. Store them securely and avoid reusing sample values.

**Rotation procedure:**
```bash
# Generate new keystore
cd apps/tarot/android/app
keytool -genkey -v -keystore upload-keystore-new.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias smart-tarot-upload-v2 \
  -storepass "NEW_PASSWORD" -keypass "NEW_PASSWORD"

# Update key.properties with new values
# Re-encode for GitHub: base64 -w 0 upload-keystore-new.jks
# Update GitHub secrets
# Test CI build before removing old keystore
```

### iOS Signing (Required for IPA builds)

| Secret Name | Description | How to Generate |
|------------|-------------|-----------------|
| `IOS_CERTIFICATE_BASE64` | Base64-encoded P12 certificate | Export from Keychain -> `base64 -w 0 certificate.p12` |
| `IOS_CERTIFICATE_PASSWORD` | Certificate password | Set during P12 export |
| `IOS_PROVISIONING_PROFILE_BASE64` | Base64-encoded provisioning profile | Download from Apple -> `base64 -w 0 profile.mobileprovision` |
| `APP_STORE_CONNECT_KEY_ID` | App Store Connect API key ID | Create at appstoreconnect.apple.com/access/api |
| `APP_STORE_CONNECT_ISSUER_ID` | API key issuer ID | From App Store Connect API keys page |
| `APP_STORE_CONNECT_KEY_BASE64` | Base64-encoded P8 key file | `base64 -w 0 AuthKey_XXXXXX.p8` |

**Setup procedure:**
1. Create App ID at developer.apple.com
2. Generate Distribution Certificate
3. Create Provisioning Profile (App Store distribution)
4. Generate App Store Connect API key
5. Download all artifacts and base64 encode for GitHub

**Rotation procedure:**
- Certificates: Annual renewal required by Apple
- API keys: Rotate if exposed, revoke old keys in App Store Connect

### Backend Deployment (Vercel)

| Secret Name | Description | How to Generate |
|------------|-------------|-----------------|
| `VERCEL_TOKEN` | Vercel deployment token | vercel.com -> Settings -> Tokens -> Create |
| `VERCEL_ORG_ID` | Vercel organization ID | From `.vercel/project.json` after linking |
| `VERCEL_PROJECT_ID` | Vercel project ID | From `.vercel/project.json` |

**Setup:**
```bash
cd smart-divination/backend
vercel link
# Creates .vercel/project.json with IDs
```

### Database & Backend Services

| Secret Name | Description | How to Generate |
|------------|-------------|-----------------|
| `SUPABASE_URL` | Supabase project URL | From Supabase dashboard -> Settings -> API |
| `SUPABASE_ANON_KEY` | Public anonymous key | Supabase -> Settings -> API -> anon key |
| `SUPABASE_SERVICE_ROLE_KEY` | Service role key (admin) | Supabase -> Settings -> API -> service_role key |
| `DEEPSEEK_API_KEY` | DeepSeek AI API key | platform.deepseek.com -> API Keys |
| `RANDOM_ORG_KEY` | Random.org signed API key | random.org -> Sign up -> API Keys (optional) |

**Security notes:**
- `SUPABASE_SERVICE_ROLE_KEY` bypasses RLS - use only in trusted environments
- DeepSeek key has rate limits - monitor usage
- Random.org key is optional - falls back to `crypto.randomInt()` if missing

### Observability (Optional)

| Secret Name | Description | How to Generate |
|------------|-------------|-----------------|
| `DATADOG_API_KEY` | Datadog metrics API key | app.datadoghq.com -> Integrations -> API |
| `DATADOG_SITE` | Datadog site (e.g., datadoghq.com) | Based on account region |

## Vercel Environment Variables

Configure in Vercel dashboard -> Project -> Settings -> Environment Variables.

### Production Environment

All environment variables from `.env.production.example`:

```bash
# Required
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=eyJhbG...
SUPABASE_SERVICE_ROLE_KEY=eyJhbG...
DEEPSEEK_API_KEY=sk-...

# Feature flags
ENABLE_ICHING=false
ENABLE_RUNES=false

# Optional
RANDOM_ORG_KEY=...
METRICS_PROVIDER=datadog
DATADOG_API_KEY=...
DATADOG_SITE=datadoghq.com
DATADOG_SERVICE=smart-divination-backend
DATADOG_ENV=production
```

### Preview/Development Environments

Use separate Supabase projects for preview deployments to avoid polluting production data:

```bash
SUPABASE_URL=https://preview-project-id.supabase.co
SUPABASE_ANON_KEY=... # Preview project keys
SUPABASE_SERVICE_ROLE_KEY=...
DEEPSEEK_API_KEY=... # Can use same key with rate limit awareness
ENABLE_ICHING=true # Enable experimental features in preview
ENABLE_RUNES=true
```

## Local Development Setup

1. Copy environment template:
```bash
cd smart-divination/backend
cp .env.production.example .env.local
```

2. Fill in development credentials:
   - Use Supabase development project URL/keys
   - Use personal DeepSeek API key (free tier acceptable)
   - Leave observability keys empty (metrics disabled by default)

3. **Never commit** `.env.local` or `.env.production` to git

## Flutter App Configuration

### Development Build

```bash
cd apps/tarot
flutter build apk \
  --dart-define=API_BASE_URL=http://localhost:3001 \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=...
```

### Production Build (CI/CD)

```bash
flutter build appbundle --release \
  --dart-define=API_BASE_URL=https://smart-divination.vercel.app \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
```

## Secret Exposure Response Plan

If any secret is exposed (committed to git, leaked in logs, etc.):

### Immediate Actions
1. **Revoke/rotate** the exposed secret immediately
2. **Audit logs** to check if secret was used by unauthorized parties
3. **Notify team** about the exposure
4. **Update CI/CD** with new secret values

### Per-Secret Rotation

**Android Keystore:**
- **Cannot rotate** - Users cannot reinstall app with different signature
- If exposed before release: Generate new keystore before first Play Store upload
- If exposed after release: Google Play has key management options

**iOS Certificate:**
- Revoke certificate at developer.apple.com
- Generate new certificate
- Update provisioning profile
- Update CI/CD secrets

**Supabase Keys:**
- Regenerate keys in Supabase dashboard -> Settings -> API -> Reset keys
- Update all environments (Vercel, GitHub Actions, local devs)
- Old keys invalidated immediately

**DeepSeek API Key:**
- Delete exposed key at platform.deepseek.com
- Generate new key
- Update all environments

**Vercel Token:**
- Revoke at vercel.com -> Settings -> Tokens
- Generate new token
- Update GitHub Actions secrets

## Compliance & Audit

### Required for Production Launch
- [ ] All production secrets stored in encrypted secret management
- [ ] Access logs enabled for secret management systems
- [ ] Regular rotation schedule established (quarterly recommended)
- [ ] Team training completed on secret handling
- [ ] Incident response plan documented and tested

### Periodic Audits (Quarterly)
- Review access permissions for all secret management systems
- Check for unused/orphaned secrets
- Verify secret rotation compliance
- Audit CI/CD logs for secret exposure
- Test secret rotation procedures

## References

- [GitHub Actions Encrypted Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Vercel Environment Variables](https://vercel.com/docs/concepts/projects/environment-variables)
- [Supabase Security Best Practices](https://supabase.com/docs/guides/platform/security)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [iOS Code Signing](https://developer.apple.com/support/code-signing/)
