# Guided Setup - Smart Divination Production Credentials
# This script will guide you step-by-step through gathering all credentials

Write-Host "=== Smart Divination - Guided Production Setup ===" -ForegroundColor Green
Write-Host ""
Write-Host "This script will help you gather all credentials needed for deployment." -ForegroundColor Cyan
Write-Host "We'll do this step by step, one service at a time." -ForegroundColor Cyan
Write-Host ""

# Create a credentials file
$credentialsFile = "C:\tarot\.credentials-temp.txt"
$envFile = "C:\tarot\smart-divination\backend\.env.production"

Write-Host "--- Step 1: Vercel Project ---" -ForegroundColor Yellow
Write-Host ""
Write-Host "First, let's check if you already have a Vercel project deployed." -ForegroundColor Cyan
Write-Host ""
Write-Host "Please open your browser and go to:" -ForegroundColor White
Write-Host "  https://vercel.com/dnitz05" -ForegroundColor Green
Write-Host ""
$hasProject = Read-Host "Do you see a project called 'smart-divination' or similar? (yes/no)"

if ($hasProject -eq "yes") {
    Write-Host ""
    Write-Host "Great! Let's get the environment variables from that project." -ForegroundColor Green
    Write-Host ""
    Write-Host "1. Click on your project" -ForegroundColor White
    Write-Host "2. Go to Settings -> Environment Variables" -ForegroundColor White
    Write-Host "3. You should see variables like SUPABASE_URL, DEEPSEEK_API_KEY, etc." -ForegroundColor White
    Write-Host ""

    $projectName = Read-Host "What is the exact project name?"

    Write-Host ""
    Write-Host "Let's try to pull the environment variables..." -ForegroundColor Cyan

    try {
        $env:VERCEL_PROJECT_NAME = $projectName
        Set-Location "C:\tarot\smart-divination\backend"

        Write-Host "Running: vercel env pull .env.production --yes" -ForegroundColor Gray
        & vercel env pull .env.production --yes 2>&1

        if (Test-Path ".env.production") {
            Write-Host ""
            Write-Host "[ok] Successfully pulled environment variables!" -ForegroundColor Green
            Write-Host "  File: .env.production" -ForegroundColor Gray
            Write-Host ""

            # Read and display (without showing secrets)
            $envContent = Get-Content ".env.production"
            Write-Host "Variables found:" -ForegroundColor Cyan
            foreach ($line in $envContent) {
                if ($line -match '^([^=]+)=') {
                    Write-Host "  [ok] $($matches[1])" -ForegroundColor Green
                }
            }

            Write-Host ""
            Write-Host "[ok] Step 1 Complete! Environment variables retrieved from Vercel." -ForegroundColor Green
            Write-Host ""
            Write-Host "Next steps:" -ForegroundColor Yellow
            Write-Host "1. Review .env.production to ensure all values are present"
            Write-Host "2. Continue with GitHub Actions secrets setup"
            Write-Host ""

            exit 0
        } else {
            Write-Host "WARNING Could not pull environment variables automatically." -ForegroundColor Yellow
            Write-Host "  We'll gather them manually instead." -ForegroundColor Gray
        }
    } catch {
        Write-Host "WARNING Error: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host "  We'll gather credentials manually." -ForegroundColor Gray
    }
} else {
    Write-Host ""
    Write-Host "No problem! We'll gather all credentials from scratch." -ForegroundColor Cyan
}

Write-Host ""
Write-Host "--- Step 2: Supabase Credentials ---" -ForegroundColor Yellow
Write-Host ""
Write-Host "Now let's get your Supabase credentials." -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Open: https://supabase.com/dashboard/projects" -ForegroundColor White
Write-Host "2. Select your project (or create a new one if needed)" -ForegroundColor White
Write-Host "3. Go to: Settings -> API" -ForegroundColor White
Write-Host ""
Write-Host "Press Enter when you're ready..." -ForegroundColor Gray
Read-Host

Write-Host ""
$supabaseUrl = Read-Host "Paste your Project URL (e.g., https://xxxxx.supabase.co)"
$supabaseAnonKey = Read-Host "Paste your anon/public key (starts with eyJhbGci...)"
$supabaseServiceKey = Read-Host "Paste your service_role key (starts with eyJhbGci...)"

Write-Host ""
Write-Host "[ok] Supabase credentials captured!" -ForegroundColor Green

Write-Host ""
Write-Host "--- Step 3: DeepSeek API Key ---" -ForegroundColor Yellow
Write-Host ""
Write-Host "Now let's get your DeepSeek API key." -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Open: https://platform.deepseek.com/api_keys" -ForegroundColor White
Write-Host "2. Click 'Create API Key' if you don't have one" -ForegroundColor White
Write-Host "3. Copy the key (starts with sk-...)" -ForegroundColor White
Write-Host ""
Write-Host "Press Enter when you're ready..." -ForegroundColor Gray
Read-Host

Write-Host ""
$deepseekKey = Read-Host "Paste your DeepSeek API key (starts with sk-...)"

Write-Host ""
Write-Host "[ok] DeepSeek API key captured!" -ForegroundColor Green

Write-Host ""
Write-Host "--- Step 4: Optional Services ---" -ForegroundColor Yellow
Write-Host ""
$useRandomOrg = Read-Host "Do you want to use Random.org? (yes/no, press Enter for no)"
$randomOrgKey = ""
if ($useRandomOrg -eq "yes") {
    Write-Host "1. Open: https://api.random.org/dashboard" -ForegroundColor White
    Write-Host "2. Sign up or log in" -ForegroundColor White
    Write-Host "3. Copy your API key" -ForegroundColor White
    Write-Host ""
    $randomOrgKey = Read-Host "Paste your Random.org API key"
    Write-Host "[ok] Random.org key captured!" -ForegroundColor Green
}

Write-Host ""
$useDatadog = Read-Host "Do you want to use Datadog monitoring? (yes/no, press Enter for no)"
$datadogKey = ""
$datadogSite = "datadoghq.com"
if ($useDatadog -eq "yes") {
    Write-Host "1. Open: https://app.datadoghq.com/organization-settings/api-keys" -ForegroundColor White
    Write-Host "2. Create or copy an API key" -ForegroundColor White
    Write-Host ""
    $datadogKey = Read-Host "Paste your Datadog API key"
    $datadogSite = Read-Host "Datadog site (datadoghq.com or datadoghq.eu, press Enter for .com)"
    if ($datadogSite -eq "") { $datadogSite = "datadoghq.com" }
    Write-Host "[ok] Datadog credentials captured!" -ForegroundColor Green
}

# Build .env.production file
Write-Host ""
Write-Host "--- Creating .env.production file ---" -ForegroundColor Yellow
Write-Host ""

$envContent = @"
# Production Environment Variables
# Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
# IMPORTANT: Never commit this file!

# Supabase Configuration (REQUIRED)
SUPABASE_URL=$supabaseUrl
SUPABASE_ANON_KEY=$supabaseAnonKey
SUPABASE_SERVICE_ROLE_KEY=$supabaseServiceKey

# DeepSeek AI (REQUIRED for interpretations)
DEEPSEEK_API_KEY=$deepseekKey

# Random.org (OPTIONAL - signed randomness)
RANDOM_ORG_KEY=$randomOrgKey

# Feature Flags (REQUIRED)
ENABLE_ICHING=false
ENABLE_RUNES=false

# Metrics & Observability (OPTIONAL)
METRICS_PROVIDER=$(if ($useDatadog -eq "yes") { "datadog" } else { "console" })
METRICS_DEBUG=false
DATADOG_API_KEY=$datadogKey
DATADOG_SITE=$datadogSite
DATADOG_SERVICE=smart-divination-backend
DATADOG_ENV=production
DATADOG_METRIC_PREFIX=smart_divination
DATADOG_TAGS=env:production,service:backend
DATADOG_TIMEOUT_MS=2000

# API Configuration
NODE_ENV=production
"@

$envContent | Out-File -FilePath $envFile -Encoding UTF8

Write-Host "[ok] .env.production file created!" -ForegroundColor Green
Write-Host "  Location: $envFile" -ForegroundColor Gray
Write-Host ""

# Summary
Write-Host "=== Setup Complete! ===" -ForegroundColor Green
Write-Host ""
Write-Host "What we've configured:" -ForegroundColor Cyan
Write-Host "  [ok] Supabase: $supabaseUrl" -ForegroundColor Green
Write-Host "  [ok] DeepSeek API key: $(if ($deepseekKey) { 'Configured' } else { 'Missing' })" -ForegroundColor $(if ($deepseekKey) { 'Green' } else { 'Red' })
Write-Host "  [ok] Random.org: $(if ($randomOrgKey) { 'Configured' } else { 'Skipped (optional)' })" -ForegroundColor Gray
Write-Host "  [ok] Datadog: $(if ($datadogKey) { 'Configured' } else { 'Skipped (optional)' })" -ForegroundColor Gray
Write-Host ""

Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Test locally: cd smart-divination/backend && npm run dev"
Write-Host "2. Deploy to Vercel: vercel --prod"
Write-Host "3. Configure GitHub Actions secrets: .\setup-github-secrets.ps1"
Write-Host ""

Write-Host "Would you like to test the configuration now? (yes/no)" -ForegroundColor Cyan
$testNow = Read-Host

if ($testNow -eq "yes") {
    Write-Host ""
    Write-Host "Testing backend with production credentials..." -ForegroundColor Yellow
    Write-Host ""

    Set-Location "C:\tarot\smart-divination\backend"
    Copy-Item ".env.production" ".env.local" -Force

    Write-Host "Starting dev server... (press Ctrl+C to stop)" -ForegroundColor Gray
    Write-Host ""

    Start-Process "http://localhost:3001/api/health"

    npm run dev
}
