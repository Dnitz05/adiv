# Setup Vercel Environment Variables (SECURE VERSION)
# Run from: C:\tarot\scripts\vercel\setup_env_vars.ps1
#
# SECURITY: This script reads secrets from environment variables
# DO NOT hardcode secrets in this file

Write-Host "Setting up Vercel environment variables..." -ForegroundColor Cyan
Write-Host ""
Write-Host "SECURITY NOTICE: This script requires environment variables to be set." -ForegroundColor Yellow
Write-Host "Set them before running this script:" -ForegroundColor Yellow
Write-Host '  $env:SUPABASE_URL = "your-value"' -ForegroundColor Gray
Write-Host '  $env:SUPABASE_ANON_KEY = "your-value"' -ForegroundColor Gray
Write-Host '  $env:SUPABASE_SERVICE_ROLE_KEY = "your-value"' -ForegroundColor Gray
Write-Host '  $env:DEEPSEEK_API_KEY = "your-value"' -ForegroundColor Gray
Write-Host '  $env:RANDOM_ORG_KEY = "your-value"' -ForegroundColor Gray
Write-Host ""

cd C:\tarot\smart-divination\backend

# Check required environment variables
$required_vars = @(
    "SUPABASE_URL",
    "SUPABASE_ANON_KEY",
    "SUPABASE_SERVICE_ROLE_KEY",
    "DEEPSEEK_API_KEY",
    "RANDOM_ORG_KEY"
)

$missing = @()
foreach ($var in $required_vars) {
    if (-not (Test-Path env:$var)) {
        $missing += $var
    }
}

if ($missing.Count -gt 0) {
    Write-Host "ERROR: Missing required environment variables:" -ForegroundColor Red
    foreach ($var in $missing) {
        Write-Host "  - $var" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "Set them with:" -ForegroundColor Yellow
    Write-Host '  $env:VARIABLE_NAME = "value"' -ForegroundColor Gray
    exit 1
}

# Environment variables configuration
$env_vars = @{
    "SUPABASE_URL" = $env:SUPABASE_URL
    "SUPABASE_ANON_KEY" = $env:SUPABASE_ANON_KEY
    "SUPABASE_SERVICE_ROLE_KEY" = $env:SUPABASE_SERVICE_ROLE_KEY
    "DEEPSEEK_API_KEY" = $env:DEEPSEEK_API_KEY
    "RANDOM_ORG_KEY" = $env:RANDOM_ORG_KEY
    "ENABLE_ICHING" = "false"
    "ENABLE_RUNES" = "false"
    "NODE_ENV" = "production"
    "METRICS_PROVIDER" = "console"
    "METRICS_DEBUG" = "false"
}

Write-Host "Adding environment variables to Vercel..." -ForegroundColor Cyan
Write-Host ""

foreach ($key in $env_vars.Keys) {
    Write-Host "Setting $key..." -ForegroundColor Yellow
    $value = $env_vars[$key]

    # Use heredoc to avoid exposing value in command line
    $tempFile = New-TemporaryFile
    Set-Content -Path $tempFile -Value $value -NoNewline

    vercel env add $key production < $tempFile 2>&1 | Out-Null

    Remove-Item $tempFile

    if ($LASTEXITCODE -eq 0) {
        Write-Host "  $key added successfully" -ForegroundColor Green
    } else {
        Write-Host "  $key already exists or failed" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "All environment variables configured!" -ForegroundColor Green
Write-Host "Next: Run 'vercel --prod' to deploy" -ForegroundColor Cyan
