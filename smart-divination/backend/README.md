Backend (Canonical)

- Stack: Next.js (API routes, Edge runtime-ready), Supabase, Jest.

Generated DB Types
- Preferred: generate from your DB to avoid drift.
- Options:
  - From DB URL: `npm run gen:db:types:dburl` (requires SUPABASE_DB_URL)
  - From project id: `npm run gen:db:types:proj` (requires SUPABASE_PROJECT_ID)
- Output: `lib/types/generated/supabase.ts` (imported by `lib/utils/supabase.ts`).

Env Vars
- SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY
- OPTIONAL: RANDOM_ORG_KEY, METRICS_PROVIDER, DATADOG_API_KEY, METRICS_EXPOSE

Scripts
- `npm test` (Jest), `npm run build`, `npm run type-check`

