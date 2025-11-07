-- =====================================================================
-- Smart Divination Platform - User Activities / Journal Schema
-- Adds user_activities table and ETL triggers for journal timeline.
-- =====================================================================

BEGIN;

-- ---------------------------------------------------------------------
-- Activity type and status enumerations
-- ---------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'journal_activity_type') THEN
        CREATE TYPE journal_activity_type AS ENUM (
            'tarot_reading',
            'iching_reading',
            'rune_reading',
            'lunar_guidance',
            'chat_session',
            'daily_draw'
        );
    END IF;
END
$$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'journal_activity_status') THEN
        CREATE TYPE journal_activity_status AS ENUM (
            'completed',
            'partial',
            'archived'
        );
    END IF;
END
$$;

-- ---------------------------------------------------------------------
-- User activities table for journal timeline
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    activity_type journal_activity_type NOT NULL,
    activity_status journal_activity_status NOT NULL DEFAULT 'completed',
    activity_date DATE NOT NULL,
    title TEXT,
    summary TEXT,
    payload JSONB NOT NULL DEFAULT '{}'::jsonb,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    lunar_phase_id lunar_phase,
    lunar_zodiac_name TEXT,
    deleted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE user_activities IS 'Timeline of user divination activities for journal/archive features.';

-- Indexes for efficient queries
CREATE INDEX IF NOT EXISTS idx_user_activities_user_date
    ON user_activities(user_id, activity_date DESC);

CREATE INDEX IF NOT EXISTS idx_user_activities_user_created
    ON user_activities(user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_user_activities_session
    ON user_activities(session_id);

CREATE INDEX IF NOT EXISTS idx_user_activities_type
    ON user_activities(user_id, activity_type, activity_date DESC);

CREATE INDEX IF NOT EXISTS idx_user_activities_deleted
    ON user_activities(deleted_at) WHERE deleted_at IS NULL;

-- ---------------------------------------------------------------------
-- Row level security policies
-- ---------------------------------------------------------------------
ALTER TABLE user_activities ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS user_activities_select ON user_activities;
CREATE POLICY user_activities_select ON user_activities
    FOR SELECT TO authenticated
    USING (auth.uid() = user_id);

DROP POLICY IF EXISTS user_activities_insert ON user_activities;
CREATE POLICY user_activities_insert ON user_activities
    FOR INSERT TO authenticated, service_role
    WITH CHECK (
        auth.uid() = user_id OR
        auth.jwt() ->> 'role' = 'service_role'
    );

DROP POLICY IF EXISTS user_activities_update ON user_activities;
CREATE POLICY user_activities_update ON user_activities
    FOR UPDATE TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS user_activities_delete ON user_activities;
CREATE POLICY user_activities_delete ON user_activities
    FOR DELETE TO authenticated
    USING (auth.uid() = user_id);

-- ---------------------------------------------------------------------
-- ETL trigger function: Sync sessions → user_activities
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION sync_session_to_activities()
RETURNS TRIGGER AS $$
DECLARE
    activity_type_val journal_activity_type;
    activity_title TEXT;
    activity_summary TEXT;
    activity_payload JSONB;
    lunar_phase lunar_phase;
    lunar_zodiac TEXT;
BEGIN
    -- Map technique to activity type
    activity_type_val := CASE NEW.technique
        WHEN 'tarot' THEN 'tarot_reading'::journal_activity_type
        WHEN 'iching' THEN 'iching_reading'::journal_activity_type
        WHEN 'runes' THEN 'rune_reading'::journal_activity_type
        ELSE 'chat_session'::journal_activity_type
    END;

    -- Extract title from question or generate default
    activity_title := COALESCE(
        SUBSTRING(NEW.question FROM 1 FOR 100),
        CASE NEW.technique
            WHEN 'tarot' THEN 'Tarot Reading'
            WHEN 'iching' THEN 'I Ching Reading'
            WHEN 'runes' THEN 'Rune Reading'
            ELSE 'Divination Session'
        END
    );

    -- Use summary or interpretation snippet
    activity_summary := COALESCE(
        NEW.summary,
        SUBSTRING(NEW.interpretation FROM 1 FOR 200)
    );

    -- Build payload from session data
    activity_payload := jsonb_build_object(
        'technique', NEW.technique,
        'question', NEW.question,
        'results', NEW.results,
        'interpretation', NEW.interpretation,
        'spread_type', NEW.metadata->>'spread_type',
        'locale', NEW.locale
    );

    -- Extract lunar metadata if present
    lunar_phase := (NEW.metadata->>'lunar_phase')::lunar_phase;
    lunar_zodiac := NEW.metadata->>'lunar_zodiac';

    -- Insert activity record
    INSERT INTO user_activities (
        user_id,
        activity_type,
        activity_status,
        activity_date,
        title,
        summary,
        payload,
        metadata,
        session_id,
        lunar_phase_id,
        lunar_zodiac_name,
        created_at
    ) VALUES (
        NEW.user_id,
        activity_type_val,
        CASE
            WHEN NEW.interpretation IS NOT NULL THEN 'completed'::journal_activity_status
            WHEN NEW.results IS NOT NULL THEN 'partial'::journal_activity_status
            ELSE 'archived'::journal_activity_status
        END,
        NEW.created_at::date,
        activity_title,
        activity_summary,
        activity_payload,
        NEW.metadata,
        NEW.id,
        lunar_phase,
        lunar_zodiac,
        NEW.created_at
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger
DROP TRIGGER IF EXISTS trigger_sync_session_to_activities ON sessions;
CREATE TRIGGER trigger_sync_session_to_activities
    AFTER INSERT ON sessions
    FOR EACH ROW
    EXECUTE FUNCTION sync_session_to_activities();

COMMENT ON FUNCTION sync_session_to_activities IS 'ETL: Automatically creates user_activity records from sessions inserts.';

-- ---------------------------------------------------------------------
-- Grants
-- ---------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON user_activities TO authenticated;
GRANT ALL ON user_activities TO service_role;

COMMIT;
