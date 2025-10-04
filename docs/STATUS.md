# Project Status (October 2025)

## Release Focus
- Android internal testing is the immediate launch path; iOS release is deferred until a macOS signing environment is available.
- Tarot backend and Flutter app remain the launch vehicle (private beta).
- I Ching and runes pipelines are implemented but hidden behind `ENABLE_ICHING` / `ENABLE_RUNES` until UX, entitlement checks, and localisation are ready.
- Content packs are tracked via `backend/data/packs/manifests.json`; premium gating still needs client surfaces.

## Recent Progress
- Completed feature-flagged I Ching and runes draw endpoints with full data sets, Supabase session persistence, and deterministic seeding.
- Added pack manifest registry with checksum validation for tarot, I Ching, and runes assets.
- Expanded Supabase utilities (`createDivinationSession`, `createSessionArtifact`, `createSessionMessage`) and backed them with integration tests plus the `supabaseTestHarness` seeding workflow.
- Hardened the metrics module with Datadog support and improved latency/error tracking.
- Fixed backend compilation errors (line ending issues in `api.ts`, node-fetch compatibility).
- Standardized error handling with centralized error definitions (`lib/utils/errors.ts`).
- Health and metrics endpoints operational with Node.js runtime.
- Android signing fully configured (keystore generated, key.properties, build.gradle.kts).
- Resolved Android build failure (app_links compileSdk) by pinning compileSdk=34 and aligning intl 0.20.0; release builds now pass Flutter analyze/test.
- Release APK build tested and verified (48.3MB).
- Migrated shared localisation pipeline to generated CommonStrings with additional smoke tests in the common package.
- Production environment variables documented (`.env.production`, `.env.production.example`).
- Comprehensive secrets management guide created (`docs/SECRETS.md`).

## In Flight / Next Up
- iOS signing configuration (certificates, provisioning profiles, App Store Connect) **on hold until Mac hardware is available**.
- Configure CI/CD secrets in GitHub Actions (Android/iOS signing, Vercel, Supabase).
- Wire premium entitlements and storefront presentation for content packs.
- Connect backend metrics to Datadog/Grafana and define alert thresholds.
- Expand Flutter coverage with HTTP mocks, Supabase-aware integration tests, and offline handling.
- Finalise store metadata, localisation polish, and branding for the tarot client release.
- Produce Play Store asset pack (icon, splash, screenshots, feature graphic) following `ANDROID_LAUNCH_CHECKLIST.md`.

## Known Gaps
- iOS signing not yet configured; blocked until macOS signing environment is available (Android complete).
- CI/CD pipeline secrets need to be added to GitHub Actions.
- I Ching and runes Flutter builds lack production-ready UX and entitlement enforcement.
- Observability remains in-memory until an external provider is configured.
- Supabase RLS policies need a production review once entitlement flows land.

## Manual QA Checklist (Tarot)
- Run `scripts/supabase/apply.sh` to migrate/seed, then confirm tarot draws, interpretations, and history for the demo account.
- Validate session limits and error messages with and without Supabase credentials.
- Exercise `flutter build apk --release` from `apps/tarot` (ensure `JAVA_HOME` points to a JDK 17 install) and smoke test on device/emulator.
- When feature flags are enabled, sanity-check I Ching and runes endpoints with seeded accounts before exposing them in builds.
