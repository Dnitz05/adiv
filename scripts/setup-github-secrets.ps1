# Interactive script to prepare all GitHub Actions secrets
# Usage: .\setup-github-secrets.ps1

Write-Host "=== GitHub Actions Secrets Setup Helper ===" -ForegroundColor Green
Write-Host ""
Write-Host "This script will help you prepare all secrets for GitHub Actions." -ForegroundColor Cyan
Write-Host "You'll need to manually add them to GitHub after." -ForegroundColor Cyan
Write-Host ""

$secrets = @{}

# Android Secrets
Write-Host "--- Android Signing Secrets ---" -ForegroundColor Yellow
Write-Host ""

$keystorePath = "C:\tarot\smart-divination\apps\tarot\android\app\upload-keystore.jks"
if (Test-Path $keystorePath) {
    Write-Host "[1/6] Encoding Android keystore..." -ForegroundColor Cyan
    $keystoreBase64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($keystorePath))
    $secrets["ANDROID_KEYSTORE_BASE64"] = $keystoreBase64
    Write-Host "  [ok] ANDROID_KEYSTORE_BASE64 prepared ($($keystoreBase64.Length) chars)" -ForegroundColor Green
} else {
    Write-Host "  [fail] Keystore not found at: $keystorePath" -ForegroundColor Red
    $secrets["ANDROID_KEYSTORE_BASE64"] = "NOT_FOUND"
}

Write-Host ""
Write-Host "[2/6] Reading key.properties..." -ForegroundColor Cyan
$keyPropsPath = "C:\tarot\smart-divination\apps\tarot\android\key.properties"
if (Test-Path $keyPropsPath) {
    $keyProps = Get-Content $keyPropsPath | ConvertFrom-StringData
    $secrets["ANDROID_KEYSTORE_PASSWORD"] = $keyProps["storePassword"]
    $secrets["ANDROID_KEY_PASSWORD"] = $keyProps["keyPassword"]
    $secrets["ANDROID_KEY_ALIAS"] = $keyProps["keyAlias"]
    Write-Host "  [ok] Android credentials extracted" -ForegroundColor Green
    Write-Host "    Password: $($keyProps["storePassword"])" -ForegroundColor Gray
    Write-Host "    Alias: $($keyProps["keyAlias"])" -ForegroundColor Gray
} else {
    Write-Host "  [fail] key.properties not found" -ForegroundColor Red
}

# iOS Secrets (placeholder - requires manual input)
Write-Host ""
Write-Host "--- iOS Signing Secrets (Manual Input Required) ---" -ForegroundColor Yellow
Write-Host ""
Write-Host "[3/6] iOS Certificate..." -ForegroundColor Cyan
Write-Host "  WARNING You need to complete iOS signing setup first" -ForegroundColor Yellow
Write-Host "    See: docs/IOS_SIGNING_GUIDE.md" -ForegroundColor Gray
$secrets["IOS_CERTIFICATE_BASE64"] = "TODO"
$secrets["IOS_CERTIFICATE_PASSWORD"] = "TODO"
$secrets["IOS_PROVISIONING_PROFILE_BASE64"] = "TODO"
$secrets["APP_STORE_CONNECT_KEY_ID"] = "TODO"
$secrets["APP_STORE_CONNECT_ISSUER_ID"] = "TODO"
$secrets["APP_STORE_CONNECT_KEY_BASE64"] = "TODO"

# Vercel Secrets (placeholder - requires vercel link)
Write-Host ""
Write-Host "--- Vercel Deployment Secrets ---" -ForegroundColor Yellow
Write-Host ""
Write-Host "[4/6] Vercel configuration..." -ForegroundColor Cyan

$vercelProjectPath = "C:\tarot\smart-divination\backend\.vercel\project.json"
if (Test-Path $vercelProjectPath) {
    $vercelConfig = Get-Content $vercelProjectPath | ConvertFrom-Json
    $secrets["VERCEL_ORG_ID"] = $vercelConfig.orgId
    $secrets["VERCEL_PROJECT_ID"] = $vercelConfig.projectId
    Write-Host "  [ok] Vercel IDs extracted" -ForegroundColor Green
    Write-Host "    Org ID: $($vercelConfig.orgId)" -ForegroundColor Gray
    Write-Host "    Project ID: $($vercelConfig.projectId)" -ForegroundColor Gray
} else {
    Write-Host "  WARNING Vercel not linked yet" -ForegroundColor Yellow
    Write-Host "    Run: cd smart-divination/backend && vercel link" -ForegroundColor Gray
    $secrets["VERCEL_ORG_ID"] = "TODO"
    $secrets["VERCEL_PROJECT_ID"] = "TODO"
}

Write-Host "  WARNING VERCEL_TOKEN needs to be created manually" -ForegroundColor Yellow
Write-Host "    Go to: https://vercel.com/account/tokens" -ForegroundColor Gray
$secrets["VERCEL_TOKEN"] = "TODO"

# Backend Secrets (from .env.production)
Write-Host ""
Write-Host "--- Backend Environment Secrets ---" -ForegroundColor Yellow
Write-Host ""
Write-Host "[5/6] Reading .env.production..." -ForegroundColor Cyan

$envPath = "C:\tarot\smart-divination\backend\.env.production"
if (Test-Path $envPath) {
    $envVars = @{}
    Get-Content $envPath | ForEach-Object {
        if ($_ -match '^([^=]+)=(.*)$' -and -not $_.StartsWith('#')) {
            $envVars[$matches[1]] = $matches[2]
        }
    }

    $secrets["SUPABASE_URL"] = $envVars["SUPABASE_URL"]
    $secrets["SUPABASE_ANON_KEY"] = $envVars["SUPABASE_ANON_KEY"]
    $secrets["SUPABASE_SERVICE_ROLE_KEY"] = $envVars["SUPABASE_SERVICE_ROLE_KEY"]
    $secrets["DEEPSEEK_API_KEY"] = $envVars["DEEPSEEK_API_KEY"]
    $secrets["RANDOM_ORG_KEY"] = $envVars["RANDOM_ORG_KEY"]

    Write-Host "  [ok] Backend secrets extracted" -ForegroundColor Green
    if ($secrets["SUPABASE_URL"]) {
        Write-Host "    Supabase URL: $($secrets["SUPABASE_URL"])" -ForegroundColor Gray
    } else {
        Write-Host "    WARNING Some secrets are missing - fill .env.production" -ForegroundColor Yellow
    }
} else {
    Write-Host "  WARNING .env.production not found or empty" -ForegroundColor Yellow
    Write-Host "    Follow: docs/PRODUCTION_CREDENTIALS_CHECKLIST.md" -ForegroundColor Gray
    $secrets["SUPABASE_URL"] = "TODO"
    $secrets["SUPABASE_ANON_KEY"] = "TODO"
    $secrets["SUPABASE_SERVICE_ROLE_KEY"] = "TODO"
    $secrets["DEEPSEEK_API_KEY"] = "TODO"
    $secrets["RANDOM_ORG_KEY"] = "TODO"
}

# Observability (optional)
Write-Host ""
Write-Host "--- Observability Secrets (Optional) ---" -ForegroundColor Yellow
Write-Host ""
Write-Host "[6/6] Datadog configuration..." -ForegroundColor Cyan
Write-Host "  WARNING Optional - skip if not using Datadog" -ForegroundColor Yellow
$secrets["DATADOG_API_KEY"] = "OPTIONAL"
$secrets["DATADOG_SITE"] = "datadoghq.com"

# Generate output
Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Green
Write-Host ""

$readyCount = 0
$todoCount = 0
$optionalCount = 0

foreach ($key in $secrets.Keys | Sort-Object) {
    $value = $secrets[$key]
    if ($value -eq "TODO") {
        Write-Host "  [ ] $key = TODO" -ForegroundColor Yellow
        $todoCount++
    } elseif ($value -eq "NOT_FOUND") {
        Write-Host "  [fail] $key = NOT_FOUND" -ForegroundColor Red
        $todoCount++
    } elseif ($value -eq "OPTIONAL") {
        Write-Host "  - $key = OPTIONAL" -ForegroundColor Gray
        $optionalCount++
    } else {
        $displayValue = if ($value.Length -gt 40) { "$($value.Substring(0, 37))..." } else { $value }
        Write-Host "  [ok] $key = $displayValue" -ForegroundColor Green
        $readyCount++
    }
}

Write-Host ""
Write-Host "Status: $readyCount ready, $todoCount TODO, $optionalCount optional" -ForegroundColor Cyan

# Save to file for reference
$outputPath = "C:\tarot\scripts\github-secrets-output.txt"
$output = @"
=== GitHub Actions Secrets ===
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Add these secrets to: https://github.com/YOUR_USERNAME/YOUR_REPO/settings/secrets/actions

"@

foreach ($key in $secrets.Keys | Sort-Object) {
    $value = $secrets[$key]
    $status = if ($value -in @("TODO", "NOT_FOUND", "OPTIONAL")) { $value } else { "[READY]" }
    $output += "`n$key = $status"
    if ($value -notin @("TODO", "NOT_FOUND", "OPTIONAL")) {
        $output += "`n    Value: $value"
    }
    $output += "`n"
}

$output | Out-File -FilePath $outputPath -Encoding UTF8

Write-Host ""
Write-Host "[ok] Secrets summary saved to: $outputPath" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Complete any TODO items above"
Write-Host "2. Go to GitHub -> Settings -> Secrets -> Actions"
Write-Host "3. Add each secret manually (click 'New repository secret')"
Write-Host "4. Verify with: docs/GITHUB_ACTIONS_SETUP.md"
Write-Host ""
