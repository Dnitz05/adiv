# Script to base64 encode Android keystore for GitHub Actions
# Usage: .\encode-android-keystore.ps1

Write-Host "=== Android Keystore Base64 Encoder ===" -ForegroundColor Green
Write-Host ""

$keystorePath = "C:\tarot\smart-divination\apps\tarot\android\app\upload-keystore.jks"

if (-not (Test-Path $keystorePath)) {
    Write-Host "ERROR: Keystore not found at: $keystorePath" -ForegroundColor Red
    exit 1
}

Write-Host "Encoding keystore..." -ForegroundColor Yellow
$base64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($keystorePath))

Write-Host ""
Write-Host "=== Base64 Encoded Keystore ===" -ForegroundColor Green
Write-Host "Length: $($base64.Length) characters" -ForegroundColor Cyan
Write-Host ""
Write-Host "Copying to clipboard..." -ForegroundColor Yellow
Set-Clipboard -Value $base64

Write-Host ""
Write-Host "[ok] Base64 string copied to clipboard!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Go to GitHub repository -> Settings -> Secrets -> Actions"
Write-Host "2. Click 'New repository secret'"
Write-Host "3. Name: ANDROID_KEYSTORE_BASE64"
Write-Host "4. Value: Paste from clipboard (Ctrl+V)"
Write-Host ""
Write-Host "Also add these secrets:"
Write-Host "  - ANDROID_KEYSTORE_PASSWORD: <your-keystore-password>"
Write-Host "  - ANDROID_KEY_ALIAS: <your-key-alias>"
Write-Host "  - ANDROID_KEY_PASSWORD: <your-key-password>"
Write-Host ""
