import { createClient, SupabaseClient, PostgrestError, User } from '@supabase/supabase-js';
import { randomUUID } from 'crypto';
import type { DivinationTechnique } from '../types/api';
import { log } from './logger';

interface SupabaseArtifact {
  id: string;
  type: 'tarot_draw' | 'iching_cast' | 'rune_cast' | 'interpretation' | 'message_bundle' | 'note';
  source: 'user' | 'assistant' | 'system';
  createdAt: string;
  version: number;
  payload: Record<string, any>;
  metadata?: Record<string, any> | null;
}

interface SupabaseMessage {
  id: string;
  sender: 'user' | 'assistant' | 'system';
  sequence: number;
  createdAt: string;
  content: string;
  metadata?: Record<string, any> | null;
}

export interface SupabaseSession {
  id: string;
  userId: string;
  technique: DivinationTechnique;
  locale: string;
  createdAt: string;
  lastActivity: string;
  question: string | null;
  results: Record<string, any> | null | undefined;
  interpretation: string | null | undefined;
  summary: string | null | undefined;
  metadata: Record<string, any> | null | undefined;
  keywords?: string[];
  artifacts?: SupabaseArtifact[];
  messages?: SupabaseMessage[];
}

interface SessionRow {
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
  is_deleted?: boolean;
  deleted_at?: string | null;
}

interface SessionArtifactRow {
  id: string;
  session_id: string;
  artifact_type:
    | 'tarot_draw'
    | 'iching_cast'
    | 'rune_cast'
    | 'interpretation'
    | 'message_bundle'
    | 'note';
  source: 'user' | 'assistant' | 'system';
  created_at: string;
  payload: Record<string, any>;
  metadata: Record<string, any> | null;
  version: number;
}

interface SessionMessageRow {
  id: string;
  session_id: string;
  sender: 'user' | 'assistant' | 'system';
  sequence: number;
  created_at: string;
  content: string;
  metadata: Record<string, any> | null;
}

interface SessionHistoryRow extends SessionRow {
  artifacts?: Array<Record<string, any>> | null;
  messages?: Array<Record<string, any>> | null;
  keywords?: string[] | null;
}

interface UserStatsRow {
  total_sessions: number | null;
  sessions_this_week: number | null;
  sessions_this_month: number | null;
}

function hasServiceCredentials(): boolean {
  return Boolean(process.env.SUPABASE_URL && process.env.SUPABASE_SERVICE_ROLE_KEY);
}

let supabaseClient: SupabaseClient | null = null;
let supabaseServiceClient: SupabaseClient | null = null;

export function getSupabaseClient(): SupabaseClient {
  if (!supabaseClient) {
    // WORKAROUND: Vercel env vars contain trailing \n - trim them
    // See: docs/vercel-env-vars-issue-report.md
    const supabaseUrl = process.env.SUPABASE_URL?.trim();
    const supabaseAnonKey = process.env.SUPABASE_ANON_KEY?.trim();
    if (!supabaseUrl || !supabaseAnonKey) {
      throw new Error('Supabase configuration missing: SUPABASE_URL or SUPABASE_ANON_KEY');
    }
    supabaseClient = createClient(supabaseUrl, supabaseAnonKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
    log('info', 'Supabase client initialized');
  }
  return supabaseClient;
}

export function getSupabaseServiceClient(): SupabaseClient {
  if (!supabaseServiceClient) {
    // WORKAROUND: Vercel env vars contain trailing \n - trim them
    // See: docs/vercel-env-vars-issue-report.md
    const supabaseUrl = process.env.SUPABASE_URL?.trim();
    const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY?.trim();
    if (!supabaseUrl || !serviceKey) {
      throw new Error('Supabase service configuration missing');
    }
    supabaseServiceClient = createClient(supabaseUrl, serviceKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
    log('info', 'Supabase service client initialized');
  }
  return supabaseServiceClient;
}

export async function getUserTier(
  userId: string
): Promise<'free' | 'premium' | 'premium_annual' | null> {
  const client = getSupabaseServiceClient();
  const { data, error } = await client
    .from('users')
    .select('tier')
    .eq('id', userId)
    .single<{ tier: 'free' | 'premium' | 'premium_annual' }>();
  if (error) {
    log('warn', 'getUserTier failed', { error: error.message, userId });
    return null;
  }
  return data?.tier ?? null;
}

export async function ensureUserRecord(user: User): Promise<void> {
  try {
    const client = getSupabaseServiceClient();
    const { data: existing, error } = await client
      .from('users')
      .select('id')
      .eq('id', user.id)
      .maybeSingle<{ id: string }>();

    if (error && error.code !== 'PGRST116') {
      log('warn', 'ensureUserRecord lookup failed', {
        error: error.message,
        userId: user.id,
      });
      return;
    }

    const metadataRecord: Record<string, unknown> =
      typeof user.user_metadata === 'object' && user.user_metadata !== null
        ? { ...user.user_metadata }
        : {};
    metadataRecord['lastAuthSyncAt'] = new Date().toISOString();

    const derivedName =
      [metadataRecord['full_name'], metadataRecord['name'], metadataRecord['user_name']]
        .map((value) => (typeof value === 'string' ? value.trim() : ''))
        .find((value) => value.length > 0) ||
      (typeof user.email === 'string' && user.email.includes('@')
        ? user.email.split('@')[0]
        : undefined);

    if (!existing) {
      const payload: Record<string, unknown> = {
        id: user.id,
        email: user.email,
        tier: 'free',
        metadata: metadataRecord,
      };
      if (derivedName) {
        payload.name = derivedName;
      }
      await client.from('users').insert(payload);
      return;
    }

    const updates: Record<string, unknown> = {
      email: user.email,
      metadata: metadataRecord,
    };
    if (derivedName) {
      updates.name = derivedName;
    }
    await client.from('users').update(updates).eq('id', user.id);
  } catch (error) {
    log('warn', 'ensureUserRecord failed', {
      error: error instanceof Error ? error.message : String(error),
      userId: user.id,
    });
  }
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
  const row = (data?.[0] as UserStatsRow) || undefined;
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

function mapSessionRow(row: SessionRow): SupabaseSession {
  return {
    id: row.id,
    userId: row.user_id,
    technique: row.technique,
    locale: row.locale,
    createdAt: row.created_at,
    lastActivity: row.last_activity,
    question: row.question,
    results: row.results,
    interpretation: row.interpretation,
    summary: row.summary,
    metadata: row.metadata,
  };
}

function mapSessionHistoryRow(row: any): SupabaseSession {
  const base = mapSessionRow(row as SessionRow);
  const artifacts = Array.isArray(row.artifacts)
    ? row.artifacts.map((artifact: any) => ({
        id: artifact.id,
        type: artifact.type,
        source: artifact.source,
        createdAt: artifact.createdAt ?? artifact.created_at ?? base.createdAt,
        version: typeof artifact.version === 'number' ? artifact.version : 1,
        payload: artifact.payload ?? {},
        metadata: artifact.metadata ?? undefined,
      }))
    : undefined;
  const messages = Array.isArray(row.messages)
    ? row.messages.map((message: any, index: number) => ({
        id: message.id ?? `${base.id}-message-${index}`,
        sender: message.sender ?? 'system',
        sequence: typeof message.sequence === 'number' ? message.sequence : index,
        createdAt: message.createdAt ?? message.created_at ?? base.createdAt,
        content: message.content ?? '',
        metadata: message.metadata ?? undefined,
      }))
    : undefined;

  return {
    ...base,
    artifacts,
    messages,
  };
}

export async function getUserSessions(
  userId: string,
  opts: GetUserSessionsOptions = {}
): Promise<SupabaseSession[]> {
  const client = getSupabaseServiceClient();
  const supabaseAvailable = hasServiceCredentials();

  if (!supabaseAvailable) {
    return [];
  }

  let query = client.from('session_history_expanded').select('*').eq('user_id', userId);
  if (opts.technique) query = query.eq('technique', opts.technique);

  const orderField = opts.orderBy ?? 'last_activity';
  const orderDir = opts.order ?? 'desc';
  const ascending = orderDir === 'asc';
  query = query.order(orderField, { ascending });

  if (!opts.orderBy) {
    query = query.order('created_at', { ascending }).order('id', { ascending });
  }

  if (opts.limit) query = query.limit(opts.limit);
  if (opts.offset) query = query.range(opts.offset, opts.offset + (opts.limit ?? 20) - 1);

  const { data, error } = await query;
  if (error) {
    log('warn', 'getUserSessions failed', { error: error.message, userId });
    return [];
  }

  return ((data ?? []) as any[]).map(mapSessionHistoryRow);
}

export async function createSession(input: {
  id?: string;
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
}): Promise<SupabaseSession> {
  const client = getSupabaseServiceClient();
  const now = new Date().toISOString();
  const sessionId = input.id ?? randomUUID();
  const row = {
    id: sessionId,
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
  return mapSessionRow(data as SessionRow);
}

export async function createSessionArtifact(params: {
  sessionId: string;
  type: SupabaseArtifact['type'];
  source?: SupabaseArtifact['source'];
  payload: Record<string, any>;
  version?: number;
  metadata?: Record<string, any>;
}): Promise<SupabaseArtifact> {
  const client = getSupabaseServiceClient();
  const { data, error } = await client
    .from('session_artifacts')
    .insert({
      session_id: params.sessionId,
      artifact_type: params.type,
      source: params.source ?? 'system',
      payload: params.payload,
      version: params.version ?? 1,
      metadata: params.metadata ?? {},
    })
    .select('*')
    .single();

  if (error) throw new Error(`createSessionArtifact failed: ${error.message}`);

  const row = data as SessionArtifactRow;
  return {
    id: row.id,
    type: row.artifact_type as SupabaseArtifact['type'],
    source: row.source,
    createdAt: row.created_at,
    version: row.version,
    payload: row.payload ?? {},
    metadata: row.metadata ?? undefined,
  };
}

export async function createSessionMessage(params: {
  sessionId: string;
  sender: SupabaseMessage['sender'];
  content: string;
  metadata?: Record<string, any>;
}): Promise<SupabaseMessage> {
  const client = getSupabaseServiceClient();
  const { data, error } = await client
    .from('session_messages')
    .insert({
      session_id: params.sessionId,
      sender: params.sender,
      content: params.content,
      metadata: params.metadata ?? {},
    })
    .select('*')
    .single();

  if (error) throw new Error(`createSessionMessage failed: ${error.message}`);

  const row = data as SessionMessageRow;
  return {
    id: row.id,
    sender: row.sender,
    sequence: row.sequence ?? 0,
    createdAt: row.created_at,
    content: row.content,
    metadata: row.metadata ?? undefined,
  };
}

export async function getSession(sessionId: string): Promise<SupabaseSession | null> {
  if (!hasServiceCredentials()) {
    return null;
  }

  const client = getSupabaseServiceClient();
  const { data, error } = await client
    .from('session_history_expanded')
    .select('*')
    .eq('id', sessionId)
    .single();

  if (error) {
    const code = (error as PostgrestError).code;
    if (code === 'PGRST116') return null;
    log('warn', 'getSession failed', { error: error.message, sessionId });
    return null;
  }

  return mapSessionHistoryRow(data);
}

export async function createDivinationSession(params: {
  userId: string;
  technique: DivinationTechnique;
  locale?: string;
  question?: string | null;
  results?: Record<string, any> | null;
  metadata?: Record<string, any> | null;
}): Promise<SupabaseSession> {
  if (!hasServiceCredentials()) {
    return buildFallbackSession(params);
  }

  // Skip Supabase operations for anonymous users
  if (params.userId.startsWith('anon_')) {
    return buildFallbackSession(params);
  }

  const metadata = params.metadata ?? null;
  const session = await createSession({
    userId: params.userId,
    technique: params.technique,
    locale: params.locale,
    question: params.question ?? null,
    results: params.results ?? null,
    metadata,
  });

  const artifactType = buildArtifactType(params.technique);
  const artifacts =
    artifactType && params.results
      ? [
          {
            id: `${session.id}-artifact-preview`,
            type: artifactType,
            source: 'system' as const,
            createdAt: session.createdAt,
            version: 1,
            payload: buildArtifactPayload(params.technique, params.results, metadata),
            metadata,
          },
        ]
      : undefined;

  return {
    ...session,
    artifacts,
    messages: undefined,
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
  const patch: Record<string, any> = {
    ...(updates.results !== undefined ? { results: updates.results } : {}),
    ...(updates.interpretation !== undefined ? { interpretation: updates.interpretation } : {}),
    ...(updates.summary !== undefined ? { summary: updates.summary } : {}),
    ...(updates.metadata !== undefined ? { metadata: updates.metadata } : {}),
    last_activity: new Date().toISOString(),
  };
  const { error } = await client.from('sessions').update(patch).eq('id', sessionId);
  if (error) throw new Error(`updateDivinationSession failed: ${error.message}`);
}

export async function checkSupabaseHealth(): Promise<{
  status: 'healthy' | 'unhealthy';
  responseTime: number;
  error?: string;
}> {
  const start = Date.now();
  try {
    const client = getSupabaseClient();
    const { error } = await client
      .from('users')
      .select('id', { count: 'exact', head: true })
      .limit(1);
    const responseTime = Date.now() - start;
    if (error) {
      return { status: 'unhealthy', responseTime, error: error.message };
    }
    return { status: 'healthy', responseTime };
  } catch (error: unknown) {
    const responseTime = Date.now() - start;
    return {
      status: 'unhealthy',
      responseTime,
      error: error instanceof Error ? error.message : String(error),
    };
  }
}

function buildArtifactPayload(
  technique: DivinationTechnique,
  results?: Record<string, any> | null,
  metadata?: Record<string, any> | null
): Record<string, any> {
  const payload: Record<string, any> = { technique };
  if (results) {
    Object.assign(payload, results);
  }
  if (metadata) {
    if (metadata.seed) payload.seed = metadata.seed;
    if (metadata.method) payload.method = metadata.method;
    if (metadata.signature) payload.signature = metadata.signature;
  }
  return payload;
}

function buildFallbackSession(params: {
  userId: string;
  technique: DivinationTechnique;
  locale?: string;
  question?: string | null;
  results?: Record<string, any> | null;
  metadata?: Record<string, any> | null;
}): SupabaseSession {
  const now = new Date().toISOString();
  const sessionId = `${params.technique}_${randomUUID()}`;
  const artifactType = buildArtifactType(params.technique);

  return {
    id: sessionId,
    userId: params.userId,
    technique: params.technique,
    locale: params.locale ?? 'en',
    createdAt: now,
    lastActivity: now,
    question: params.question ?? null,
    results: params.results ?? undefined,
    interpretation: null,
    summary: null,
    metadata: params.metadata ?? null,
    artifacts:
      artifactType && params.results
        ? [
            {
              id: `${sessionId}-artifact`,
              type: artifactType,
              source: 'system',
              createdAt: now,
              version: 1,
              payload: buildArtifactPayload(
                params.technique,
                params.results,
                params.metadata ?? null
              ),
              metadata: params.metadata ?? undefined,
            },
          ]
        : undefined,
    messages: undefined,
  };
}

function buildArtifactType(technique: DivinationTechnique): SupabaseArtifact['type'] | null {
  switch (technique) {
    case 'tarot':
      return 'tarot_draw';
    case 'iching':
      return 'iching_cast';
    case 'runes':
      return 'rune_cast';
    default:
      return null;
  }
}
