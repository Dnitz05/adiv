# Critical Blockers Plan - Android Launch

Step-by-step plan to resolve the five critical Android launch tasks.

Estimated effort: 5-7 days (part-time)
Prerequisites: Git, Flutter 3.24+, Android Studio, Node.js 18+

---

## Task 1: Fix Android build (pp_links compileSdk error)
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
1. Edit ndroid/build.gradle.kts under the tarot app and add:
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
2. Re-run lutter build apk --release to verify.

---

## Task 2: Complete localisation migration
Priority: High (Completed)
Estimated time: 1 day
Difficulty: Medium

Actions
- Shared localisation now uses ARB-generated CommonStrings with helper extensions for technique labels.
- Removed the legacy AppLocalizations wrapper and updated all apps/tests to use CommonStrings delegates.
- Checked in generated localisation sources and re-enabled smoke tests for tarot, iching, and runes.

Verification: melos run analyze:all --no-select && melos run test:all --no-select (passes).

---

## Task 3: Configure Supabase production
Priority: High
Estimated time: 2 days
Difficulty: Medium

Actions
- Provision production project and set environment variables (URL, anon key, service role).
- Apply migrations and seed data with scripts/supabase/apply.sh.
- Enable RLS policies and entitlement checks.
- Document secret rotation and access.

Verification: backend integration tests against production instance or staging clone.

---

## Task 4: Deploy backend to Vercel production
Priority: High
Estimated time: 1 day
Difficulty: Medium

Actions
- Configure Vercel project with Node 18 runtime and Supabase env vars.
- Set DeepSeek key and feature flags (ENABLE_ICHING, ENABLE_RUNES) as required.
- Deploy via 
pm run deploy from ackend/.
- Smoke test endpoints (/api/health, /api/draw/cards).

Verification: post-deploy checks in Vercel dashboard and Supabase logs.

---

## Task 5: Produce signed production AAB
Priority: High
Estimated time: 1 day
Difficulty: Medium

Actions
- Verify upload-keystore.jks and key.properties.
- Build bundle: lutter build appbundle --release (ensure JAVA_HOME points to JDK 17).
- Validate signature with jarsigner -verify -verbose -certs.
- Archive artefact in release folder and document checksum.

Follow-up: upload to Google Play closed testing track and collect feedback.
