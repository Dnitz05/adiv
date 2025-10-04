# Smart Divination Monorepo

## Workspace Summary
Release focus remains on the tarot experience. The I Ching and runes stacks are implemented end-to-end but gated by `ENABLE_ICHING` / `ENABLE_RUNES` until UX, entitlement flows, and localisation are production ready. Treat the workspace as the canonical source of truth: legacy repositories are frozen.

## Directories
- `backend/` - Next.js API routes with shared libraries under `lib/`, Supabase integration helpers, metrics, and feature-flagged draw pipelines.
- `apps/` - Flutter apps (`tarot`, `iching`, `runes`) orchestrated by Melos. The tarot client is the beta target; the others stay hidden until their feature flags flip on.
- `packages/common/` - Shared localisation bundles (ca/en/es) and Flutter utilities.
- `docs/` - Monorepo-specific guidance and architecture notes.
- `supabase/` - Shared migrations, seeds, and CLI config.

## Backend Highlights
- Node 18+, Next.js API routes deployed to Vercel or compatible Node targets.
- Persistence powered by Supabase (sessions, artefacts, messages, stats, usage).
- Feature flags:
  - `ENABLE_ICHING=true` exposes `/api/draw/coins` with hexagram analytics.
  - `ENABLE_RUNES=true` exposes `/api/draw/runes` with Elder Futhark data.
- Content packs live in `lib/packs/manifestRegistry.ts` and `data/packs/manifests.json`, including checksum validation and premium metadata.
- Observability uses in-memory metrics with optional Datadog forwarding via env vars.

### Quick Start
```bash
cd backend
npm ci
cp .env.example .env.local
# fill SUPABASE_* keys, DEEPSEEK_API_KEY, toggle ENABLE_ICHING/ENABLE_RUNES as needed
npm run dev
```

### Tests
- `npm test`, `npm run lint`, `npm run type-check` keep the backend hermetic.
- Supabase integration suites under `__tests__/integration` require CLI access plus service credentials; skip with `SKIP_SUPABASE_INTEGRATION=1` when unavailable.

## Flutter Highlights
- Run `melos bootstrap` at repo root before working on apps.
- `apps/tarot` includes authentication, history, interpretations, entitlement scaffolding, and release automation (`flutter-release.yml`).
- `apps/iching` and `apps/runes` share networking/state layers and target the new endpoints once feature flags flip; UX polish and entitlement handling remain in progress.
- Add HTTP mocks and golden/widget tests before public release.

## Supabase
- `scripts/supabase/apply.sh` applies migrations (`supabase/migrations`) and seeds (`supabase/seeds/dev_seed.sql`).
- Regenerate backend types with `npm run supabase:types:ci` whenever the schema changes.
- Demo credentials: seed user `demo-seeker@smartdivination.test / TarotDemo1!` exists after running the seed script.

## Current Priorities
1. Finalise tarot launch polish: store metadata, localisation review, extended widget coverage.
2. Wire Datadog (or alternative) for backend metrics and alerting.
3. Design entitlement flow for premium packs (`runes-elder-futhark`) and surface it in Flutter.
4. Bring I Ching and runes apps up to production parity once content packs and UX assets land.

See `../docs/STATUS.md` for sprint-level checkpoints and `../docs/MIGRATION_GUIDE.md` for the migration checklist.
