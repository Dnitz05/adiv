import { Buffer } from 'node:buffer';

import type { PostgrestError } from '@supabase/supabase-js';

import type { Database } from '../types/generated/supabase';
import { log } from '../utils/api';
import { getSupabaseServiceClient, hasServiceCredentials } from '../utils/supabase';

export type JournalActivityType = Database['public']['Enums']['journal_activity_type'];
export type JournalActivityStatus = Database['public']['Enums']['journal_activity_status'];
type LunarPhase = Database['public']['Enums']['lunar_phase'];
type UserActivityRow = Database['public']['Tables']['user_activities']['Row'];

export interface JournalTimelineFilters {
  types?: JournalActivityType[];
  phase?: LunarPhase | 'any';
  from?: string | null;
  to?: string | null;
  cursor?: string | null;
  limit?: number;
  search?: string | null;
}

export interface JournalTimelineItem {
  id: string;
  activityType: JournalActivityType;
  status: JournalActivityStatus;
  title?: string | null;
  summary?: string | null;
  timestamp: string;
  payload: Record<string, unknown>;
  metadata?: Record<string, unknown>;
  lunarPhase?: LunarPhase | null;
  lunarZodiac?: string | null;
}

export interface JournalTimelineResult {
  items: JournalTimelineItem[];
  nextCursor: string | null;
  hasMore: boolean;
  source: 'supabase' | 'unavailable';
}

export interface JournalDaySummary {
  date: string;
  lunar?: {
    phaseId?: LunarPhase | null;
    phaseName?: string | null;
    zodiac?: string | null;
    guidance?: string | null;
  };
  activities: JournalTimelineItem[];
  totalsByType: Record<string, number>;
  totalActivities: number;
  source: 'supabase' | 'unavailable';
}

type LunarMetadata = JournalDaySummary['lunar'];

export type JournalStatsPeriod = 'week' | 'month' | 'year' | 'all';

export interface JournalStatsOptions {
  period?: JournalStatsPeriod;
}

export interface JournalStatsResult {
  period: JournalStatsPeriod;
  from?: string | null;
  to: string;
  totalsByType: Record<string, number>;
  totalsByPhase: Record<string, number>;
  totalActivities: number;
  source: 'supabase' | 'unavailable';
}

const DEFAULT_LIMIT = 25;
const MAX_LIMIT = 100;
const DATE_REGEX = /^\d{4}-\d{2}-\d{2}$/;

interface CursorPayload {
  ts: string;
  id: string;
}

function sanitizeLimit(limit?: number | null): number {
  if (!limit || Number.isNaN(limit)) {
    return DEFAULT_LIMIT;
  }
  return Math.min(Math.max(Math.trunc(limit), 1), MAX_LIMIT);
}

function encodeCursor(row: UserActivityRow): string {
  const payload: CursorPayload = { ts: row.activity_date, id: row.id };
  return Buffer.from(JSON.stringify(payload), 'utf8').toString('base64url');
}

function decodeCursor(cursor?: string | null): CursorPayload | null {
  if (!cursor) {
    return null;
  }
  try {
    const raw = Buffer.from(cursor, 'base64url').toString('utf8');
    const parsed = JSON.parse(raw) as CursorPayload;
    if (typeof parsed?.ts === 'string' && typeof parsed?.id === 'string') {
      return parsed;
    }
  } catch (error) {
    log('warn', 'journal timeline received invalid cursor', {
      cursor,
      error: error instanceof Error ? error.message : String(error),
    });
  }
  return null;
}

function escapeIlike(term: string): string {
  return term.replace(/[%_]/g, (char) => `\\${char}`);
}

function mapRowToTimelineItem(row: UserActivityRow): JournalTimelineItem {
  return {
    id: row.id,
    activityType: row.activity_type,
    status: row.activity_status,
    title: row.title,
    summary: row.summary,
    timestamp: row.activity_date,
    payload: row.payload ?? {},
    metadata: row.metadata ?? undefined,
    lunarPhase: row.lunar_phase_id ?? null,
    lunarZodiac: row.lunar_zodiac_name ?? null,
  };
}

function normaliseDateOnly(value: string): { date: string; from: string; to: string } {
  const trimmed = value.trim();
  if (!DATE_REGEX.test(trimmed)) {
    throw new Error('Invalid date format. Expected YYYY-MM-DD');
  }
  const [yearStr, monthStr, dayStr] = trimmed.split('-');
  const utcDate = Date.UTC(
    Number.parseInt(yearStr, 10),
    Number.parseInt(monthStr, 10) - 1,
    Number.parseInt(dayStr, 10)
  );
  const fromDate = new Date(utcDate);
  const toDate = new Date(utcDate);
  toDate.setUTCDate(toDate.getUTCDate() + 1);
  return {
    date: trimmed,
    from: fromDate.toISOString(),
    to: toDate.toISOString(),
  };
}

async function fetchLunarMetadata(date: string): Promise<LunarMetadata | undefined> {
  try {
    const client = getSupabaseServiceClient();
    const { data, error } = await client
      .from('lunar_daily_cache')
      .select('phase,zodiac_sign,guidance,data')
      .eq('date', date)
      .maybeSingle();
    if (error) {
      log('warn', 'Failed to fetch lunar metadata', {
        date,
        error: (error as PostgrestError)?.message ?? String(error),
      });
      return undefined;
    }
    if (!data) {
      return undefined;
    }
    return {
      phaseId: (data.phase as LunarPhase) ?? null,
      phaseName: data.data?.names?.en ?? null,
      zodiac: data.zodiac_sign ?? null,
      guidance: data.guidance ?? null,
    };
  } catch (error) {
    log('warn', 'Lunar metadata lookup threw', {
      date,
      error: error instanceof Error ? error.message : String(error),
    });
    return undefined;
  }
}

function resolveStatsWindow(period: JournalStatsPeriod): { from: string | null; to: string } {
  const now = new Date();
  const to = now.toISOString();
  if (period === 'all') {
    return { from: null, to };
  }
  const start = new Date(now);
  if (period === 'week') {
    start.setUTCDate(start.getUTCDate() - 7);
  } else if (period === 'month') {
    start.setUTCMonth(start.getUTCMonth() - 1);
  } else if (period === 'year') {
    start.setUTCFullYear(start.getUTCFullYear() - 1);
  }
  return { from: start.toISOString(), to };
}

export async function getJournalTimeline(
  userId: string,
  filters: JournalTimelineFilters
): Promise<JournalTimelineResult> {
  if (!userId) {
    throw new Error('userId is required');
  }

  if (!hasServiceCredentials()) {
    log('warn', 'journal timeline requested without service credentials', { userId });
    return {
      items: [],
      nextCursor: null,
      hasMore: false,
      source: 'unavailable',
    };
  }

  const limit = sanitizeLimit(filters.limit);
  const cursorPayload = decodeCursor(filters.cursor);
  const client = getSupabaseServiceClient();

  let query = client
    .from('user_activities')
    .select('*')
    .eq('user_id', userId)
    .is('deleted_at', null)
    .order('activity_date', { ascending: false })
    .order('id', { ascending: false })
    .limit(limit + 1);

  if (filters.types && filters.types.length > 0) {
    query = query.in('activity_type', filters.types);
  }

  if (filters.phase && filters.phase !== 'any') {
    query = query.eq('lunar_phase_id', filters.phase);
  }

  if (filters.from) {
    query = query.gte('activity_date', filters.from);
  }
  if (filters.to) {
    query = query.lte('activity_date', filters.to);
  }

  if (cursorPayload) {
    // Prefer strict tuple ordering; if Supabase rejects OR expression fallback to simple lt.
    const tupleFilter = `and(activity_date.eq.${cursorPayload.ts},id.lt.${cursorPayload.id}),activity_date.lt.${cursorPayload.ts}`;
    query = query.or(tupleFilter);
  }

  const searchTerm = filters.search?.trim();
  if (searchTerm) {
    const escaped = escapeIlike(searchTerm);
    const pattern = `%${escaped}%`;
    query = query.or(`title.ilike.${pattern},summary.ilike.${pattern}`);
  }

  const { data, error } = await query;
  if (error) {
    const details = (error as PostgrestError)?.message ?? String(error);
    log('error', 'journal timeline query failed', { userId, error: details });
    throw new Error(`Failed to load journal timeline: ${details}`);
  }

  const rows = data ?? [];
  const hasMore = rows.length > limit;
  const limitedRows = hasMore ? rows.slice(0, limit) : rows;
  const items = limitedRows.map(mapRowToTimelineItem);
  const nextCursor = hasMore ? encodeCursor(limitedRows[limitedRows.length - 1]) : null;

  return {
    items,
    nextCursor,
    hasMore,
    source: 'supabase',
  };
}

export async function getJournalDaySummary(
  userId: string,
  date: string
): Promise<JournalDaySummary> {
  if (!userId) {
    throw new Error('userId is required');
  }

  if (!hasServiceCredentials()) {
    log('warn', 'journal day summary requested without service credentials', { userId });
    return {
      date,
      activities: [],
      totalsByType: {},
      totalActivities: 0,
      source: 'unavailable',
    };
  }

  const { from, to, date: normalizedDate } = normaliseDateOnly(date);
  const client = getSupabaseServiceClient();

  const { data, error } = await client
    .from('user_activities')
    .select('*')
    .eq('user_id', userId)
    .is('deleted_at', null)
    .gte('activity_date', from)
    .lt('activity_date', to)
    .order('activity_date', { ascending: false })
    .order('id', { ascending: false });

  if (error) {
    const details = (error as PostgrestError)?.message ?? String(error);
    log('error', 'journal day summary query failed', { userId, date, error: details });
    throw new Error(`Failed to load day summary: ${details}`);
  }

  const rows = data ?? [];
  const activities = rows.map(mapRowToTimelineItem);
  const totalsByType: Record<string, number> = {};

  rows.forEach((row) => {
    const key = row.activity_type ?? 'unknown';
    totalsByType[key] = (totalsByType[key] ?? 0) + 1;
  });

  const lunar = await fetchLunarMetadata(normalizedDate);

  return {
    date: normalizedDate,
    lunar,
    activities,
    totalsByType,
    totalActivities: activities.length,
    source: 'supabase',
  };
}

export async function getJournalStats(
  userId: string,
  options?: JournalStatsOptions
): Promise<JournalStatsResult> {
  if (!userId) {
    throw new Error('userId is required');
  }

  if (!hasServiceCredentials()) {
    log('warn', 'journal stats requested without service credentials', { userId });
    return {
      period: options?.period ?? 'month',
      totalsByType: {},
      totalsByPhase: {},
      totalActivities: 0,
      to: new Date().toISOString(),
      source: 'unavailable',
    };
  }

  const period = options?.period ?? 'month';
  const { from, to } = resolveStatsWindow(period);
  const client = getSupabaseServiceClient();

  let query = client
    .from('user_activities')
    .select('activity_type,lunar_phase_id')
    .eq('user_id', userId)
    .is('deleted_at', null);

  if (from) {
    query = query.gte('activity_date', from);
  }
  query = query.lte('activity_date', to);

  const { data, error } = await query;
  if (error) {
    const details = (error as PostgrestError)?.message ?? String(error);
    log('error', 'journal stats query failed', { userId, error: details });
    throw new Error(`Failed to load journal stats: ${details}`);
  }

  const rows = data ?? [];
  const totalsByType: Record<string, number> = {};
  const totalsByPhase: Record<string, number> = {};

  rows.forEach((row) => {
    const typeKey = row.activity_type ?? 'unknown';
    totalsByType[typeKey] = (totalsByType[typeKey] ?? 0) + 1;

    const phaseKey = row.lunar_phase_id ?? 'unknown';
    totalsByPhase[phaseKey] = (totalsByPhase[phaseKey] ?? 0) + 1;
  });

  return {
    period,
    from,
    to,
    totalsByType,
    totalsByPhase,
    totalActivities: rows.length,
    source: 'supabase',
  };
}
