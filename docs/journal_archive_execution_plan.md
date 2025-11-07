# Journal Archive / Calendar / Agenda / AI — Execution Blueprint

This document captures the deep‑dive analysis for the new Archive experience. It covers the current state, gaps, concrete tasks, and the CLI work needed to deliver a reliable multi-surface journal.

---

## 1. Data Inventory & Gaps

| Domain | Current Source | Path / Lines | Notes & Issues |
| --- | --- | --- | --- |
| Tarot / I Ching / Runes sessions | `sessions`, `session_artifacts`, `session_messages`, view `session_history_expanded` | Supabase migration `supabase/migrations/20250922090000_session_history_schema.sql:37-215`; Supabase helper `backend/lib/utils/supabase.ts:382-452` | Provides cards, interpretations, chat transcripts. No unified schema with other activity types. |
| Session API | `GET /api/sessions/[userId]` | `backend/pages/api/sessions/[userId].ts:55-154` | Uses offset pagination, only covers divination sessions. |
| Lunar advice history | Table implied as `lunar_queries` (not yet migrated) | API `backend/pages/api/lunar/history.ts:18-98`; helper `backend/lib/utils/supabase.ts:681-754` | Missing migration + Supabase types. |
| Lunar reminders | Table implied as `lunar_reminders` (not yet migrated) | API `backend/pages/api/lunar/schedule.ts:18-205`; helpers `backend/lib/utils/supabase.ts:766-959` | Same gap as above; needed for Agenda view. |
| Lunar metadata | `lunar_daily_cache` | Migration `supabase/migrations/20251023093000_lunar_cache_schema.sql:31-70`; service `backend/lib/services/lunar-service.ts:458-550` | Useful for per-day headers (phase + zodiac). |
| Flutter UI | Archive tab placeholder only | `_handleQuickActionArchive` `apps/tarot/lib/main.dart:1910`; BottomNav `apps/tarot/lib/main.dart:3403-3475` | No screens, controllers, or models for journal data. |

**Missing assets**: rituals, meditations, personal notes, reminders, insights, cross-linking between items, IA stats, detail views, search.

---

## 2. Phase 1 — Supabase Schema & ETL Tasks

### 2.1 New Schema Objects

1. **Enums**
   - `journal_activity_type` (`tarot_reading`, `chat`, `lunar_advice`, `ritual`, `meditation`, `note`, `reminder`, …).
   - `journal_activity_status` (e.g., `draft`, `in_progress`, `completed`, `scheduled`, `missed`).
   - `journal_activity_source` (`user`, `assistant`, `system`, `import`).

2. **Core tables**
   - `user_activities` (id, user_id FK → `users`, type, status, activity_date (TIMESTAMPTZ), timezone, lunar phase/zodiac meta, title, summary, tags `TEXT[]`, mood, duration, `reference_table`, `reference_id`, `payload JSONB`, `metadata JSONB`, timestamps).
   - `journal_notes` (id, user_id, title, body, mood, visibility, linked_activity_id, tags, created/updated timestamps).
   - `journal_reminders` (id, user_id, scheduled_at, timezone, type, status, payload, metadata, delivery history).
   - `journal_activity_links` (junction table to relate activities ↔ notes/rituals).
   - `journal_insights` (id, user_id, period, summary, metrics JSONB, generated_at, expires_at, provider metadata).

3. **Supporting Objects**
   - Trigger `set_updated_at` for each table.
   - Functions `journal_touch_activity_from_session()`, `..._from_lunar_advice()`, `..._from_reminder()` to convert raw events into normalized entries.
   - Row-Level Security mirroring existing tables: owner access for `authenticated/anon`, full access for `service_role`.
   - Indexes:
     - `idx_journal_activities_user_date` (`user_id`, `activity_date DESC`).
     - `idx_journal_activities_type`, `idx_journal_activities_phase`, `idx_journal_activities_reference`.
     - `GIN` on `tags` and `payload`.

4. **Formalize existing but undocumented tables** (`lunar_queries`, `lunar_reminders`) and regenerate Supabase types via `npm run supabase:types:ci`.

### 2.2 ETL & Backfill

- **Triggers**:
  - `AFTER INSERT/UPDATE` on `sessions`, `session_artifacts`, `session_messages` to insert/refresh a `user_activities` row representing tarot/I Ching/Rune events.
  - Similar triggers on `lunar_queries` and `lunar_reminders`.
  - Hooks for future ritual/meditation tables (stubs now, easy to implement later).

- **Backfill script** (`scripts/backfill_journal_activities.ts`):
  - Scans existing sessions and lunar data, batches inserts into `user_activities`.
  - Validates counts per user, checks duplicates, logs metrics.
  - CLI steps: `cd backend && npm run ts-node scripts/backfill_journal_activities.ts --limit=500`.
- Placeholder CLI entry lives at `smart-divination/backend/scripts/backfill_user_activities.mjs`. Today it only performs dry-run inspection (`--dry-run`) while we finish ETL logic; once data contracts stabilize we will extend it to insert/update records in batches.

- **Validation**:
  - Supabase CLI: `supabase db reset` with new migrations; ensure tests pass.
  - SQL smoke tests verifying indexes + view counts.

---

## 3. Backend Journal Service Tasks

1. **Service Layer**
   - Create `backend/lib/services/journal-service.ts` that queries `user_activities`, `journal_notes`, `journal_reminders`, `journal_insights`, `lunar_daily_cache`.
   - Provide helpers for timeline pagination (cursor-based), day summaries, stats computation, and insight caching.

2. **API Endpoints**
   - `GET /api/journal/timeline`: query params `from`, `to`, `cursor`, `types`, `phase`, `search`. Response includes `items`, `nextCursor`, `hasMore`.
   - `GET /api/journal/day/[date]`: includes lunar header and grouped activities.
   - `GET /api/journal/activity/[id]`: full payload + CTA metadata (links back to Chat/Tarot screens).
   - `GET /api/journal/stats`: totals per phase/type, streak info.
   - `GET /api/journal/insights`: returns cached insights; triggers regeneration if expired.
   - `POST/PATCH/DELETE /api/journal/notes` and `/api/journal/reminders`: CRUD with ownership checks.
   - `GET /api/journal/search`: `tsvector`-backed full-text search across titles, summaries, tags, payload (cards/questions).

3. **Observability**
   - Each handler uses `parseApiRequest`, `recordApiMetric`, and structured logs (matching `GET /api/sessions/[userId]`).
   - Feature flag `journalArchive` (config via env) to gate new routes until ready.

4. **Caching Strategy**
   - Introduce `timelineCacheKey(userId, filters)` storing latest page (e.g., Redis or in-memory fallback). TTL 24 h, invalidated on new activity/notes.
   - Stats/insights cached in `journal_insights` with TTL 12 h, recomputed via scheduled job.

---

## 4. Flutter / Frontend Tasks

1. **Models & State**
   - Add `lib/models/journal_entry.dart`, `journal_filters.dart`, `journal_stats.dart`.
   - API client `lib/api/journal_api.dart` using existing `buildApiUri` and `buildAuthenticatedHeaders`.
   - State management: `JournalController` (ChangeNotifier) for timeline, filters, view modes, note/reminder actions. Persist filters in `LocalStorageService`.

2. **Screens**
   - `ArchiveScreen`: hosts tabs (Timeline, Calendar, Agenda, Insights).
   - Timeline view:
     - `CustomScrollView` with day headers (`Waning Crescent • ♓ Pisces`) and cards for each activity (tarot, chat, ritual, meditation, note, reminder).
     - CTA buttons (`Continuar conversa`, `Veure interpretació`, `Afegir nota`).
     - Infinite scroll + pull-to-refresh.
   - Calendar view:
     - Monthly grid with dots per category (colors/icons).
     - Day detail sheet summarizing counts + quick links.
   - Agenda view:
     - Upcoming reminders/rituals with complete/snooze actions.
     - Integration with notification service.
   - Insights view:
     - KPI cards (tirades per fase, ratxa, temes recurrents).
     - “Pregunta a l’IA” composer using chat backend.

3. **Integration**
   - Update `apps/tarot/lib/main.dart:3112-3153` to render `ArchiveScreen` when `_selectedBottomNavIndex == 3`.
   - Replace `_handleQuickActionArchive` (line 1910) to set the tab (and optionally show onboarding if user not logged in).
   - Add l10n strings for new labels in `common` package.

4. **Detail Components**
   - `JournalActivityDetailSheet` showing metadata, cards/messages, note editor, share/export CTA.
   - `NoteComposer` and `ReminderEditor` with validation and linking to activities.
   - Reuse existing components (e.g., `ChatScreen`) via deep links for “Continuar conversa”.

---

## 5. Testing & Validation

- **Backend**
  - Unit tests for `journal-service` (timeline grouping, filters, stats).
  - Endpoint tests using `supertest` (auth required, filtering, pagination).
  - Integration tests with Supabase (migrations applied) verifying triggers/backfill.
  - Load tests for timeline with >10k activities per user, target <200 ms per page.

- **Frontend**
  - Unit tests for `JournalController` (filter changes, pagination).
  - Widget tests for Timeline/Calendar/Agenda views.
  - Golden tests for key cards (tarot/chat/notes).
  - Manual QA: navigation between tabs, CTA deep links, offline/cache behaviour.

- **ETL Validation**
  - Post-backfill SQL verifying counts per user & type.
  - Scripts comparing sessions vs journal entries to ensure parity.
  - Monitoring alerts for trigger failures.

---

## 6. CLI Workflow (High-Level)

1. `supabase db commit -m "add journal schema"` → review SQL, run `supabase db reset` locally.
2. `npm run supabase:types:ci` → update `backend/lib/types/generated/supabase.ts`.
3. Implement `journal-service` + endpoints → `npm test`.
4. Flutter work:
   - `melos bootstrap` (if needed), `flutter pub get`, build new screens.
   - `flutter test`.
5. Backfill script:
   - `node scripts/backfill_journal_activities.js --dry-run`.
   - Verify logs, then run without `--dry-run`.
6. Deploy behind feature flag; enable gradually.

---

This blueprint completes Phase 0 (analysis) and prepares the concrete todo list for Phase 1 (schema + ETL). The next step is to translate the schema changes into actual Supabase migrations and begin implementing the `journal-service` layer.॥
