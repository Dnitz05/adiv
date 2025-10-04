# Backend (Canonical)

This package hosts the active Next.js backend for Smart Divination. It exposes API routes intended for Vercel/Node 18 deployments and relies on Supabase for persistence. All endpoints support graceful degradation when credentials are missing.

## Requirements
- Node 18+
- npm 9+
- Supabase project with migrations applied (see `../../supabase/migrations`)
- Optional: DeepSeek API key for interpretations, Datadog API key for metrics forwarding

## Setup
```bash
npm ci
cp .env.example .env.local
# populate SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY
# optional: DEEPSEEK_API_KEY, ENABLE_ICHING, ENABLE_RUNES, METRICS_PROVIDER, DATADOG_* overrides
npm run dev
```
The dev server listens on `http://localhost:3001`.

## Implemented Routes
- `POST /api/draw/cards` - tarot draw backed by Supabase randomness helpers and pack metadata. Persists sessions, artefacts, and messages when service credentials exist.
- `POST /api/draw/coins` - I Ching coins endpoint. Feature flagged by `ENABLE_ICHING=true`; when enabled it returns full hexagram analysis and persists the session envelope.
- `POST /api/draw/runes` - Elder Futhark rune casts. Feature flagged by `ENABLE_RUNES=true`; when enabled it returns rune metadata, reversed states, and persists the session envelope.
- `POST /api/chat/interpret` - AI interpretation pipeline (DeepSeek). Writes artefacts/messages back to Supabase when credentials are present.
- `POST /api/sessions` - canonical session creation endpoint used by mobile clients and background jobs.
- `GET /api/sessions/[userId]` - paginated session history sourced from `session_history_expanded`.
- `GET /api/users/[userId]/profile` and `GET /api/users/[userId]/can-start-session` - consolidated profile/usage metadata.
- `GET /api/metrics` and `GET /api/health` - observability endpoints (in-memory metrics with optional Datadog forwarder).

Planned but not yet implemented: pack download endpoints, premium purchase flows, and production-grade observability dashboards.

## Scripts
- `npm run dev` - start local dev server.
- `npm test` - Jest suite (unit plus integration when Supabase credentials exist).
- `npm run lint` - ESLint with TypeScript support.
- `npm run build` - production build (fails on type errors).
- `npm run supabase:types:ci` - regenerate Supabase types via CLI.
- `npm run supabase:db:push` - apply migrations using helper script.

## Testing Notes
- Unit tests mock Supabase; integration suites (`__tests__/integration`) require `SUPABASE_DB_URL`, `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `SUPABASE_ANON_KEY`, plus `supabase` CLI and `psql`. Set `SKIP_SUPABASE_INTEGRATION=1` to bypass them locally.
- `__tests__/lib/supabase.createDivinationSession.test.ts` validates session persistence helpers.
- `__tests__/integration/supabase.persistence.integration.test.ts` exercises real inserts/reads against the seeded database.

## Supabase Types
Generated Supabase types live in `lib/types/generated/supabase.ts`. Regenerate after schema changes:
```bash
npm run supabase:types:ci
```
Ensure commits stay in sync with `../../supabase/migrations` and rerun integration suites after edits.

## Known Gaps
- Coins and runes endpoints still need artefact/message persistence parity with tarot once UX plans solidify.
- Observability outside the built-in metrics endpoint is pending (Datadog/Grafana dashboards).
- Entitlement enforcement for premium packs happens at the client layer; server-side checks still need to land.

Contributions must include tests and documentation updates for any new endpoint or behaviour change.
