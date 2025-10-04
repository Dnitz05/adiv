-- =====================================================================
-- Smart Divination Platform - Session History Schema Migration
-- Adds normalized storage for cross-technique session timelines.
-- =====================================================================

BEGIN;

-- ---------------------------------------------------------------------
-- Enumerations for history actors and artifact payloads
-- ---------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'session_actor_type') THEN
        CREATE TYPE session_actor_type AS ENUM ('user', 'assistant', 'system');
    END IF;
END
$$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'session_artifact_type') THEN
        CREATE TYPE session_artifact_type AS ENUM (
            'tarot_draw',
            'iching_cast',
            'rune_cast',
            'interpretation',
            'message_bundle',
            'note'
        );
    END IF;
END
$$;

-- ---------------------------------------------------------------------
-- Session artifacts: persisted draws / interpretations / attachments
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS session_artifacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
    artifact_type session_artifact_type NOT NULL,
    source session_actor_type NOT NULL DEFAULT 'system',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    payload JSONB NOT NULL,
    version SMALLINT NOT NULL DEFAULT 1,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    CONSTRAINT session_artifacts_payload_not_empty CHECK (jsonb_typeof(payload) IS NOT NULL)
);

CREATE INDEX IF NOT EXISTS idx_session_artifacts_session_created_at
    ON session_artifacts(session_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_session_artifacts_type
    ON session_artifacts(session_id, artifact_type);

-- ---------------------------------------------------------------------
-- Session messages: conversational timeline per session
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS session_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
    sender session_actor_type NOT NULL,
    sequence BIGINT GENERATED ALWAYS AS IDENTITY,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    CONSTRAINT session_messages_content_not_empty CHECK (char_length(content) > 0)
);

CREATE INDEX IF NOT EXISTS idx_session_messages_session_sequence
    ON session_messages(session_id, sequence);
CREATE INDEX IF NOT EXISTS idx_session_messages_created_at
    ON session_messages(session_id, created_at DESC);

-- ---------------------------------------------------------------------
-- Function + triggers to keep session history metadata in sync
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION touch_session_history()
RETURNS TRIGGER AS $$
DECLARE
    target_session UUID;
    touch_time TIMESTAMPTZ;
    artifact_count INTEGER;
    message_count INTEGER;
    history_summary JSONB;
BEGIN
    PERFORM set_config('search_path', 'public', true);

    target_session := COALESCE(NEW.session_id, OLD.session_id);
    IF target_session IS NULL THEN
        RETURN COALESCE(NEW, OLD);
    END IF;

    touch_time := COALESCE(NEW.created_at, OLD.created_at, NOW());

    SELECT COUNT(*) INTO artifact_count
    FROM session_artifacts
    WHERE session_id = target_session;

    SELECT COUNT(*) INTO message_count
    FROM session_messages
    WHERE session_id = target_session;

    history_summary := jsonb_build_object(
        'artifacts', artifact_count,
        'messages', message_count,
        'updatedAt', touch_time
    );

    UPDATE sessions
    SET metadata = jsonb_set(
        COALESCE(metadata, '{}'::jsonb),
        '{history}',
        history_summary,
        true
    )
    WHERE id = target_session;

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_touch_session_history_artifacts ON session_artifacts;
CREATE TRIGGER trigger_touch_session_history_artifacts
    AFTER INSERT OR UPDATE OR DELETE ON session_artifacts
    FOR EACH ROW
    EXECUTE FUNCTION touch_session_history();

DROP TRIGGER IF EXISTS trigger_touch_session_history_messages ON session_messages;
CREATE TRIGGER trigger_touch_session_history_messages
    AFTER INSERT OR UPDATE OR DELETE ON session_messages
    FOR EACH ROW
    EXECUTE FUNCTION touch_session_history();

-- ---------------------------------------------------------------------
-- Derived view returning consolidated history payloads
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW session_history_expanded AS
SELECT
    s.id,
    s.user_id,
    s.technique,
    s.locale,
    s.created_at,
    s.last_activity,
    s.question,
      s.interpretation,
      s.summary,
    s.results,
    s.metadata,
    COALESCE(
        (
            SELECT jsonb_agg(
                jsonb_build_object(
                    'id', a.id,
                    'type', a.artifact_type,
                    'source', a.source,
                    'createdAt', a.created_at,
                    'version', a.version,
                    'payload', a.payload,
                    'metadata', a.metadata
                )
                ORDER BY a.created_at ASC
            )
            FROM session_artifacts a
            WHERE a.session_id = s.id
        ),
        '[]'::jsonb
    ) AS artifacts,
    COALESCE(
        (
            SELECT jsonb_agg(
                jsonb_build_object(
                    'id', m.id,
                    'sender', m.sender,
                    'sequence', m.sequence,
                    'createdAt', m.created_at,
                    'content', m.content,
                    'metadata', m.metadata
                )
                ORDER BY m.sequence ASC
            )
            FROM session_messages m
            WHERE m.session_id = s.id
        ),
        '[]'::jsonb
    ) AS messages
FROM sessions s
WHERE s.is_deleted = false;

COMMENT ON VIEW session_history_expanded IS 'Aggregated session timeline with artifacts and conversational messages per session.';

-- ---------------------------------------------------------------------
-- Row level security policies
-- ---------------------------------------------------------------------
ALTER TABLE session_artifacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE session_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own artifacts" ON session_artifacts
    FOR SELECT USING (
        EXISTS (
            SELECT 1
            FROM sessions s
            WHERE s.id = session_artifacts.session_id
              AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can insert artifacts for own sessions" ON session_artifacts
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1
            FROM sessions s
            WHERE s.id = session_artifacts.session_id
              AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update own artifacts" ON session_artifacts
    FOR UPDATE USING (
        EXISTS (
            SELECT 1
            FROM sessions s
            WHERE s.id = session_artifacts.session_id
              AND s.user_id = auth.uid()
        )
    ) WITH CHECK (
        EXISTS (
            SELECT 1
            FROM sessions s
            WHERE s.id = session_artifacts.session_id
              AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can delete own artifacts" ON session_artifacts
    FOR DELETE USING (
        EXISTS (
            SELECT 1
            FROM sessions s
            WHERE s.id = session_artifacts.session_id
              AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can view own messages" ON session_messages
    FOR SELECT USING (
        EXISTS (
            SELECT 1
            FROM sessions s
            WHERE s.id = session_messages.session_id
              AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can insert messages for own sessions" ON session_messages
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1
            FROM sessions s
            WHERE s.id = session_messages.session_id
              AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update own messages" ON session_messages
    FOR UPDATE USING (
        EXISTS (
            SELECT 1
            FROM sessions s
            WHERE s.id = session_messages.session_id
              AND s.user_id = auth.uid()
        )
    ) WITH CHECK (
        EXISTS (
            SELECT 1
            FROM sessions s
            WHERE s.id = session_messages.session_id
              AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can delete own messages" ON session_messages
    FOR DELETE USING (
        EXISTS (
            SELECT 1
            FROM sessions s
            WHERE s.id = session_messages.session_id
              AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "Service role manages artifacts" ON session_artifacts
    FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

CREATE POLICY "Service role manages messages" ON session_messages
    FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

-- ---------------------------------------------------------------------
-- Grants aligning with existing session access rules
-- ---------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON session_artifacts TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON session_messages TO authenticated;
GRANT SELECT ON session_history_expanded TO authenticated;

GRANT INSERT, SELECT ON session_artifacts TO anon;
GRANT INSERT, SELECT ON session_messages TO anon;
GRANT SELECT ON session_history_expanded TO anon;

GRANT ALL ON session_artifacts TO service_role;
GRANT ALL ON session_messages TO service_role;
GRANT SELECT ON session_history_expanded TO service_role;

COMMENT ON TABLE session_artifacts IS 'Technique-specific assets (draws, interpretations, attachments) linked to a session.';
COMMENT ON COLUMN session_artifacts.payload IS 'Structured JSON payload describing the artifact contents (cards, hexagrams, runes, etc.).';
COMMENT ON TABLE session_messages IS 'Chronological transcript for user <> assistant exchanges within a session.';
COMMENT ON COLUMN session_messages.content IS 'Message body stored as UTF-8 text.';

COMMIT;



