# Critical blockers plan - Android launch

Updated: 2025-10-05 (after deploying backend and Supabase)

---

## Task 1: Fix Android build (compileSdk/app_links)
Status: complete
- Updated dependency configuration, build now passes
- Verification: `flutter build apk --release`

## Task 2: Localisation migration
Status: complete
- CommonStrings enabled across apps
- Tests restored (`melos run analyze:all`, `melos run test:all`)

## Task 3: Configure Supabase production
Status: complete
- Supabase project linked via CLI (`supabase link --project-ref vanrixxzaawybszeuivb`)
- Migrations applied: initial schema + session history schema
- Tables verified in dashboard
- Supabase secrets stored in GitHub Actions and Vercel
- Backend health reporting Supabase healthy (~1 s)
- ✅ Security: Supabase keys rotated on 2025-10-06 (incident closed)

## Task 4: Deploy backend to Vercel production
Status: complete
- Production URL: https://backend-4sircya71-dnitzs-projects.vercel.app
- Environment variables configured via CLI
- Health checks: /api/health 200, /api/draw/cards 401 unauthenticated
- Scripts: `scripts/vercel/setup_env_vars.ps1` and `scripts/verify-deployment.ps1`
- Follow-up: create `VERCEL_TOKEN` for automated deploys on push

## Task 5: Produce signed production AAB
Status: CI/CD ready, local build pending
- GitHub Actions contains keystore and passwords
- `build.gradle.kts` validates signing configuration
- Helper scripts guide manual setup for local signing
- Local build attempt (2025-10-05) failed because keystore not yet decoded to `android/upload-keystore.jks`
- Next steps:
  * Decode `ANDROID_KEYSTORE_BASE64` into `android/upload-keystore.jks`
  * Populate `android/key.properties`
  * Export `JAVA_HOME` to `C:\tarot\temp\jdk\jdk-17.0.2`
  * Run `flutter build appbundle --release` and verify with `jarsigner`
  * Archive checksum and upload to Play Console Internal Testing track

---

## Outstanding items before Play Store submission
1. ~~Rotate exposed secrets (Supabase, DeepSeek, Random.org).~~ ✅ **COMPLETED 2025-10-06**
2. Configure local signing and produce the signed AAB.
3. ~~Create app icon~~ ✅ **COMPLETED 2025-10-13** | ⚠️ Remaining: screenshots (2-8), feature graphic (1024x500)
4. ~~Draft privacy policy and terms~~ ✅ **TEMPLATES READY** | ⚠️ Need hosting and final review
5. Complete manual QA using production backend.
6. Configure Google Play Console (developer account + Internal Testing track).
7. Fix AndroidManifest.xml label to "Smart Tarot".

---

## Scripts and documentation updates
- `scripts/vercel/setup_env_vars.ps1` (reads secrets from environment variables, no hardcoded data)
- `scripts/android/setup_local_signing.ps1` and `scripts/android/decode_keystore.ps1`
- `DEPLOYMENT_SUCCESS.md` and `Blockers cleared` report summarise completed work
- `docs/STATUS.md` reflects current backlog (assets, metadata, QA)

---

Next milestone: finish assets, legal copy, and QA to open the Internal Testing track.
