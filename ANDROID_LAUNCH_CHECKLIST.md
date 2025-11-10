# Android launch checklist - Smart Tarot

Structured list of tasks to complete before publishing the Smart Tarot Android app to Google Play.

---

## Phase 1: critical technical fixes (high priority)

### Status overview
All launch-critical blockers were cleared on 2025-10-05 (backend, Supabase migrations, Android signing in CI/CD).

### 1.1 Resolve Android build failure
Status: complete
- compileSdk override for app_links applied
- `flutter build apk --release` succeeds
- Test suite (5/5) passing

### 1.2 Localisation migration
Status: complete
- Apps consume `CommonStrings`
- Legacy localisation wrapper removed
- `melos run analyze:all` and `melos run test:all` passing

### 1.3 Backend and database production deployment
Status: complete (2025-10-05)
- Backend: https://backend-gv4a2ueuy-dnitzs-projects.vercel.app
- Supabase project: vanrixxzaawybszeuivb.supabase.co
- Migrations applied: initial schema + session history schema
- Tables online: users, sessions, session_artifacts, session_messages
- Environment variables configured in Vercel and GitHub Secrets
- Health check: Supabase healthy (~1 s), endpoints verified

### 1.4 Android release signing setup
Status: âœ… Complete (2025-10-16)
- GitHub Secrets: ANDROID_KEYSTORE_BASE64 / PASSWORD / ALIAS / KEY_PASSWORD configured
- `build.gradle.kts` configured with signing (fails fast if config missing)
- Helper scripts: `scripts/android/setup_local_signing.ps1`, `scripts/android/decode_keystore.ps1`
- Local setup complete:
  * Keystore generated: `android/upload-keystore.jks` (password: SmartTarot2025!, alias: upload)
  * `android/key.properties` configured with signing credentials
  * Signed release APK built and tested: 55MB (`app-release.apk`)
  * Signed release AAB generated: 45.7MB (`app-release.aab`)
  * App successfully installed and runs on physical Android device

Build command for release:
```
flutter build appbundle --release   --dart-define=API_BASE_URL=https://backend-gv4a2ueuy-dnitzs-projects.vercel.app   --dart-define=SUPABASE_URL=https://vanrixxzaawybszeuivb.supabase.co   --dart-define=SUPABASE_ANON_KEY=<anon-key>
```

### 1.5 Lint and polish
Status: clean
- `flutter analyze` reports no issues (39 s)
- Optional: remove legacy ignore comments, apply const constructors, tidy async contexts

---

## Phase 2: assets and store content (high priority)

### 2.1 App icon and splash screen
Status: âœ… Icon complete, splash pending
- âœ… Custom 1024x1024 launcher icon integrated (`smart-divination/apps/tarot/assets/app_icon/icon.png`) via `flutter_launcher_icons`
- âœ… Adaptive background color set to `#8C52FF`; all mipmaps regenerated
- âœ… Master artwork stored at `docs/store-assets/icon.png` (export 512x512 for Play Console branding)
- âœ… `AndroidManifest.xml` label updated to "Smart Tarot"
- â³ Produce 1920x1080 splash artwork
- â³ Configure flutter_native_splash or custom launch screen assets

### 2.2 Screenshots
Status: not started
- Capture at least two 1080x1920 screenshots covering:
  * Authentication / onboarding
  * Three-card spread draw
  * AI interpretation
  * Session history
- Save under `docs/store-assets/screenshots/android/`

### 2.3 Feature graphic
Status: not started
- Create 1024x500 marketing banner with title and short copy

### 2.4 Promo video (optional)
Status: optional
- Suggested length: 30-60 seconds showing key flows

---

## Phase 3: metadata and documentation (medium priority)

### 3.1 Play Store descriptions
Status: not started
- Title (30 chars max): draft `Smart Tarot - AI Divination`
- Short description (80 chars max)
- Long description (4000 chars max) covering value props, features, privacy
- Localise copy for EN, ES, CA (see `docs/store-metadata/play_store_copy.md`)

### 3.2 Privacy policy and terms
Status: not started
- Draft GDPR-compliant privacy policy (template in `docs/store-metadata/privacy_policy_template.md`)
- Draft terms of service (template in `docs/store-metadata/terms_template.md`)
- Host both documents publicly and link from the app and Play Console listing

---

## Phase 4: release management (medium priority)

### 4.1 Google Play Console setup
Status: not started
- Create Google Play Developer account ($25)
- Register `com.smartdivination.tarot`
- Configure Internal Testing track and tester list

### 4.2 Upload signed AAB
Status: not started
- Generate signed AAB (CI/CD or local once keystore available)
- Upload to Internal Testing track and provide release notes

### 4.3 Monitoring and follow-up
Status: not started
- Monitor publishing overview
- Review pre-launch report
- Capture tester feedback and triage issues

---

## Security note
Secrets were exposed during deployment automation on 2025-10-05. All Supabase, DeepSeek, and Random.org keys were rotated on 2025-10-06 (`SECURITY_INCIDENT_RESPONSE.md`).
