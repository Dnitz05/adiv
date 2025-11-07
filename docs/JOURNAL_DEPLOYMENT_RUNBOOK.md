# Journal/Archive Feature - Deployment Runbook

## Overview

This runbook covers the deployment of the Journal/Archive feature, which includes:
- Database schema changes (user_activities table + ETL trigger)
- Backend API endpoints (/api/journal/*)
- Flutter UI (ArchiveScreen + journal widgets)

**Estimated Deployment Time:** 30-45 minutes
**Downtime Required:** None (zero-downtime deployment)
**Rollback Time:** 10-15 minutes

---

## Pre-Deployment Checklist

- [ ] All tests passing (unit + widget tests)
- [ ] Code reviewed and approved
- [ ] Staging environment tested successfully
- [ ] Database backup taken
- [ ] Monitoring alerts configured
- [ ] Rollback plan documented and understood
- [ ] Stakeholders notified of deployment window

---

## Step 1: Database Migration (Supabase)

### 1.1 Verify Migration File

```bash
# Check migration file exists
cat smart-divination/supabase/migrations/20251107161635_journal_user_activities.sql

# Verify SQL syntax
psql --dry-run -f smart-divination/supabase/migrations/20251107161635_journal_user_activities.sql
```

### 1.2 Apply Migration to Production

```bash
cd smart-divination

# Link to production project
C:/tarot/supabase_cli/supabase.exe link --project-ref vanrixxzaawybszeuivb

# Push migration (will prompt for confirmation)
C:/tarot/supabase_cli/supabase.exe db push --linked
```

**Expected Output:**
```
Applying migration 20251107161635_journal_user_activities.sql...
✓ Migration applied successfully
```

### 1.3 Verify Migration Applied

```sql
-- Connect to production DB and run:

-- Check table exists
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public' AND table_name = 'user_activities';

-- Check ENUMs created
SELECT typname FROM pg_type WHERE typname IN ('journal_activity_type', 'journal_activity_status');

-- Check trigger exists
SELECT trigger_name FROM information_schema.triggers
WHERE trigger_name = 'trg_sync_session_to_activities';

-- Check RLS policies active
SELECT tablename, policyname FROM pg_policies WHERE tablename = 'user_activities';
```

**Expected Results:**
- user_activities table exists
- 2 ENUMs exist (journal_activity_type, journal_activity_status)
- 1 trigger exists (trg_sync_session_to_activities)
- 2+ RLS policies exist (user_can_view_own, user_can_insert_own, etc.)

### 1.4 Test Trigger Functionality

```sql
-- Create a test session
INSERT INTO sessions (id, user_id, technique, status, created_at)
VALUES (gen_random_uuid(), '<test-user-id>', 'tarot', 'completed', NOW())
RETURNING id;

-- Verify activity created
SELECT * FROM user_activities WHERE session_id = '<session-id-from-above>';

-- Clean up
DELETE FROM sessions WHERE id = '<session-id-from-above>';
```

**⏱️ Estimated Time:** 10 minutes

---

## Step 2: Backend Deployment (Next.js API)

### 2.1 Generate TypeScript Types

```bash
cd smart-divination

# Regenerate types from updated schema
C:/tarot/supabase_cli/supabase.exe gen types typescript --linked --schema public > backend/lib/types/generated/supabase.ts
```

### 2.2 Verify Backend Code

```bash
cd smart-divination/backend

# Run type checking
npm run type-check

# Run linting
npm run lint

# Run tests
npm test
```

### 2.3 Deploy to Vercel

```bash
cd smart-divination

# Deploy to production
npx vercel --prod

# Or push to main branch (auto-deploys)
git push origin main
```

**Expected Output:**
```
✓ Deployment ready [production]
🔗 https://smart-divination.vercel.app
```

### 2.4 Verify API Endpoints

```bash
# Test timeline endpoint
curl -X GET 'https://smart-divination.vercel.app/api/journal/timeline?limit=10&userId=<test-user>&locale=en' \
  -H 'Authorization: Bearer <token>'

# Test stats endpoint
curl -X GET 'https://smart-divination.vercel.app/api/journal/stats?userId=<test-user>&locale=en' \
  -H 'Authorization: Bearer <token>'

# Test day summary endpoint
curl -X GET 'https://smart-divination.vercel.app/api/journal/day/2025-11-07?userId=<test-user>&locale=en' \
  -H 'Authorization: Bearer <token>'
```

**Expected Responses:**
- 200 OK with JSON payload
- Correct data structure (entries array, hasMore boolean, etc.)
- No 500 errors

**⏱️ Estimated Time:** 10 minutes

---

## Step 3: Flutter App Build & Release

### 3.1 Update Version Number

```yaml
# smart-divination/apps/tarot/pubspec.yaml
version: 1.X.X+Y  # Increment appropriately
```

### 3.2 Run Flutter Tests

```bash
cd smart-divination/apps/tarot

# Run all tests
flutter test

# Run specific test suites
flutter test test/journal_controller_test.dart
flutter test test/widgets/archive_screen_test.dart
```

**Expected Output:**
```
All tests passed!
8/8 tests passed
```

### 3.3 Build Release APK (Android)

```bash
cd smart-divination/apps/tarot

# Set environment variables
export JAVA_HOME="/c/tarot/temp/jdk/jdk-17.0.2"
export API_BASE_URL="https://smart-divination.vercel.app"

# Build release APK
JAVA_HOME="/c/tarot/temp/jdk/jdk-17.0.2" flutter build apk --release \
  --dart-define=API_BASE_URL=https://smart-divination.vercel.app
```

**Expected Output:**
```
✓ Built build/app/outputs/flutter-apk/app-release.apk (XX.X MB)
```

### 3.4 Build Release IPA (iOS - if applicable)

```bash
cd smart-divination/apps/tarot

# Build iOS release
flutter build ios --release \
  --dart-define=API_BASE_URL=https://smart-divination.vercel.app
```

### 3.5 Upload to Play Store / App Store

#### Android (Google Play)
1. Navigate to Google Play Console
2. Select "Smart Divination" app
3. Go to "Production" > "Create new release"
4. Upload `app-release.apk`
5. Fill release notes:
   ```
   New in this version:
   - Added Journal/Archive feature to track your readings and activities
   - View timeline of past tarot readings, lunar guidance, and more
   - Filter by activity type, lunar phase, and time period
   - Calendar view with daily activity summaries
   - Stats dashboard showing your divination practice insights
   ```
6. Submit for review

#### iOS (App Store)
1. Open Xcode and archive app
2. Upload to App Store Connect
3. Fill release notes with same content as above
4. Submit for review

**⏱️ Estimated Time:** 15 minutes (build) + 24-48 hours (store review)

---

## Step 4: Backfill Historical Data (Optional)

### 4.1 Run Backfill Script

```bash
cd smart-divination/backend

# Dry run first
node scripts/backfill_user_activities.mjs --dry-run

# Review output, then run for real
node scripts/backfill_user_activities.mjs --limit=1000

# If all looks good, backfill all
node scripts/backfill_user_activities.mjs
```

**Expected Output:**
```
Backfilling sessions to user_activities...
✓ Processed 1523 sessions
✓ Created 1523 activities
✓ Skipped 47 invalid sessions
```

### 4.2 Verify Backfill

```sql
-- Check activity counts match session counts
SELECT
  (SELECT COUNT(*) FROM sessions WHERE status = 'completed') AS total_sessions,
  (SELECT COUNT(*) FROM user_activities) AS total_activities;
```

**⏱️ Estimated Time:** 5-10 minutes

---

## Step 5: Monitoring & Validation

### 5.1 Check Error Rates

```bash
# Check Vercel logs
vercel logs --prod --since=1h

# Look for errors in /api/journal/* endpoints
vercel logs --prod --since=1h | grep "api/journal" | grep "500"
```

### 5.2 Check Database Performance

```sql
-- Check query performance for timeline endpoint
EXPLAIN ANALYZE
SELECT * FROM user_activities
WHERE user_id = '<test-user-id>'
ORDER BY created_at DESC
LIMIT 20;

-- Verify index usage (should use index, not seq scan)
-- Expected: Index Scan on user_activities_user_id_created_at_idx
```

### 5.3 Verify Monitoring Alerts

- [ ] Check Sentry for new errors in Archive screen
- [ ] Verify Vercel dashboard shows healthy response times
- [ ] Check Supabase dashboard for query performance
- [ ] Verify no spike in error rates

### 5.4 Manual Smoke Test

1. Open app on test device
2. Navigate to Archive tab
3. Verify timeline loads with entries
4. Tap different calendar days, verify summaries load
5. Open filter panel, apply filters, verify timeline updates
6. Pull to refresh, verify data reloads
7. Scroll through 50+ entries, verify smooth scrolling

**⏱️ Estimated Time:** 10 minutes

---

## Rollback Procedure

### If Backend Issues Detected

```bash
# Revert to previous Vercel deployment
vercel rollback

# Or redeploy previous commit
git revert HEAD
git push origin main
```

### If Database Issues Detected

```sql
-- Rollback migration (use with caution!)
DROP TRIGGER IF EXISTS trg_sync_session_to_activities ON sessions;
DROP FUNCTION IF EXISTS sync_session_to_activities();
DROP TABLE IF EXISTS user_activities CASCADE;
DROP TYPE IF EXISTS journal_activity_status CASCADE;
DROP TYPE IF EXISTS journal_activity_type CASCADE;
```

**⚠️ WARNING:** Rolling back migration will delete all user_activities data. Only do this in emergency.

### If Flutter App Issues Detected

1. Remove from store listing (make unavailable for new downloads)
2. Push hotfix build with feature flag disabled:
   ```dart
   // In main.dart, hide Archive tab
   const bool ENABLE_ARCHIVE = false;

   // In navigation, skip index 3 if !ENABLE_ARCHIVE
   ```
3. Submit hotfix for expedited review

**⏱️ Rollback Time:** 10-15 minutes

---

## Post-Deployment Monitoring (First 24 Hours)

### Hour 1-2: High-Priority Monitoring
- [ ] Check error rates every 15 minutes
- [ ] Monitor API response times (should be < 500ms p95)
- [ ] Watch for crash reports in Sentry
- [ ] Verify user_activities table growing as expected

### Hour 2-24: Normal Monitoring
- [ ] Check error rates every 2 hours
- [ ] Review user feedback/support tickets
- [ ] Monitor database storage growth
- [ ] Check API endpoint usage metrics

### Metrics to Track
- `user_activities` table row count (should grow steadily)
- `/api/journal/timeline` average response time
- `/api/journal/stats` cache hit rate
- Archive screen navigation count (analytics)
- User engagement time on Archive screen

---

## Success Criteria

Deployment is considered successful when:
- [ ] All API endpoints returning 2xx responses (< 1% error rate)
- [ ] Database trigger firing correctly (100% sessions create activities)
- [ ] Flutter app loading Archive screen without crashes (< 0.1% crash rate)
- [ ] Timeline pagination working smoothly
- [ ] No performance regressions in app startup time
- [ ] User feedback positive (no critical bugs reported)

---

## Contacts & Escalation

- **Backend Issues:** [Backend Team Lead]
- **Database Issues:** [Database Admin]
- **Flutter Issues:** [Mobile Team Lead]
- **Infrastructure Issues:** [DevOps Team]
- **Rollback Decision:** [Product Manager / Tech Lead]

---

## Post-Mortem (If Issues Occur)

Document any issues encountered:
- What went wrong?
- What was the root cause?
- How was it detected?
- How was it resolved?
- How can we prevent this in the future?

**Template:** `docs/postmortems/journal-deployment-YYYY-MM-DD.md`

---

## Checklist Summary

- [x] Database migration applied
- [x] Backend deployed to production
- [ ] Flutter app built and uploaded to stores
- [ ] Backfill script run (optional)
- [ ] Monitoring alerts verified
- [ ] Manual smoke tests passed
- [ ] Success metrics met
- [ ] Documentation updated

**Deployment completed by:** _______________
**Date:** _______________
**Sign-off:** _______________
