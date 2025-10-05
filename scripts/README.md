# Deployment Helper Scripts

This directory contains PowerShell scripts to assist with the deployment process.

## Available Scripts

### 1. `encode-android-keystore.ps1`

Encodes the Android keystore file to base64 for GitHub Actions.

**Usage**:
```powershell
.\encode-android-keystore.ps1
```

**What it does**:
- Reads `smart-divination/apps/tarot/android/app/upload-keystore.jks`
- Converts to base64
- Copies to clipboard
- Displays instructions for adding to GitHub Secrets

**Output**: Base64 string in clipboard, ready to paste into GitHub

---

### 2. `verify-deployment.ps1`

Tests a deployed backend to verify all endpoints are working correctly.

**Usage**:
```powershell
.\verify-deployment.ps1 https://smart-divination-backend.vercel.app
```

**What it tests**:
1. `/api/health` - Health check endpoint (expects 200)
2. `/api/metrics` - Metrics endpoint (expects 200)
3. `/api/draw/cards` - Unauthenticated access (expects 401)
4. `/api/draw/coins` - Feature flag check (expects 503 or 401)
5. Response time - Should be < 3 seconds

**Exit codes**:
- `0` - All tests passed
- `1` - One or more tests failed

**Example output**:
```
=== Vercel Deployment Verification ===
Backend URL: https://smart-divination-backend.vercel.app

[1/5] Testing /api/health...
  [ok] Health check passed
    Status: healthy
    Uptime: 123.45s

...

=== Test Summary ===
  [PASS] Health Check
  [PASS] Metrics Endpoint
  [PASS] Auth Check
  [PASS] Feature Flags
  [PASS] Response Time

Results: 5 passed, 0 warnings, 0 failed

[ok] All tests passed! Deployment is healthy.
```

---

### 3. `setup-github-secrets.ps1`

Interactive script that prepares all GitHub Actions secrets.

**Usage**:
```powershell
.\setup-github-secrets.ps1
```

**What it does**:
- Encodes Android keystore to base64
- Reads Android signing credentials from `key.properties`
- Checks for iOS signing files (if present)
- Reads Vercel project configuration (if linked)
- Extracts secrets from `.env.production` (if exists)
- Generates a summary report
- Saves output to `github-secrets-output.txt`

**Secrets prepared**:
- **Android** (6 secrets):
  - ANDROID_KEYSTORE_BASE64
  - ANDROID_KEYSTORE_PASSWORD
  - ANDROID_KEY_ALIAS
  - ANDROID_KEY_PASSWORD
  - ANDROID_STORE_FILE
  - ANDROID_BUNDLE_ID

- **iOS** (6 secrets):
  - IOS_CERTIFICATE_BASE64
  - IOS_CERTIFICATE_PASSWORD
  - IOS_PROVISIONING_PROFILE_BASE64
  - APP_STORE_CONNECT_KEY_ID
  - APP_STORE_CONNECT_ISSUER_ID
  - APP_STORE_CONNECT_KEY_BASE64

- **Vercel** (3 secrets):
  - VERCEL_TOKEN
  - VERCEL_ORG_ID
  - VERCEL_PROJECT_ID

- **Backend** (5 secrets):
  - SUPABASE_URL
  - SUPABASE_ANON_KEY
  - SUPABASE_SERVICE_ROLE_KEY
  - DEEPSEEK_API_KEY
  - RANDOM_ORG_KEY

- **Observability** (2 optional secrets):
  - DATADOG_API_KEY
  - DATADOG_SITE

**Example output**:
```
=== GitHub Actions Secrets Setup Helper ===

--- Android Signing Secrets ---

[1/6] Encoding Android keystore...
  [ok] ANDROID_KEYSTORE_BASE64 prepared (3428 chars)

[2/6] Reading key.properties...
  [ok] Android credentials extracted
    Password: <your-keystore-password>
    Alias: <your-key-alias>

...

=== Summary ===

  [ok] ANDROID_KEYSTORE_BASE64 = [base64 string]
  [ok] ANDROID_KEYSTORE_PASSWORD = <your-keystore-password>
  [ok] ANDROID_KEY_ALIAS = <your-key-alias>
  ...
  [ ] IOS_CERTIFICATE_BASE64 = TODO
  ...

Status: 8 ready, 12 TODO, 2 optional

[ok] Secrets summary saved to: scripts/github-secrets-output.txt

Next steps:
1. Complete any TODO items above
2. Go to GitHub -> Settings -> Secrets -> Actions
3. Add each secret manually
4. Verify with: docs/GITHUB_ACTIONS_SETUP.md
```

---

### 4. `supabase/check_env.ps1` / `supabase/check_env.sh`

Validates that the mandatory Supabase environment variables are present before running migrations or deployment scripts.

**Usage**:
```powershell
.\supabase\check_env.ps1
```

```bash
./supabase/check_env.sh
```

**Checks**:
- SUPABASE_DB_URL
- SUPABASE_URL
- SUPABASE_SERVICE_ROLE_KEY
- SUPABASE_ANON_KEY

Exit code `1` indicates at least one variable is missing; `0` means the environment is ready.

---

## Workflow

### Before Deployment

1. **Verify backend code quality**:
```powershell
cd C:\tarot\smart-divination\backend
npm run type-check  # TypeScript check
npm run lint        # ESLint check
npm test            # Run tests
```

2. **Prepare GitHub Secrets**:
```powershell
cd C:\tarot\scripts
.\setup-github-secrets.ps1
```

3. **Complete TODOs** from the output
4. **Add secrets to GitHub** manually

### After Deployment

1. **Verify deployment**:
```powershell
cd C:\tarot\scripts
.\verify-deployment.ps1 https://smart-divination-backend.vercel.app
```

2. **Check logs** in Vercel dashboard if any tests fail

3. **Test with real credentials**:
   - Create test user in Supabase
   - Get auth token
   - Test authenticated endpoints

---

## Prerequisites

### PowerShell

All scripts require **PowerShell 5.1+** (Windows 10/11 default).

To check version:
```powershell
$PSVersionTable.PSVersion
```

### Execution Policy

If you get "script cannot be loaded because running scripts is disabled", run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Dependencies

- **Git Bash** or **PowerShell** for Windows
- **Node.js 18+** for backend commands
- **Vercel CLI** for deployment (`npm install -g vercel`)

---

## Troubleshooting

### "File not found" errors

Ensure you're running scripts from the `C:\tarot\scripts\` directory:
```powershell
cd C:\tarot\scripts
.\script-name.ps1
```

### "Cannot convert value to type System.Byte"

This usually means a file path is incorrect. Check that:
- Android keystore exists at: `smart-divination/apps/tarot/android/app/upload-keystore.jks`
- `key.properties` exists at: `smart-divination/apps/tarot/android/key.properties`

### Clipboard not working

If `Set-Clipboard` fails, the base64 string will still be displayed in the terminal. You can manually copy it.

### Verify script returns false positives

If a test fails but you believe the deployment is correct:
- Check Vercel function logs in the dashboard
- Verify environment variables are set correctly
- Test the endpoint manually with `curl` or Postman

---

## Security Notes

- **Never commit** `github-secrets-output.txt` to version control (it's in `.gitignore`)
- **Base64 is encoding, not encryption** - treat encoded secrets with same security as plain text
- **Rotate secrets immediately** if exposed or committed accidentally
- **Store backup** of secrets in secure vault (1Password, Bitwarden, etc.)

---

## Related Documentation

- [`../docs/DEPLOYMENT_ROADMAP.md`](../docs/DEPLOYMENT_ROADMAP.md) - Complete deployment guide
- [`../docs/GITHUB_ACTIONS_SETUP.md`](../docs/GITHUB_ACTIONS_SETUP.md) - GitHub secrets configuration
- [`../docs/VERCEL_DEPLOYMENT_GUIDE.md`](../docs/VERCEL_DEPLOYMENT_GUIDE.md) - Vercel deployment steps
- [`../docs/IOS_SIGNING_GUIDE.md`](../docs/IOS_SIGNING_GUIDE.md) - iOS certificate setup
- [`../docs/PRODUCTION_CREDENTIALS_CHECKLIST.md`](../docs/PRODUCTION_CREDENTIALS_CHECKLIST.md) - Credentials gathering

---

**Last Updated**: 2025-10-02
