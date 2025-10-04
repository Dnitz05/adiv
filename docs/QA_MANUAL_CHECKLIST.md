# QA Manual Checklist - Smart Divination Tarot

Complete quality assurance checklist for production readiness.

## Prerequisites

- [ ] Backend deployed to Vercel production
- [ ] Supabase production database with migrations applied
- [ ] Test user accounts created in Supabase
- [ ] Android APK built and signed
- [ ] iOS IPA built and signed (when iOS signing complete)

## Test Environment Setup

### 1. Create Test Accounts

In Supabase Dashboard -> Authentication -> Users:

**Test Account 1** (New User):
- Email: `test1@smartdivination.com`
- Password: `TestUser123!`
- Confirm email manually in dashboard

**Test Account 2** (Existing User with History):
- Email: `test2@smartdivination.com`
- Password: `TestUser123!`
- Create some session history manually or via API

### 2. Install Test Build on Devices

**Android**:
```bash
cd C:\tarot\smart-divination\apps\tarot
flutter build apk --release \
  --dart-define=API_BASE_URL=https://smart-divination-backend.vercel.app \
  --dart-define=SUPABASE_URL=YOUR_PRODUCTION_SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY

# Transfer APK to device and install
# APK location: build/app/outputs/flutter-apk/app-release.apk
```

**iOS** (when ready):
```bash
flutter build ipa --release \
  --dart-define=API_BASE_URL=https://smart-divination-backend.vercel.app \
  --dart-define=SUPABASE_URL=YOUR_PRODUCTION_SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

## Backend API Testing

### Health & Metrics Endpoints

**Test 1: Health Check**
```bash
curl https://smart-divination-backend.vercel.app/api/health
```
- [ ] Status: 200 OK
- [ ] Response contains: `status`, `timestamp`, `uptime`, `memory`
- [ ] Response time: < 2 seconds

**Test 2: Metrics Endpoint**
```bash
curl https://smart-divination-backend.vercel.app/api/metrics
```
- [ ] Status: 200 OK
- [ ] Response contains: `metrics` array, `provider`, `timestamp`

### Authentication Flow

**Test 3: Unauthenticated Access**
```bash
curl -X POST https://smart-divination-backend.vercel.app/api/draw/cards \
  -H "Content-Type: application/json" \
  -d '{"spread": "three_card", "question": "Test"}'
```
- [ ] Status: 401 Unauthorized
- [ ] Error code: `UNAUTHENTICATED`
- [ ] Error message: "Authentication required."

**Test 4: Get Auth Token (via Supabase)**
```bash
curl -X POST https://YOUR_PROJECT.supabase.co/auth/v1/token?grant_type=password \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"email": "test1@smartdivination.com", "password": "TestUser123!"}'
```
- [ ] Status: 200 OK
- [ ] Response contains: `access_token`, `refresh_token`
- [ ] Save `access_token` for next tests

### Tarot Draw Endpoints

**Test 5: Three Card Spread**
```bash
curl -X POST https://smart-divination-backend.vercel.app/api/draw/cards \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "spread": "three_card",
    "question": "What should I focus on today?",
    "deckId": "rider_waite_smith"
  }'
```
- [ ] Status: 200 OK
- [ ] Response contains 3 cards with: `id`, `name`, `suit`, `rank`, `orientation`
- [ ] Response contains: `spread`, `question`, `sessionId`
- [ ] Response time: < 3 seconds

**Test 6: Celtic Cross Spread**
```bash
curl -X POST https://smart-divination-backend.vercel.app/api/draw/cards \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "spread": "celtic_cross",
    "question": "Career guidance",
    "deckId": "rider_waite_smith"
  }'
```
- [ ] Status: 200 OK
- [ ] Response contains 10 cards
- [ ] Each card has correct position metadata
- [ ] Response time: < 3 seconds

**Test 7: Single Card Draw**
```bash
curl -X POST https://smart-divination-backend.vercel.app/api/draw/cards \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "spread": "single_card",
    "question": "Daily guidance"
  }'
```
- [ ] Status: 200 OK
- [ ] Response contains 1 card
- [ ] Response time: < 2 seconds

### AI Interpretation Endpoints

**Test 8: Request Interpretation**
```bash
curl -X POST https://smart-divination-backend.vercel.app/api/chat/interpret \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "sessionId": "SESSION_ID_FROM_DRAW",
    "cards": [...],
    "question": "What should I focus on today?"
  }'
```
- [ ] Status: 200 OK
- [ ] Response contains: `interpretation` text
- [ ] Interpretation is coherent and relevant
- [ ] Response time: < 10 seconds
- [ ] DeepSeek API called successfully

**Test 9: Interpretation Persisted**
```bash
curl https://smart-divination-backend.vercel.app/api/sessions/USER_ID \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```
- [ ] Status: 200 OK
- [ ] Session history includes interpretation
- [ ] `artifacts` array contains card data
- [ ] `messages` array contains AI interpretation

### Session Management

**Test 10: Get User Profile**
```bash
curl https://smart-divination-backend.vercel.app/api/users/USER_ID/profile \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```
- [ ] Status: 200 OK
- [ ] Response contains: `userId`, `sessionCount`, `recentSessions`

**Test 11: Check Session Eligibility**
```bash
curl https://smart-divination-backend.vercel.app/api/users/USER_ID/can-start-session \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```
- [ ] Status: 200 OK
- [ ] Response contains: `canStart` boolean, `remainingSessions`

**Test 12: Session Limit Enforcement**

Perform 10+ draws rapidly:
- [ ] After limit, receives `RATE_LIMITED` error
- [ ] Error message indicates session limit
- [ ] User can view history but not create new sessions

### Feature Flags

**Test 13: I Ching Disabled**
```bash
curl -X POST https://smart-divination-backend.vercel.app/api/draw/coins \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{"question": "Test"}'
```
- [ ] Status: 503 Service Unavailable
- [ ] Error code: `FEATURE_DISABLED`
- [ ] Error message mentions I Ching not enabled

**Test 14: Runes Disabled**
```bash
curl -X POST https://smart-divination-backend.vercel.app/api/draw/runes \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{"count": 3}'
```
- [ ] Status: 503 Service Unavailable
- [ ] Error code: `FEATURE_DISABLED`

## Mobile App Testing (Android)

### Installation & First Launch

**Test 15: Fresh Install**
- [ ] APK installs without errors
- [ ] App icon displays correctly
- [ ] App name: "Smart Divination"
- [ ] Splash screen displays
- [ ] Permissions requested appropriately

**Test 16: First Launch Flow**
- [ ] Welcome/onboarding screen displays
- [ ] Sign up option available
- [ ] Sign in option available
- [ ] UI is responsive and fluid

### Authentication Flows

**Test 17: User Sign Up**
1. Tap "Sign Up"
2. Enter email: `newuser@test.com`
3. Enter password: `TestPass123!`
4. Confirm password
5. Submit

- [ ] Validation works (email format, password strength)
- [ ] Sign up succeeds
- [ ] Redirects to main screen
- [ ] User is authenticated
- [ ] Supabase creates user account

**Test 18: User Sign In**
1. Tap "Sign In"
2. Enter test1@smartdivination.com / TestUser123!
3. Submit

- [ ] Sign in succeeds
- [ ] Redirects to main screen
- [ ] Session persists across app restarts

**Test 19: Sign Out**
1. Navigate to profile/settings
2. Tap "Sign Out"

- [ ] Logs out successfully
- [ ] Returns to welcome screen
- [ ] Session cleared

**Test 20: Forgot Password**
1. Tap "Forgot Password"
2. Enter email
3. Submit

- [ ] Sends password reset email
- [ ] Displays confirmation message
- [ ] Email received (check Supabase email templates)

### Tarot Draw Flows

**Test 21: Select Spread**
1. Sign in as test1
2. Navigate to "New Reading"
3. Select "Three Card Spread"

- [ ] Spread options display correctly
- [ ] Spread descriptions visible
- [ ] UI intuitive

**Test 22: Enter Question**
1. Type question: "What should I focus on?"
2. Proceed

- [ ] Text input works smoothly
- [ ] Character limit enforced (if any)
- [ ] Validation works

**Test 23: Draw Cards Animation**
1. Tap "Draw Cards"

- [ ] Loading indicator displays
- [ ] Animation plays (if implemented)
- [ ] Cards reveal smoothly
- [ ] Response time: < 5 seconds

**Test 24: View Card Details**
1. Tap on a drawn card

- [ ] Card details screen displays
- [ ] Shows card image (or placeholder)
- [ ] Shows card name, suit, rank
- [ ] Shows orientation (upright/reversed)
- [ ] Shows position in spread

**Test 25: Request Interpretation**
1. After draw, tap "Get Interpretation"

- [ ] Loading indicator shows
- [ ] AI interpretation displays
- [ ] Text is readable and formatted
- [ ] Response time: < 15 seconds

**Test 26: Save Reading**
1. After interpretation, tap "Save" (if implemented)

- [ ] Reading saved to history
- [ ] Confirmation message shown

### Session History

**Test 27: View History**
1. Navigate to "History" or "My Readings"

- [ ] List of past readings displays
- [ ] Shows date, question, spread type
- [ ] Sorted by most recent first

**Test 28: View Past Reading**
1. Tap on a historical reading

- [ ] Full reading displays
- [ ] Cards shown in correct positions
- [ ] Interpretation displayed
- [ ] Timestamp accurate

**Test 29: Delete Reading**
1. Long-press or swipe on a reading
2. Tap "Delete"

- [ ] Confirmation dialog shown
- [ ] Reading deleted from history
- [ ] Syncs with backend

### Offline Behavior

**Test 30: Offline Mode**
1. Disable device internet
2. Open app

- [ ] App launches successfully
- [ ] Cached history visible
- [ ] Clear error message when attempting new draw
- [ ] No crashes

**Test 31: Reconnection**
1. Re-enable internet
2. Attempt new draw

- [ ] Connection restored automatically
- [ ] New draw succeeds
- [ ] Data syncs properly

### Error Handling

**Test 32: Network Timeout**
1. Use network throttling tool
2. Attempt draw with very slow connection

- [ ] Timeout handled gracefully
- [ ] User-friendly error message
- [ ] Retry option available

**Test 33: Invalid Session**
1. Manually expire session token
2. Attempt API call

- [ ] Detects expired token
- [ ] Redirects to sign in
- [ ] Shows "Session expired" message

**Test 34: Rate Limit Reached**
1. Perform 10+ draws rapidly

- [ ] Clear error message about session limit
- [ ] Shows remaining sessions (0)
- [ ] Explains when limit resets (daily)
- [ ] History still accessible

### Performance & Stability

**Test 35: Memory Usage**
1. Open app
2. Perform 10+ draws
3. Check device memory

- [ ] Memory usage stable (< 200 MB)
- [ ] No memory leaks
- [ ] No ANR (App Not Responding)

**Test 36: Battery Usage**
1. Use app for 30 minutes
2. Check battery drain

- [ ] Battery usage reasonable (< 5% for 30 min)
- [ ] No excessive background activity

**Test 37: App Rotation**
1. Rotate device during various screens

- [ ] UI adapts to landscape/portrait
- [ ] No data loss on rotation
- [ ] Layouts remain usable

**Test 38: Background/Foreground**
1. Put app in background
2. Wait 5 minutes
3. Bring to foreground

- [ ] App resumes correctly
- [ ] Session still valid
- [ ] No crashes

### UI/UX Polish

**Test 39: Visual Consistency**
- [ ] Colors consistent across screens
- [ ] Fonts readable and appropriate sizes
- [ ] Icons clear and meaningful
- [ ] Spacing and padding uniform

**Test 40: Accessibility**
1. Enable TalkBack (Android)
2. Navigate app

- [ ] All buttons have labels
- [ ] Screen reader works
- [ ] Text contrast sufficient (WCAG AA)
- [ ] Font scaling works

**Test 41: Edge Cases**
- [ ] Extremely long questions handled
- [ ] Special characters in input
- [ ] Empty input validation
- [ ] Rapid button tapping doesn't cause issues

## iOS Testing (When Available)

Repeat Tests 15-41 on iOS device:
- [ ] Installation & first launch
- [ ] Authentication flows
- [ ] Tarot draw flows
- [ ] Session history
- [ ] Offline behavior
- [ ] Error handling
- [ ] Performance
- [ ] UI/UX polish

## Cross-Platform Testing

**Test 42: Data Sync Between Devices**
1. Sign in on Android device
2. Perform draw
3. Sign in on iOS device (same account)

- [ ] History syncs correctly
- [ ] Session counts match
- [ ] No duplicate sessions

## Security Testing

**Test 43: SQL Injection**
Try malicious input in question field:
```
Test'; DROP TABLE sessions; --
```
- [ ] Input sanitized
- [ ] No database errors

**Test 44: XSS Prevention**
Enter HTML/JS in question:
```
<script>alert('xss')</script>
```
- [ ] Rendered as plain text
- [ ] No script execution

**Test 45: Authentication Bypass**
1. Sign out
2. Manually craft API request without token

- [ ] Returns 401 Unauthorized
- [ ] No data exposed

## Final Checklist

### Blockers (Must Fix Before Launch)
- [ ] All API endpoints return correct status codes
- [ ] Authentication flows work reliably
- [ ] Tarot draws succeed consistently
- [ ] AI interpretations generate successfully
- [ ] Session history persists correctly
- [ ] No crashes during normal usage

### High Priority (Should Fix Before Launch)
- [ ] Offline mode handles gracefully
- [ ] Error messages are user-friendly
- [ ] Performance is acceptable (< 3s API calls)
- [ ] UI is polished and consistent
- [ ] Rate limiting works correctly

### Medium Priority (Can Address Post-Launch)
- [ ] Advanced animations
- [ ] Detailed analytics
- [ ] Premium features
- [ ] Social sharing

### Documentation
- [ ] User guide written
- [ ] Privacy policy published
- [ ] Terms of service published
- [ ] Support email configured

## Sign-Off

**QA Tester**: _________________________
**Date**: _________________________
**Build Version**: _________________________
**Backend Version**: _________________________

**Ready for Release?**: [ ] Yes  |  [ ] No (see blockers above)

**Notes**:
```
[Add any additional observations or concerns here]
```
