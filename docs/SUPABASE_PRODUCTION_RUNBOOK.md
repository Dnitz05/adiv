# Supabase Production Runbook

Step-by-step guide for preparing and configuring the Supabase production environment without touching the live project until credentials are confirmed.

---

## 1. Prerequisites

- Supabase CLI `>=1.160.0`
- `psql` client available on PATH
- Service-role connection string in the form `postgresql://postgres:<password>@db.<ref>.supabase.co:5432/postgres`
- Access to the Supabase Dashboard with Owner privileges
- Local repository cloned (root: `C:\tarot`)

Verify tooling locally:

```bash
supabase --version
psql --version
```

If the commands are missing, install them before proceeding.

---

## 2. Collect Required Values (no API calls)

Prepare the following placeholders before anyone logs into the Supabase dashboard. Capture them in a secure document (e.g., Bitwarden note):

| Key                         | Notes                                               |
|-----------------------------|-----------------------------------------------------|
| `SUPABASE_PROJECT_NAME`     | Human-friendly project label (e.g., `smart-tarot`) |
| `SUPABASE_PROJECT_REF`      | Supabase project reference (shown in dashboard URL) |
| `SUPABASE_DB_PASSWORD`      | Random strong password for the Postgres instance    |
| `SUPABASE_URL`              | `https://<project-ref>.supabase.co`                 |
| `SUPABASE_ANON_KEY`         | Generated after project creation                    |
| `SUPABASE_SERVICE_ROLE_KEY` | Generated in dashboard -> Settings -> API           |
| `SUPABASE_DB_URL`           | Service-role connection string                      |

> ⛔️ Do **not** paste real secrets into source control. Store them only in the team secret manager.

---

## 3. Prepare Environment Files (local only)

Create a working copy of `.env.production` (do **not** commit):

```bash
cp .env.example .env.production
# Fill in the Supabase placeholders when the real values are available
```

Add the same values to `smart-divination/backend/.env.production` so the Next.js app can read them when deployed.

> Tip: keep placeholders in the format `CHANGE_ME_<NAME>` until secrets are issued to avoid accidental usage.

---

## 4. Dry-Run CLI Workflow (without executing remote mutations)

Ensure the CLI scripts resolve the correct paths:

```bash
cd C:\tarot
scripts\supabase\db_push.sh --help  # verifies bash invocation
scripts\supabase\generate_types.sh --help
```

These scripts fail fast if the Supabase CLI is unavailable. No network calls are made when `--help` is requested.

Use the helper scripts to confirm the environment before running migrations:

```powershell
# PowerShell
scripts/supabase/check_env.ps1
```

```bash
# Bash / Git Bash
bash scripts/supabase/check_env.sh
```

Update the environment variables once actual secrets are available; do not store them in plain text files.

---

## 5. Planned Production Workflow (execute later)

Once the actual Supabase project is provisioned, run the following **from a secure machine**:

1. Link the local repo to the project (one time):

   ```bash
   cd C:\tarot\supabase
   supabase link --project-ref <SUPABASE_PROJECT_REF>
   ```

2. Push migrations without seeds (recommended for production):

   ```bash
   supabase db push --linked
   ```

3. For controlled seed data (optional):

   - Copy `supabase/seeds/dev_seed.sql`
   - Remove demo users or sensitive entries
   - Execute via:

     ```bash
     psql "$SUPABASE_DB_URL" -f path/to/sanitised_seed.sql
     ```

4. Regenerate backend types to keep API contracts in sync:

   ```bash
   cd C:\tarot\smart-divination\backend
   npm run supabase:types:ci
   ```

5. Snapshot the schema for auditing:

   ```bash
   supabase db dump --linked --schema public --file schema-backup-$(date +%Y%m%d).sql
   ```

Store the dump securely (e.g., encrypted S3 bucket or vault).

---

## 6. Verification Checklist (post-setup)

- [ ] `supabase db push` succeeded without errors
- [ ] Supabase Dashboard -> Database -> Tables lists `users`, `sessions`, `session_artifacts`, `session_messages`
- [ ] RLS policies respected (open `Table editor` -> Policies)
- [ ] Service-role connection tested locally (`scripts/supabase/apply.sh` only when necessary)
- [ ] Backend regenerated types committed (`lib/types/generated/supabase.ts`)

Document results in the team runbook or ticket, including timestamps and operator name.

---

## 7. Secret Distribution Plan

- Store Supabase secrets in the organisation's password manager with restricted access.
- When piping secrets into CI/CD (GitHub Actions, Vercel), use the existing guides:
  - `docs/PRODUCTION_CREDENTIALS_CHECKLIST.md`
  - `docs/GITHUB_ACTIONS_SETUP.md`
  - `docs/VERCEL_DEPLOYMENT_GUIDE.md`
- Rotate `SUPABASE_SERVICE_ROLE_KEY` immediately if exposed.

---

## 8. Next Actions

- Blocked until the Supabase project is provisioned and secrets are issued.
- Once available, follow the "Planned Production Workflow" section and record the outcome in this repo's runbook folder.
