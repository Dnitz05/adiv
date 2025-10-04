# Android Launch Checklist - Smart Tarot

Structured list of tasks to complete before publishing the Smart Tarot Android app to Google Play.

---

## Phase 1: Critical Technical Fixes (High Priority)

### 1.1 Resolve Android build failure
Status: Completed (app_links compileSdk override in place)
Verification: cd smart-divination/apps/tarot && flutter build apk --release

### 1.2 Finish localisation migration (CommonStrings from ARB files)
Status: In progress
Actions:
- Migrate remaining code paths away from legacy CommonStrings wrappers.
- Remove obsolete references once all screens read from generated delegates.
- Re-enable any skipped localisation tests.
Verification: cd smart-divination/apps/tarot && flutter test

### 1.3 Validate Android release signing setup
Status: Pending verification
Actions:
- Confirm ndroid/app/upload-keystore.jks and ndroid/key.properties contain production credentials.
- Build signed bundle: lutter build appbundle --release
- Verify signature: jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab

### 1.4 Address lint warnings (recommended)
Status: Pending
Actions:
- Remove unnecessary ignore_for_file directives.
- Apply const constructors where possible.
- Fix async build context usage.
- Delete dead code such as legacy record helpers.

---

## Phase 2: Assets and Store Content (High Priority)

### 2.1 App icon and splash screen
Status: Pending
Actions:
- Design 512x512 app icon and mipmap variants.
- Produce 1920x1080 splash graphic.
- Configure lutter_native_splash or manual assets.

### 2.2 Play Store screenshots
Status: Pending
Actions:
- Capture at least two 1080x1920 screenshots highlighting core flows.
- Store assets under docs/store-assets/screenshots/android/.

### 2.3 Feature graphic (Play Store banner)
Status: Pending
Actions:
- Create 1024x500 promotional banner with Smart Tarot branding and copy.

### 2.4 Promo video (optional)
Status: Optional
Recommendation: 30-60 second walkthrough video showcasing key features.

---

## Phase 3: Metadata and Documentation (Medium Priority)

### 3.1 Play Store descriptions
Status: Pending
Actions:
- Title (max 30 chars): Smart Tarot - AI Divination
- Short description (max 80 chars): Professional tarot readings with AI-powered insight
- Long description (max 4000 chars) covering features, spreads, AI interpretation, session history, premium tiers, Supabase requirement.
- Translate copy for EN, ES, CA.

### 3.2 Privacy policy and terms of service
Status: Pending
Actions:
- Draft GDPR-compliant privacy policy outlining collected data, Supabase usage, DeepSeek processing, and user rights.
- Draft terms of service.
- Host documents (for example https://smartdivination.com/privacy) and link from the app settings.

---

## Phase 4: Release Management (Medium Priority)

### 4.1 Internal testing track setup
Status: Pending
Actions:
- Configure internal testing testers (email list or Google Group).
- Upload signed AAB and add release notes with beta scope and support contact.

### 4.2 Monitoring and follow-up
Status: Pending
Actions:
- Monitor Play Console publishing overview after submission (expect 1-3 business days).
- Review pre-launch report for device issues.
- Collect tester feedback via agreed tracker (Notion, Jira, etc.).
