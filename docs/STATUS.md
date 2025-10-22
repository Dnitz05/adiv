# Project Status (October 2025)

Last Updated: 2025-10-22

## Current Status: Android Release Ready
**Focus:** Android signing complete. App successfully tested on physical device. Ready for Play Store assets creation and submission.

## Release Focus
- Android internal testing is the immediate launch path; iOS is deferred until Mac signing hardware is available.
- Tarot backend and Flutter app stay as the launch vehicle (private beta).
- I Ching and runes pipelines exist but remain behind ENABLE_ICHING / ENABLE_RUNES until UX, entitlements, and localisation are ready.
- Content packs live in backend/data/packs/manifests.json; the client entitlement surface is still pending.

## Current Sprint: Pre-Launch Checklist
Target: Android internal testing track (1-2 weeks)
Status: critical blockers cleared on 2025-10-05

Completed work (total ~45 minutes once secrets were available):
1. Deploy backend to Vercel production (15 min)
2. Apply Supabase migrations to production (10 min)
3. Configure Android signing for CI/CD (20 min)
4. Fix Android build failure (app_links compileSdk)
5. Finish localisation migration to CommonStrings

## Recent Progress (2025-10-22)

### UX & Visual Improvements
- **Mystical Background**: Home screen now features Solaris Tarot starry texture background with central sun and scattered stars on deep purple-blue gradient at 30% opacity. Creates rich atmospheric depth while maintaining readability.
- **Auto Celtic Cross**: When question field is left empty, automatically selects Celtic Cross (10-card) spread for comprehensive general consultations. Skips AI spread recommendation to save time.
- **Functional Header**: Replaced logo with 5 actionable icons (Home, Chat, Spreads, Archive, Settings) in top header bar. Clean vertical icon+text layout. Removed duplicate QuickActions from below text field for streamlined UX.
- **Spread Gallery Layout**: Increased diagram size from 38% to 50% of screen height, making Celtic Cross cards significantly larger and more readable. Fixed text section to 25% max height with scrolling.
- **AI Content Quality**: Completely rewritten "Why this spread?" content with rich 30-50 word bullets (previously 10-15 words). Removed generic intro sentences. First bullet explains WHY the spread is perfect, second provides concrete reading guidance. Increased Gemini temperature to 0.9 and maxTokens to 700 for deeper insights.
- **App Icon**: Updated launcher icon with textured sun design. Features large central sun with 10 pointed rays and granular texture on starry night background. Regenerated all adaptive icons for Android & iOS.
- **Daily Quotes**: Removed author attribution, showing only quote text for cleaner presentation.

## Recent Progress (2025-10-18)

### UX & AI polish
- Added the AI question formatter endpoint (`POST /api/questions/format`) and updated the Flutter client so even “Consulta General” passes through DeepSeek before hitting the backend.
- When the user leaves the prompt empty, the app now nudges them with a localized tip and still performs the draw using a contextual general question.
- Backend draw endpoint now reuses the canonical spread catalog, preventing `INVALID_SPREAD` errors when the recommender picks spreads like `two_card` or `five_card_cross`.
- Spread reasoning text was rewritten to be more empathetic and didactic in CA/ES/EN without the old “Key factors detected…” boilerplate.

## Recent Progress (2025-10-13)

### Infrastructure & Deployment
- Backend production URL: https://backend-jnmkq4odo-dnitzs-projects.vercel.app (health check OK)
- Supabase project vanrixxzaawybszeuivb.supabase.co linked and migrated
- Tables: users, sessions, session_artifacts, session_messages (created via migrations)
- GitHub secrets: 13/13 configured (Android signing, Vercel IDs, Supabase, DeepSeek, Random.org)
- Vercel environment variables: production set in dashboard/CLI
- DeepSeek and Random.org integrations tested (Random.org marked degraded but fallback available)

### Flutter Workspace
- Localisation migration complete; all apps use `CommonStrings`
- Widget tests: 5/5 passing
- `flutter analyze`: clean run (39 s)
- Android build: succeeds with compileSdk 34 and `intl` 0.20.0
- Launcher icon refreshed via `flutter_launcher_icons` (asset at `apps/tarot/assets/app_icon/icon.png`, adaptive background `#8C52FF`)
- Splash artwork and theming polish still pending

### Backend
- Production deployment verified via `scripts/verify-deployment.ps1`
- Lint, build, and type-check pass (`npm run lint`, `npm run build`, `npm run type-check`)
- Centralised error handling in `lib/utils/errors.ts`
- Metrics module ready for Datadog but currently running in console mode
- Supabase session utilities covered by integration tests

### Android Signing
- ✅ CI/CD secrets cover keystore, passwords, and alias
- ✅ `build.gradle.kts` configured with signing (fails fast if config missing)
- ✅ Keystore generated: `upload-keystore.jks` (password: SmartTarot2025!, alias: upload)
- ✅ `android/key.properties` configured with signing credentials
- ✅ Release APK generated and tested: 55MB (`app-release.apk`)
- ✅ Release AAB generated: 45.7MB (`app-release.aab`)
- ✅ App successfully installed and runs on physical Android device
- Helper scripts available: `scripts/android/setup_local_signing.ps1` and `scripts/android/decode_keystore.ps1`

## Next Actions

Short term (immediate - post-signing phase):
- [x] Custom launcher icon integrated (adaptive icons regenerated across mipmaps)
- [x] Update `AndroidManifest.xml` label to "Smart Tarot"
- [x] Document physical-device testing workflow (`docs/RUN_ON_PHONE.md`)
- [x] Run the app on a physical phone and capture the real UI/UX state
- [x] Android signing complete (keystore, key.properties, signed APK/AAB)
- [x] App successfully tested on physical device
- [ ] Identify and prioritise design/UX improvements needed before Play Store screenshots
- [ ] Implement design iterations with hot reload testing
- [ ] Capture screenshots once design is ready (minimum 2 at 1080x1920; aim for 4-8)
- [ ] Create a 1024x500 feature graphic with final branding
- [ ] Produce a 1920x1080 splash artwork and wire up `flutter_native_splash`
- [ ] Host privacy policy and terms of service (EN/ES/CA) and link in Play Console
- [ ] Finalise and localise Play Store listing copy (see `docs/store-metadata/play_store_copy.md`)
- [ ] Configure Google Play Console developer account and Internal Testing track
- [ ] Run full manual QA against production backend (signup, draws, interpretations, history, limits)

Medium term:
- Implement premium entitlement flows and storefront surfaces
- Connect metrics to Datadog/Grafana and establish alert thresholds
- Expand Flutter test coverage with HTTP mocks and offline scenarios
- Resume iOS signing once Mac hardware is available

## Known Gaps
- `VERCEL_TOKEN` still missing (manual CLI deploys work; token needed to automate deploy-on-push)
- Play Store assets and metadata outstanding (screenshots, feature graphic, splash art)
- Privacy policy and terms not yet written or hosted
- I Ching and runes remain feature-flagged until UX and entitlements are finished
- Observability limited to console metrics; Datadog not yet configured
- Row level security policy review pending once entitlement flows land

## Recent Security Actions
- 2025-10-06: Rotated all secrets exposed during deployment automation (Supabase, DeepSeek, Random.org)
- Updated GitHub Secrets and Vercel environment variables with new credentials
- Redeployed backend and re-ran `scripts/verify-deployment.ps1`

## Manual QA Checklist (Tarot) - to schedule after assets/metadata
- Create production test accounts in Supabase
- Exercise signup, login, logout
- Run tarot draw and verify AI interpretation persists
- Check session history and limits (with and without credentials)
- Build release APK/AAB with production defines and corrected `JAVA_HOME`
- Smoke test on physical Android hardware
- Validate backend endpoints with `scripts/verify-deployment.ps1`

## Security Note
Secrets were briefly committed during automation on 2025-10-05. All exposed credentials (Supabase, DeepSeek, Random.org) were rotated on 2025-10-06. See `SECURITY_INCIDENT_RESPONSE.md` for full details.
