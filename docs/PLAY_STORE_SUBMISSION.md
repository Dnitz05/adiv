# Play Store Submission Guide - Smart Divination Tarot

## Prerequisites
- Active Google Play Console account with Release Manager access.
- Signed APK or AAB generated via `melos` (see Task 1.6 in the consolidated plan).
- Complete metadata: short name, short/long description, category, tags.
- Artwork: 512x512 icon, 1024x500 feature graphic, minimum two screenshots per device type (phone, tablet optional).
- Published privacy policy with accessible URL.
- `android/app/src/main/AndroidManifest.xml` updated with correct `versionCode` and `versionName`.

## Step-by-step
1. **Prepare binary**
   - `flutter build appbundle --release --dart-define=...`
   - Verify signing with the production keystore.
   - Keep the AAB at `apps/tarot/build/app/outputs/bundle/release/app-release.aab`.
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
- [ ] Signed AAB verified locally.
- [ ] Store listing completed (name, descriptions, screenshots, artwork).
- [ ] Privacy policy linked.
- [ ] App content forms cleared.
- [ ] Internal Testing track configured with invited testers.
- [ ] Release notes ready.

## Follow-up
- Monitor *Publishing overview* (review typically 1-3 business days).
- Check the Pre-launch report for device-specific issues.
- After approval, notify testers and capture feedback in the agreed tracker (Notion, Jira, etc.).
