# Screenshots guide - Smart Tarot Android

Quick guide to capture Play Store screenshots for the internal testing release.

---

## Requirements

- Minimum: 2 screenshots (1080x1920 or higher)
- Recommended: 4-8 screenshots showing key flows
- Format: PNG or JPEG
- Target location: `docs/store-assets/screenshots/android/`

---

## Setup

### 1. Start Android emulator or connect physical device

**Emulator (recommended for consistent screenshots):**
```bash
# List available emulators
emulator -list-avds

# Start a Pixel 6 or similar device (1080x2400)
emulator -avd Pixel_6_API_34 &
```

**Physical device:**
- Enable USB debugging
- Connect via USB
- Verify with `adb devices`

### 2. Build and run the app with production backend

```bash
cd C:/tarot/smart-divination/apps/tarot

flutter run --dart-define=API_BASE_URL=https://backend-4sircya71-dnitzs-projects.vercel.app --dart-define=SUPABASE_URL=https://vanrixxzaawybszeuivb.supabase.co --dart-define=SUPABASE_ANON_KEY=$env:SUPABASE_ANON_KEY
```

**Note**: Replace `$env:SUPABASE_ANON_KEY` with the actual anon key from GitHub Secrets or Vercel dashboard.

---

## Screenshots to capture

### Screenshot 1: Authentication / Onboarding (REQUIRED)
- Shows: Login/signup screen or welcome screen
- Purpose: First impression for users
- Action: Open app, capture initial screen

### Screenshot 2: Three-card spread draw (REQUIRED)
- Shows: Cards displayed in a spread layout
- Purpose: Core functionality showcase
- Action:
  1. Complete authentication
  2. Navigate to tarot draw
  3. Select "Three Card Spread"
  4. Perform draw
  5. Capture cards displayed

### Screenshot 3: AI interpretation results (RECOMMENDED)
- Shows: AI-generated interpretation text
- Purpose: Highlight AI feature
- Action:
  1. After draw, tap "Get Interpretation" or similar
  2. Wait for AI response
  3. Capture interpretation screen

### Screenshot 4: Session history (RECOMMENDED)
- Shows: List of past readings
- Purpose: Demonstrate session persistence
- Action:
  1. Navigate to history/profile section
  2. Capture list of past sessions

### Optional screenshots (5-8):
- Card detail view (single card with meanings)
- Settings/profile page
- Celtic Cross spread (10 cards)
- Different spread types selection

---

## Capturing screenshots

### Method 1: ADB command (cleanest, no status bar artifacts)
```bash
# Take screenshot and save to device
adb shell screencap -p /sdcard/screenshot_01.png

# Pull to computer
adb pull /sdcard/screenshot_01.png C:/tarot/docs/store-assets/screenshots/android/01_authentication.png

# Clean up device
adb shell rm /sdcard/screenshot_01.png
```

Repeat for each screenshot, naming them sequentially:
- `01_authentication.png`
- `02_three_card_draw.png`
- `03_ai_interpretation.png`
- `04_session_history.png`

### Method 2: Emulator screenshot button
- Click camera icon in emulator toolbar
- Screenshots saved to: `%USERPROFILE%\Pictures\Screenshots` (Windows)
- Manually copy to `C:/tarot/docs/store-assets/screenshots/android/`

### Method 3: Device screenshot (for physical devices)
- Use device hardware buttons (Power + Volume Down)
- Transfer via USB or cloud
- Copy to `C:/tarot/docs/store-assets/screenshots/android/`

---

## Post-capture checklist

After capturing screenshots:

1. ✅ Verify resolution (minimum 1080x1920, higher is better)
2. ✅ Check file size (under 8MB per image)
3. ✅ Rename with descriptive names
4. ✅ Verify no sensitive data visible (test accounts only)
5. ✅ Review for visual quality (no blur, good contrast)
6. ✅ Update `ANDROID_LAUNCH_CHECKLIST.md` status to complete

---

## Verification

Run this command to verify screenshots are present:
```bash
ls -lh C:/tarot/docs/store-assets/screenshots/android/
```

Expected output: 2-8 PNG/JPEG files, each 1080x1920 or higher.

---

## Troubleshooting

**Issue**: App crashes on startup
- **Fix**: Verify `API_BASE_URL` and `SUPABASE_*` environment variables are correct
- **Check**: Backend health endpoint: `curl https://backend-4sircya71-dnitzs-projects.vercel.app/api/health`

**Issue**: Can't authenticate
- **Fix**: Create test account in Supabase dashboard first
- **Or**: Use anonymous/guest mode if available

**Issue**: Screenshots too small
- **Fix**: Use emulator with higher resolution (Pixel 6 Pro: 1440x3120)
- **Or**: Use `adb shell wm size` to check device resolution

**Issue**: AI interpretation not working
- **Fix**: Verify `DEEPSEEK_API_KEY` is set in Vercel environment variables
- **Check**: Backend logs for API errors

---

## Next steps after screenshots

Once screenshots are captured and saved:

1. Create feature graphic (1024x500) using a design tool
2. Finalize Play Store copy in `docs/store-metadata/play_store_copy.md`
3. Host privacy policy and terms of service
4. Configure Google Play Console
5. Upload APK/AAB to Internal Testing track

See `ANDROID_LAUNCH_CHECKLIST.md` for complete pre-launch checklist.
