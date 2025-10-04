/*
 * Supabase type definitions (manually curated for the Smart Divination schema).
 *
 * If the Supabase schema changes, regenerate types via
 * `npm run supabase:types:ci` and update any additional fields below.
 */

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

type TableRow<T> = {
  Row: T;
  Insert: Partial<T>;
  Update: Partial<T>;
};

export interface Database {
  public: {
    Tables: {
      users: TableRow<{
        id: string;
        email: string | null;
        name: string | null;
        tier: 'free' | 'premium' | 'premium_annual';
        created_at: string;
        last_activity: string;
        preferences: Record<string, any>;
        metadata: Record<string, any> | null;
      }>;
      user_stats: TableRow<{
        user_id: string;
        technique: 'tarot' | 'iching' | 'runes';
        total_sessions: number;
        sessions_this_week: number;
        sessions_this_month: number;
        last_session_at: string | null;
        favorite_spread: string | null;
        average_rating: number | null;
        updated_at: string;
      }>;
      sessions: TableRow<{
        id: string;
        user_id: string;
        technique: 'tarot' | 'iching' | 'runes';
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
      }>;
      session_artifacts: TableRow<{
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
      }>;
      session_messages: TableRow<{
        id: string;
        session_id: string;
        sender: 'user' | 'assistant' | 'system';
        sequence: number;
        created_at: string;
        content: string;
        metadata: Record<string, any> | null;
      }>;
      api_usage: TableRow<{
        id: string;
        user_id: string | null;
        endpoint: string;
        method: string;
        status_code: number;
        processing_time_ms: number;
        technique: 'tarot' | 'iching' | 'runes' | null;
        created_at: string;
        metadata: Record<string, any> | null;
      }>;
    };
    Views: {
      session_history_expanded: {
        Row: Database['public']['Tables']['sessions']['Row'] & {
          artifacts: Array<{
            id: string;
            type: Database['public']['Tables']['session_artifacts']['Row']['artifact_type'];
            source: Database['public']['Tables']['session_artifacts']['Row']['source'];
            createdAt?: string;
            created_at?: string;
            version?: number | null;
            payload?: Record<string, any> | null;
            metadata?: Record<string, any> | null;
          }> | null;
          messages: Array<{
            id?: string;
            sender?: Database['public']['Tables']['session_messages']['Row']['sender'];
            sequence?: number;
            createdAt?: string;
            created_at?: string;
            content?: string;
            metadata?: Record<string, any> | null;
          }> | null;
        };
      };
    };
    Functions: Record<string, never>;
    Enums: {
      divination_technique: 'tarot' | 'iching' | 'runes';
      user_tier: 'free' | 'premium' | 'premium_annual';
      session_actor_type: 'user' | 'assistant' | 'system';
      session_artifact_type:
        | 'tarot_draw'
        | 'iching_cast'
        | 'rune_cast'
        | 'interpretation'
        | 'message_bundle'
        | 'note';
    };
    CompositeTypes: Record<string, never>;
  };
}
