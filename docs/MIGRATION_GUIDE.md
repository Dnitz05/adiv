# Smart Divination Migration Guide

This guide tracks the consolidation of development inside `smart-divination/` and the retirement of legacy artefacts. Update it whenever tasks move.

> Scope reminder: the first launch remains tarot (backend + app). I Ching and runes follow once UX, entitlement, and localisation are ready.

## Objectives
1. Maintain a single canonical backend at `smart-divination/backend`.
2. Ship Flutter apps from the Melos workspace; legacy app projects stay archived.
3. Keep the Supabase schema, generated types, and documentation in sync.

## Backend Checklist
- [x] Implement draw endpoints for all techniques (`/api/draw/cards`, `/api/draw/coins`, `/api/draw/runes`). Coins and runes stay feature-flagged via env vars until release.
- [x] Persist sessions in Supabase when credentials exist, with graceful fallbacks when they do not.
- [ ] Extend I Ching and runes endpoints to persist artefacts/messages the same way tarot does.
- [x] Add Supabase integration tests (`__tests__/integration`) and harness scripts to catch schema drift.
- [x] Production environment configuration complete (`.env.production`, `.env.production.example`).
- [x] Error handling standardized with centralized error definitions (`lib/utils/errors.ts`).
- [x] Health and metrics endpoints operational with Node.js runtime.
- [ ] Finalise production observability (dashboards/alerts) beyond the in-memory metrics module.

## Flutter Checklist
- [x] Point all three apps at the canonical backend and shared identity helpers.
- [x] Android signing configured (keystore, key.properties, build.gradle.kts).
- [x] Release APK build tested and verified (48.3MB).
- [ ] iOS signing configuration (certificates, provisioning profiles).
- [ ] Replace placeholder assets/copy and align visual design across techniques.
- [ ] Surface enriched Supabase history (interpretations, keywords) in I Ching and runes once backend artefacts land.
- [ ] Add widget and integration tests with HTTP/Supabase mocks.
- [x] Keep release workflows in place (`flutter-release.yml` for signed AAB/IPA generation).

## Supabase Checklist
- [x] Migrations committed (`20250101000001_initial_schema.sql`, `20250922090000_session_history_schema.sql`).
- [x] Development seed available at `supabase/seeds/dev_seed.sql`.
- [x] Automation ready (`scripts/supabase/apply.sh`, `scripts/supabase/db_push.sh`, `npm run supabase:types:ci`).
- [x] Production environment variables documented (`.env.production.example`).
- [x] Secret management guide complete (`docs/SECRETS.md`).
- [ ] RLS hardening and security audit for production.

## Documentation
- [x] Refresh READMEs and `docs/STATUS.md` with the real project state.
- [x] Deployment playbooks published (docs/GITHUB_ACTIONS_SETUP.md, docs/VERCEL_DEPLOYMENT_GUIDE.md).
- [ ] Keep this guide and `docs/ARCHITECTURE.md` aligned with each milestone.

## Legacy Clean-up
- Archive references to `smart-divination-production` and `smart_tarot` once feature parity is confirmed.
- Remove or lock tooling that still points at archived directories to avoid confusion.

Review this checklist after each sprint to ensure migration goals stay on track.
