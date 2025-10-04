# GitHub Actions Secrets Setup Guide

This guide shows you how to configure all secrets needed for CI/CD pipelines.

## Prerequisites

- Repository: `https://github.com/YOUR_USERNAME/YOUR_REPO`
- Admin access to the repository
- All credentials from previous tasks ready

## Accessing GitHub Secrets

1. Go to your repository on GitHub
2. Click **Settings** (tab at top)
3. In left sidebar: **Secrets and variables** -> **Actions**
4. Click **New repository secret** for each secret below

## Required Secrets

### Android Signing (6 secrets)

#### 1. `ANDROID_KEYSTORE_BASE64`
**Value**: Base64-encoded keystore file

**Windows PowerShell**:
```powershell
cd C:\tarot\smart-divination\apps\tarot\android\app
[Convert]::ToBase64String([IO.File]::ReadAllBytes("upload-keystore.jks")) | Set-Clipboard
# Now paste from clipboard into GitHub
```

**Git Bash / Linux**:
```bash
cd smart-divination/apps/tarot/android/app
base64 -w 0 upload-keystore.jks | clip  # Windows
# or
base64 -w 0 upload-keystore.jks | pbcopy  # macOS
# or
base64 -w 0 upload-keystore.jks  # Linux (copy output manually)
```

#### 2. `ANDROID_KEYSTORE_PASSWORD`
**Value**: Use the keystore password you generated (storePassword)

#### 3. `ANDROID_KEY_ALIAS`
**Value**: Use the upload key alias defined in key.properties

#### 4. `ANDROID_KEY_PASSWORD`
**Value**: Use the keystore password you generated (storePassword)

#### 5. `ANDROID_STORE_FILE`
**Value**: Relative path to the keystore file (e.g., upload-keystore.jks)

#### 6. `ANDROID_BUNDLE_ID`
**Value**: `com.smartdivination.tarot` (or your chosen bundle ID)

### iOS Signing (6 secrets)

WARNING: **Complete iOS signing setup first** (see `IOS_SIGNING_GUIDE.md`)

#### 1. `IOS_CERTIFICATE_BASE64`
**Value**: Base64-encoded P12 certificate

**PowerShell**:
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("path\to\distribution-certificate.p12")) | Set-Clipboard
```

**macOS/Linux**:
```bash
base64 -i distribution-certificate.p12 | pbcopy
```

#### 2. `IOS_CERTIFICATE_PASSWORD`
**Value**: The password you set when exporting P12

#### 3. `IOS_PROVISIONING_PROFILE_BASE64`
**Value**: Base64-encoded provisioning profile

**PowerShell**:
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("path\to\profile.mobileprovision")) | Set-Clipboard
```

**macOS/Linux**:
```bash
base64 -i profile.mobileprovision | pbcopy
```

#### 4. `APP_STORE_CONNECT_KEY_ID`
**Value**: Key ID from App Store Connect (e.g., `ABC123XYZ`)

#### 5. `APP_STORE_CONNECT_ISSUER_ID`
**Value**: Issuer ID from App Store Connect (UUID format)

#### 6. `APP_STORE_CONNECT_KEY_BASE64`
**Value**: Base64-encoded .p8 API key

**PowerShell**:
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("path\to\AuthKey_ABC123XYZ.p8")) | Set-Clipboard
```

**macOS/Linux**:
```bash
base64 -i AuthKey_ABC123XYZ.p8 | pbcopy
```

### Vercel Deployment (3 secrets)

#### 1. `VERCEL_TOKEN`
**How to get**:
1. Go to https://vercel.com/account/tokens
2. Click **Create Token**
3. Name: `Smart Divination CI`
4. Scope: Full Account
5. Expiration: No expiration (or set based on security policy)
6. Click **Create Token**
7. Copy immediately (shown only once)

#### 2. `VERCEL_ORG_ID`
**How to get**:
```bash
cd C:\tarot\smart-divination\backend
vercel link
# Answer prompts to link to existing project or create new
# After completion, check .vercel/project.json
```

**From .vercel/project.json**:
```json
{
  "orgId": "team_xxxxxxxxxxxx",
  "projectId": "prj_xxxxxxxxxxxx"
}
```

Copy the `orgId` value.

#### 3. `VERCEL_PROJECT_ID`
**How to get**: From same `.vercel/project.json` file above, copy `projectId` value.

### Backend Environment Variables (5 secrets)

These are the same values from your `.env.production` file:

#### 1. `SUPABASE_URL`
**Value**: `https://xxxxx.supabase.co`

#### 2. `SUPABASE_ANON_KEY`
**Value**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` (very long string)

#### 3. `SUPABASE_SERVICE_ROLE_KEY`
**Value**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` (very long string)

#### 4. `DEEPSEEK_API_KEY`
**Value**: `sk-...`

#### 5. `RANDOM_ORG_KEY` (Optional)
**Value**: Your Random.org API key (or leave empty)

### Optional Observability (2 secrets)

#### 1. `DATADOG_API_KEY` (Optional)
**Value**: Your Datadog API key

#### 2. `DATADOG_SITE` (Optional)
**Value**: `datadoghq.com` or `datadoghq.eu`

## Complete Secrets List Summary

Here's the full list of secrets to add (26 total, or 20 if skipping optionals):

**Android (6)**:
- [x] ANDROID_KEYSTORE_BASE64
- [x] ANDROID_KEYSTORE_PASSWORD
- [x] ANDROID_KEY_ALIAS
- [x] ANDROID_KEY_PASSWORD
- [x] ANDROID_STORE_FILE
- [x] ANDROID_BUNDLE_ID

**iOS (6)**:
- [ ] IOS_CERTIFICATE_BASE64
- [ ] IOS_CERTIFICATE_PASSWORD
- [ ] IOS_PROVISIONING_PROFILE_BASE64
- [ ] APP_STORE_CONNECT_KEY_ID
- [ ] APP_STORE_CONNECT_ISSUER_ID
- [ ] APP_STORE_CONNECT_KEY_BASE64

**Vercel (3)**:
- [ ] VERCEL_TOKEN
- [ ] VERCEL_ORG_ID
- [ ] VERCEL_PROJECT_ID

**Backend (5)**:
- [ ] SUPABASE_URL
- [ ] SUPABASE_ANON_KEY
- [ ] SUPABASE_SERVICE_ROLE_KEY
- [ ] DEEPSEEK_API_KEY
- [ ] RANDOM_ORG_KEY (optional)

**Observability (2, optional)**:
- [ ] DATADOG_API_KEY
- [ ] DATADOG_SITE

## Verification Script

Create a GitHub Actions workflow to verify secrets are set correctly:

**.github/workflows/verify-secrets.yml**:
```yaml
name: Verify Secrets

on:
  workflow_dispatch:

jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - name: Check Android secrets
        run: |
          echo "ANDROID_KEYSTORE_BASE64: ${{ secrets.ANDROID_KEYSTORE_BASE64 != '' }}"
          echo "ANDROID_KEY_ALIAS: ${{ secrets.ANDROID_KEY_ALIAS }}"
          echo "ANDROID_BUNDLE_ID: ${{ secrets.ANDROID_BUNDLE_ID }}"

      - name: Check Vercel secrets
        run: |
          echo "VERCEL_TOKEN: ${{ secrets.VERCEL_TOKEN != '' }}"
          echo "VERCEL_ORG_ID: ${{ secrets.VERCEL_ORG_ID }}"
          echo "VERCEL_PROJECT_ID: ${{ secrets.VERCEL_PROJECT_ID }}"

      - name: Check Backend secrets
        run: |
          echo "SUPABASE_URL: ${{ secrets.SUPABASE_URL }}"
          echo "DEEPSEEK_API_KEY: ${{ secrets.DEEPSEEK_API_KEY != '' }}"
```

Run via: **Actions** tab -> **Verify Secrets** -> **Run workflow**

## Security Best Practices

1. **Never log secret values** - Always check they exist with `!= ''` rather than echoing
2. **Rotate immediately if exposed** - If a secret is committed or logged, rotate it ASAP
3. **Use environment-specific secrets** - Consider separate secrets for staging/production
4. **Audit access regularly** - Review who has access to repository secrets
5. **Enable secret scanning** - GitHub can alert you if secrets are pushed

## Troubleshooting

### "Secret not found" in workflow
- Verify secret name matches exactly (case-sensitive)
- Check you're adding to the correct repository
- Ensure you have admin access

### Base64 encoding issues
- Ensure no line breaks or extra whitespace
- Use `-w 0` flag with base64 (Linux) to disable line wrapping
- Verify the decoded output matches original file size

### Vercel deployment fails
- Verify `VERCEL_TOKEN` has not expired
- Check `VERCEL_ORG_ID` and `VERCEL_PROJECT_ID` match the linked project
- Ensure token has correct permissions

## Next Steps

After configuring all secrets:
1. [x] Run verification workflow
2. -> Task 4: Deploy backend to Vercel
3. -> Configure CI/CD workflows to use these secrets
4. -> Test automated builds for Android/iOS

## References

- [GitHub Encrypted Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Vercel CLI Documentation](https://vercel.com/docs/cli)
- [Base64 Command Reference](https://linux.die.net/man/1/base64)
