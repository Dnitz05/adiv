# Decode Android keystore from GitHub Secrets
# Run: powershell -File scripts/android/decode_keystore.ps1

Write-Host "Checking Android keystore..." -ForegroundColor Cyan

$keystorePath = "C:\tarot\smart-divination\apps\\tarot\\android\\upload-keystore.jks"
$keyPropertiesPath = "C:\tarot\smart-divination\apps\tarot\android\key.properties"

if (Test-Path $keystorePath) {
    Write-Host "Keystore exists at: $keystorePath" -ForegroundColor Green
} else {
    Write-Host "Keystore not found." -ForegroundColor Red
    Write-Host "Populate it by decoding ANDROID_KEYSTORE_BASE64 from GitHub Secrets:" -ForegroundColor Yellow
    Write-Host "  $base64 = 'PASTE_BASE64_HERE'" -ForegroundColor Gray
    Write-Host "  [System.IO.File]::WriteAllBytes('$keystorePath', [Convert]::FromBase64String($base64))" -ForegroundColor Gray
    exit 1
}

if (Test-Path $keyPropertiesPath) {
    Write-Host "key.properties found. Ensure it contains production credentials." -ForegroundColor Green
    Write-Host "Expected keys: storePassword, keyAlias, keyPassword, storeFile" -ForegroundColor Yellow
} else {
    Write-Host "key.properties missing. Copy the sample and fill it with real values." -ForegroundColor Red
    exit 1
}

Write-Host "Ready to build: run flutter build appbundle --release when JAVA_HOME is set." -ForegroundColor Cyan

