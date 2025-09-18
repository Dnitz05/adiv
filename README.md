Smart Divination Monorepo

Professional divination platform (Tarot, I Ching, Runes) built as a polyglot monorepo:
- Flutter apps per technique, with a shared `common` package
- Next.js serverless backend (Vercel) with Supabase integration

Quick Links
- Backend overview: `smart-divination/README.md`
- Workspace manager: `smart-divination/melos.yaml`
- Supabase config & migrations: `supabase/`
- Docs index: `docs/README.md`

Repository Layout (canonical)
- `smart-divination/` — Next.js backend + Flutter workspace (Melos)
  - `apps/` — Flutter apps: `tarot/`, `iching/`, `runes/`
  - `packages/common/` — Shared Flutter code (UI, services, models)
  - `pages/api/` — Serverless endpoints (draw, chat/interpret, sessions, packs)
  - `lib/utils/` and `lib/types/` — Backend utilities and types (TypeScript)
- `supabase/` — Project config and SQL migrations (rate limiting, sessions)
- `docs/` — Guides, reports, ADRs, and archives

Deprecated/Legacy (kept temporarily)
- `smart_tarot/`, `i_ching_app/`, `runes_app/`, `smart-divination-production/`
  These are earlier experiments or frozen builds. They will be archived/removed once the migration is complete.

Getting Started
1) Backend (Node 18+)
   - Copy `smart-divination/.env.example` to `.env.local` and fill values
   - `cd smart-divination && npm ci && npm run dev` (serves on :3001)

2) Flutter workspace
   - Install Flutter 3.24+, Dart 3.5+
   - `dart pub global activate melos`
   - `cd smart-divination && melos bootstrap`
   - Run Tarot app: `cd apps/tarot && flutter run`

CI/CD
- GitHub Actions for Next.js and Flutter (workflows under `smart-divination/.github/workflows/`)
- Coverage and analysis enforced via Melos scripts

Security & Legal
- Security policy: `SECURITY.md`
- Code of conduct: `CODE_OF_CONDUCT.md`
- License: MIT (see `LICENSE`)

Status
This repo is under active consolidation. The canonical code lives under `smart-divination/`. Older folders will be deprecated and removed after a final pass.

