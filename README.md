# Smart Divination Platform

## Overview
Release focus: tarot backend plus Flutter client in private beta. I Ching and runes pipelines now exist end-to-end but stay behind feature flags until UX, content packs, and QA catch up. The root repo wraps the canonical workspace in `smart-divination/` together with Supabase tooling and runbooks. The system is functional as of October 2025 but remains pre-launch: expect active work on UX polish, observability, pack distribution, and release automation.

## Repository Layout
- `smart-divination/backend` - Next.js API routes for tarot, I Ching, and runes with Supabase integration, feature gating, metrics, and Jest/unit plus Supabase integration tests.
- `smart-divination/apps` - Flutter apps (`tarot`, `iching`, `runes`) managed by Melos; tarot is the beta target, the others are hidden builds until feature flags flip on.
- `smart-divination/packages/common` - Shared localisation (ca/en/es) and client utilities.
- `supabase/` - Database migrations, seeds, and helper scripts (`scripts/supabase/*`).
- `docs/` - Living architecture notes, migration guide, and current status.

## Development Setup
### Backend (Next.js)
```bash
cd smart-divination/backend
npm ci
cp .env.production.example .env.local
# Required: SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY
# Required for AI: DEEPSEEK_API_KEY
# Feature flags: ENABLE_ICHING, ENABLE_RUNES (default: false)
# Optional: RANDOM_ORG_KEY, METRICS_PROVIDER, DATADOG_* overrides
npm run dev
```
The dev server listens on `http://localhost:3001`. See `.env.production.example` for full configuration options.

#### Endpoints
- `POST /api/draw/cards` - tarot draws with Supabase persistence and pack metadata.
- `POST /api/draw/coins` - I Ching throws. Returns 503 unless `ENABLE_ICHING=true`; when enabled it delivers full 64-hexagram analysis, session persistence, and artefact stubs.
- `POST /api/draw/runes` - Elder Futhark rune casts. Returns 503 unless `ENABLE_RUNES=true`; when enabled it outputs rune metadata, orientation, and persists the session envelope.
- `POST /api/chat/interpret` - AI interpretation pipeline (DeepSeek). Persists generated messages and artefacts when Supabase credentials are present.
- `POST /api/sessions` - canonical session creation endpoint for mobile clients and background jobs.
- `GET /api/sessions/[userId]`, `GET /api/users/[userId]/profile`, `GET /api/users/[userId]/can-start-session` - session history and eligibility backed by the `session_history_expanded` view.
- `GET /api/metrics`, `GET /api/health` - local observability endpoints (in-memory metrics with optional Datadog forwarder).

Supabase credentials are optional for local smoke runs: endpoints fall back to non-persistent responses when service keys are absent.

#### Testing
- `npm test`, `npm run lint`, and `npm run type-check` remain required for CI.
- Supabase integration specs live in `__tests__/integration/*`. To exercise them locally export `SUPABASE_DB_URL`, `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `SUPABASE_ANON_KEY` and ensure `supabase` CLI plus `psql` are on PATH. The harness runs `scripts/supabase/apply.sh` to migrate and seed before tests.
- Use `npm run supabase:types:ci` to regenerate TypeScript types after changing migrations.

### Flutter Workspace (Melos)
```bash
cd smart-divination
dart pub global activate melos
melos bootstrap
melos run analyze:all
melos run test:all
```

Running tarot on an Android emulator:
```bash
cd smart-divination/apps/tarot
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3001   --dart-define=SUPABASE_URL=https://<project>.supabase.co   --dart-define=SUPABASE_ANON_KEY=<public-anon-key>
```
The tarot client consumes live Supabase history and interpretations. The I Ching and runes apps compile but stay hidden/off by default until the feature flags are enabled and content packs ship.

### Supabase
- Apply migrations in `supabase/migrations` via `scripts/supabase/apply.sh` (requires Supabase CLI plus `psql`) to provision schemas, views, and the demo seed (`supabase/seeds/dev_seed.sql`).
- Continuous integration calls `scripts/supabase/db_push.sh` and `npm run supabase:types:ci` to keep backend types aligned with the database.
- The backend uses the service-role key; do not expose it in Flutter apps. The clients authenticate with anon keys only.

## Testing & Tooling
- Backend unit tests mock Supabase; integration suites verify persistence when credentials exist.
- Flutter projects currently have smoke/widget coverage. Expand HTTP mocking and Supabase-aware tests before launch.
- Metrics module (`lib/utils/metrics.ts`) can emit to stdout (`METRICS_PROVIDER=console`) or Datadog (`METRICS_PROVIDER=datadog` with `DATADOG_*` env vars).
- Pack metadata lives in `backend/data/packs/manifests.json` and is loaded through `lib/packs/manifestRegistry.ts` with checksum validation.

## Release Status & Next Steps
- **Tarot**: Backend plus Flutter app in private beta. Android signing complete (keystore, key.properties), release APK tested (48.3MB). Build blockers resolved (app_links compileSdk, intl 0.20.0) and documented in `ANDROID_LAUNCH_CHECKLIST.md`. iOS signing and store metadata pending.
- **Backend**: Production environment configuration complete (`.env.production`, error handling standardized, health/metrics endpoints operational).
- **Security**: Comprehensive secrets management guide in `docs/SECRETS.md` covering GitHub Actions, Vercel, Supabase, and rotation procedures.
- **I Ching and runes**: Server endpoints complete behind feature flags; Flutter clients need UX, localisation, entitlement gating, and QA before exposure.
- **Content packs**: Manifest registry in place; distribution hosting, entitlement checks, and purchase flows are still TODO.
- **Observability**: In-memory metrics available; connect Datadog or Grafana before production.
- **CI/CD**: Secrets documented but not yet configured in GitHub Actions. Use `CRITICAL_BLOCKERS_PLAN.md` to track the remaining launch-critical tasks.

Consult `docs/STATUS.md` for the current sprint focus, `docs/MIGRATION_GUIDE.md` for migration checklist progress, and `docs/SECRETS.md` for comprehensive secrets management.
