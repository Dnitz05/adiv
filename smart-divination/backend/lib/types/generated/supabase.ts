export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "13.0.5"
  }
  public: {
    Tables: {
      api_usage: {
        Row: {
          created_at: string
          endpoint: string
          id: string
          metadata: Json | null
          method: string
          processing_time_ms: number
          status_code: number
          technique: Database["public"]["Enums"]["divination_technique"] | null
          user_id: string | null
        }
        Insert: {
          created_at?: string
          endpoint: string
          id?: string
          metadata?: Json | null
          method: string
          processing_time_ms: number
          status_code: number
          technique?: Database["public"]["Enums"]["divination_technique"] | null
          user_id?: string | null
        }
        Update: {
          created_at?: string
          endpoint?: string
          id?: string
          metadata?: Json | null
          method?: string
          processing_time_ms?: number
          status_code?: number
          technique?: Database["public"]["Enums"]["divination_technique"] | null
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "api_usage_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "user_engagement"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "api_usage_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      daily_lunar_insights: {
        Row: {
          date: string
          element: string
          generated_at: string | null
          generation_cost: number | null
          generation_model: string | null
          generation_prompt: string | null
          id: string
          illumination: number
          is_special_event: boolean | null
          lunar_age: number
          phase_id: string
          quality_score: number | null
          reviewed: boolean | null
          special_event_type: string | null
          specific_insight: Json
          universal_insight: Json
          zodiac_sign: string
        }
        Insert: {
          date: string
          element: string
          generated_at?: string | null
          generation_cost?: number | null
          generation_model?: string | null
          generation_prompt?: string | null
          id?: string
          illumination: number
          is_special_event?: boolean | null
          lunar_age: number
          phase_id: string
          quality_score?: number | null
          reviewed?: boolean | null
          special_event_type?: string | null
          specific_insight: Json
          universal_insight: Json
          zodiac_sign: string
        }
        Update: {
          date?: string
          element?: string
          generated_at?: string | null
          generation_cost?: number | null
          generation_model?: string | null
          generation_prompt?: string | null
          id?: string
          illumination?: number
          is_special_event?: boolean | null
          lunar_age?: number
          phase_id?: string
          quality_score?: number | null
          reviewed?: boolean | null
          special_event_type?: string | null
          specific_insight?: Json
          universal_insight?: Json
          zodiac_sign?: string
        }
        Relationships: []
      }
      lunar_daily_cache: {
        Row: {
          age: number
          data: Json
          date: string
          guidance: string | null
          illumination: number
          phase: Database["public"]["Enums"]["lunar_phase"]
          updated_at: string
          zodiac_sign: string
        }
        Insert: {
          age: number
          data?: Json
          date: string
          guidance?: string | null
          illumination: number
          phase: Database["public"]["Enums"]["lunar_phase"]
          updated_at?: string
          zodiac_sign: string
        }
        Update: {
          age?: number
          data?: Json
          date?: string
          guidance?: string | null
          illumination?: number
          phase?: Database["public"]["Enums"]["lunar_phase"]
          updated_at?: string
          zodiac_sign?: string
        }
        Relationships: []
      }
      lunar_guide_templates: {
        Row: {
          active: boolean | null
          created_at: string | null
          element: string | null
          energy_description: Json
          focus_areas: Json
          headline: Json
          id: string
          journal_prompts: Json | null
          phase_id: string
          polarity_note: Json | null
          priority: number | null
          recommended_actions: Json
          tagline: Json | null
          updated_at: string | null
          zodiac_sign: string | null
        }
        Insert: {
          active?: boolean | null
          created_at?: string | null
          element?: string | null
          energy_description: Json
          focus_areas: Json
          headline: Json
          id?: string
          journal_prompts?: Json | null
          phase_id: string
          polarity_note?: Json | null
          priority?: number | null
          recommended_actions: Json
          tagline?: Json | null
          updated_at?: string | null
          zodiac_sign?: string | null
        }
        Update: {
          active?: boolean | null
          created_at?: string | null
          element?: string | null
          energy_description?: Json
          focus_areas?: Json
          headline?: Json
          id?: string
          journal_prompts?: Json | null
          phase_id?: string
          polarity_note?: Json | null
          priority?: number | null
          recommended_actions?: Json
          tagline?: Json | null
          updated_at?: string | null
          zodiac_sign?: string | null
        }
        Relationships: []
      }
      session_artifacts: {
        Row: {
          artifact_type: Database["public"]["Enums"]["session_artifact_type"]
          created_at: string
          id: string
          metadata: Json
          payload: Json
          session_id: string
          source: Database["public"]["Enums"]["session_actor_type"]
          version: number
        }
        Insert: {
          artifact_type: Database["public"]["Enums"]["session_artifact_type"]
          created_at?: string
          id?: string
          metadata?: Json
          payload: Json
          session_id: string
          source?: Database["public"]["Enums"]["session_actor_type"]
          version?: number
        }
        Update: {
          artifact_type?: Database["public"]["Enums"]["session_artifact_type"]
          created_at?: string
          id?: string
          metadata?: Json
          payload?: Json
          session_id?: string
          source?: Database["public"]["Enums"]["session_actor_type"]
          version?: number
        }
        Relationships: [
          {
            foreignKeyName: "session_artifacts_session_id_fkey"
            columns: ["session_id"]
            isOneToOne: false
            referencedRelation: "session_history_expanded"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "session_artifacts_session_id_fkey"
            columns: ["session_id"]
            isOneToOne: false
            referencedRelation: "sessions"
            referencedColumns: ["id"]
          },
        ]
      }
      session_messages: {
        Row: {
          content: string
          created_at: string
          id: string
          metadata: Json
          sender: Database["public"]["Enums"]["session_actor_type"]
          sequence: number
          session_id: string
        }
        Insert: {
          content: string
          created_at?: string
          id?: string
          metadata?: Json
          sender: Database["public"]["Enums"]["session_actor_type"]
          sequence?: never
          session_id: string
        }
        Update: {
          content?: string
          created_at?: string
          id?: string
          metadata?: Json
          sender?: Database["public"]["Enums"]["session_actor_type"]
          sequence?: never
          session_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "session_messages_session_id_fkey"
            columns: ["session_id"]
            isOneToOne: false
            referencedRelation: "session_history_expanded"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "session_messages_session_id_fkey"
            columns: ["session_id"]
            isOneToOne: false
            referencedRelation: "sessions"
            referencedColumns: ["id"]
          },
        ]
      }
      sessions: {
        Row: {
          created_at: string
          deleted_at: string | null
          id: string
          interpretation: string | null
          is_deleted: boolean
          last_activity: string
          locale: string
          metadata: Json
          question: string | null
          results: Json | null
          summary: string | null
          technique: Database["public"]["Enums"]["divination_technique"]
          user_id: string
        }
        Insert: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          interpretation?: string | null
          is_deleted?: boolean
          last_activity?: string
          locale?: string
          metadata?: Json
          question?: string | null
          results?: Json | null
          summary?: string | null
          technique: Database["public"]["Enums"]["divination_technique"]
          user_id: string
        }
        Update: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          interpretation?: string | null
          is_deleted?: boolean
          last_activity?: string
          locale?: string
          metadata?: Json
          question?: string | null
          results?: Json | null
          summary?: string | null
          technique?: Database["public"]["Enums"]["divination_technique"]
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "sessions_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "user_engagement"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "sessions_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      user_activities: {
        Row: {
          activity_date: string
          activity_status: Database["public"]["Enums"]["journal_activity_status"]
          activity_type: Database["public"]["Enums"]["journal_activity_type"]
          created_at: string
          deleted_at: string | null
          id: string
          lunar_phase_id: Database["public"]["Enums"]["lunar_phase"] | null
          lunar_zodiac_name: string | null
          metadata: Json
          payload: Json
          session_id: string | null
          summary: string | null
          title: string | null
          user_id: string
        }
        Insert: {
          activity_date: string
          activity_status?: Database["public"]["Enums"]["journal_activity_status"]
          activity_type: Database["public"]["Enums"]["journal_activity_type"]
          created_at?: string
          deleted_at?: string | null
          id?: string
          lunar_phase_id?: Database["public"]["Enums"]["lunar_phase"] | null
          lunar_zodiac_name?: string | null
          metadata?: Json
          payload?: Json
          session_id?: string | null
          summary?: string | null
          title?: string | null
          user_id: string
        }
        Update: {
          activity_date?: string
          activity_status?: Database["public"]["Enums"]["journal_activity_status"]
          activity_type?: Database["public"]["Enums"]["journal_activity_type"]
          created_at?: string
          deleted_at?: string | null
          id?: string
          lunar_phase_id?: Database["public"]["Enums"]["lunar_phase"] | null
          lunar_zodiac_name?: string | null
          metadata?: Json
          payload?: Json
          session_id?: string | null
          summary?: string | null
          title?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_activities_session_id_fkey"
            columns: ["session_id"]
            isOneToOne: false
            referencedRelation: "session_history_expanded"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_activities_session_id_fkey"
            columns: ["session_id"]
            isOneToOne: false
            referencedRelation: "sessions"
            referencedColumns: ["id"]
          },
        ]
      }
      user_stats: {
        Row: {
          average_rating: number | null
          favorite_spread: string | null
          last_session_at: string | null
          sessions_this_month: number
          sessions_this_week: number
          technique: Database["public"]["Enums"]["divination_technique"]
          total_sessions: number
          updated_at: string
          user_id: string
        }
        Insert: {
          average_rating?: number | null
          favorite_spread?: string | null
          last_session_at?: string | null
          sessions_this_month?: number
          sessions_this_week?: number
          technique: Database["public"]["Enums"]["divination_technique"]
          total_sessions?: number
          updated_at?: string
          user_id: string
        }
        Update: {
          average_rating?: number | null
          favorite_spread?: string | null
          last_session_at?: string | null
          sessions_this_month?: number
          sessions_this_week?: number
          technique?: Database["public"]["Enums"]["divination_technique"]
          total_sessions?: number
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_stats_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "user_engagement"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_stats_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      users: {
        Row: {
          created_at: string
          email: string | null
          id: string
          last_activity: string
          metadata: Json | null
          name: string | null
          preferences: Json
          tier: Database["public"]["Enums"]["user_tier"]
        }
        Insert: {
          created_at?: string
          email?: string | null
          id?: string
          last_activity?: string
          metadata?: Json | null
          name?: string | null
          preferences?: Json
          tier?: Database["public"]["Enums"]["user_tier"]
        }
        Update: {
          created_at?: string
          email?: string | null
          id?: string
          last_activity?: string
          metadata?: Json | null
          name?: string | null
          preferences?: Json
          tier?: Database["public"]["Enums"]["user_tier"]
        }
        Relationships: []
      }
    }
    Views: {
      daily_usage_stats: {
        Row: {
          avg_processing_time_ms: number | null
          date: string | null
          session_count: number | null
          technique: Database["public"]["Enums"]["divination_technique"] | null
          unique_users: number | null
        }
        Relationships: []
      }
      session_history_expanded: {
        Row: {
          artifacts: Json | null
          created_at: string | null
          id: string | null
          interpretation: string | null
          last_activity: string | null
          locale: string | null
          messages: Json | null
          metadata: Json | null
          question: string | null
          results: Json | null
          summary: string | null
          technique: Database["public"]["Enums"]["divination_technique"] | null
          user_id: string | null
        }
        Insert: {
          artifacts?: never
          created_at?: string | null
          id?: string | null
          interpretation?: string | null
          last_activity?: string | null
          locale?: string | null
          messages?: never
          metadata?: Json | null
          question?: string | null
          results?: Json | null
          summary?: string | null
          technique?: Database["public"]["Enums"]["divination_technique"] | null
          user_id?: string | null
        }
        Update: {
          artifacts?: never
          created_at?: string | null
          id?: string | null
          interpretation?: string | null
          last_activity?: string | null
          locale?: string | null
          messages?: never
          metadata?: Json | null
          question?: string | null
          results?: Json | null
          summary?: string | null
          technique?: Database["public"]["Enums"]["divination_technique"] | null
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "sessions_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "user_engagement"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "sessions_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      user_engagement: {
        Row: {
          first_session: string | null
          id: string | null
          last_activity: string | null
          last_session: string | null
          techniques_used: number | null
          tier: Database["public"]["Enums"]["user_tier"] | null
          total_sessions: number | null
          user_created_at: string | null
        }
        Relationships: []
      }
    }
    Functions: {
      cleanup_old_deleted_sessions: { Args: never; Returns: number }
      refresh_user_stats: { Args: { user_uuid: string }; Returns: undefined }
    }
    Enums: {
      divination_technique: "tarot" | "iching" | "runes"
      journal_activity_status: "completed" | "partial" | "archived"
      journal_activity_type:
        | "tarot_reading"
        | "iching_reading"
        | "rune_reading"
        | "lunar_guidance"
        | "chat_session"
        | "daily_draw"
      lunar_phase:
        | "new_moon"
        | "waxing_crescent"
        | "first_quarter"
        | "waxing_gibbous"
        | "full_moon"
        | "waning_gibbous"
        | "last_quarter"
        | "waning_crescent"
      notification_type: "email" | "push" | "marketing"
      session_actor_type: "user" | "assistant" | "system"
      session_artifact_type:
        | "tarot_draw"
        | "iching_cast"
        | "rune_cast"
        | "interpretation"
        | "message_bundle"
        | "note"
      user_tier: "free" | "premium" | "premium_annual"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      divination_technique: ["tarot", "iching", "runes"],
      journal_activity_status: ["completed", "partial", "archived"],
      journal_activity_type: [
        "tarot_reading",
        "iching_reading",
        "rune_reading",
        "lunar_guidance",
        "chat_session",
        "daily_draw",
      ],
      lunar_phase: [
        "new_moon",
        "waxing_crescent",
        "first_quarter",
        "waxing_gibbous",
        "full_moon",
        "waning_gibbous",
        "last_quarter",
        "waning_crescent",
      ],
      notification_type: ["email", "push", "marketing"],
      session_actor_type: ["user", "assistant", "system"],
      session_artifact_type: [
        "tarot_draw",
        "iching_cast",
        "rune_cast",
        "interpretation",
        "message_bundle",
        "note",
      ],
      user_tier: ["free", "premium", "premium_annual"],
    },
  },
} as const
