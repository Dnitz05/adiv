Smart Divination – Architecture Overview

Monorepo Structure
- `smart-divination/` (canonical workspace)
  - `backend/` – Next.js serverless (API routes under `pages/api`, shared code under `lib`)
  - `apps/` – Flutter apps (`iching/`, `runes/`, `tarot/` (WIP))
  - `packages/common/` – Shared Flutter code (UI, localization, models)
- `supabase/` – Project configuration and SQL migrations (enums, tables, RLS, functions)
- `docs/` – Guides and status

Backend (Next.js + TypeScript)
- API: serverless routes exposing health, draw (cards/coins/runes), sessions, packs, users, chat.
- Type system: strict TS desired; align with Supabase schema via generated or hand-maintained types.
- Observability: lightweight in-memory metrics with optional Datadog provider (to be ported into canonical).
- Security: CORS headers via `vercel.json`, DB RLS policies; add auth middleware and schema validation (Zod/Joi).

Database (Supabase)
- Enums: `divination_technique`, `user_tier`.
- Tables: `users`, `sessions`, `user_stats`, `api_usage` with constraints and indexes.
- RLS: enabled across tables; policies for user and service roles.
- Functions/Triggers: keep `last_activity` updated; stats refresh; cleanup for soft-deleted sessions.

Flutter Workspace (Melos)
- Apps share `packages/common` for localization and common code.
- Scripts: analyze, test, coverage, l10n generation.

CI/CD
- Backend CI (canonical): lint, type-check, tests, build.
- Legacy backend CI: maintained until canonical parity.
- Flutter CI: l10n, analyze, tests, coverage and threshold enforcement.
- Deploy (target): Vercel from canonical backend with preview (PR) and prod (main) stages.

