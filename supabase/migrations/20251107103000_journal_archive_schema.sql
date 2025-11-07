-- =====================================================================
-- Smart Divination Platform - Journal Archive Schema
-- Adds normalized journal storage, lunar history tables, and metadata
-- =====================================================================

BEGIN;

-- ---------------------------------------------------------------------
-- Reusable helper to auto-update updated_at columns
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------------------
-- Domain enums for journal activities
-- ---------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'journal_activity_type') THEN
        CREATE TYPE journal_activity_type AS ENUM (
            'tarot_reading',
            'chat',
            'lunar_advice',
            'ritual',
            'meditation',
            'note',
            'reminder',
            'insight',
            'custom'
        );
    END IF;
END
$$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'journal_activity_status') THEN
        CREATE TYPE journal_activity_status AS ENUM (
            'draft',
            'scheduled',
            'in_progress',
            'completed',
            'missed',
            'cancelled',
            'archived'
        );
    END IF;
END
$$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'journal_activity_source') THEN
        CREATE TYPE journal_activity_source AS ENUM (
            'user',
            'assistant',
            'system',
            'import'
        );
    END IF;
END
$$;

-- Ensure lunar_phase enum exists (created in previous migration)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'lunar_phase') THEN
        CREATE TYPE lunar_phase AS ENUM (
            'new_moon',
            'waxing_crescent',
            'first_quarter',
            'waxing_gibbous',
            'full_moon',
            'waning_gibbous',
            'last_quarter',
            'waning_crescent'
        );
    END IF;
END
$$;

-- ---------------------------------------------------------------------
-- Core journal activity table
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    activity_type journal_activity_type NOT NULL,
    activity_status journal_activity_status NOT NULL DEFAULT 'completed',
    source journal_activity_source NOT NULL DEFAULT 'system',
    activity_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    timezone TEXT,
    lunar_phase_id lunar_phase,
    lunar_phase_name TEXT,
    lunar_zodiac_id TEXT,
    lunar_zodiac_name TEXT,
    title TEXT,
    summary TEXT,
    tags TEXT[] NOT NULL DEFAULT '{}'::text[],
    mood TEXT,
    duration_minutes SMALLINT,
    reference_table TEXT,
    reference_id UUID,
    payload JSONB NOT NULL DEFAULT '{}'::jsonb,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    CONSTRAINT chk_duration_non_negative CHECK (duration_minutes IS NULL OR duration_minutes >= 0)
);

CREATE INDEX IF NOT EXISTS idx_user_activities_user_date
    ON user_activities(user_id, activity_date DESC);
CREATE INDEX IF NOT EXISTS idx_user_activities_type
    ON user_activities(activity_type);
CREATE INDEX IF NOT EXISTS idx_user_activities_status
    ON user_activities(activity_status);
CREATE INDEX IF NOT EXISTS idx_user_activities_phase
    ON user_activities(lunar_phase_id);
CREATE INDEX IF NOT EXISTS idx_user_activities_reference
    ON user_activities(reference_table, reference_id);
CREATE INDEX IF NOT EXISTS idx_user_activities_tags
    ON user_activities USING GIN(tags);
CREATE INDEX IF NOT EXISTS idx_user_activities_payload
    ON user_activities USING GIN(payload);

CREATE TRIGGER set_user_activities_updated_at
    BEFORE UPDATE ON user_activities
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();

-- ---------------------------------------------------------------------
-- Journal notes (user-authored reflections)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS journal_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    activity_id UUID REFERENCES user_activities(id) ON DELETE SET NULL,
    title TEXT,
    body TEXT NOT NULL,
    mood TEXT,
    tags TEXT[] NOT NULL DEFAULT '{}'::text[],
    is_private BOOLEAN NOT NULL DEFAULT TRUE,
    source journal_activity_source NOT NULL DEFAULT 'user',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_journal_notes_user_created
    ON journal_notes(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_journal_notes_activity
    ON journal_notes(activity_id);
CREATE INDEX IF NOT EXISTS idx_journal_notes_tags
    ON journal_notes USING GIN(tags);

CREATE TRIGGER set_journal_notes_updated_at
    BEFORE UPDATE ON journal_notes
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();

-- ---------------------------------------------------------------------
-- Journal reminders (scheduled rituals/meditations/etc.)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS journal_reminders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    activity_type journal_activity_type NOT NULL DEFAULT 'reminder',
    status journal_activity_status NOT NULL DEFAULT 'scheduled',
    scheduled_at TIMESTAMPTZ NOT NULL,
    timezone TEXT,
    title TEXT,
    description TEXT,
    payload JSONB NOT NULL DEFAULT '{}'::jsonb,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    last_notification_at TIMESTAMPTZ,
    last_notification_error TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_journal_reminders_user_schedule
    ON journal_reminders(user_id, scheduled_at);
CREATE INDEX IF NOT EXISTS idx_journal_reminders_status
    ON journal_reminders(status);

CREATE TRIGGER set_journal_reminders_updated_at
    BEFORE UPDATE ON journal_reminders
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();

-- ---------------------------------------------------------------------
-- Activity links for relationships (note ↔ reading, etc.)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS journal_activity_links (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    source_activity_id UUID NOT NULL REFERENCES user_activities(id) ON DELETE CASCADE,
    target_activity_id UUID NOT NULL REFERENCES user_activities(id) ON DELETE CASCADE,
    relation TEXT NOT NULL DEFAULT 'related',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_activity_link_distinct CHECK (source_activity_id <> target_activity_id)
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_journal_activity_links_unique
    ON journal_activity_links(source_activity_id, target_activity_id, relation);

-- ---------------------------------------------------------------------
-- Insights cache table (AI-generated summaries/stats)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS journal_insights (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    period TEXT NOT NULL,
    headline TEXT,
    summary TEXT,
    metrics JSONB NOT NULL DEFAULT '{}'::jsonb,
    provider TEXT,
    request_id TEXT,
    generated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_journal_insights_user_period
    ON journal_insights(user_id, period);
CREATE INDEX IF NOT EXISTS idx_journal_insights_expiry
    ON journal_insights(expires_at);

CREATE TRIGGER set_journal_insights_updated_at
    BEFORE UPDATE ON journal_insights
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();

-- ---------------------------------------------------------------------
-- Formalize lunar queries (history of guidance)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS lunar_queries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    topic TEXT NOT NULL,
    intention TEXT,
    advice JSONB NOT NULL,
    context JSONB NOT NULL,
    locale TEXT NOT NULL DEFAULT 'en',
    date DATE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_lunar_queries_user_date
    ON lunar_queries(user_id, date DESC);
CREATE INDEX IF NOT EXISTS idx_lunar_queries_topic
    ON lunar_queries(topic);

-- ---------------------------------------------------------------------
-- Formalize lunar reminders (existing API dependency)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS lunar_reminders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    time TEXT,
    topic TEXT NOT NULL,
    intention TEXT,
    locale TEXT NOT NULL DEFAULT 'en',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_lunar_reminders_user_date
    ON lunar_reminders(user_id, date);

-- ---------------------------------------------------------------------
-- Row level security
-- ---------------------------------------------------------------------
ALTER TABLE user_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE journal_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE journal_reminders ENABLE ROW LEVEL SECURITY;
ALTER TABLE journal_activity_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE journal_insights ENABLE ROW LEVEL SECURITY;
ALTER TABLE lunar_queries ENABLE ROW LEVEL SECURITY;
ALTER TABLE lunar_reminders ENABLE ROW LEVEL SECURITY;

-- Helper expressions
CREATE POLICY "Users view own activities" ON user_activities
    FOR SELECT USING (auth.uid() = user_id AND deleted_at IS NULL);
CREATE POLICY "Users insert own activities" ON user_activities
    FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users update own activities" ON user_activities
    FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users delete own activities" ON user_activities
    FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "Service role manages activities" ON user_activities
    FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

CREATE POLICY "Users view own notes" ON journal_notes
    FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users manage own notes" ON journal_notes
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Service role manages notes" ON journal_notes
    FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

CREATE POLICY "Users view own reminders" ON journal_reminders
    FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users manage own reminders" ON journal_reminders
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Service role manages reminders" ON journal_reminders
    FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

CREATE POLICY "Users view own activity links" ON journal_activity_links
    FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users manage own activity links" ON journal_activity_links
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Service role manages activity links" ON journal_activity_links
    FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

CREATE POLICY "Users view own insights" ON journal_insights
    FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users manage own insights" ON journal_insights
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Service role manages insights" ON journal_insights
    FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

CREATE POLICY "Users view own lunar queries" ON lunar_queries
    FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users insert own lunar queries" ON lunar_queries
    FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Service role manages lunar queries" ON lunar_queries
    FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

CREATE POLICY "Users view own lunar reminders" ON lunar_reminders
    FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users manage own lunar reminders" ON lunar_reminders
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Service role manages lunar reminders" ON lunar_reminders
    FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

-- Grants
GRANT SELECT, INSERT, UPDATE, DELETE ON user_activities TO authenticated;
GRANT SELECT, INSERT ON user_activities TO anon;
GRANT ALL ON user_activities TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON journal_notes TO authenticated;
GRANT SELECT, INSERT ON journal_notes TO anon;
GRANT ALL ON journal_notes TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON journal_reminders TO authenticated;
GRANT SELECT, INSERT ON journal_reminders TO anon;
GRANT ALL ON journal_reminders TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON journal_activity_links TO authenticated;
GRANT SELECT, INSERT ON journal_activity_links TO anon;
GRANT ALL ON journal_activity_links TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON journal_insights TO authenticated;
GRANT SELECT ON journal_insights TO anon;
GRANT ALL ON journal_insights TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON lunar_queries TO authenticated;
GRANT SELECT, INSERT ON lunar_queries TO anon;
GRANT ALL ON lunar_queries TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON lunar_reminders TO authenticated;
GRANT SELECT, INSERT ON lunar_reminders TO anon;
GRANT ALL ON lunar_reminders TO service_role;

COMMENT ON TABLE user_activities IS 'Unified activity timeline for the Journal/Archive experience.';
COMMENT ON TABLE journal_notes IS 'User-authored reflections linked to activities.';
COMMENT ON TABLE journal_reminders IS 'Scheduled ritual/meditation reminders for the Agenda view.';
COMMENT ON TABLE journal_activity_links IS 'Relationships between activities (e.g., note linked to tarot reading).';
COMMENT ON TABLE journal_insights IS 'Cached AI-generated insights and metrics for the journal.';
COMMENT ON TABLE lunar_queries IS 'Historical record of lunar guidance responses.';
COMMENT ON TABLE lunar_reminders IS 'Existing reminder table formalized for Supabase schema.';

COMMIT;
