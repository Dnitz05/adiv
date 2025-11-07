# Journal Archive Deploy Runbook

## Overview
The Archive/Calendar/Agenda feature unifies user activity history. Deployment requires data migration, backfill, API enablement, and app rollout.

## Prerequisites
1. Ensure Supabase migrations are applied (journal schema + triggers).
2. Backend code deployed to staging with `/api/journal/*` behind a feature flag (`JOURNAL_ARCHIVE_ENABLED` or similar).
3. Flutter app builds with Archive tab enabled.

## Deployment Steps
### 1. Supabase Migration & Types
- Run `supabase db push` (or deploy via CI) to apply `20251107103000_journal_archive_schema.sql`.
- In backend workspace, execute `npm run supabase:types:ci` with `SUPABASE_DB_URL` set to regenerate `lib/types/generated/supabase.ts`.
- Verify migrations via `supabase db lint` or manual SQL checks.

### 2. Backfill
- Set environment:
  ```bash
  export SUPABASE_URL=...
  export SUPABASE_SERVICE_ROLE_KEY=...
  export JOURNAL_BACKFILL_BATCH=250
  export JOURNAL_BACKFILL_MAX=0   # 0 = unlimited
  ```
- Dry run:
  ```bash
  node scripts/backfill_user_activities.mjs --dry-run
  ```
- Execute real run (may take hours; monitor logs):
  ```bash
  node scripts/backfill_user_activities.mjs
  ```
- Track progress (activities count per user, errors). Resume from offsets using `JOURNAL_BACKFILL_*_OFFSET`.

### 3. API & Feature Flag
- Deploy backend to staging with flag `JOURNAL_ARCHIVE_ENABLED=false`.
- Smoke test `/api/journal/timeline` (curl with bearer token).
- Enable flag for staging users; run QA checklist (docs/journal_archive_qa_checklist.md).
- For production, roll out flag gradually (internal users -> 10% -> 50% -> 100%).

### 4. App Release
- Prepare new app build (Android/iOS). Ensure Archive tab visible only when server flag returns true (optional guard).
- Run regression tests (chat, tarot, lunar panels).
- Submit to stores or roll out via OTA if applicable.

## Monitoring & Alerting
- Metrics (Next.js `recordApiMetric` already emits). Hook to Datadog/Grafana:
  - `journal.timeline.fetch` latency/error rate.
  - `/api/journal/day` and `/stats` error counts.
  - Supabase row counts for `user_activities` per hour.
- Alerts:
  - High error rate (>5% over 5 min) on journal endpoints.
  - Backfill failures (script exit non-zero).
  - Supabase trigger failures (check Postgres logs).

## Rollback Plan
- If issues arise:
  1. Disable feature flag (Archive tab reverts to old behavior).
  2. Stop backfill or pause job.
  3. If schema causes issues, revert migration (preferred to add hotfix migration marking feature inactive rather than drop data).

## Checklist
- [ ] Migrations applied (prod & staging).
- [ ] Types regenerated and committed.
- [ ] Backfill completed; sample users validated.
- [ ] API flag enabled in staging; QA checklist passed.
- [ ] Monitoring dashboards updated with journal metrics.
- [ ] Feature flag rollout plan established.
- [ ] App release scheduled or OTA toggled.
