# Critical Blockers Plan - Android Launch

Step-by-step plan to resolve the five critical Android launch tasks.

Estimated effort: 5-7 days (part-time)
Prerequisites: Git, Flutter 3.24+, Android Studio, Node.js 18+

---

## Task 1: Fix Android build (app_links compileSdk error)
Priority: Critical
Estimated time: 2-3 hours
Difficulty: Low

Problem
`
Android Gradle Plugin: project ':app_links' does not specify compileSdk
`

Solution A (recommended): update dependency
1. Check current version
   `
   cd C:\tarot\smart-divination\apps\tarot
   flutter pub deps | find "app_links"
   `
2. Upgrade to the latest release
   `
   flutter pub upgrade app_links
   # or update supabase_flutter if the transitive dependency lags
   flutter pub upgrade supabase_flutter
   `
3. If needed, pin the minimum version in pubspec.yaml.
4. Review changes with git diff pubspec.yaml pubspec.lock.

Solution B: override compileSdk in Gradle
1. Edit android/build.gradle.kts under the tarot app and add:
   `kotlin
   subprojects {
       project.evaluationDependsOn(":app")
       afterEvaluate {
           if (project.plugins.hasPlugin("com.android.library")) {
               extensions.configure<com.android.build.gradle.LibraryExtension> {
                   compileSdk = 34
               }
           }
       }
   }
   `
2. Re-run flutter build apk --release to verify.

---

## Task 2: Complete localisation migration
Priority: High
Status: ✅ COMPLETED (2025-10-05)
Estimated time: 1 day
Difficulty: Medium

Actions Completed:
- ✅ Shared localisation now uses ARB-generated CommonStrings with helper extensions for technique labels
- ✅ Removed the legacy AppLocalizations wrapper and updated all apps/tests to use CommonStrings delegates
- ✅ Checked in generated localisation sources and re-enabled smoke tests for tarot, iching, and runes

Verification: ✅ melos run analyze:all --no-select && melos run test:all --no-select (5/5 tests passing)
Verification: ✅ flutter analyze (No issues found in 39.0s)

---

## Task 3: Configure Supabase production
Priority: High
Status: ⚠️ PARTIALLY COMPLETE (Credentials configured, migrations pending)
Estimated time: 2 days
Difficulty: Medium

Actions Completed:
- ✅ Production project provisioned: vanrixxzaawybszeuivb.supabase.co
- ✅ Environment variables configured in .env.production:
  * SUPABASE_URL=https://vanrixxzaawybszeuivb.supabase.co
  * SUPABASE_ANON_KEY (configured)
  * SUPABASE_SERVICE_ROLE_KEY (configured)
- ✅ Credentials added to GitHub Secrets
- ✅ Secret rotation documented in SECRETS.md

Actions Remaining:
- ❌ Link local repo to production: `supabase link --project-ref vanrixxzaawybszeuivb`
- ❌ Apply migrations: `supabase db push --linked`
- ❌ Enable RLS policies and entitlement checks
- ❌ Run seed data (optional, for demo accounts)

Verification: Backend integration tests against production instance.

---

## Task 4: Deploy backend to Vercel production
Priority: High
Status: ⚠️ PARTIALLY COMPLETE (Project linked, not deployed)
Estimated time: 1 day
Difficulty: Medium

Actions Completed:
- ✅ Vercel CLI installed (v46.0.1)
- ✅ Project linked: prj_1W7dSxmVE6qwzuX4xaqr9EkoCbAC
- ✅ Org ID: team_4XuuNZAQVCaHrPaESHalLBde
- ✅ DeepSeek key configured: sk-c31cd42fdccf4b46a383d721b996e94f
- ✅ Random.org key configured: 6ea3503a-15f7-4220-a3b9-6c57b30f7b9f
- ✅ GitHub secrets configured: VERCEL_ORG_ID, VERCEL_PROJECT_ID
- ✅ Backend type-check passing

Actions Remaining:
- ❌ Add environment variables to Vercel Dashboard:
  * vercel env add SUPABASE_URL production
  * vercel env add SUPABASE_ANON_KEY production
  * vercel env add SUPABASE_SERVICE_ROLE_KEY production
  * vercel env add DEEPSEEK_API_KEY production
  * vercel env add RANDOM_ORG_KEY production
  * vercel env add ENABLE_ICHING production (false)
  * vercel env add ENABLE_RUNES production (false)
  * vercel env add NODE_ENV production
- ❌ Deploy: `cd smart-divination/backend && vercel --prod`
- ❌ Smoke test endpoints: /api/health, /api/metrics, /api/draw/cards
- ❌ Create VERCEL_TOKEN and add to GitHub Secrets

Verification: curl https://smart-divination.vercel.app/api/health (Currently: 404 NOT_FOUND)

---

## Task 5: Produce signed production AAB
Priority: High
Status: ⚠️ BLOCKED (Local signing setup incomplete)
Estimated time: 1 day
Difficulty: Medium

Actions Completed:
- ✅ GitHub Secrets configured for CI/CD:
  * ANDROID_KEYSTORE_BASE64
  * ANDROID_KEYSTORE_PASSWORD
  * ANDROID_KEY_ALIAS
  * ANDROID_KEY_PASSWORD
  * ANDROID_STORE_FILE
- ✅ build.gradle.kts configured to fail fast if signing missing
- ✅ JDK 17 available at C:\tarot\temp\jdk\jdk-17.0.2

Actions Remaining:
- ❌ Fix JAVA_HOME: Currently set to jdk-17.0.13+11 (invalid), should be C:\tarot\temp\jdk\jdk-17.0.2
- ❌ Create local key.properties: `cp android/key.properties.sample android/key.properties`
- ❌ Fill key.properties with production credentials (same as GitHub Secrets)
- ❌ Build bundle: `flutter build appbundle --release --dart-define=API_BASE_URL=https://smart-divination.vercel.app`
- ❌ Validate signature: `jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab`
- ❌ Archive artefact and document checksum

Blocker: JAVA_HOME environment variable + local key.properties file

Follow-up: Upload to Google Play closed testing track and collect feedback.
