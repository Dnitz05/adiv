# Smart Divination Architecture Overview

## Monorepo Structure
- `backend/` - Next.js API routes (Node runtime) with shared logic under `lib/`.
- `apps/` - Flutter apps (`tarot`, `iching`, `runes`) managed by Melos.
- `packages/common/` - Shared localisation bundles (ca/en/es) and Flutter utilities.
- `supabase/` - SQL migrations, seeds, and CLI scripts.
- `docs/` - Living documentation (status, architecture, migration guide, schema notes).

## Backend
- Framework: Next.js API routes written in TypeScript, targeting Node 18.
- Persistence: Supabase (`users`, `sessions`, `session_artifacts`, `session_messages`, `user_stats`, `api_usage`).
- Validation: Zod schemas in `lib/utils/api.ts`, shared auth helpers, and feature gating via env vars.
- Content packs: `lib/packs/manifestRegistry.ts` loads `data/packs/manifests.json`, validates checksums, and exposes premium metadata per pack.
- Observability: In-memory metrics with optional console/Datadog providers, surfaced through `/api/metrics`.
- Endpoints: tarot/I Ching/runes draws (`POST /api/draw/*`), interpretations (`POST /api/chat/interpret`), session management (`POST /api/sessions`, `GET /api/sessions/[userId]`), profile/eligibility (`GET /api/users/...`), metrics and health probes.
- Feature flags: `ENABLE_ICHING` and `ENABLE_RUNES` gate their respective draw endpoints until ready.

## Database
- Enums: `divination_technique`, `user_tier`, `session_actor_type`, `session_artifact_type`.
- Core tables: `users`, `sessions`, `session_artifacts`, `session_messages`, `user_stats`, `api_usage`.
- Views and triggers: `session_history_expanded`, `touch_session_history()` keep aggregates fresh.
- Seeds: `supabase/seeds/dev_seed.sql` provides demo user, sessions, and artefacts.
- Policies: RLS enabled on artefacts/messages; production hardening still pending.

## Flutter Workspace
- Melos orchestrates dependencies between apps and shared packages.
- `apps/tarot` integrates draws, history, interpretations, eligibility, and pack metadata.
- `apps/iching` and `apps/runes` share networking/state layers and target the new endpoints once feature flags flip; UX polish and entitlement handling are work in progress.
- Testing focus: expand widget/integration coverage with HTTP mocks, Supabase fixtures, and golden tests.

## Deployment Considerations
- Backend deploys cleanly to Vercel/Node 18 but still needs environment bootstrap scripts and monitoring.
- Mobile release automation exists (`flutter-release.yml`) yet relies on manual secrets; store metadata and entitlements remain TODO.
- Supabase provisioning currently executes via scripts; plan managed environments and secret rotation before GA.

Use this overview alongside `docs/MIGRATION_GUIDE.md` to sequence upcoming milestones without relying on archived reports.
