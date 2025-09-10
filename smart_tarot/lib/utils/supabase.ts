/**
 * Supabase Client - Ultra-Professional Database Integration
 * 
 * Comprehensive Supabase client with authentication, real-time subscriptions,
 * and optimized database operations for the Smart Divination platform.
 */

import { createClient, SupabaseClient, User, AuthError, PostgrestError } from '@supabase/supabase-js';
import type {
  DivinationSession,
  User as ApiUser,
  UserPreferences,
  SessionMetadata,
  DivinationTechnique,
} from '../types/api';
import { log, logError } from './api';

// =============================================================================
// SUPABASE CLIENT SETUP
// =============================================================================

let supabaseClient: SupabaseClient | null = null;
let supabaseServiceClient: SupabaseClient | null = null;

/**
 * Get Supabase client (user-scoped)
 */
export function getSupabaseClient(): SupabaseClient {
  if (!supabaseClient) {
    const supabaseUrl = process.env.SUPABASE_URL;
    const supabaseAnonKey = process.env.SUPABASE_ANON_KEY;
    
    if (!supabaseUrl || !supabaseAnonKey) {
      throw new Error('Supabase configuration missing: SUPABASE_URL or SUPABASE_ANON_KEY');
    }
    
    supabaseClient = createClient(supabaseUrl, supabaseAnonKey, {
      auth: {
        persistSession: false, // Server-side, don't persist
        autoRefreshToken: false,
      },
      realtime: {
        params: {
          eventsPerSecond: 10,
        },
      },
    });
    
    log('info', 'Supabase client initialized', { url: supabaseUrl });
  }
  
  return supabaseClient;
}

/**
 * Get Supabase service client (bypasses RLS)
 */
export function getSupabaseServiceClient(): SupabaseClient {
  if (!supabaseServiceClient) {
    const supabaseUrl = process.env.SUPABASE_URL;
    const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
    
    if (!supabaseUrl || !supabaseServiceKey) {
      throw new Error('Supabase service configuration missing');
    }
    
    supabaseServiceClient = createClient(supabaseUrl, supabaseServiceKey, {
      auth: {
        persistSession: false,
        autoRefreshToken: false,
      },
    });
    
    log('info', 'Supabase service client initialized');
  }
  
  return supabaseServiceClient;
}

// =============================================================================
// DATABASE TYPES (Supabase Generated)
// =============================================================================

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
          preferences: UserPreferences;
          metadata: Record<string, any> | null;
        };
        Insert: {
          id?: string;
          email?: string | null;
          name?: string | null;
          tier?: 'free' | 'premium' | 'premium_annual';
          created_at?: string;
          last_activity?: string;
          preferences?: UserPreferences;
          metadata?: Record<string, any> | null;
        };
        Update: {
          id?: string;
          email?: string | null;
          name?: string | null;
          tier?: 'free' | 'premium' | 'premium_annual';
          created_at?: string;
          last_activity?: string;
          preferences?: UserPreferences;
          metadata?: Record<string, any> | null;
        };
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
          metadata: SessionMetadata;
          is_deleted: boolean;
          deleted_at: string | null;
        };
        Insert: {
          id?: string;
          user_id: string;
          technique: DivinationTechnique;
          locale?: string;
          created_at?: string;
          last_activity?: string;
          question?: string | null;
          results?: Record<string, any> | null;
          interpretation?: string | null;
          summary?: string | null;
          metadata?: SessionMetadata;
          is_deleted?: boolean;
          deleted_at?: string | null;
        };
        Update: {
          id?: string;
          user_id?: string;
          technique?: DivinationTechnique;
          locale?: string;
          created_at?: string;
          last_activity?: string;
          question?: string | null;
          results?: Record<string, any> | null;
          interpretation?: string | null;
          summary?: string | null;
          metadata?: SessionMetadata;
          is_deleted?: boolean;
          deleted_at?: string | null;
        };
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
        Insert: {
          user_id: string;
          technique: DivinationTechnique;
          total_sessions?: number;
          sessions_this_week?: number;
          sessions_this_month?: number;
          last_session_at?: string | null;
          favorite_spread?: string | null;
          average_rating?: number | null;
          updated_at?: string;
        };
        Update: {
          user_id?: string;
          technique?: DivinationTechnique;
          total_sessions?: number;
          sessions_this_week?: number;
          sessions_this_month?: number;
          last_session_at?: string | null;
          favorite_spread?: string | null;
          average_rating?: number | null;
          updated_at?: string;
        };
      };
    };
    Views: {
      [_ in never]: never;
    };
    Functions: {
      [_ in never]: never;
    };
    Enums: {
      divination_technique: 'tarot' | 'iching' | 'runes';
      user_tier: 'free' | 'premium' | 'premium_annual';
    };
  };
}

// =============================================================================
// USER OPERATIONS
// =============================================================================

/**
 * Create or update user profile
 */
export async function upsertUser(userData: {
  id: string;
  email?: string;
  name?: string;
  tier?: 'free' | 'premium' | 'premium_annual';
  preferences?: UserPreferences;
}): Promise<ApiUser> {
  const client = getSupabaseClient();
  
  const now = new Date().toISOString();
  const defaultPreferences: UserPreferences = {
    locale: 'en',
    theme: 'auto',
    notifications: {
      email: true,
      push: true,
      marketing: false,
    },
  };
  
  const { data, error } = await client
    .from('users')
    .upsert({
      id: userData.id,
      email: userData.email || null,
      name: userData.name || null,
      tier: userData.tier || 'free',
      last_activity: now,
      preferences: { ...defaultPreferences, ...userData.preferences },
    })
    .select()
    .single();
  
  if (error) {
    log('error', 'Failed to upsert user', { error, userId: userData.id });
    throw new Error(`User operation failed: ${error.message}`);
  }
  
  return {
    id: data.id,
    email: data.email || undefined,
    name: data.name || undefined,
    tier: data.tier,
    createdAt: data.created_at,
    lastActivity: data.last_activity,
    preferences: data.preferences,
  };
}

/**
 * Get user by ID
 */
export async function getUser(userId: string): Promise<ApiUser | null> {
  const client = getSupabaseClient();
  
  const { data, error } = await client
    .from('users')
    .select('*')
    .eq('id', userId)
    .single();
  
  if (error) {
    if (error.code === 'PGRST116') {
      return null; // User not found
    }
    throw new Error(`Failed to get user: ${error.message}`);
  }
  
  return {
    id: data.id,
    email: data.email || undefined,
    name: data.name || undefined,
    tier: data.tier,
    createdAt: data.created_at,
    lastActivity: data.last_activity,
    preferences: data.preferences,
  };
}

/**
 * Update user tier (for premium upgrades)
 */
export async function updateUserTier(
  userId: string, 
  tier: 'free' | 'premium' | 'premium_annual'
): Promise<void> {
  const client = getSupabaseClient();
  
  const { error } = await client
    .from('users')
    .update({ 
      tier,
      last_activity: new Date().toISOString(),
    })
    .eq('id', userId);
  
  if (error) {
    throw new Error(`Failed to update user tier: ${error.message}`);
  }
  
  log('info', 'User tier updated', { userId, tier });
}

/**
 * Get user tier from database
 */
export async function getUserTier(
  userId: string
): Promise<'free' | 'premium' | 'premium_annual' | null> {
  const client = getSupabaseClient();
  
  const { data, error } = await client
    .from('users')
    .select('tier')
    .eq('id', userId)
    .single();
  
  if (error) {
    if (error.code === 'PGRST116') {
      // User not found
      return null;
    }
    throw new Error(`Failed to get user tier: ${error.message}`);
  }
  
  return data?.tier || 'free';
}

// =============================================================================
// SESSION OPERATIONS
// =============================================================================

/**
 * Create new divination session
 */
export async function createSession(sessionData: {
  id: string;
  userId: string;
  technique: DivinationTechnique;
  locale?: string;
  question?: string;
  metadata: SessionMetadata;
}): Promise<DivinationSession> {
  const client = getSupabaseClient();
  
  const now = new Date().toISOString();
  
  const { data, error } = await client
    .from('sessions')
    .insert({
      id: sessionData.id,
      user_id: sessionData.userId,
      technique: sessionData.technique,
      locale: sessionData.locale || 'en',
      question: sessionData.question || null,
      metadata: sessionData.metadata,
      created_at: now,
      last_activity: now,
    })
    .select()
    .single();
  
  if (error) {
    throw new Error(`Failed to create session: ${error.message}`);
  }
  
  // Update user stats
  await updateUserStats(sessionData.userId, sessionData.technique);
  
  return mapDbSessionToApi(data);
}

/**
 * Update session with results and interpretation
 */
export async function updateSession(
  sessionId: string,
  updates: {
    results?: Record<string, any>;
    interpretation?: string;
    summary?: string;
    metadata?: Partial<SessionMetadata>;
  }
): Promise<DivinationSession> {
  const client = getSupabaseClient();
  
  const updateData: any = {
    last_activity: new Date().toISOString(),
  };
  
  if (updates.results) updateData.results = updates.results;
  if (updates.interpretation) updateData.interpretation = updates.interpretation;
  if (updates.summary) updateData.summary = updates.summary;
  if (updates.metadata) {
    // Merge metadata
    const { data: current } = await client
      .from('sessions')
      .select('metadata')
      .eq('id', sessionId)
      .single();
    
    updateData.metadata = { ...current?.metadata, ...updates.metadata };
  }
  
  const { data, error } = await client
    .from('sessions')
    .update(updateData)
    .eq('id', sessionId)
    .select()
    .single();
  
  if (error) {
    throw new Error(`Failed to update session: ${error.message}`);
  }
  
  return mapDbSessionToApi(data);
}

/**
 * Get session by ID
 */
export async function getSession(sessionId: string): Promise<DivinationSession | null> {
  const client = getSupabaseClient();
  
  const { data, error } = await client
    .from('sessions')
    .select('*')
    .eq('id', sessionId)
    .eq('is_deleted', false)
    .single();
  
  if (error) {
    if (error.code === 'PGRST116') {
      return null; // Session not found
    }
    throw new Error(`Failed to get session: ${error.message}`);
  }
  
  return mapDbSessionToApi(data);
}

/**
 * Get user session history
 */
export async function getUserSessions(
  userId: string,
  options: {
    technique?: DivinationTechnique;
    limit?: number;
    offset?: number;
    orderBy?: 'created_at' | 'last_activity';
    order?: 'asc' | 'desc';
  } = {}
): Promise<DivinationSession[]> {
  const client = getSupabaseClient();
  
  let query = client
    .from('sessions')
    .select('*')
    .eq('user_id', userId)
    .eq('is_deleted', false);
  
  if (options.technique) {
    query = query.eq('technique', options.technique);
  }
  
  const orderBy = options.orderBy || 'last_activity';
  const order = options.order || 'desc';
  query = query.order(orderBy, { ascending: order === 'asc' });
  
  if (options.limit) {
    query = query.limit(options.limit);
  }
  
  if (options.offset) {
    query = query.range(options.offset, options.offset + (options.limit || 50) - 1);
  }
  
  const { data, error } = await query;
  
  if (error) {
    throw new Error(`Failed to get user sessions: ${error.message}`);
  }
  
  return data.map(mapDbSessionToApi);
}

/**
 * Soft delete session
 */
export async function deleteSession(sessionId: string, userId: string): Promise<void> {
  const client = getSupabaseClient();
  
  const { error } = await client
    .from('sessions')
    .update({
      is_deleted: true,
      deleted_at: new Date().toISOString(),
    })
    .eq('id', sessionId)
    .eq('user_id', userId); // Ensure user owns the session
  
  if (error) {
    throw new Error(`Failed to delete session: ${error.message}`);
  }
  
  log('info', 'Session deleted', { sessionId, userId });
}

// =============================================================================
// USER STATISTICS
// =============================================================================

/**
 * Update user statistics
 */
async function updateUserStats(userId: string, technique: DivinationTechnique): Promise<void> {
  const client = getSupabaseClient();
  
  const now = new Date();
  const weekStart = new Date(now.getFullYear(), now.getMonth(), now.getDate() - now.getDay());
  const monthStart = new Date(now.getFullYear(), now.getMonth(), 1);
  
  // Get current stats
  const { data: currentStats } = await client
    .from('user_stats')
    .select('*')
    .eq('user_id', userId)
    .eq('technique', technique)
    .single();
  
  // Count sessions
  const [totalSessions, weekSessions, monthSessions] = await Promise.all([
    client
      .from('sessions')
      .select('id', { count: 'exact' })
      .eq('user_id', userId)
      .eq('technique', technique)
      .eq('is_deleted', false),
    client
      .from('sessions')
      .select('id', { count: 'exact' })
      .eq('user_id', userId)
      .eq('technique', technique)
      .eq('is_deleted', false)
      .gte('created_at', weekStart.toISOString()),
    client
      .from('sessions')
      .select('id', { count: 'exact' })
      .eq('user_id', userId)
      .eq('technique', technique)
      .eq('is_deleted', false)
      .gte('created_at', monthStart.toISOString()),
  ]);
  
  const statsData = {
    user_id: userId,
    technique,
    total_sessions: totalSessions.count || 0,
    sessions_this_week: weekSessions.count || 0,
    sessions_this_month: monthSessions.count || 0,
    last_session_at: now.toISOString(),
    updated_at: now.toISOString(),
  };
  
  if (currentStats) {
    // Update existing stats
    await client
      .from('user_stats')
      .update(statsData)
      .eq('user_id', userId)
      .eq('technique', technique);
  } else {
    // Insert new stats
    await client.from('user_stats').insert(statsData);
  }
}

/**
 * Get user statistics
 */
export async function getUserStats(userId: string): Promise<Record<DivinationTechnique, any>> {
  const client = getSupabaseClient();
  
  const { data, error } = await client
    .from('user_stats')
    .select('*')
    .eq('user_id', userId);
  
  if (error) {
    throw new Error(`Failed to get user stats: ${error.message}`);
  }
  
  const stats: Record<string, any> = {};
  
  for (const stat of data) {
    stats[stat.technique] = {
      totalSessions: stat.total_sessions,
      sessionsThisWeek: stat.sessions_this_week,
      sessionsThisMonth: stat.sessions_this_month,
      lastSessionAt: stat.last_session_at,
      favoriteSpread: stat.favorite_spread,
      averageRating: stat.average_rating,
    };
  }
  
  return stats as Record<DivinationTechnique, any>;
}

// =============================================================================
// HELPER FUNCTIONS
// =============================================================================

/**
 * Map database session to API format
 */
function mapDbSessionToApi(dbSession: any): DivinationSession {
  return {
    id: dbSession.id,
    userId: dbSession.user_id,
    technique: dbSession.technique,
    locale: dbSession.locale,
    createdAt: dbSession.created_at,
    lastActivity: dbSession.last_activity,
    question: dbSession.question,
    results: dbSession.results,
    interpretation: dbSession.interpretation,
    summary: dbSession.summary,
    metadata: dbSession.metadata,
  };
}

// =============================================================================
// CONVENIENCE WRAPPERS (for API compatibility)
// =============================================================================

/**
 * Create divination session (API endpoint compatibility)
 */
export async function createDivinationSession(sessionData: {
  userId: string;
  technique: DivinationTechnique;
  locale?: string;
  question?: string;
  results?: Record<string, any>;
  metadata: SessionMetadata;
}): Promise<DivinationSession | null> {
  try {
    const sessionId = `${sessionData.technique}_${Date.now()}_${Math.random().toString(36).slice(2)}`;
    
    const session = await createSession({
      id: sessionId,
      userId: sessionData.userId,
      technique: sessionData.technique,
      locale: sessionData.locale,
      question: sessionData.question,
      metadata: sessionData.metadata,
    });
    
    // If results provided, update the session
    if (sessionData.results) {
      return await updateSession(session.id, { results: sessionData.results });
    }
    
    return session;
  } catch (error) {
    log('error', 'Failed to create divination session', { 
      error: error instanceof Error ? error.message : String(error),
      sessionData: { ...sessionData, metadata: 'redacted' }
    });
    return null; // Return null instead of throwing for API compatibility
  }
}

/**
 * Update divination session (API endpoint compatibility)
 */
export async function updateDivinationSession(
  sessionId: string,
  updates: {
    results?: Record<string, any>;
    interpretation?: string;
    summary?: string;
    metadata?: Partial<SessionMetadata>;
  }
): Promise<DivinationSession | null> {
  try {
    return await updateSession(sessionId, updates);
  } catch (error) {
    log('error', 'Failed to update divination session', { 
      error: error instanceof Error ? error.message : String(error),
      sessionId
    });
    return null; // Return null instead of throwing for API compatibility
  }
}

/**
 * Health check for Supabase connection
 */
export async function checkSupabaseHealth(): Promise<{
  status: 'healthy' | 'unhealthy';
  responseTime: number;
  error?: string;
}> {
  const startTime = Date.now();
  
  try {
    const client = getSupabaseClient();
    await client.from('users').select('id').limit(1);
    
    const responseTime = Date.now() - startTime;
    return { status: 'healthy', responseTime };
  } catch (error) {
    const responseTime = Date.now() - startTime;
    return {
      status: 'unhealthy',
      responseTime,
      error: error instanceof Error ? error.message : String(error),
    };
  }
}