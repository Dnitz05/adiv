// Generated types placeholder. Replace by running Supabase CLI:
// supabase gen types typescript --db-url "$SUPABASE_DB_URL" --schema public > lib/types/generated/supabase.ts
// or
// supabase gen types typescript --project-id "$SUPABASE_PROJECT_ID" --schema public > lib/types/generated/supabase.ts

import type { DivinationTechnique } from '../../types/api';

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

