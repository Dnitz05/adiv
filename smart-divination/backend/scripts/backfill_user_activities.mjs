#!/usr/bin/env node
/* eslint-disable no-console */
/**
 * Journal backfill
 * ----------------
 * Migrates historic sessions, lunar queries, and reminders into user_activities.
 *
 * Usage examples:
 *   JOURNAL_BACKFILL_MAX=1000 node scripts/backfill_user_activities.mjs --dry-run
 *   node scripts/backfill_user_activities.mjs
 */

import { createClient } from '@supabase/supabase-js';
import process from 'node:process';

const DRY_RUN = process.argv.includes('--dry-run');
const BATCH_SIZE = Number(process.env.JOURNAL_BACKFILL_BATCH ?? 250);
const MAX_ITEMS = process.env.JOURNAL_BACKFILL_MAX
  ? Number(process.env.JOURNAL_BACKFILL_MAX)
  : null;

function requireEnv(name) {
  const value = process.env[name];
  if (!value) {
    console.error(`[journal-backfill] Missing required env ${name}`);
    process.exit(1);
  }
  return value;
}

function encodeCursor(value) {
  return Buffer.from(value).toString('base64url');
}

function toTimestamp(date) {
  return date ? new Date(date).toISOString() : new Date().toISOString();
}

async function fetchSessions(client, offset) {
  const { data, error } = await client
    .from('sessions')
    .select(
      'id,user_id,technique,created_at,last_activity,question,summary,results,interpretation,metadata,is_deleted,deleted_at',
    )
    .order('created_at', { ascending: true })
    .range(offset, offset + BATCH_SIZE - 1);
  if (error) throw new Error(`Failed to fetch sessions: ${error.message}`);
  return data ?? [];
}

async function fetchLunarQueries(client, offset) {
  const { data, error } = await client
    .from('lunar_queries')
    .select('*')
    .order('created_at', { ascending: true })
    .range(offset, offset + BATCH_SIZE - 1);
  if (error) throw new Error(`Failed to fetch lunar queries: ${error.message}`);
  return data ?? [];
}

async function fetchLunarReminders(client, offset) {
  const { data, error } = await client
    .from('lunar_reminders')
    .select('*')
    .order('created_at', { ascending: true })
    .range(offset, offset + BATCH_SIZE - 1);
  if (error) throw new Error(`Failed to fetch lunar reminders: ${error.message}`);
  return data ?? [];
}

function buildSessionActivity(row) {
  const payload = {
    technique: row.technique,
    question: row.question,
    results: row.results ?? {},
    summary: row.summary,
    interpretation: row.interpretation,
    metadata: row.metadata ?? {},
  };
  return {
    user_id: row.user_id,
    activity_type:
      row.technique === 'tarot'
        ? 'tarot_reading'
        : row.technique === 'iching'
          ? 'iching_cast'
          : row.technique === 'runes'
            ? 'rune_cast'
            : 'custom',
    activity_status: row.is_deleted ? 'archived' : 'completed',
    source: 'system',
    activity_date: row.last_activity ?? row.created_at ?? new Date().toISOString(),
    title: row.summary ?? row.question ?? 'Divination session',
    summary: row.interpretation ?? row.summary ?? '',
    reference_table: 'sessions',
    reference_id: row.id,
    payload,
    metadata: row.metadata ?? {},
    deleted_at: row.is_deleted ? row.deleted_at ?? toTimestamp(new Date()) : null,
  };
}

function buildLunarQueryActivity(row) {
  return {
    user_id: row.user_id,
    activity_type: 'lunar_advice',
    activity_status: 'completed',
    source: 'assistant',
    activity_date: row.created_at ?? toTimestamp(new Date()),
    lunar_phase_id: row.context?.phaseId ?? row.context?.phase_id ?? null,
    lunar_phase_name: row.context?.phaseName ?? row.context?.phase_name ?? null,
    title: `Consulta lunar: ${row.topic}`,
    summary: row.intention ?? row.context?.guidanceSummary ?? '',
    reference_table: 'lunar_queries',
    reference_id: row.id,
    payload: {
      topic: row.topic,
      intention: row.intention,
      advice: row.advice,
      context: row.context,
    },
    metadata: row.context ?? {},
  };
}

function buildLunarReminderActivity(row) {
  const activityDate = `${row.date}T${row.time ?? '00:00'}:00Z`;
  return {
    user_id: row.user_id,
    activity_type: 'reminder',
    activity_status: 'scheduled',
    source: 'system',
    activity_date: activityDate,
    title: `Recordatori: ${row.topic}`,
    summary: row.intention ?? 'Reminder set.',
    reference_table: 'lunar_reminders',
    reference_id: row.id,
    payload: {
      topic: row.topic,
      intention: row.intention,
      locale: row.locale,
      date: row.date,
      time: row.time,
    },
    metadata: { date: row.date, time: row.time },
  };
}

async function upsertActivities(client, activities) {
  if (!activities.length) return;
  const { error } = await client.from('user_activities').upsert(activities, {
    onConflict: 'reference_table,reference_id',
  });
  if (error) throw new Error(`Failed to upsert activities: ${error.message}`);
}

async function backfillSessions(client) {
  let offset = Number(process.env.JOURNAL_BACKFILL_SESSIONS_OFFSET ?? 0);
  let processed = 0;

  while (true) {
    if (MAX_ITEMS && processed >= MAX_ITEMS) {
      console.info('[journal-backfill] Session limit reached, stopping.');
      break;
    }

    const batch = await fetchSessions(client, offset);
    if (!batch.length) break;

    console.info(
      `[journal-backfill] Sessions ${offset}-${offset + batch.length - 1} (users=${
        new Set(batch.map((row) => row.user_id)).size
      })`,
    );

    if (!DRY_RUN) {
      const activities = batch.map(buildSessionActivity);
      await upsertActivities(client, activities);
    }

    processed += batch.length;
    offset += batch.length;
  }
}

async function backfillLunarQueries(client) {
  let offset = Number(process.env.JOURNAL_BACKFILL_LUNAR_OFFSET ?? 0);
  let processed = 0;

  while (true) {
    if (MAX_ITEMS && processed >= MAX_ITEMS) break;
    const batch = await fetchLunarQueries(client, offset);
    if (!batch.length) break;

    console.info(
      `[journal-backfill] Lunar queries ${offset}-${offset + batch.length - 1} (users=${
        new Set(batch.map((row) => row.user_id)).size
      })`,
    );

    if (!DRY_RUN) {
      const activities = batch.map(buildLunarQueryActivity);
      await upsertActivities(client, activities);
    }

    processed += batch.length;
    offset += batch.length;
  }
}

async function backfillLunarReminders(client) {
  let offset = Number(process.env.JOURNAL_BACKFILL_REMINDERS_OFFSET ?? 0);
  let processed = 0;

  while (true) {
    if (MAX_ITEMS && processed >= MAX_ITEMS) break;
    const batch = await fetchLunarReminders(client, offset);
    if (!batch.length) break;

    console.info(
      `[journal-backfill] Lunar reminders ${offset}-${offset + batch.length - 1} (users=${
        new Set(batch.map((row) => row.user_id)).size
      })`,
    );

    if (!DRY_RUN) {
      const activities = batch.map(buildLunarReminderActivity);
      await upsertActivities(client, activities);
    }

    processed += batch.length;
    offset += batch.length;
  }
}

async function main() {
  const supabaseUrl = requireEnv('SUPABASE_URL');
  const serviceKey = requireEnv('SUPABASE_SERVICE_ROLE_KEY');

  const client = createClient(supabaseUrl, serviceKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  console.info(
    `[journal-backfill] Starting ${DRY_RUN ? 'dry-run' : 'mutation'} (batch=${BATCH_SIZE}, max=${MAX_ITEMS ?? '∞'})`,
  );

  await backfillSessions(client);
  await backfillLunarQueries(client);
  await backfillLunarReminders(client);

  console.info('[journal-backfill] Completed successfully');
}

main().catch((error) => {
  console.error('[journal-backfill] Fatal error:', error);
  process.exitCode = 1;
});
