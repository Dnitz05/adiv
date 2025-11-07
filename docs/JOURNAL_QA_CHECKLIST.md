# Journal/Archive Feature - QA Checklist

## Pre-Deployment Verification

### Backend API Endpoints

- [ ] **GET /api/journal/timeline** - Timeline with pagination
  - [ ] Test with limit=20, verify cursor pagination works
  - [ ] Test with filters (types, phase, period, search)
  - [ ] Test with invalid userId returns appropriate error
  - [ ] Test response includes correct entries, hasMore, nextCursor

- [ ] **GET /api/journal/stats** - Activity statistics
  - [ ] Test with period='month', verify aggregations
  - [ ] Test totalActivities count matches reality
  - [ ] Test totalsByType breakdown is accurate
  - [ ] Test totalsByPhase includes lunar data

- [ ] **GET /api/journal/day/[date]** - Day summary
  - [ ] Test with valid date YYYY-MM-DD format
  - [ ] Test with future date returns empty result
  - [ ] Test entries for day are correctly filtered
  - [ ] Test lunar metadata is included

### Database & Migration

- [ ] **Supabase Migration Applied**
  - [ ] Run `supabase db push --linked` successfully
  - [ ] Verify `user_activities` table exists
  - [ ] Verify ENUMs created: `journal_activity_type`, `journal_activity_status`
  - [ ] Verify RLS policies active for user_activities table
  - [ ] Verify ETL trigger `sync_session_to_activities` installed
  - [ ] Test trigger fires on sessions INSERT/UPDATE

- [ ] **Data Integrity**
  - [ ] Create a tarot reading, verify activity created in user_activities
  - [ ] Verify activity has correct activity_type, payload, metadata
  - [ ] Verify lunar_phase_id and lunar_zodiac_name populated
  - [ ] Delete a session, verify CASCADE deletes activity

### Flutter App - Archive Screen

#### Navigation
- [ ] **Bottom Nav Integration**
  - [ ] Tap Archive tab (index 3) navigates to ArchiveScreen
  - [ ] Quick action "View Archive" navigates correctly
  - [ ] Back button returns to previous screen
  - [ ] userId and locale passed correctly

#### UI Components
- [ ] **Stats Card**
  - [ ] Displays "Insights" header
  - [ ] Shows "Total" count
  - [ ] Shows top 3 activity types with counts
  - [ ] Refresh button reloads stats
  - [ ] Loading indicator appears during fetch

- [ ] **Calendar View**
  - [ ] Calendar renders with current month
  - [ ] Days with activities have event markers
  - [ ] Tap day shows day summary below calendar
  - [ ] Day summary shows "X activities" count
  - [ ] Day summary shows breakdown by type
  - [ ] Loading indicator appears during day fetch

- [ ] **Timeline View**
  - [ ] Entries display with correct icon per type
  - [ ] Entry card shows title (or fallback to type name)
  - [ ] Entry card shows summary text (truncated to 3 lines)
  - [ ] Entry card shows timestamp in local timezone
  - [ ] Entry card shows activity type chip with color
  - [ ] Infinite scroll loads more entries when reaching bottom
  - [ ] "No more entries" appears when all loaded

#### Interactions
- [ ] **Pull-to-Refresh**
  - [ ] Pull down from top triggers refresh
  - [ ] Spinner appears during refresh
  - [ ] Timeline, stats, and day summary all refresh
  - [ ] Scroll position resets to top

- [ ] **Filter Panel**
  - [ ] Tap filter icon opens bottom sheet
  - [ ] Search text input works
  - [ ] Activity type chips toggle on/off
  - [ ] Lunar phase dropdown shows all phases
  - [ ] Period chips (Today, Week, Month, All time) work
  - [ ] "Apply filters" button closes sheet and reloads timeline
  - [ ] Timeline respects all applied filters

#### Empty States
- [ ] **No User ID**
  - [ ] Shows "Sign in to view your journal history."
  - [ ] No API calls made

- [ ] **No Entries Yet**
  - [ ] Shows "No entries yet.\nStart a reading or add a note!"
  - [ ] Stats card shows 0 total
  - [ ] Calendar has no event markers

#### Error Handling
- [ ] **Network Failure**
  - [ ] Timeline fails gracefully, shows error message
  - [ ] Stats fails gracefully, shows "No stats available"
  - [ ] Day summary fails gracefully, doesn't crash

- [ ] **Invalid Data**
  - [ ] Malformed API response doesn't crash app
  - [ ] Missing title falls back to activity type name
  - [ ] Missing summary doesn't break card layout

### Performance

- [ ] **Initial Load Time**
  - [ ] Archive screen loads within 2 seconds on 4G
  - [ ] No janky animations or frame drops
  - [ ] Images/icons load without flicker

- [ ] **Scroll Performance**
  - [ ] Timeline scrolls smoothly with 100+ entries
  - [ ] Infinite scroll pagination is smooth
  - [ ] No memory leaks after scrolling through 500+ entries

- [ ] **API Response Times**
  - [ ] Timeline endpoint responds < 500ms for 20 entries
  - [ ] Stats endpoint responds < 300ms
  - [ ] Day summary endpoint responds < 200ms

### Accessibility

- [ ] **Screen Reader**
  - [ ] All buttons have semantic labels
  - [ ] Entry cards announce title and type
  - [ ] Calendar days announce date and activity count

- [ ] **Keyboard Navigation** (if applicable)
  - [ ] Tab order is logical
  - [ ] All interactive elements focusable

- [ ] **Color Contrast**
  - [ ] Activity type colors meet WCAG AA standards
  - [ ] Text readable in both light and dark themes

### Localization

- [ ] **Catalan (ca)**
  - [ ] All UI strings translated
  - [ ] Date formatting uses Catalan locale
  - [ ] Activity type labels translated

- [ ] **English (en)**
  - [ ] All UI strings display correctly
  - [ ] Date formatting uses English locale

### Edge Cases

- [ ] **Timezone Handling**
  - [ ] Entries show correct local time
  - [ ] Day boundaries respect user's timezone
  - [ ] UTC timestamps convert correctly

- [ ] **Large Data Sets**
  - [ ] 1000+ entries load without crash
  - [ ] Pagination cursor doesn't break
  - [ ] Stats aggregation handles large counts

- [ ] **Concurrent Updates**
  - [ ] Create entry in another device, pull-to-refresh shows it
  - [ ] No race conditions in timeline loading

## Post-Deployment Smoke Tests

- [ ] Create a new tarot reading, verify it appears in Archive
- [ ] Apply 3 different filters, verify timeline updates
- [ ] Scroll through 50+ entries, verify no crashes
- [ ] Refresh stats, verify counts update
- [ ] Select 5 different calendar days, verify summaries load

## Monitoring & Alerts

- [ ] Sentry error tracking configured for Archive screen
- [ ] API endpoint latency alerts configured (p95 > 1s)
- [ ] Database query performance monitored (sync_session_to_activities)
- [ ] user_activities table size growth tracked

## Rollback Plan

- [ ] Document rollback procedure for migration
- [ ] Test rollback on staging environment
- [ ] Verify app functions without journal feature if backend down

---

**Test Coverage:**
- Unit tests: 3/3 passing (JournalController)
- Widget tests: 5/5 passing (ArchiveScreen)
- E2E tests: Manual QA required

**Sign-off:**
- [ ] Backend Engineer
- [ ] Flutter Engineer
- [ ] QA Engineer
- [ ] Product Manager
