Smart Divination – Migration Guide

Scope
- Consolidate development into the canonical workspace `smart-divination/`.
- Retire legacy folders after parity: `smart_tarot/`, `smart-divination-production/`.

Checklist (Backend)
- Type Safety: fix TS errors in `smart-divination/backend/lib/utils/supabase.ts` (nullability, typed rows, `Insert/Update`).
- API Parity: port routes (sessions/users/packs/chat) from legacy; remove temporary 501 delegates.
- Observability: add `lib/utils/metrics.ts` and `/api/metrics` endpoint; wire Datadog env vars.
- Tests: extend coverage to all new routes; keep Jest green in CI.
- CI/CD: ensure `backend-canonical-ci` is green (lint, type-check, tests, build). Add deploy pipeline (Vercel) once green.

Checklist (Flutter)
- Workspace: ensure `packages/common/pubspec.yaml` exists; `melos bootstrap` succeeds.
- L10n: run `melos run gen:l10n`; verify generated code compiles.
- Apps: migrate Tarot to `smart-divination/apps/tarot/`; update assets and imports to use `packages/common`.
- CI: Flutter analyze/tests pass in CI; minimum coverage enforced.

Retiring Legacy
- Freeze deploys from `smart-divination-production/` after canonical parity.
- Archive `smart_tarot/` once the new `apps/tarot/` builds and tests pass under Melos.

Acceptance Gates
- Canonical backend: `npm run type-check` and `npm test` pass; `/api/metrics` available in dev.
- Flutter workspace: `melos run analyze:all && melos run test:all` pass.
- Single deploy origin: canonical backend via Vercel.

