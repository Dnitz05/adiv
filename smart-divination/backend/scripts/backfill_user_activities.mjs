#!/usr/bin/env node
/**
 * Journal backfill (placeholder)
 * --------------------------------
 * This script will migrate pre-existing sessions, lunar queries, and reminders
 * into the new user_activities table. The implementation intentionally runs as
 * a stub so we can wire CLI + observability before moving real data.
 *
 * Usage:
 *   SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... node scripts/backfill_user_activities.mjs --dry-run
 */

import { createClient } from '@supabase/supabase-js';

const DRY_RUN = process.argv.includes('--dry-run');
const BATCH_SIZE = Number(process.env.JOURNAL_BACKFILL_BATCH ?? 250);

function requireEnv(name) {
  const value = process.env[name];
  if (!value) {
    console.error(`[journal-backfill] Missing required env ${name}`);
    process.exit(1);
  }
  return value;
}

async function fetchSessions(client, offset) {
  const { data, error } = await client
    .from('sessions')
    .select('id,user_id,technique,created_at,last_activity,question,summary')
    .order('created_at', { ascending: true })
    .range(offset, offset + BATCH_SIZE - 1);
  if (error) {
    throw new Error(`Failed to fetch sessions: ${error.message}`);
  }
  return data ?? [];
}

async function main() {
  const supabaseUrl = requireEnv('SUPABASE_URL');
  const serviceKey = requireEnv('SUPABASE_SERVICE_ROLE_KEY');

  const client = createClient(supabaseUrl, serviceKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  console.info(
    `[journal-backfill] Starting ${DRY_RUN ? 'dry-run' : 'mutation'} with batch=${BATCH_SIZE}`,
  );

  let offset = Number(process.env.JOURNAL_BACKFILL_OFFSET ?? 0);
  let processed = 0;

  while (true) {
    const batch = await fetchSessions(client, offset);
    if (!batch.length) {
      break;
    }

    console.info(
      `[journal-backfill] Inspecting sessions ${offset}..${offset + batch.length - 1} (userIds=${[
        ...new Set(batch.map((row) => row.user_id)),
      ].length})`,
    );

    if (!DRY_RUN) {
      console.warn(
        '[journal-backfill] Mutation mode not implemented yet. This run only inspects batches.',
      );
    }

    processed += batch.length;
    offset += batch.length;

    if (process.env.JOURNAL_BACKFILL_MAX && processed >= Number(process.env.JOURNAL_BACKFILL_MAX)) {
      console.info(
        `[journal-backfill] Reached JOURNAL_BACKFILL_MAX=${process.env.JOURNAL_BACKFILL_MAX}. Stopping.`,
      );
      break;
    }
  }

  console.info(`[journal-backfill] Completed. processed=${processed}, dryRun=${DRY_RUN}`);
}

main().catch((error) => {
  console.error('[journal-backfill] Fatal error:', error);
  process.exitCode = 1;
});
