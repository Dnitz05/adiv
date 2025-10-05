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

**Status**: [X] Complete ✅ (2025-10-05)

All values collected and securely stored:

| Key                         | Status | Notes                                               |
|-----------------------------|--------|-----------------------------------------------------|
| `SUPABASE_PROJECT_NAME`     | ✅     | `smart-tarot` |
| `SUPABASE_PROJECT_REF`      | ✅     | `vanrixxzaawybszeuivb` |
| `SUPABASE_DB_PASSWORD`      | ✅     | Stored in GitHub Secrets |
| `SUPABASE_URL`              | ✅     | `https://vanrixxzaawybszeuivb.supabase.co` |
| `SUPABASE_ANON_KEY`         | ✅     | Configured in .env.production + GitHub Secrets |
| `SUPABASE_SERVICE_ROLE_KEY` | ✅     | Configured in .env.production + GitHub Secrets |
| `SUPABASE_DB_URL`           | ✅     | Available from dashboard |

✅ All secrets stored in GitHub Secrets and .env.production (not in source control)

---

## 3. Prepare Environment Files (local only)

**Status**: [X] Complete ✅ (2025-10-05)

✅ `.env.production` exists at `C:\tarot\smart-divination\backend\.env.production`
✅ All real Supabase values configured (no placeholders)
✅ File is git-ignored (in `.gitignore`)

**Configured values**:
- SUPABASE_URL=https://vanrixxzaawybszeuivb.supabase.co
- SUPABASE_ANON_KEY (full JWT)
- SUPABASE_SERVICE_ROLE_KEY (full JWT)

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

## 5. Production Workflow (READY TO EXECUTE)

**Status**: [ ] NOT COMPLETE ❌ (migrations not yet applied)

**Blocker**: Local repo not yet linked to production project

The Supabase production project is provisioned and ready. Execute the following steps:

**Step 1**: Link the local repo to the project (one time):

   ```bash
   cd C:\tarot\supabase
   supabase link --project-ref vanrixxzaawybszeuivb
   ```

**Step 2**: Push migrations without seeds (recommended for production):

   ```bash
   supabase db push --linked
   ```

   This will apply:
   - `20250101000001_initial_schema.sql`
   - `20250922090000_session_history_schema.sql`

   Expected tables: `users`, `sessions`, `session_artifacts`, `session_messages`

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

**Current Status**: ⚠️ READY TO EXECUTE

- [X] Supabase project provisioned ✅
- [X] Secrets issued and configured ✅
- [X] .env.production configured ✅
- [X] GitHub Secrets configured ✅
- [ ] Link local repo: `supabase link --project-ref vanrixxzaawybszeuivb` ❌ **BLOCKER**
- [ ] Push migrations: `supabase db push --linked` ❌ **BLOCKER**
- [ ] Verify tables in Supabase Dashboard ❌

**Immediate Action**: Execute Section 5 (Production Workflow) to apply migrations


