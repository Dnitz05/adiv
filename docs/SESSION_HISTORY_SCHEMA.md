# Session History Schema

This document describes the Supabase schema introduced in `supabase/migrations/20250922090000_session_history_schema.sql`. It powers the session history API (`GET /api/sessions/:userId`). The tarot draw endpoint now persists artefacts and messages; I Ching and runes endpoints currently store sessions only.

## Objectives
- Store enough information to rebuild a session timeline across devices and techniques.
- Keep `sessions.metadata.history` in sync so eligibility checks and usage stats remain accurate.
- Provide a simple view (`session_history_expanded`) that the backend can query without manual joins.

## Key Structures

### Tables
- `session_artifacts`
  - Links to `sessions.id`.
  - `artifact_type`: `tarot_draw`, `iching_cast`, `rune_cast`, `interpretation`, `message_bundle`, `note`.
  - Stores structured payloads (cards drawn, spreads, AI output, attachments).
  - Trigger `touch_session_history` updates metadata counts after changes.

- `session_messages`
  - Stores conversational entries related to a session.
  - `sender`: `user`, `assistant`, or `system`.
  - `sequence`: identity column for ordering.
  - Also monitored by `touch_session_history` trigger.

### View
`session_history_expanded` combines `sessions` with JSON arrays of artefacts and messages:
```json
{
  "id": "uuid",
  "user_id": "uuid",
  "technique": "tarot",
  "created_at": "2025-09-22T10:00:00Z",
  "results": {"cards": [...]},
  "metadata": {"history": {"artifacts": 1, "messages": 0, "updatedAt": "..."}},
  "artifacts": [ ... ],
  "messages": [ ... ]
}
```
The backend serialises this into the `sessions` array returned to Flutter clients.

## Current Usage
- `/api/draw/cards` writes sessions, artefacts, and system/user messages when Supabase credentials exist; it falls back to in-memory artefacts when credentials are missing.
- `/api/draw/coins` and `/api/draw/runes` create sessions today but will add artefacts/messages once the mobile UX is finalised.
- `/api/chat/interpret` appends interpretation artefacts/messages tied to an existing session when DeepSeek plus Supabase credentials are supplied.
- `/api/sessions/:userId` queries `session_history_expanded` and falls back to empty lists without Supabase credentials.
- Integration tests under `backend/__tests__/integration` validate that artefacts/messages appear in the view after tarot draws and manual inserts.

## Recommended Payload Shapes
Use these structures when writing artefacts:
- Tarot draws:
```json
{
  "cards": [{"id": "card_0", "name": "The Fool", "position": 1, "upright": true}],
  "spread": "three_card",
  "cardCount": 3,
  "seed": "...",
  "method": "crypto_secure"
}
```
- I Ching casts:
```json
{
  "lineValues": [7, 8, 7, 9, 6, 7],
  "primary": {"id": 1},
  "result": {"id": 2}
}
```
- Runes casts:
```json
{
  "runes": [{"id": 3, "name": "Thurisaz", "position": 1, "isReversed": false}],
  "spread": "three_rune"
}
```
- Interpretations:
```json
{
  "model": "deepseek-v3",
  "language": "en",
  "content": "..."
}
```

## Row Level Security
RLS is enabled on `session_artifacts` and `session_messages`. Policies ensure:
- Users can only access entries tied to their sessions.
- Service role (used by the backend) has full access.
- Anonymous access is currently permitted for inserts/selects; tighten policies when moving to production.

## Next Steps
1. Extend I Ching and runes draws to insert artefacts/messages once UX is finalised.
2. Backfill existing sessions with artefacts/messages if historical data exists.
3. Extend the history API with pagination metadata (`hasMore`, cursors) once datasets grow.
4. Add regression coverage for interpretation artefact writes in integration tests.

Keep this document updated as storage behaviour evolves so client teams know which fields are reliable.
