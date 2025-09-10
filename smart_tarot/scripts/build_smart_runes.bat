@echo off
REM Smart Runes - Build Script for Windows
REM Builds the Smart Runes app with Runes-specific configuration

setlocal EnableDelayedExpansion

echo.
echo =========================================
echo   ᚱ Building Smart Runes Application
echo =========================================
echo.

REM Set app-specific environment variables
set "APP_TECHNIQUE=runes"
set "APP_NAME=Smart Runes"
set "PRIMARY_COLOR=0xFF059669"
set "BUILD_ENV=production"

REM API Configuration (load from .env file or set defaults)
if exist ".env" (
    echo Loading environment variables from .env...
    for /f "tokens=1,2 delims==" %%a in (.env) do (
        set "%%a=%%b"
    )
) else (
    echo Warning: .env file not found. Using default configuration.
    set "API_BASE_URL=https://smart-divination.vercel.app"
    set "RANDOM_ORG_API_KEY="
    set "DEEPSEEK_API_KEY="
    set "ENABLE_ANALYTICS=false"
    set "ENABLE_CRASHLYTICS=false"
)

REM Validate required environment
if "%RANDOM_ORG_API_KEY%"=="" (
    echo Error: RANDOM_ORG_API_KEY not set in .env file
    echo This is required for production builds
    exit /b 1
)

if "%DEEPSEEK_API_KEY%"=="" (
    echo Error: DEEPSEEK_API_KEY not set in .env file  
    echo This is required for production builds
    exit /b 1
)

echo Configuration:
echo   • Technique: %APP_TECHNIQUE%
echo   • App Name: %APP_NAME%
echo   • Environment: %BUILD_ENV%
echo   • Primary Color: %PRIMARY_COLOR%
echo   • API Base URL: %API_BASE_URL%
echo   • Analytics: %ENABLE_ANALYTICS%
echo.

REM Clean previous builds
echo Cleaning previous builds...
flutter clean
if errorlevel 1 (
    echo Error: Flutter clean failed
    exit /b 1
)

REM Get dependencies
echo Getting Flutter dependencies...
flutter pub get
if errorlevel 1 (
    echo Error: Flutter pub get failed
    exit /b 1
)

REM Generate code
echo Generating Dart code...
dart run build_runner build --delete-conflicting-outputs
if errorlevel 1 (
    echo Error: Code generation failed
    exit /b 1
)

REM Build Android APK
if "%1"=="android" or "%1"=="all" (
    echo.
    echo 📱 Building Android APK...
    flutter build apk ^
        --dart-define=APP_TECHNIQUE=%APP_TECHNIQUE% ^
        --dart-define=APP_NAME="%APP_NAME%" ^
        --dart-define=PRIMARY_COLOR=%PRIMARY_COLOR% ^
        --dart-define=BUILD_ENV=%BUILD_ENV% ^
        --dart-define=API_BASE_URL=%API_BASE_URL% ^
        --dart-define=RANDOM_ORG_API_KEY=%RANDOM_ORG_API_KEY% ^
        --dart-define=DEEPSEEK_API_KEY=%DEEPSEEK_API_KEY% ^
        --dart-define=ENABLE_ANALYTICS=%ENABLE_ANALYTICS% ^
        --dart-define=ENABLE_CRASHLYTICS=%ENABLE_CRASHLYTICS% ^
        --target-platform android-arm,android-arm64,android-x64 ^
        --split-per-abi ^
        lib/app/smart_runes.dart
    
    if errorlevel 1 (
        echo Error: Android APK build failed
        exit /b 1
    )
    
    echo ✅ Android APK built successfully
    echo Location: build\app\outputs\flutter-apk\
    echo.
)

REM Build Android App Bundle (for Play Store)
if "%1"=="bundle" or "%1"=="all" (
    echo.
    echo 📦 Building Android App Bundle...
    flutter build appbundle ^
        --dart-define=APP_TECHNIQUE=%APP_TECHNIQUE% ^
        --dart-define=APP_NAME="%APP_NAME%" ^
        --dart-define=PRIMARY_COLOR=%PRIMARY_COLOR% ^
        --dart-define=BUILD_ENV=%BUILD_ENV% ^
        --dart-define=API_BASE_URL=%API_BASE_URL% ^
        --dart-define=RANDOM_ORG_API_KEY=%RANDOM_ORG_API_KEY% ^
        --dart-define=DEEPSEEK_API_KEY=%DEEPSEEK_API_KEY% ^
        --dart-define=ENABLE_ANALYTICS=%ENABLE_ANALYTICS% ^
        --dart-define=ENABLE_CRASHLYTICS=%ENABLE_CRASHLYTICS% ^
        lib/app/smart_runes.dart
    
    if errorlevel 1 (
        echo Error: Android App Bundle build failed
        exit /b 1
    )
    
    echo ✅ Android App Bundle built successfully
    echo Location: build\app\outputs\bundle\release\
    echo.
)

REM Build iOS (if on macOS with Xcode)
if "%1"=="ios" or "%1"=="all" (
    echo.
    echo 🍎 Building iOS IPA...
    flutter build ipa ^
        --dart-define=APP_TECHNIQUE=%APP_TECHNIQUE% ^
        --dart-define=APP_NAME="%APP_NAME%" ^
        --dart-define=PRIMARY_COLOR=%PRIMARY_COLOR% ^
        --dart-define=BUILD_ENV=%BUILD_ENV% ^
        --dart-define=API_BASE_URL=%API_BASE_URL% ^
        --dart-define=RANDOM_ORG_API_KEY=%RANDOM_ORG_API_KEY% ^
        --dart-define=DEEPSEEK_API_KEY=%DEEPSEEK_API_KEY% ^
        --dart-define=ENABLE_ANALYTICS=%ENABLE_ANALYTICS% ^
        --dart-define=ENABLE_CRASHLYTICS=%ENABLE_CRASHLYTICS% ^
        lib/app/smart_runes.dart
    
    if errorlevel 1 (
        echo Error: iOS IPA build failed
        exit /b 1
    )
    
    echo ✅ iOS IPA built successfully
    echo Location: build\ios\ipa\
    echo.
)

REM Build Web (for testing)
if "%1"=="web" (
    echo.
    echo 🌐 Building Web Application...
    flutter build web ^
        --dart-define=APP_TECHNIQUE=%APP_TECHNIQUE% ^
        --dart-define=APP_NAME="%APP_NAME%" ^
        --dart-define=PRIMARY_COLOR=%PRIMARY_COLOR% ^
        --dart-define=BUILD_ENV=%BUILD_ENV% ^
        --dart-define=API_BASE_URL=%API_BASE_URL% ^
        --dart-define=RANDOM_ORG_API_KEY=%RANDOM_ORG_API_KEY% ^
        --dart-define=DEEPSEEK_API_KEY=%DEEPSEEK_API_KEY% ^
        --dart-define=ENABLE_ANALYTICS=%ENABLE_ANALYTICS% ^
        --dart-define=ENABLE_CRASHLYTICS=%ENABLE_CRASHLYTICS% ^
        lib/app/smart_runes.dart
    
    if errorlevel 1 (
        echo Error: Web build failed
        exit /b 1
    )
    
    echo ✅ Web application built successfully
    echo Location: build\web\
    echo.
)

if "%1"=="" (
    echo Usage: build_smart_runes.bat [android^|bundle^|ios^|web^|all]
    echo.
    echo Examples:
    echo   build_smart_runes.bat android    - Build Android APK only
    echo   build_smart_runes.bat bundle     - Build Android App Bundle only
    echo   build_smart_runes.bat ios        - Build iOS IPA only
    echo   build_smart_runes.bat web        - Build Web application only
    echo   build_smart_runes.bat all        - Build all platforms
    echo.
)

echo.
echo =========================================
echo   ᚱ Smart Runes Build Complete!
echo =========================================
echo.

endlocal