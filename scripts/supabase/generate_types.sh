#!/usr/bin/env bash
set -euo pipefail

if ! command -v supabase >/dev/null 2>&1; then
  echo "supabase CLI is required. Install it from https://supabase.com/docs/guides/cli." >&2
  exit 1
fi

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")"/../.. && pwd)
cd "$ROOT_DIR"/smart-divination/backend

if [ -n "${SUPABASE_DB_URL:-}" ]; then
  npm run gen:db:types:dburl
elif [ -n "${SUPABASE_PROJECT_ID:-}" ]; then
  if [ -z "${SUPABASE_ACCESS_TOKEN:-}" ]; then
    echo "SUPABASE_ACCESS_TOKEN is required when SUPABASE_PROJECT_ID is used." >&2
    exit 1
  fi
  npm run gen:db:types:proj
else
  echo "Missing Supabase credentials. Provide SUPABASE_DB_URL or SUPABASE_PROJECT_ID." >&2
  exit 1
fi
