#!/usr/bin/env bash
set -euo pipefail

REQUIRED_VARS=(SUPABASE_DB_URL SUPABASE_URL SUPABASE_SERVICE_ROLE_KEY SUPABASE_ANON_KEY)

missing=()
for var in "${REQUIRED_VARS[@]}"; do
  if [[ -z "${!var:-}" ]]; then
    missing+=("$var")
  fi
done

if (( ${#missing[@]} > 0 )); then
  printf 'Missing environment variables: %s
' "${missing[*]}" >&2
  exit 1
fi

echo 'Supabase environment variables detected.'
