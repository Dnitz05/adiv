# Legacy Notice

This guide belongs to the legacy `smart_tarot/` tree. The canonical backend and up-to-date build instructions live under `smart-divination/`.

See: `smart-divination/README.md` and `smart-divination/backend/`.

---

# ðŸš€ Smart Divination - Build Guide

**One Codebase â†’ Three Professional Applications**

This guide explains how to build Smart Tarot, Smart I Ching, and Smart Runes from the unified Smart Divination codebase.

## ðŸ—ï¸ Architecture Overview

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚                    UNIFIED CODEBASE                        â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â” â”‚
â”‚  â”‚    Core     â”‚  â”‚   Shared    â”‚  â”‚       Packs         â”‚ â”‚
â”‚  â”‚   Engine    â”‚  â”‚  Services   â”‚  â”‚  Configuration      â”‚ â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜ â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                           â–¼
                  Environment Variables
                 â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
                 â”‚  APP_TECHNIQUE=X    â”‚
                 â”‚  APP_NAME=Y         â”‚
                 â”‚  PRIMARY_COLOR=Z    â”‚
                 â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                           â–¼
       â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
       â”‚               BUILD PROCESS                     â”‚
       â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                           â–¼
  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
  â”‚ Smart Tarot â”‚  â”‚Smart I Chingâ”‚  â”‚  Smart Runes    â”‚
  â”‚     ðŸƒ      â”‚  â”‚     â˜¯ï¸      â”‚  â”‚       áš±         â”‚
  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

## ðŸ”§ Prerequisites

### Required Software
- **Flutter SDK** 3.24.0 or higher
- **Dart SDK** 3.5.0 or higher  
- **Android Studio** with Android SDK (for Android builds)
- **Xcode** 15.0+ (for iOS builds, macOS only)
- **Node.js** 18+ (for backend deployment)

### Required API Keys
- **Random.org API Key** - For cryptographic randomness
  - Get from: https://api.random.org/json-rpc/4/signing
  - Required for production builds
- **DeepSeek API Key** - For AI interpretations
  - Get from: https://platform.deepseek.com/
  - Required for production builds

## âš™ï¸ Environment Setup

### 1. Clone and Setup
```bash
git clone https://github.com/your-org/smart-divination.git
cd smart-divination
flutter pub get
```

### 2. Configure Environment
```bash
# Copy environment template
copy .env.example .env

# Edit .env with your API keys and configuration
# Required fields for production:
# RANDOM_ORG_API_KEY=your_api_key_here
# DEEPSEEK_API_KEY=your_api_key_here
```

### 3. Generate Code
```bash
dart run build_runner build --delete-conflicting-outputs
```

## ðŸ“± Building Applications

### Quick Start - Build All Apps
```bash
# Build Android App Bundles for all three apps
scripts\build_all_apps.bat bundle

# Build Android APKs for all three apps  
scripts\build_all_apps.bat android

# Build iOS IPAs for all three apps
scripts\build_all_apps.bat ios
```

### Individual App Builds

#### Smart Tarot ðŸƒ
```bash
# Android App Bundle (for Google Play)
scripts\build_smart_tarot.bat bundle

# Android APK (for testing)
scripts\build_smart_tarot.bat android

# iOS IPA (for App Store)
scripts\build_smart_tarot.bat ios

# Web build (for testing)
scripts\build_smart_tarot.bat web
```

#### Smart I Ching â˜¯ï¸
```bash
# Android App Bundle
scripts\build_smart_iching.bat bundle

# Android APK
scripts\build_smart_iching.bat android

# iOS IPA
scripts\build_smart_iching.bat ios

# Web build
scripts\build_smart_iching.bat web
```

#### Smart Runes áš±
```bash
# Android App Bundle
scripts\build_smart_runes.bat bundle

# Android APK
scripts\build_smart_runes.bat android

# iOS IPA  
scripts\build_smart_runes.bat ios

# Web build
scripts\build_smart_runes.bat web
```

## ðŸŽ¯ App Configurations

Each app is configured via environment variables and pack manifests:

### Smart Tarot
- **Technique**: `tarot`
- **Primary Color**: Purple (`#4C1D95`)
- **Bundle ID**: `com.smartdivination.tarot`
- **Features**: 78-card deck, Celtic Cross, reversed cards

### Smart I Ching
- **Technique**: `iching`  
- **Primary Color**: Red (`#DC2626`)
- **Bundle ID**: `com.smartdivination.iching`
- **Features**: 64 hexagrams, changing lines, traditional wisdom

### Smart Runes
- **Technique**: `runes`
- **Primary Color**: Green (`#059669`)
- **Bundle ID**: `com.smartdivination.runes`
- **Features**: 24 Elder Futhark runes, Norse mythology, bindrunes

## ðŸ“¦ Build Outputs

After successful builds, find your apps here:

### Android
- **APK Files**: `build/app/outputs/flutter-apk/`
- **App Bundles**: `build/app/outputs/bundle/release/`

### iOS
- **IPA Files**: `build/ios/ipa/`

### Web
- **Web Apps**: `build/web/`

## ðŸ” Troubleshooting

### Common Build Issues

#### Missing API Keys
```
Error: RANDOM_ORG_API_KEY not set in .env file
```
**Solution**: Copy `.env.example` to `.env` and add your API keys.

#### Flutter SDK Issues
```
Error: Flutter SDK not found
```
**Solution**: Install Flutter SDK and add to PATH.

#### Code Generation Errors
```
Error: Code generation failed
```
**Solution**: Run `dart run build_runner clean` then `dart run build_runner build --delete-conflicting-outputs`.

#### iOS Build Issues (macOS only)
```
Error: Xcode not found
```
**Solution**: Install Xcode from Mac App Store and run `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`.

### Build Verification

#### Test Your Builds
1. **Install APK/IPA** on test devices
2. **Verify technique-specific content** loads correctly  
3. **Test API connectivity** (Random.org, DeepSeek)
4. **Confirm in-app purchases** work (production only)
5. **Check analytics** integration

#### Performance Checks
- App startup time < 3 seconds
- Memory usage < 100MB during normal operation
- Battery usage acceptable during extended sessions
- Network requests complete within timeout limits

## ðŸš€ Deployment

### App Store Preparation

#### Google Play Store
1. Build with `scripts\build_smart_[app].bat bundle`
2. Upload `.aab` files to Google Play Console
3. Configure store listings with app-specific content
4. Set up in-app billing products
5. Submit for review

#### Apple App Store  
1. Build with `scripts\build_smart_[app].bat ios`
2. Upload `.ipa` files via Xcode or Transporter
3. Configure App Store Connect listings
4. Set up in-app purchase products
5. Submit for review

### Backend Deployment
The Vercel backend (`pages/api/`) supports all three apps automatically. Deploy once:

```bash
npm install -g vercel
vercel --prod
```

## ðŸ” Security Considerations

### API Key Security
- âœ… Never commit `.env` to version control
- âœ… Use environment-specific API keys
- âœ… Rotate API keys regularly
- âœ… Monitor API usage for suspicious activity

### Build Security
- âœ… Use signed release builds for production
- âœ… Enable code obfuscation for Flutter releases
- âœ… Validate all environment variables
- âœ… Use secure build environments

## ðŸ“Š Monitoring

### Build Pipeline Monitoring
- Build success/failure rates
- Build duration trends  
- Code coverage metrics
- Security vulnerability scans

### Application Monitoring
- Crash rates per app
- User engagement metrics
- API response times
- Revenue analytics

## ðŸ†˜ Support

### Build Issues
1. Check this guide first
2. Review build logs for specific errors
3. Search existing issues in repository
4. Create issue with full build logs

### Architecture Questions  
- Review `ROADMAP.md` for implementation details
- Check code documentation and comments
- Consult the architecture diagrams

## ðŸŽ‰ Success Checklist

After successful builds, verify:

- [ ] **Three distinct apps** built from one codebase
- [ ] **Technique-specific branding** applied correctly
- [ ] **API keys** configured and working
- [ ] **Pack configurations** loading properly
- [ ] **Core functionality** working in each app
- [ ] **Build artifacts** ready for app store submission

---

## ðŸ“ Build Commands Reference

```bash
# Quick build all apps (Android App Bundles)
scripts\build_all_apps.bat bundle

# Individual app builds
scripts\build_smart_tarot.bat [android|bundle|ios|web|all]
scripts\build_smart_iching.bat [android|bundle|ios|web|all]  
scripts\build_smart_runes.bat [android|bundle|ios|web|all]

# Development builds (faster, less optimized)
flutter run --dart-define=APP_TECHNIQUE=tarot lib/app/smart_tarot.dart

# Clean everything
flutter clean && flutter pub get
```

**ðŸš€ Ready to build the future of divination apps!**
