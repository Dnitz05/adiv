# Setup Local Android Signing from GitHub Secrets
# Run: powershell -File scripts/android/setup_local_signing.ps1

Write-Host "Setting up Android signing from GitHub Secrets..." -ForegroundColor Cyan

# Check GitHub CLI availability
$ghVersion = gh --version 2>&1 | Select-String "gh version"
if ($LASTEXITCODE -ne 0) {
    Write-Host "GitHub CLI not found. Install from https://cli.github.com/" -ForegroundColor Red
    exit 1
}
Write-Host "GitHub CLI detected: $ghVersion" -ForegroundColor Green

Write-Host ""
Write-Host "GitHub does not allow reading secret values via CLI. Copy the values manually from Settings > Secrets and variables > Actions." -ForegroundColor Yellow
Write-Host ""

$keystorePath = "C:\tarot\smart-divination\apps\\tarot\\android\\upload-keystore.jks"
$keyPropertiesPath = "C:\tarot\smart-divination\apps\tarot\android\key.properties"

Write-Host "Manual setup steps:" -ForegroundColor Cyan
Write-Host "1. Copy ANDROID_KEYSTORE_BASE64 from GitHub Secrets." -ForegroundColor White
Write-Host "2. In PowerShell, run:" -ForegroundColor White
Write-Host "   $base64 = 'PASTE_BASE64_HERE'" -ForegroundColor Gray
Write-Host "   [System.IO.File]::WriteAllBytes('$keystorePath', [Convert]::FromBase64String($base64))" -ForegroundColor Gray
Write-Host "3. Update $keyPropertiesPath with:" -ForegroundColor White
Write-Host "   storePassword=... (ANDROID_KEYSTORE_PASSWORD)" -ForegroundColor Gray
Write-Host "   keyAlias=... (ANDROID_KEY_ALIAS)" -ForegroundColor Gray
Write-Host "   keyPassword=... (ANDROID_KEY_PASSWORD)" -ForegroundColor Gray
Write-Host ""
Write-Host "Alternative: export the secrets as environment variables before building:" -ForegroundColor Cyan
Write-Host "   $env:ANDROID_KEYSTORE_BASE64 = 'value'" -ForegroundColor Gray
Write-Host "   $env:ANDROID_KEYSTORE_PASSWORD = 'value'" -ForegroundColor Gray
Write-Host "   $env:ANDROID_KEY_ALIAS = 'value'" -ForegroundColor Gray
Write-Host "   $env:ANDROID_KEY_PASSWORD = 'value'" -ForegroundColor Gray
Write-Host ""
Write-Host "Next, run the release build (after fixing JAVA_HOME):" -ForegroundColor Cyan
Write-Host "   flutter build appbundle --release --dart-define=API_BASE_URL=https://backend-4sircya71-dnitzs-projects.vercel.app" -ForegroundColor Gray

