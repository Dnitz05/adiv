import { createClient, SupabaseClient, PostgrestError } from '@supabase/supabase-js';
import type { DivinationTechnique } from '../types/api';
import { log } from './api';

let supabaseClient: SupabaseClient<Database> | null = null;
let supabaseServiceClient: SupabaseClient<Database> | null = null;

export function getSupabaseClient(): SupabaseClient<Database> {
  if (!supabaseClient) {
    const supabaseUrl = process.env.SUPABASE_URL;
    const supabaseAnonKey = process.env.SUPABASE_ANON_KEY;
    if (!supabaseUrl || !supabaseAnonKey) {
      throw new Error('Supabase configuration missing: SUPABASE_URL or SUPABASE_ANON_KEY');
    }
    supabaseClient = createClient<Database>(supabaseUrl, supabaseAnonKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
    log('info', 'Supabase client initialized');
  }
  return supabaseClient;
}

export function getSupabaseServiceClient(): SupabaseClient<Database> {
  if (!supabaseServiceClient) {
    const supabaseUrl = process.env.SUPABASE_URL;
    const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
    if (!supabaseUrl || !serviceKey) {
      throw new Error('Supabase service configuration missing');
    }
    supabaseServiceClient = createClient<Database>(supabaseUrl, serviceKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
    log('info', 'Supabase service client initialized');
  }
  return supabaseServiceClient;
}

export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string;
          email: string | null;
          name: string | null;
          tier: 'free' | 'premium' | 'premium_annual';
          created_at: string;
          last_activity: string;
          preferences: Record<string, any>;
          metadata: Record<string, any> | null;
        };
        Insert: Partial<Database['public']['Tables']['users']['Row']>;
        Update: Partial<Database['public']['Tables']['users']['Row']>;
      };
      sessions: {
        Row: {
          id: string;
          user_id: string;
          technique: DivinationTechnique;
          locale: string;
          created_at: string;
          last_activity: string;
          question: string | null;
          results: Record<string, any> | null;
          interpretation: string | null;
          summary: string | null;
          metadata: Record<string, any> | null;
          is_deleted: boolean;
          deleted_at: string | null;
        };
        Insert: Partial<Database['public']['Tables']['sessions']['Row']>;
        Update: Partial<Database['public']['Tables']['sessions']['Row']>;
      };
      user_stats: {
        Row: {
          user_id: string;
          technique: DivinationTechnique;
          total_sessions: number;
          sessions_this_week: number;
          sessions_this_month: number;
          last_session_at: string | null;
          favorite_spread: string | null;
          average_rating: number | null;
          updated_at: string;
        };
        Insert: Partial<Database['public']['Tables']['user_stats']['Row']>;
        Update: Partial<Database['public']['Tables']['user_stats']['Row']>;
      };
    };
    Views: { [_ in never]: never };
    Functions: { [_ in never]: never };
    Enums: {
      divination_technique: 'tarot' | 'iching' | 'runes';
      user_tier: 'free' | 'premium' | 'premium_annual';
    };
  };
}

export async function getUserTier(userId: string): Promise<'free' | 'premium' | 'premium_annual' | null> {
  const client = getSupabaseServiceClient();
  const { data, error } = await client
    .from('users')
    .select('tier')
    .eq('id', userId)
    .single<{ tier: Database['public']['Tables']['users']['Row']['tier'] }>();
  if (error) {
    log('warn', 'getUserTier failed', { error: error.message, userId });
    return null;
  }
  return data?.tier ?? null;
}

export async function getUserStats(userId: string): Promise<{
  totalSessions: number;
  sessionsThisWeek: number;
  sessionsThisMonth: number;
}> {
  const client = getSupabaseServiceClient();
  const { data, error } = await client
    .from('user_stats')
    .select('total_sessions,sessions_this_week,sessions_this_month')
    .eq('user_id', userId)
    .limit(1);
  if (error) {
    log('warn', 'getUserStats failed', { error: error.message, userId });
    return { totalSessions: 0, sessionsThisWeek: 0, sessionsThisMonth: 0 };
  }
  const row = (data?.[0] as Database['public']['Tables']['user_stats']['Row']) || undefined;
  return {
    totalSessions: row?.total_sessions ?? 0,
    sessionsThisWeek: row?.sessions_this_week ?? 0,
    sessionsThisMonth: row?.sessions_this_month ?? 0,
  };
}

export interface GetUserSessionsOptions {
  limit?: number;
  offset?: number;
  technique?: DivinationTechnique | null;
  orderBy?: 'created_at' | 'last_activity';
  order?: 'asc' | 'desc';
}

export async function getUserSessions(
  userId: string,
  opts: GetUserSessionsOptions = {}
): Promise<Array<{
  id: string;
  userId: string;
  technique: DivinationTechnique;
  locale: string;
  createdAt: string;
  lastActivity: string;
  question: string | null;
  results: Record<string, any> | null;
  interpretation: string | null;
  summary: string | null;
  metadata: Record<string, any> | null;
}>> {
  const client = getSupabaseServiceClient();
  let query = client
    .from('sessions')
    .select('*')
    .eq('user_id', userId)
    .eq('is_deleted', false);

  if (opts.technique) query = query.eq('technique', opts.technique);
  const orderBy = opts.orderBy ?? 'created_at';
  const order = opts.order ?? 'desc';
  query = query.order(orderBy, { ascending: order === 'asc' });
  if (opts.limit) query = query.limit(opts.limit);
  if (opts.offset) query = query.range(opts.offset, (opts.offset + (opts.limit ?? 20)) - 1);

  const { data, error } = await query;
  if (error) {
    log('warn', 'getUserSessions failed', { error: error.message, userId });
    return [];
  }
  const rows = (data ?? []) as Database['public']['Tables']['sessions']['Row'][];
  return rows.map((r) => ({
    id: r.id,
    userId: r.user_id,
    technique: r.technique,
    locale: r.locale,
    createdAt: r.created_at,
    lastActivity: r.last_activity,
    question: r.question,
    results: r.results,
    interpretation: r.interpretation,
    summary: r.summary,
    metadata: r.metadata,
  }));
}

export async function createSession(input: {
  id: string;
  userId: string;
  technique: DivinationTechnique;
  locale?: string;
  createdAt?: string;
  lastActivity?: string;
  question?: string | null;
  results?: Record<string, any> | null;
  interpretation?: string | null;
  summary?: string | null;
  metadata?: Record<string, any> | null;
}): Promise<{ id: string } & typeof input> {
  const client = getSupabaseServiceClient();
  const now = new Date().toISOString();
  const row = {
    id: input.id,
    user_id: input.userId,
    technique: input.technique,
    locale: input.locale ?? 'en',
    created_at: input.createdAt ?? now,
    last_activity: input.lastActivity ?? now,
    question: input.question ?? null,
    results: input.results ?? null,
    interpretation: input.interpretation ?? null,
    summary: input.summary ?? null,
    metadata: input.metadata ?? null,
    is_deleted: false,
    deleted_at: null,
  };
  const { data, error } = await client.from('sessions').insert(row).select('*').single();
  if (error) throw new Error(`createSession failed: ${error.message}`);
  const d = data as Database['public']['Tables']['sessions']['Row'];
  return {
    id: d.id,
    userId: d.user_id,
    technique: d.technique,
    locale: d.locale,
    createdAt: d.created_at,
    lastActivity: d.last_activity,
    question: d.question,
    results: d.results,
    interpretation: d.interpretation,
    summary: d.summary,
    metadata: d.metadata,
  };
}

export async function getSession(sessionId: string): Promise<{
  id: string;
  userId: string;
  technique: DivinationTechnique;
  locale: string;
  createdAt: string;
  lastActivity: string;
  question: string | null;
  results: Record<string, any> | null;
  interpretation: string | null;
  summary: string | null;
  metadata: Record<string, any> | null;
} | null> {
  const client = getSupabaseServiceClient();
  const { data, error } = await client
    .from('sessions')
    .select('*')
    .eq('id', sessionId)
    .eq('is_deleted', false)
    .single();
  if (error) {
    const code = (error as PostgrestError).code;
    if (code === 'PGRST116') return null; // no rows
    log('warn', 'getSession failed', { error: error.message, sessionId });
    return null;
  }
  const d = data as Database['public']['Tables']['sessions']['Row'];
  return {
    id: d.id,
    userId: d.user_id,
    technique: d.technique,
    locale: d.locale,
    createdAt: d.created_at,
    lastActivity: d.last_activity,
    question: d.question,
    results: d.results,
    interpretation: d.interpretation,
    summary: d.summary,
    metadata: d.metadata,
  };
}

export async function updateDivinationSession(
  sessionId: string,
  updates: Partial<{
    results: Record<string, any> | null;
    interpretation: string | null;
    summary: string | null;
    metadata: Record<string, any> | null;
  }>
): Promise<void> {
  const client = getSupabaseServiceClient();
  const patch = {
    ...(updates.results !== undefined ? { results: updates.results } : {}),
    ...(updates.interpretation !== undefined ? { interpretation: updates.interpretation } : {}),
    ...(updates.summary !== undefined ? { summary: updates.summary } : {}),
    ...(updates.metadata !== undefined ? { metadata: updates.metadata } : {}),
    last_activity: new Date().toISOString(),
  } as Database['public']['Tables']['sessions']['Update'];
  const { error } = await client.from('sessions').update(patch).eq('id', sessionId);
  if (error) throw new Error(`updateDivinationSession failed: ${error.message}`);
}

export async function checkSupabaseHealth(): Promise<{ status: 'healthy' | 'unhealthy'; responseTime: number; error?: string }>{
  const start = Date.now();
  try {
    const client = getSupabaseClient();
    const { error } = await client.from('users').select('id', { count: 'exact', head: true }).limit(1);
    const ms = Date.now() - start;
    if (error) return { status: 'unhealthy', responseTime: ms, error: error.message };
    return { status: 'healthy', responseTime: ms };
  } catch (e: unknown) {
    const err = e as { message?: string } | undefined;
    return { status: 'unhealthy', responseTime: Date.now() - start, error: String(err?.message ?? e) };
  }
}
