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
            'iching_cast',
            'rune_cast',
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
    CONSTRAINT chk_duration_non_negative CHECK (duration_minutes IS NULL OR duration_minutes >= 0),
    CONSTRAINT user_activities_reference_unique UNIQUE (reference_table, reference_id)
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
-- Synchronization helpers to feed user_activities
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION journal_archive_activity()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE user_activities
    SET activity_status = 'archived',
        deleted_at = NOW()
    WHERE reference_table = TG_TABLE_NAME
      AND reference_id = OLD.id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION journal_sync_session_activity()
RETURNS TRIGGER AS $$
DECLARE
    activity_type journal_activity_type;
    activity_status journal_activity_status;
    activity_deleted_at TIMESTAMPTZ;
    timezone_hint TEXT;
BEGIN
    PERFORM set_config('search_path', 'public', true);

    IF TG_OP = 'DELETE' THEN
        RETURN journal_archive_activity();
    END IF;

    activity_type := CASE NEW.technique
        WHEN 'tarot' THEN 'tarot_reading'
        WHEN 'iching' THEN 'iching_cast'
        WHEN 'runes' THEN 'rune_cast'
        ELSE 'custom'
    END;

    activity_status := CASE
        WHEN NEW.is_deleted THEN 'archived'
        ELSE 'completed'
    END;

    activity_deleted_at := CASE
        WHEN NEW.is_deleted THEN COALESCE(NEW.deleted_at, NOW())
        ELSE NULL
    END;

    timezone_hint := COALESCE(NEW.metadata->>'timezone', NULL);

    INSERT INTO user_activities (
        user_id,
        activity_type,
        activity_status,
        source,
        activity_date,
        timezone,
        title,
        summary,
        reference_table,
        reference_id,
        payload,
        metadata,
        deleted_at
    )
    VALUES (
        NEW.user_id,
        activity_type,
        activity_status,
        'system',
        COALESCE(NEW.last_activity, NEW.created_at, NOW()),
        timezone_hint,
        COALESCE(NEW.summary, NEW.question, INITCAP(NEW.technique) || ' session'),
        COALESCE(NEW.interpretation, NEW.summary, NEW.question),
        'sessions',
        NEW.id,
        jsonb_build_object(
            'technique', NEW.technique,
            'question', NEW.question,
            'results', COALESCE(NEW.results, '{}'::jsonb),
            'summary', NEW.summary,
            'interpretation', NEW.interpretation,
            'metadata', COALESCE(NEW.metadata, '{}'::jsonb)
        ),
        COALESCE(NEW.metadata, '{}'::jsonb),
        activity_deleted_at
    )
    ON CONFLICT (reference_table, reference_id)
    DO UPDATE SET
        user_id = EXCLUDED.user_id,
        activity_type = EXCLUDED.activity_type,
        activity_status = EXCLUDED.activity_status,
        source = EXCLUDED.source,
        activity_date = EXCLUDED.activity_date,
        timezone = EXCLUDED.timezone,
        title = EXCLUDED.title,
        summary = EXCLUDED.summary,
        payload = EXCLUDED.payload,
        metadata = EXCLUDED.metadata,
        deleted_at = EXCLUDED.deleted_at,
        updated_at = NOW();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS journal_sync_session_activity_trigger ON sessions;
CREATE TRIGGER journal_sync_session_activity_trigger
    AFTER INSERT OR UPDATE OR DELETE ON sessions
    FOR EACH ROW
    EXECUTE FUNCTION journal_sync_session_activity();

CREATE OR REPLACE FUNCTION journal_sync_lunar_query_activity()
RETURNS TRIGGER AS $$
DECLARE
    phase_id_text TEXT;
    phase_id_value lunar_phase;
    payload JSONB;
BEGIN
    PERFORM set_config('search_path', 'public', true);

    IF TG_OP = 'DELETE' THEN
        RETURN journal_archive_activity();
    END IF;

    phase_id_text := COALESCE(NEW.context->>'phaseId', NEW.context->>'phase_id');
    IF phase_id_text IS NOT NULL THEN
        BEGIN
            phase_id_value := phase_id_text::lunar_phase;
        EXCEPTION
            WHEN others THEN
                phase_id_value := NULL;
        END;
    END IF;

    payload := jsonb_build_object(
        'topic', NEW.topic,
        'intention', NEW.intention,
        'advice', NEW.advice,
        'context', NEW.context,
        'locale', NEW.locale
    );

    INSERT INTO user_activities (
        user_id,
        activity_type,
        activity_status,
        source,
        activity_date,
        lunar_phase_id,
        lunar_phase_name,
        title,
        summary,
        reference_table,
        reference_id,
        payload,
        metadata
    )
    VALUES (
        NEW.user_id,
        'lunar_advice',
        'completed',
        'assistant',
        COALESCE(NEW.created_at, NOW()),
        phase_id_value,
        COALESCE(NEW.context->>'phaseName', NEW.context->>'phase_name'),
        'Consulta lunar: ' || NEW.topic,
        COALESCE(NEW.intention, NEW.context->>'guidanceSummary'),
        'lunar_queries',
        NEW.id,
        payload,
        NEW.context
    )
    ON CONFLICT (reference_table, reference_id)
    DO UPDATE SET
        activity_date = EXCLUDED.activity_date,
        lunar_phase_id = EXCLUDED.lunar_phase_id,
        lunar_phase_name = EXCLUDED.lunar_phase_name,
        title = EXCLUDED.title,
        summary = EXCLUDED.summary,
        payload = EXCLUDED.payload,
        metadata = EXCLUDED.metadata,
        updated_at = NOW();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS journal_sync_lunar_query_activity_trigger ON lunar_queries;
CREATE TRIGGER journal_sync_lunar_query_activity_trigger
    AFTER INSERT OR UPDATE OR DELETE ON lunar_queries
    FOR EACH ROW
    EXECUTE FUNCTION journal_sync_lunar_query_activity();

CREATE OR REPLACE FUNCTION journal_sync_lunar_reminder_activity()
RETURNS TRIGGER AS $$
DECLARE
    scheduled_at TIMESTAMPTZ;
    hour_part INT;
    minute_part INT;
BEGIN
    PERFORM set_config('search_path', 'public', true);

    IF TG_OP = 'DELETE' THEN
        RETURN journal_archive_activity();
    END IF;

    hour_part := split_part(COALESCE(NEW.time, '00:00'), ':', 1)::INT;
    minute_part := split_part(COALESCE(NEW.time, '00:00'), ':', 2)::INT;

    scheduled_at := make_timestamptz(
        EXTRACT(YEAR FROM NEW.date)::INT,
        EXTRACT(MONTH FROM NEW.date)::INT,
        EXTRACT(DAY FROM NEW.date)::INT,
        hour_part,
        minute_part,
        0
    );

    INSERT INTO user_activities (
        user_id,
        activity_type,
        activity_status,
        source,
        activity_date,
        title,
        summary,
        reference_table,
        reference_id,
        payload,
        metadata
    )
    VALUES (
        NEW.user_id,
        'reminder',
        'scheduled',
        'system',
        COALESCE(scheduled_at, NOW()),
        'Recordatori lunar: ' || NEW.topic,
        COALESCE(NEW.intention, 'Recordatori programat'),
        'lunar_reminders',
        NEW.id,
        jsonb_build_object(
            'topic', NEW.topic,
            'intention', NEW.intention,
            'locale', NEW.locale
        ),
        jsonb_build_object('date', NEW.date, 'time', NEW.time)
    )
    ON CONFLICT (reference_table, reference_id)
    DO UPDATE SET
        activity_date = EXCLUDED.activity_date,
        title = EXCLUDED.title,
        summary = EXCLUDED.summary,
        payload = EXCLUDED.payload,
        metadata = EXCLUDED.metadata,
        updated_at = NOW();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS journal_sync_lunar_reminder_activity_trigger ON lunar_reminders;
CREATE TRIGGER journal_sync_lunar_reminder_activity_trigger
    AFTER INSERT OR UPDATE OR DELETE ON lunar_reminders
    FOR EACH ROW
    EXECUTE FUNCTION journal_sync_lunar_reminder_activity();

CREATE OR REPLACE FUNCTION journal_prepare_note_activity()
RETURNS TRIGGER AS $$
DECLARE
    activity_id UUID;
BEGIN
    PERFORM set_config('search_path', 'public', true);

    INSERT INTO user_activities (
        user_id,
        activity_type,
        activity_status,
        source,
        activity_date,
        title,
        summary,
        reference_table,
        reference_id,
        payload,
        metadata
    )
    VALUES (
        NEW.user_id,
        'note',
        'completed',
        NEW.source,
        COALESCE(NEW.updated_at, NEW.created_at, NOW()),
        COALESCE(NEW.title, 'Nota personal'),
        SUBSTRING(NEW.body FOR 280),
        'journal_notes',
        NEW.id,
        jsonb_build_object(
            'body', NEW.body,
            'mood', NEW.mood,
            'tags', COALESCE(to_jsonb(NEW.tags), '[]'::jsonb),
            'isPrivate', NEW.is_private
        ),
        jsonb_build_object('tags', COALESCE(to_jsonb(NEW.tags), '[]'::jsonb))
    )
    ON CONFLICT (reference_table, reference_id)
    DO UPDATE SET
        activity_date = EXCLUDED.activity_date,
        title = EXCLUDED.title,
        summary = EXCLUDED.summary,
        payload = EXCLUDED.payload,
        metadata = EXCLUDED.metadata,
        updated_at = NOW()
    RETURNING id INTO activity_id;

    NEW.activity_id := activity_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS journal_prepare_note_activity_trigger ON journal_notes;
CREATE TRIGGER journal_prepare_note_activity_trigger
    BEFORE INSERT OR UPDATE ON journal_notes
    FOR EACH ROW
    EXECUTE FUNCTION journal_prepare_note_activity();

DROP TRIGGER IF EXISTS journal_archive_note_activity_trigger ON journal_notes;
CREATE TRIGGER journal_archive_note_activity_trigger
    AFTER DELETE ON journal_notes
    FOR EACH ROW
    EXECUTE FUNCTION journal_archive_activity();

CREATE OR REPLACE FUNCTION journal_prepare_reminder_activity()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM set_config('search_path', 'public', true);

    INSERT INTO user_activities (
        user_id,
        activity_type,
        activity_status,
        source,
        activity_date,
        timezone,
        title,
        summary,
        reference_table,
        reference_id,
        payload,
        metadata
    )
    VALUES (
        NEW.user_id,
        COALESCE(NEW.activity_type, 'reminder'),
        NEW.status,
        'system',
        NEW.scheduled_at,
        NEW.timezone,
        COALESCE(NEW.title, 'Recordatori'),
        COALESCE(NEW.description, 'Ritual programat'),
        'journal_reminders',
        NEW.id,
        jsonb_build_object(
            'payload', NEW.payload,
            'metadata', NEW.metadata
        ),
        NEW.metadata
    )
    ON CONFLICT (reference_table, reference_id)
    DO UPDATE SET
        activity_type = EXCLUDED.activity_type,
        activity_status = EXCLUDED.activity_status,
        activity_date = EXCLUDED.activity_date,
        timezone = EXCLUDED.timezone,
        title = EXCLUDED.title,
        summary = EXCLUDED.summary,
        payload = EXCLUDED.payload,
        metadata = EXCLUDED.metadata,
        updated_at = NOW();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS journal_prepare_reminder_activity_trigger ON journal_reminders;
CREATE TRIGGER journal_prepare_reminder_activity_trigger
    BEFORE INSERT OR UPDATE ON journal_reminders
    FOR EACH ROW
    EXECUTE FUNCTION journal_prepare_reminder_activity();

DROP TRIGGER IF EXISTS journal_archive_reminder_activity_trigger ON journal_reminders;
CREATE TRIGGER journal_archive_reminder_activity_trigger
    AFTER DELETE ON journal_reminders
    FOR EACH ROW
    EXECUTE FUNCTION journal_archive_activity();

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
