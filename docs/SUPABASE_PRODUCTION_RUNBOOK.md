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

**Status**: [X] Complete âœ… (2025-10-05)

All values collected and securely stored:

| Key                         | Status | Notes                                               |
|-----------------------------|--------|-----------------------------------------------------|
| `SUPABASE_PROJECT_NAME`     | âœ…     | `smart-tarot` |
| `SUPABASE_PROJECT_REF`      | âœ…     | `vanrixxzaawybszeuivb` |
| `SUPABASE_DB_PASSWORD`      | âœ…     | Stored in GitHub Secrets |
| `SUPABASE_URL`              | âœ…     | `https://vanrixxzaawybszeuivb.supabase.co` |
| `SUPABASE_ANON_KEY`         | âœ…     | Configured in .env.production + GitHub Secrets |
| `SUPABASE_SERVICE_ROLE_KEY` | âœ…     | Configured in .env.production + GitHub Secrets |
| `SUPABASE_DB_URL`           | âœ…     | Available from dashboard |

âœ… All secrets stored in GitHub Secrets and .env.production (not in source control)

---

## 3. Prepare Environment Files (local only)

**Status**: [X] Complete âœ… (2025-10-05)

âœ… `.env.production` exists at `C:\tarot\smart-divination\backend\.env.production`
âœ… All real Supabase values configured (no placeholders)
âœ… File is git-ignored (in `.gitignore`)

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

## 5. Production Workflow

**Status**: âš ï¸ READY TO LINK & PUSH (backend verified, migrations pending)

**Backend Status**: âœ… Deployed and verified (2025-10-05)
- Production URL: https://backend-gv4a2ueuy-dnitzs-projects.vercel.app
- Supabase connection healthy (418ms response time)
- All environment variables configured

**Migrations Status**: âš ï¸ Not yet applied (database empty)

The Supabase production project is provisioned and backend is verified. Execute the following steps:

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

**Backend Connectivity**: âœ… Verified (2025-10-05)
- [X] Backend deployed and reachable âœ…
- [X] Supabase connection healthy (418ms response time) âœ…
- [X] Environment variables configured âœ…
- [X] `/api/health` returns Supabase "healthy" status âœ…

**Database Migrations**: âš ï¸ Pending
- [ ] `supabase db push` succeeded without errors
- [ ] Supabase Dashboard -> Database -> Tables lists `users`, `sessions`, `session_artifacts`, `session_messages`
- [ ] RLS policies respected (open `Table editor` -> Policies)
- [ ] Service-role connection tested locally (`scripts/supabase/apply.sh` only when necessary)
- [ ] Backend regenerated types committed (`lib/types/generated/supabase.ts`)

**Verification Script**: âœ… Available
```powershell
cd C:\tarot\scripts
.\verify-deployment.ps1 https://backend-gv4a2ueuy-dnitzs-projects.vercel.app
```

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

**Current Status**: âœ… Backend Deployed | âš ï¸ Migrations Pending

- [X] Supabase project provisioned âœ… (vanrixxzaawybszeuivb)
- [X] Secrets issued and configured âœ…
- [X] .env.production configured âœ…
- [X] GitHub Secrets configured âœ…
- [X] Backend deployed to Vercel âœ… (https://backend-gv4a2ueuy-dnitzs-projects.vercel.app)
- [X] Backend connectivity verified âœ… (Supabase healthy)
- [ ] Link local repo: `supabase link --project-ref vanrixxzaawybszeuivb` âŒ **BLOCKER**
- [ ] Push migrations: `supabase db push --linked` âŒ **BLOCKER**
- [ ] Verify tables in Supabase Dashboard âŒ

**Immediate Action**: Execute Section 5 (Production Workflow) to apply migrations

**Backend Verification**: Run `.\scripts\verify-deployment.ps1 https://backend-gv4a2ueuy-dnitzs-projects.vercel.app`


