import path from 'path';
import { execFileSync } from 'child_process';

const REQUIRED_ENV_VARS = ['SUPABASE_DB_URL', 'SUPABASE_URL', 'SUPABASE_SERVICE_ROLE_KEY', 'SUPABASE_ANON_KEY'] as const;

const REPO_ROOT = path.resolve(__dirname, '../../../..');
const SUPABASE_CLI_PATH = process.env.SUPABASE_CLI_PATH || 'supabase';

export const SUPABASE_SEED_USER_ID = '00000000-0000-0000-0000-000000000001';
export const SUPABASE_SEED_TAROT_SESSION_ID = '10000000-0000-0000-0000-000000000001';

let harnessReady: boolean | null = null;
let migrationsApplied = false;

function hasRequiredEnv(): boolean {
  let ok = true;
  for (const key of REQUIRED_ENV_VARS) {
    if (!process.env[key]) {
      console.warn(`Supabase integration: missing env var ${key}`);
      ok = false;
    }
  }
  return ok;
}

function commandExists(command: string, args: string[]): boolean {
  try {
    execFileSync(command, args, { stdio: 'ignore' });
    return true;
  } catch (error) {
    return false;
  }
}

function ensureSupabaseCli(): boolean {
  if (commandExists(SUPABASE_CLI_PATH, ['--version'])) {
    return true;
  }
  console.warn('Supabase integration: Supabase CLI not available.');
  return false;
}

function applyMigrations(): boolean {
  if (migrationsApplied) {
    return true;
  }
  const dbUrl = process.env.SUPABASE_DB_URL;
  if (!dbUrl) {
    console.warn('Supabase integration: SUPABASE_DB_URL missing.');
    return false;
  }

  try {
    execFileSync(
      SUPABASE_CLI_PATH,
      ['db', 'push', '--db-url', dbUrl],
      { stdio: 'inherit', cwd: REPO_ROOT, env: process.env as NodeJS.ProcessEnv }
    );
    migrationsApplied = true;
    return true;
  } catch (error) {
    console.warn(
      'Supabase integration: failed to apply migrations.',
      error instanceof Error ? error.message : error
    );
    return false;
  }
}

export function ensureSupabaseTestHarness(): boolean {
  if (harnessReady !== null) {
    return harnessReady;
  }

  if (process.env.SKIP_SUPABASE_INTEGRATION === '1') {
    console.warn('Supabase integration: SKIP_SUPABASE_INTEGRATION=1, skipping.');
    harnessReady = false;
    return harnessReady;
  }

  if (!hasRequiredEnv()) {
    harnessReady = false;
    return harnessReady;
  }

  if (!ensureSupabaseCli()) {
    harnessReady = false;
    return harnessReady;
  }

  harnessReady = applyMigrations();
  return harnessReady;
}

export function describeSupabaseIntegration(
  name: string,
  fn: Parameters<typeof describe>[1]
): void {
  const runner = ensureSupabaseTestHarness() ? describe : describe.skip;
  runner(name, fn);
}


describe('supabaseTestHarness module', () => {
  it('exposes helpers for integration suites', () => {
    expect(typeof ensureSupabaseTestHarness).toBe('function');
    expect(typeof describeSupabaseIntegration).toBe('function');
  });
});
