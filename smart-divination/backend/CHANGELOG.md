## 2025-09-18

- Migrate 501 placeholders to canonical implementations:
  - POST `/api/sessions`
  - GET `/api/sessions/[userId]`
  - GET `/api/sessions/detail/[sessionId]`
  - GET `/api/users/[userId]/premium`
  - GET `/api/users/[userId]/can-start-session`
  - GET `/api/packs/[packId]/manifest`
  - POST `/api/draw/runes`
- Validation: Zod schemas for request bodies and query params.
- Security/Headers: Unified CORS handling and standard headers on all routes.
- Observability: `recordApiMetric` invoked before responses; `/api/metrics` already present.
- Typings: Remove `any` in Supabase utils; add strong typing and `getSession` helper.
- Tests: Add Jest suites for runes and method handling across routes; all tests passing.
- Config: Set `typescript.ignoreBuildErrors = false` in Next config once green.

