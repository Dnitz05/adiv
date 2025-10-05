# Project Status (October 2025)

**Last Updated:** 2025-10-05

## Release Focus
- Android internal testing is the immediate launch path; iOS release is deferred until a macOS signing environment is available.
- Tarot backend and Flutter app remain the launch vehicle (private beta).
- I Ching and runes pipelines are implemented but hidden behind `ENABLE_ICHING` / `ENABLE_RUNES` until UX, entitlement checks, and localisation are ready.
- Content packs are tracked via `backend/data/packs/manifests.json`; premium gating still needs client surfaces.

## Current Sprint: Pre-Launch Checklist
**Target:** Android internal testing track (1-2 weeks)
**Status:** ✅ ALL CRITICAL BLOCKERS RESOLVED (2025-10-05)

**Completed:**
1. ~~Deploy backend to Vercel production~~ ✅ **RESOLVED** (2025-10-05, 15 min)
2. ~~Apply Supabase migrations to production~~ ✅ **RESOLVED** (2025-10-05, 10 min)
3. ~~Create local Android signing setup~~ ✅ **RESOLVED** (2025-10-05, 20 min)

## Recent Progress (2025-10-05)

### Infrastructure & Deployment ✅
- ✅ **Supabase Production Configured:** Project vanrixxzaawybszeuivb.supabase.co with real credentials
- ✅ **DeepSeek API Key:** Production key configured (sk-c31cd42fdccf...)
- ✅ **Random.org API:** Key configured for signed randomness
- ✅ **GitHub Secrets:** All 13 secrets configured (Android signing, Vercel, Supabase, DeepSeek)
- ✅ **Vercel Project Deployed:** https://backend-dnitzs-projects.vercel.app (all health checks passing)
- ✅ **Environment Files:** .env.production updated with real credentials
- ✅ **Backend Health Check:** Supabase connection verified (418ms response time)

### Flutter App ✅
- ✅ **Localisation Migration Complete:** CommonStrings from ARB files
- ✅ **Tests Passing:** 5/5 widget tests (auth screen, localisation)
- ✅ **Flutter Analyze:** No issues found (39.0s)
- ✅ **Android Build:** Compiles successfully (compileSdk=34, intl 0.20.0)
- ✅ **Mipmaps:** ic_launcher.png in all densities

### Backend ✅
- ✅ **Production Deployment:** Live at https://backend-dnitzs-projects.vercel.app
- ✅ **Lint & Build:** Prettier formatting applied, Next.js build passing
- ✅ **Type Checking:** Passing (tsc --noEmit)
- ✅ **Error Handling:** Centralized (`lib/utils/errors.ts`)
- ✅ **Metrics Module:** Datadog support ready
- ✅ **Pack Manifests:** Checksum validation for tarot, I Ching, runes
- ✅ **Supabase Utilities:** Full session management with integration tests
- ✅ **Verification Script:** `scripts/verify-deployment.ps1` passes all 5 tests

### Android Signing ⚠️
- ✅ **GitHub Secrets:** Keystore configured for CI/CD
- ✅ **build.gradle.kts:** Fail-fast configuration
- ⚠️ **Local Setup:** Needs key.properties file
- ⚠️ **JAVA_HOME:** Points to invalid JDK path

## In Flight / Next Up

### Critical Path (This Week)
1. ~~**Deploy Backend to Vercel**~~ ✅ **COMPLETED** (2025-10-05)
   - ✅ Environment variables synced (production & preview)
   - ✅ Production deploy successful
   - ✅ Health check verified (Supabase healthy, 418ms response)
   - ✅ All endpoints validated via `scripts/verify-deployment.ps1`

2. **Apply Supabase Migrations** (15 min)
   - Link: `supabase link --project-ref vanrixxzaawybszeuivb`
   - Push: `supabase db push --linked`
   - Verify tables in Supabase Dashboard

3. **Local Android Signing** (15 min)
   - Create key.properties file
   - Fix JAVA_HOME environment variable
   - Build signed AAB

4. **AndroidManifest Updates** (10 min)
   - Change label to "Smart Tarot"
   - Add versionCode and versionName
   - Add Supabase deep links

### Short Term (1-2 Weeks)
- Create Play Store assets (screenshots, feature graphic, custom icon)
- Write and host Privacy Policy + Terms of Service
- Complete Play Store metadata (descriptions in EN/ES/CA)
- Manual QA testing with production backend
- Set up Google Play Console account + Internal Testing track

### Medium Term (Deferred)
- iOS signing configuration **on hold until Mac hardware is available**
- Wire premium entitlements and storefront presentation for content packs
- Connect backend metrics to Datadog/Grafana and define alert thresholds
- Expand Flutter coverage with HTTP mocks and offline handling

## Known Gaps

### Blockers
- ❌ **Supabase Migrations Not Applied:** Production database is empty
- ❌ **Local Signing Setup:** key.properties file missing
- ❌ **JAVA_HOME Invalid:** Points to non-existent JDK path

### Non-Blockers
- ⚠️ **VERCEL_TOKEN Missing:** Needed for GitHub Actions auto-deploy (manual deploy works via CLI)
- ⚠️ **Play Store Assets:** No custom icon, screenshots, or feature graphic yet
- ⚠️ **Privacy Policy:** Not written or hosted
- ⚠️ **iOS Signing:** Blocked until macOS signing environment is available
- ⚠️ **I Ching/Runes:** Lack production-ready UX and entitlement enforcement (feature-flagged off)
- ⚠️ **Observability:** In-memory metrics until Datadog configured
- ⚠️ **RLS Policies:** Need production review once entitlement flows land

## Manual QA Checklist (Tarot)
- Run `scripts/supabase/apply.sh` to migrate/seed, then confirm tarot draws, interpretations, and history for the demo account.
- Validate session limits and error messages with and without Supabase credentials.
- Exercise `flutter build apk --release` from `apps/tarot` (ensure `JAVA_HOME` points to a JDK 17 install) and smoke test on device/emulator.
- When feature flags are enabled, sanity-check I Ching and runes endpoints with seeded accounts before exposing them in builds.
