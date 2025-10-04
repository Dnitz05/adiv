#!/usr/bin/env bash
set -euo pipefail

if ! command -v supabase >/dev/null 2>&1; then
  echo "supabase CLI is required. Install it from https://supabase.com/docs/guides/cli." >&2
  exit 1
fi

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")"/../.. && pwd)
cd "$ROOT_DIR"

if [ -n "${SUPABASE_DB_URL:-}" ]; then
  echo "Running supabase db push via SUPABASE_DB_URL"
  supabase db push --db-url "$SUPABASE_DB_URL"
elif [ -n "${SUPABASE_PROJECT_ID:-}" ] && [ -n "${SUPABASE_ACCESS_TOKEN:-}" ]; then
  echo "Running supabase db push via linked project $SUPABASE_PROJECT_ID"
  supabase link --project-ref "$SUPABASE_PROJECT_ID"
  supabase db push
else
  echo "Missing Supabase credentials. Provide SUPABASE_DB_URL or SUPABASE_PROJECT_ID + SUPABASE_ACCESS_TOKEN." >&2
  exit 1
fi