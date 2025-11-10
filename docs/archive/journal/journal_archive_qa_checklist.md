# Journal Archive QA Checklist

This checklist ensures the Archive/Calendar/Agenda experience works end-to-end before rollout.

## Preconditions
- Supabase migrations applied (journal tables, ETL triggers).
- Backfill script executed (user_activities contains historic data).
- Backend `/api/journal/*` endpoints reachable.
- Flutter app built with Archive tab enabled.

## API Verification
1. `GET /api/journal/timeline`
   - Authenticated requests return items sorted DESC by `activity_date`.
   - Supports `types`, `phase`, `search`, `limit`, `cursor` and `from/to` filters.
   - Cursor pagination works: second page starts where first ended.
2. `GET /api/journal/day/:date`
   - Returns activities for the day and totals per type.
   - Lunar metadata present when cache has data.
   - Invalid dates (format) return 400.
3. `GET /api/journal/stats`
   - Period values `week|month|year|all` respected (date windows correct).
   - Totals by type/phase sum to `totalActivities`.

## Flutter UI
1. **Timeline**
   - Initial load shows spinner then cards grouped chronologically.
   - Scroll to end triggers `loadMore` and appends entries.
   - Tap on entry (tarot/chat/note…) opens correct action or detail (if wired).
2. **Filters**
   - Filter sheet opens, toggles type/phase/period/search.
   - Applying filters refreshes list and updates chip indicators.
   - Clearing filters resets to defaults.
3. **Calendar**
   - Monthly grid shows markers for days with activity.
   - Selecting a day fetches summary; stats update accordingly.
   - Switching months focuses new range; no crashes.
4. **Stats Card**
   - Displays totals and top activity types.
   - Refresh button refetches stats (loading indicator visible).
5. **Offline/Error Handling**
   - Disable network and ensure UI shows retry/toast.
   - API failure surfaces friendly message (no blank screen).
6. **Navigation**
   - Bottom tab Archive loads even after app restart.
   - Back navigation returns to previous screens correctly.

## Performance
- Timeline load < 200 ms for first page (simulate realistic network; monitor logs).
- Infinite scroll doesn’t issue duplicate calls.
- Filter changes don’t leak memory (use Flutter DevTools memory view).

## Backfill Validation
- Sample users show full history vs direct SQL query counts.
- ETL triggers confirmed by performing new sessions/chats and checking `user_activities`.

## Regression Checks
- Chat, tarot draws, lunar panels still operate (Archive changes didn’t break existing tabs).
- Lint/analysis passes or known warnings documented.

## Sign-off
- QA engineer signs verifying all checks.
- Runbook updated with deployment + monitoring steps.
