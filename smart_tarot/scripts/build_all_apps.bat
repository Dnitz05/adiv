@echo off
REM Build All Smart Divination Apps
REM Builds Smart Tarot, Smart I Ching, and Smart Runes applications

setlocal EnableDelayedExpansion

echo.
echo ==========================================
echo   🚀 Building All Smart Divination Apps
echo ==========================================
echo.

REM Check if .env file exists
if not exist ".env" (
    echo ❌ Error: .env file not found!
    echo.
    echo Please copy .env.example to .env and configure your API keys:
    echo   copy .env.example .env
    echo.
    echo Then edit .env with your actual API keys and configuration.
    echo.
    exit /b 1
)

REM Get build target from parameter
set "BUILD_TARGET=%1"
if "%BUILD_TARGET%"=="" (
    set "BUILD_TARGET=bundle"
    echo No build target specified, defaulting to 'bundle'
)

echo Building all apps for target: %BUILD_TARGET%
echo.

REM Track build results
set "SUCCESSFUL_BUILDS="
set "FAILED_BUILDS="

REM Build Smart Tarot
echo.
echo ==========================================
echo   🃏 Building Smart Tarot
echo ==========================================
call scripts\build_smart_tarot.bat %BUILD_TARGET%
if errorlevel 1 (
    echo ❌ Smart Tarot build FAILED
    set "FAILED_BUILDS=!FAILED_BUILDS! Smart-Tarot"
) else (
    echo ✅ Smart Tarot build SUCCESS  
    set "SUCCESSFUL_BUILDS=!SUCCESSFUL_BUILDS! Smart-Tarot"
)

REM Wait a moment between builds
timeout /t 2 /nobreak > nul

REM Build Smart I Ching
echo.
echo ==========================================
echo   ☯️ Building Smart I Ching
echo ==========================================
call scripts\build_smart_iching.bat %BUILD_TARGET%
if errorlevel 1 (
    echo ❌ Smart I Ching build FAILED
    set "FAILED_BUILDS=!FAILED_BUILDS! Smart-I-Ching"
) else (
    echo ✅ Smart I Ching build SUCCESS
    set "SUCCESSFUL_BUILDS=!SUCCESSFUL_BUILDS! Smart-I-Ching"
)

REM Wait a moment between builds
timeout /t 2 /nobreak > nul

REM Build Smart Runes
echo.
echo ==========================================
echo   ᚱ Building Smart Runes
echo ==========================================
call scripts\build_smart_runes.bat %BUILD_TARGET%
if errorlevel 1 (
    echo ❌ Smart Runes build FAILED
    set "FAILED_BUILDS=!FAILED_BUILDS! Smart-Runes"
) else (
    echo ✅ Smart Runes build SUCCESS
    set "SUCCESSFUL_BUILDS=!SUCCESSFUL_BUILDS! Smart-Runes"
)

REM Summary Report
echo.
echo ==========================================
echo   📊 Build Summary Report
echo ==========================================
echo.

if not "%SUCCESSFUL_BUILDS%"=="" (
    echo ✅ SUCCESSFUL BUILDS:
    for %%a in (%SUCCESSFUL_BUILDS%) do (
        echo    • %%a
    )
    echo.
)

if not "%FAILED_BUILDS%"=="" (
    echo ❌ FAILED BUILDS:
    for %%a in (%FAILED_BUILDS%) do (
        echo    • %%a
    )
    echo.
)

REM Count results
set "SUCCESS_COUNT=0"
set "FAIL_COUNT=0"

for %%a in (%SUCCESSFUL_BUILDS%) do (
    set /a SUCCESS_COUNT+=1
)

for %%a in (%FAILED_BUILDS%) do (
    set /a FAIL_COUNT+=1
)

echo Total Apps: 3
echo Successful: %SUCCESS_COUNT%
echo Failed: %FAIL_COUNT%
echo.

REM Show build output locations
if %SUCCESS_COUNT% gtr 0 (
    echo 📁 Build Output Locations:
    if "%BUILD_TARGET%"=="android" (
        echo    APK Files: build\app\outputs\flutter-apk\
    )
    if "%BUILD_TARGET%"=="bundle" (
        echo    App Bundles: build\app\outputs\bundle\release\
    )
    if "%BUILD_TARGET%"=="ios" (
        echo    IPA Files: build\ios\ipa\
    )
    if "%BUILD_TARGET%"=="web" (
        echo    Web Apps: build\web\
    )
    echo.
)

REM Show next steps
echo 📋 Next Steps:
echo    1. Test the built applications on target devices
echo    2. Upload to app stores (Google Play, App Store)
echo    3. Monitor deployment and user feedback
echo    4. Update analytics and crash reporting dashboards
echo.

REM Exit with error if any builds failed
if %FAIL_COUNT% gtr 0 (
    echo ⚠️  Warning: %FAIL_COUNT% build(s) failed. Check the logs above.
    exit /b 1
) else (
    echo 🎉 All builds completed successfully!
    exit /b 0
)

endlocal