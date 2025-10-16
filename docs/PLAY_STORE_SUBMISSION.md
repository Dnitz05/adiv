# Play Store Submission Guide - Smart Divination Tarot

## Prerequisites

### ✅ Complete (as of 2025-10-16)
- ✅ **Signed AAB generated**: `app-release.aab` (45.7MB) ready for upload
- ✅ **Signed APK generated**: `app-release.apk` (55MB) tested on physical device
- ✅ **Android signing configured**: keystore `upload-keystore.jks` with password/alias set
- ✅ **App icon ready**: 1024x1024 icon with adaptive mipmaps integrated
- ✅ **AndroidManifest.xml updated**: app label set to "Smart Tarot"
- ✅ **Physical device testing**: app successfully installs and runs on Android device

### ⏳ Pending
- ⏳ Active Google Play Console account with Release Manager access
- ⏳ Complete metadata: short name, short/long description, category, tags (drafts in `docs/store-metadata/play_store_copy.md`)
- ⏳ Artwork: 1024x500 feature graphic (512x512 icon ready, need feature graphic)
- ⏳ Screenshots: minimum two 1080x1920 screenshots per device type (phone required, tablet optional)
- ⏳ Published privacy policy with accessible URL (template in `docs/store-metadata/privacy_policy_template.md`)
- ⏳ Published terms of service (template in `docs/store-metadata/terms_template.md`)
- ⏳ `versionCode` and `versionName` verified in `android/app/build.gradle.kts`

## Step-by-step
1. **Prepare binary** ✅ COMPLETE
   - ✅ Signed AAB available at: `smart-divination/apps/tarot/build/app/outputs/bundle/release/app-release.aab` (45.7MB)
   - ✅ Signing verified with production keystore: `upload-keystore.jks` (alias: upload)
   - ✅ Build command for regeneration:
     ```bash
     cd smart-divination/apps/tarot
     flutter build appbundle --release \
       --dart-define=API_BASE_URL=https://backend-4sircya71-dnitzs-projects.vercel.app \
       --dart-define=SUPABASE_URL=https://vanrixxzaawybszeuivb.supabase.co \
       --dart-define=SUPABASE_ANON_KEY=<anon-key>
     ```
2. **Create draft in Google Play Console**
   - Go to *All apps* -> *Create app* (if it does not exist) or select the existing entry.
   - Choose primary language and confirm the app is free.
3. **Complete App Content**
   - Fill in age rating (IARC), permissions, ads declaration, and target audience (13+).
   - Attach the privacy policy URL.
4. **Store listing**
   - Provide name, short description (<80 chars), full description (<4000 chars).
   - Upload feature graphic and icon.
   - Add screenshots (1080x1920 recommended) sourced from the beta build.
5. **Release details**
   - Navigate to *Production* -> *Create new release* (or *Closed testing* for Internal Testing channel).
   - Upload the signed AAB.
   - Add release notes: highlight beta scope, Supabase requirement, support contact.
6. **Targeting and distribution**
   - Select launch countries (start small if needed).
   - Configure Internal Testing testers (email list or Google Group).
7. **Review checks**
   - Run the Pre-launch report when available.
   - Resolve any warnings; ensure all sections display green status before submission.
8. **Submit for review**
   - Record release ID and submission timestamp for tracking.

## Deliverable checklist
- [x] Signed AAB verified locally (45.7MB, tested on physical device)
- [x] Android signing configured (keystore, key.properties, build.gradle.kts)
- [x] App icon ready (1024x1024 with adaptive mipmaps)
- [ ] Store listing completed (name, descriptions, screenshots, artwork)
  - [x] Name: "Smart Tarot" set in AndroidManifest.xml
  - [ ] Short description (<80 chars) - draft pending
  - [ ] Full description (<4000 chars) - draft pending
  - [ ] Screenshots (minimum 2x 1080x1920) - capture pending
  - [ ] Feature graphic (1024x500) - creation pending
- [ ] Privacy policy written and hosted with public URL
- [ ] Terms of service written and hosted with public URL
- [ ] App content forms cleared (age rating, ads declaration, target audience)
- [ ] Google Play Console account created
- [ ] Internal Testing track configured with invited testers
- [ ] Release notes drafted

## Follow-up
- Monitor *Publishing overview* (review typically 1-3 business days).
- Check the Pre-launch report for device-specific issues.
- After approval, notify testers and capture feedback in the agreed tracker (Notion, Jira, etc.).
