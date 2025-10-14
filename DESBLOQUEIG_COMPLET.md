# Blockers cleared - Smart Tarot

Date: 2025-10-05
Status: all launch-critical blockers resolved

---

## Blockers resolved

### Backend deployed to Vercel
- Previous state: 404 NOT_FOUND
- Current state: production deployment verified
- URL: https://backend-4sircya71-dnitzs-projects.vercel.app
- Endpoints confirmed: `/api/health` (200), `/api/draw/cards` (401 unauthenticated), `/api/metrics` (403 protected)
- Environment variables set: SUPABASE_URL/ANON_KEY/SERVICE_ROLE_KEY, DEEPSEEK_API_KEY, RANDOM_ORG_KEY, ENABLE_ICHING=false, ENABLE_RUNES=false, NODE_ENV=production, METRICS_PROVIDER=console, METRICS_DEBUG=false

### Supabase production migrations
- Previous state: project unlinked and empty
- Current state: linked (`supabase link --project-ref vanrixxzaawybszeuivb`) and migrated (`supabase db push --linked`)
- Migrations applied: 20250101000001_initial_schema.sql, 20250922090000_session_history_schema.sql
- Tables created: users, sessions, session_artifacts, session_messages

### Android signing (CI/CD)
- Previous state: JAVA_HOME incorrect, no key.properties
- Current state: GitHub Actions secrets configured, build.gradle.kts validation in place, helper scripts added
- Local action items: set JAVA_HOME to the installed JDK and replace placeholders in key.properties before building locally

---

## Summary table

| Component               | Previous state     | Current state        | Notes                                     |
|-------------------------|--------------------|----------------------|-------------------------------------------|
| Backend (Vercel)        | 404                | Production live      | Verified via scripts/verify-deployment.ps1 |
| Supabase                | No migrations      | Schema applied       | Core tables available                     |
| Android signing (CI/CD) | Incomplete         | Ready                | CI/CD can build signed AAB                |
| Android signing (local) | Not configured     | Structure prepared   | Populate secrets and fix JAVA_HOME        |

---

## Next steps

### Immediate
1. Configure local signing using GitHub secrets (see `scripts/android/setup_local_signing.ps1`).
2. Generate `flutter build appbundle --release` with production `--dart-define` values.
3. Create Supabase test accounts and exercise end-to-end flows (auth, draws, history).

### This week
- Design branded icon and splash artwork.
- Capture at least two 1080x1920 screenshots and a 1024x500 feature graphic.
- Draft and host privacy policy and terms of service (CA/ES/EN).
- Prepare Play Store copy and upload the release build to the Internal Testing track.

### Medium term
- Collect tester feedback, address issues, and prepare public launch.

---

## Helper scripts
- `scripts/vercel/setup_env_vars.ps1`: loads Vercel env vars from local environment variables (no secrets in code).
- `scripts/android/setup_local_signing.ps1`: documents manual signing steps using GitHub secrets.
- `scripts/android/decode_keystore.ps1`: decodes the keystore base64 and checks file presence.

---

## Pre-launch checklist (remaining)

### Backend & infrastructure
- [x] Vercel deployment
- [x] Supabase migrations
- [x] DeepSeek and Random.org configured (rotate keys after exposure)
- [ ] Create VERCEL_TOKEN for automated deploys

### Android app
- [x] Build compiles
- [x] Flutter tests pass
- [x] `flutter analyze` clean
- [ ] Local signing configured and tested
- [ ] Signed AAB generated and verified locally

### Play Store assets & content
- [ ] Custom icon and splash artwork
- [ ] Screenshots (>=2)
- [ ] Feature graphic
- [ ] Store copy EN/ES/CA
- [ ] Privacy policy and terms of service hosted

### QA & Play Console
- [ ] Manual QA checklist complete
- [ ] Physical device smoke test
- [ ] Google Play Console account and Internal Testing track ready
- [ ] Signed AAB uploaded to Internal Testing track

---

Critical engineering blockers are cleared; focus now shifts to assets, QA, and Play Store readiness to start internal testing.
