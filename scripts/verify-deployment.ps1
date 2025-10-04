# Script to verify Vercel deployment endpoints
# Usage: .\verify-deployment.ps1 <backend-url>
# Example: .\verify-deployment.ps1 https://smart-divination-backend.vercel.app

param(
    [Parameter(Mandatory=$true)]
    [string]$BackendUrl
)

Write-Host "=== Vercel Deployment Verification ===" -ForegroundColor Green
Write-Host "Backend URL: $BackendUrl" -ForegroundColor Cyan
Write-Host ""

# Remove trailing slash if present
$BackendUrl = $BackendUrl.TrimEnd('/')

$testResults = @()

# Test 1: Health Check
Write-Host "[1/5] Testing /api/health..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$BackendUrl/api/health" -Method GET -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        $json = $response.Content | ConvertFrom-Json
        Write-Host "  [ok] Health check passed" -ForegroundColor Green
        Write-Host "    Status: $($json.status)" -ForegroundColor Gray
        Write-Host "    Uptime: $($json.uptime)s" -ForegroundColor Gray
        $testResults += @{Name="Health Check"; Status="PASS"}
    } else {
        Write-Host "  [fail] Unexpected status code: $($response.StatusCode)" -ForegroundColor Red
        $testResults += @{Name="Health Check"; Status="FAIL"}
    }
} catch {
    Write-Host "  [fail] Error: $($_.Exception.Message)" -ForegroundColor Red
    $testResults += @{Name="Health Check"; Status="FAIL"}
}
Write-Host ""

# Test 2: Metrics Endpoint
Write-Host "[2/5] Testing /api/metrics..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$BackendUrl/api/metrics" -Method GET -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        $json = $response.Content | ConvertFrom-Json
        Write-Host "  [ok] Metrics endpoint passed" -ForegroundColor Green
        Write-Host "    Provider: $($json.provider)" -ForegroundColor Gray
        Write-Host "    Metrics count: $($json.metrics.Count)" -ForegroundColor Gray
        $testResults += @{Name="Metrics Endpoint"; Status="PASS"}
    } else {
        Write-Host "  [fail] Unexpected status code: $($response.StatusCode)" -ForegroundColor Red
        $testResults += @{Name="Metrics Endpoint"; Status="FAIL"}
    }
} catch {
    Write-Host "  [fail] Error: $($_.Exception.Message)" -ForegroundColor Red
    $testResults += @{Name="Metrics Endpoint"; Status="FAIL"}
}
Write-Host ""

# Test 3: Unauthenticated Draw (should return 401)
Write-Host "[3/5] Testing /api/draw/cards (unauthenticated)..." -ForegroundColor Yellow
try {
    $body = @{
        spread = "three_card"
        question = "Test"
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "$BackendUrl/api/draw/cards" -Method POST `
        -ContentType "application/json" -Body $body -TimeoutSec 10 -SkipHttpErrorCheck

    if ($response.StatusCode -eq 401) {
        $json = $response.Content | ConvertFrom-Json
        Write-Host "  [ok] Authentication required (expected 401)" -ForegroundColor Green
        Write-Host "    Error code: $($json.error.code)" -ForegroundColor Gray
        $testResults += @{Name="Auth Check"; Status="PASS"}
    } else {
        Write-Host "  [fail] Expected 401, got $($response.StatusCode)" -ForegroundColor Red
        $testResults += @{Name="Auth Check"; Status="FAIL"}
    }
} catch {
    Write-Host "  [fail] Error: $($_.Exception.Message)" -ForegroundColor Red
    $testResults += @{Name="Auth Check"; Status="FAIL"}
}
Write-Host ""

# Test 4: I Ching Disabled (should return 503)
Write-Host "[4/5] Testing /api/draw/coins (feature disabled)..." -ForegroundColor Yellow
try {
    $body = @{
        question = "Test"
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "$BackendUrl/api/draw/coins" -Method POST `
        -ContentType "application/json" -Body $body -TimeoutSec 10 -SkipHttpErrorCheck

    if ($response.StatusCode -eq 503 -or $response.StatusCode -eq 401) {
        Write-Host "  [ok] Feature disabled or auth required (expected)" -ForegroundColor Green
        $testResults += @{Name="Feature Flags"; Status="PASS"}
    } else {
        Write-Host "  WARNING Unexpected status code: $($response.StatusCode)" -ForegroundColor Yellow
        $testResults += @{Name="Feature Flags"; Status="WARN"}
    }
} catch {
    Write-Host "  [fail] Error: $($_.Exception.Message)" -ForegroundColor Red
    $testResults += @{Name="Feature Flags"; Status="FAIL"}
}
Write-Host ""

# Test 5: Response Time
Write-Host "[5/5] Testing response time..." -ForegroundColor Yellow
try {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $response = Invoke-WebRequest -Uri "$BackendUrl/api/health" -Method GET -TimeoutSec 10
    $stopwatch.Stop()
    $responseTime = $stopwatch.ElapsedMilliseconds

    if ($responseTime -lt 3000) {
        Write-Host "  [ok] Response time: $($responseTime)ms (< 3s)" -ForegroundColor Green
        $testResults += @{Name="Response Time"; Status="PASS"}
    } elseif ($responseTime -lt 5000) {
        Write-Host "  WARNING Response time: $($responseTime)ms (3-5s)" -ForegroundColor Yellow
        $testResults += @{Name="Response Time"; Status="WARN"}
    } else {
        Write-Host "  [fail] Response time: $($responseTime)ms (> 5s)" -ForegroundColor Red
        $testResults += @{Name="Response Time"; Status="FAIL"}
    }
} catch {
    Write-Host "  [fail] Error: $($_.Exception.Message)" -ForegroundColor Red
    $testResults += @{Name="Response Time"; Status="FAIL"}
}
Write-Host ""

# Summary
Write-Host "=== Test Summary ===" -ForegroundColor Green
$passCount = ($testResults | Where-Object { $_.Status -eq "PASS" }).Count
$warnCount = ($testResults | Where-Object { $_.Status -eq "WARN" }).Count
$failCount = ($testResults | Where-Object { $_.Status -eq "FAIL" }).Count

foreach ($result in $testResults) {
    $color = switch ($result.Status) {
        "PASS" { "Green" }
        "WARN" { "Yellow" }
        "FAIL" { "Red" }
    }
    Write-Host "  [$($result.Status)] $($result.Name)" -ForegroundColor $color
}

Write-Host ""
Write-Host "Results: $passCount passed, $warnCount warnings, $failCount failed" -ForegroundColor Cyan

if ($failCount -eq 0 -and $warnCount -eq 0) {
    Write-Host ""
    Write-Host "[ok] All tests passed! Deployment is healthy." -ForegroundColor Green
    exit 0
} elseif ($failCount -eq 0) {
    Write-Host ""
    Write-Host "WARNING Deployment has warnings but is functional." -ForegroundColor Yellow
    exit 0
} else {
    Write-Host ""
    Write-Host "[fail] Deployment has failures. Please investigate." -ForegroundColor Red
    exit 1
}
