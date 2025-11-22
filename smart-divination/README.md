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
- **Lunar Academy**: Complete educational content platform with 6 sections covering lunar wisdom, astronomy, and astrology with full multilingual support (ca/es/en):
  - **Special Moon Events**: Eclipses, supermoons, blue moons, void of course moon, and Black Moon Lilith
  - **Seasonal Wisdom**: 4 seasons and 8 sabbats with astrological correspondences
  - **Planetary Days**: 7 weekdays with celestial rulers following the Chaldean Order
  - **Lunar Elements**: Fire, Earth, Air, Water with zodiac signs and tarot suit connections
  - **Moon in Signs**: 12 zodiac signs with detailed lunar influence information
  - **Lunar Phases**: 8 moon phases with spiritual and practical guidance
  - See `docs/LUNAR_ACADEMY_ARCHITECTURE.md` for technical architecture details
- **Wisdom & Tradition**: Traditional tarot knowledge learning journey with 6 categories and 43 lessons covering the history, ethics, systems, symbolism, reading practices, and rituals of tarot with full multilingual support (ca/es/en):
  - **Origins & History** (8 lessons): From 15th century playing cards to modern tarot renaissance
  - **Ethics & Responsible Practice** (6 lessons): Professional standards and cultural sensitivity
  - **Traditional Tarot Systems** (5 lessons): Marseille, RWS, Thoth, Golden Dawn, and Kabbalistic traditions
  - **Symbolism & Archetypes** (10 lessons): Deep dive into Major and Minor Arcana symbolism
  - **Reading Practices & Techniques** (8 lessons): Spreads, reversals, intuition, and professional skills
  - **Sacred Space & Rituals** (6 lessons): Preparation, cleansing, moon phases, and seasonal timing
  - Features: Progress tracking, bookmarks, search, markdown content, offline-first
  - See `WISDOM-TRADITION-ULTRATHINK-PLAN.md` for complete implementation plan
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
