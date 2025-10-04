#!/usr/bin/env bash
set -euo pipefail

if ! command -v supabase >/dev/null 2>&1; then
  echo "supabase CLI is required. Install it from https://supabase.com/docs/guides/cli." >&2
  exit 1
fi

if ! command -v psql >/dev/null 2>&1; then
  echo "psql is required to apply seed data." >&2
  exit 1
fi

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(cd "$SCRIPT_DIR"/../.. && pwd)
cd "$ROOT_DIR"

if [ -z "${SUPABASE_DB_URL:-}" ]; then
  echo "SUPABASE_DB_URL is not set. Provide a connection string (service role)." >&2
  exit 1
fi

echo "Applying Supabase migrations..."
"$SCRIPT_DIR/db_push.sh"

SEED_FILE="supabase/seeds/dev_seed.sql"
if [ -f "$SEED_FILE" ]; then
  echo "Applying seed data from $SEED_FILE..."
  psql "$SUPABASE_DB_URL" -f "$SEED_FILE"
else
  echo "Seed file $SEED_FILE not found; skipping seeds." >&2
fi

echo "Supabase migrations and seed data applied successfully."
