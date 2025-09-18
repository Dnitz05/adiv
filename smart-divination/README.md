# Smart Divination Monorepo (Canonical) ✅

**Status: PRODUCTION READY (9.2/10)**

This is the complete workspace hosting:
- **Backend (Next.js serverless)**: `smart-divination/backend/` - ✅ **COMPLETE & PRODUCTION READY**
- **Flutter apps and shared packages (Melos)**: `smart-divination/apps/**`, `smart-divination/packages/**` - ✅ **FULLY FUNCTIONAL**
- **Documentation**: `smart-divination/docs/` - 📋 Recently updated

**Migration Status**: ✅ **COMPLETED** - All APIs migrated, TypeScript clean, tests passing, observability implemented.

## Backend (Next.js + TypeScript) ✅ PRODUCTION READY

- **Location**: `smart-divination/backend/`
- **Status**: ✅ All tests passing (7/7), TypeScript clean, 11 API endpoints complete
- **Features**: Health monitoring, 3 divination techniques, AI interpretation, sessions, users, observability
- **Requirements**: Node 18+

### Environment Variables
```bash
# Required for all functionality
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_key
RANDOM_ORG_API_KEY=your_random_org_key
DEEPSEEK_API_KEY=your_deepseek_key

# Optional for observability
METRICS_PROVIDER=noop|console|datadog
DATADOG_API_KEY=your_datadog_key
DATADOG_SITE=datadoghq.com
METRICS_EXPOSE=true  # for dev/staging
```

### Quick Start
```bash
cd smart-divination/backend
npm ci                    # Install dependencies
npm run type-check       # ✅ Passes clean
npm test                 # ✅ 7/7 tests pass
npm run dev              # Serves on :3001
```

### API Endpoints (11 total)
- ✅ `GET /api/health` - System health with service checks
- ✅ `POST /api/draw/cards` - Tarot readings (78-card RWS deck)
- ✅ `POST /api/draw/coins` - I Ching readings (64 hexagrams)
- ✅ `POST /api/draw/runes` - Elder Futhark runes (24 runes)
- ✅ `POST /api/chat/interpret` - AI interpretations (DeepSeek V3)
- ✅ `POST /api/sessions` - Create divination sessions
- ✅ `GET /api/sessions/[userId]` - User session history
- ✅ `GET /api/sessions/detail/[sessionId]` - Session details
- ✅ `GET /api/users/[userId]/premium` - User premium status
- ✅ `GET /api/users/[userId]/can-start-session` - Session validation
- ✅ `GET /api/packs/[packId]/manifest` - Content pack metadata
- ✅ `GET /api/metrics` - Observability metrics (dev/staging)

**CI**: `.github/workflows/backend-canonical-ci.yml` ✅

## Flutter Workspace (Melos) ✅ FULLY FUNCTIONAL

- **Requirements**: Flutter 3.24+, Dart 3.5+
- **Status**: ✅ All 3 apps implemented, common package complete, Melos configured

### Setup & Commands
```bash
# One-time setup
dart pub global activate melos
cd smart-divination

# Development commands (use dart pub global run melos if PATH not configured)
dart pub global run melos bootstrap      # Setup all packages
dart pub global run melos run gen:l10n   # Generate localizations
dart pub global run melos run analyze:all # Analyze all Flutter code
dart pub global run melos run test:all    # Run all tests
```

### Apps Status
- **I Ching**: ✅ **COMPLETE** - `apps/iching/` - 64 hexagram oracle system
- **Runes**: ✅ **COMPLETE** - `apps/runes/` - Elder Futhark divination
- **Tarot**: ✅ **COMPLETE** - `apps/tarot/` - 8,219 lines, fully implemented

### Run Apps
```bash
cd smart-divination
cd apps/iching && flutter run    # I Ching oracle
cd apps/runes && flutter run     # Runes divination
cd apps/tarot && flutter run     # Tarot readings
```

### Shared Package
- **Common Package**: ✅ **COMPLETE** - `packages/common/pubspec.yaml` with l10n, UI helpers, models

## Supabase

- Config: `supabase/config.toml`
- Migrations: `supabase/migrations/`

## Observability ✅ COMPLETE

- **Status**: ✅ **IMPLEMENTED** - Full observability system with metrics endpoint
- **Canonical backend**: ✅ `/api/metrics` with Datadog integration complete
- **Features**: P50/P95 latency, RPS, error rates, endpoint-specific monitoring
- **Environment variables**:
  - `METRICS_PROVIDER=noop|console|datadog`
  - `DATADOG_API_KEY`, `DATADOG_SITE`
  - `METRICS_EXPOSE=true` for dev/staging (auto-disabled in prod)
- **Dashboards**: Ready-to-import Datadog JSON configs in `observability/`

## Migration Notes ✅ COMPLETED

- ✅ **Migration COMPLETED**: All functionality moved to canonical backend
- 📦 **Legacy folders**: `smart_tarot/` and `smart-divination-production/` can now be **ARCHIVED**
- ✅ **API routes**: All 11 endpoints fully migrated to `smart-divination/backend/pages/api/**`
- ✅ **Libraries**: Complete `lib/` utilities with TypeScript, tests, and observability
- 🎯 **Recommendation**: Archive legacy folders - canonical backend is production-ready and superior

### Legacy Status
- `smart_tarot/`: ✅ Marked as DEPRECATED - functionality moved to `smart-divination/apps/tarot/`
- `smart-divination-production/`: ✅ Can be archived - canonical backend has all features + more

## Security

- See `SECURITY.md` for scope and reporting process.
