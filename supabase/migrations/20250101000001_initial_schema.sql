-- =====================================================================
-- Smart Divination Platform - Initial Database Schema
-- Ultra-Professional Supabase Database Structure
-- =====================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================================
-- ENUMS
-- =====================================================================

-- Divination techniques supported by the platform
CREATE TYPE divination_technique AS ENUM ('tarot', 'iching', 'runes');

-- User subscription tiers
CREATE TYPE user_tier AS ENUM ('free', 'premium', 'premium_annual');

-- Notification types for user preferences
CREATE TYPE notification_type AS ENUM ('email', 'push', 'marketing');

-- =====================================================================
-- TABLES
-- =====================================================================

-- Users table - Core user profiles and preferences
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE,
    name TEXT,
    tier user_tier NOT NULL DEFAULT 'free',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_activity TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    preferences JSONB NOT NULL DEFAULT '{
        "locale": "en",
        "theme": "auto",
        "defaultTechnique": null,
        "notifications": {
            "email": true,
            "push": true,
            "marketing": false
        }
    }'::jsonb,
    metadata JSONB DEFAULT '{}'::jsonb,
    
    -- Constraints
    CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' OR email IS NULL),
    CONSTRAINT valid_preferences CHECK (preferences ? 'locale' AND preferences ? 'theme' AND preferences ? 'notifications')
);

-- Divination sessions - Complete reading sessions with results
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    technique divination_technique NOT NULL,
    locale TEXT NOT NULL DEFAULT 'en',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_activity TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    question TEXT,
    results JSONB,
    interpretation TEXT,
    summary TEXT,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at TIMESTAMPTZ,
    
    -- Constraints
    CONSTRAINT valid_locale CHECK (locale IN ('en', 'es', 'ca', 'fr', 'de', 'it')),
    CONSTRAINT valid_metadata CHECK (metadata IS NOT NULL),
    CONSTRAINT deleted_consistency CHECK (
        (is_deleted = FALSE AND deleted_at IS NULL) OR
        (is_deleted = TRUE AND deleted_at IS NOT NULL)
    )
);

-- User statistics - Aggregated usage analytics per technique
CREATE TABLE user_stats (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    technique divination_technique NOT NULL,
    total_sessions INTEGER NOT NULL DEFAULT 0,
    sessions_this_week INTEGER NOT NULL DEFAULT 0,
    sessions_this_month INTEGER NOT NULL DEFAULT 0,
    last_session_at TIMESTAMPTZ,
    favorite_spread TEXT,
    average_rating DECIMAL(3,2),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Primary key on user + technique combination
    PRIMARY KEY (user_id, technique),
    
    -- Constraints
    CONSTRAINT valid_session_counts CHECK (
        total_sessions >= 0 AND 
        sessions_this_week >= 0 AND 
        sessions_this_month >= 0 AND
        sessions_this_week <= total_sessions AND
        sessions_this_month <= total_sessions
    ),
    CONSTRAINT valid_rating CHECK (average_rating IS NULL OR (average_rating >= 1.0 AND average_rating <= 5.0))
);

-- API usage tracking - Monitor endpoint usage and performance
CREATE TABLE api_usage (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    endpoint TEXT NOT NULL,
    method TEXT NOT NULL,
    status_code INTEGER NOT NULL,
    processing_time_ms INTEGER NOT NULL,
    technique divination_technique,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    metadata JSONB DEFAULT '{}'::jsonb,
    
    -- Constraints
    CONSTRAINT valid_http_method CHECK (method IN ('GET', 'POST', 'PUT', 'DELETE', 'OPTIONS')),
    CONSTRAINT valid_status_code CHECK (status_code >= 100 AND status_code < 600),
    CONSTRAINT valid_processing_time CHECK (processing_time_ms >= 0)
);

-- User sessions for authentication (Supabase Auth integration)
-- This table is managed by Supabase Auth, we just add our custom columns
ALTER TABLE auth.users ADD COLUMN IF NOT EXISTS user_tier user_tier DEFAULT 'free';
ALTER TABLE auth.users ADD COLUMN IF NOT EXISTS preferences JSONB DEFAULT '{
    "locale": "en",
    "theme": "auto",
    "defaultTechnique": null,
    "notifications": {
        "email": true,
        "push": true,
        "marketing": false
    }
}'::jsonb;

-- =====================================================================
-- INDEXES
-- =====================================================================

-- Users table indexes
CREATE INDEX idx_users_email ON users(email) WHERE email IS NOT NULL;
CREATE INDEX idx_users_tier ON users(tier);
CREATE INDEX idx_users_last_activity ON users(last_activity);
CREATE INDEX idx_users_preferences_locale ON users USING GIN ((preferences->'locale'));

-- Sessions table indexes
CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_technique ON sessions(technique);
CREATE INDEX idx_sessions_created_at ON sessions(created_at);
CREATE INDEX idx_sessions_last_activity ON sessions(last_activity);
CREATE INDEX idx_sessions_user_technique ON sessions(user_id, technique);
CREATE INDEX idx_sessions_active ON sessions(user_id, is_deleted) WHERE is_deleted = false;
CREATE INDEX idx_sessions_results ON sessions USING GIN (results) WHERE results IS NOT NULL;

-- User stats indexes
CREATE INDEX idx_user_stats_technique ON user_stats(technique);
CREATE INDEX idx_user_stats_last_session ON user_stats(last_session_at);
CREATE INDEX idx_user_stats_updated_at ON user_stats(updated_at);

-- API usage indexes
CREATE INDEX idx_api_usage_user_id ON api_usage(user_id);
CREATE INDEX idx_api_usage_endpoint ON api_usage(endpoint);
CREATE INDEX idx_api_usage_created_at ON api_usage(created_at);
CREATE INDEX idx_api_usage_technique ON api_usage(technique) WHERE technique IS NOT NULL;
CREATE INDEX idx_api_usage_status_code ON api_usage(status_code);

-- =====================================================================
-- ROW LEVEL SECURITY (RLS)
-- =====================================================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_usage ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view own profile" ON users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Service role can manage all users" ON users
    FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

-- Sessions policies
CREATE POLICY "Users can view own sessions" ON sessions
    FOR SELECT USING (auth.uid() = user_id AND is_deleted = false);

CREATE POLICY "Users can insert own sessions" ON sessions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own sessions" ON sessions
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can soft delete own sessions" ON sessions
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Service role can manage all sessions" ON sessions
    FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

-- User stats policies
CREATE POLICY "Users can view own stats" ON user_stats
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Service role can manage all stats" ON user_stats
    FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

-- API usage policies (admin only)
CREATE POLICY "Service role can manage API usage" ON api_usage
    FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Function to update user last activity
CREATE OR REPLACE FUNCTION update_user_last_activity()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE users SET last_activity = NOW() WHERE id = NEW.user_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to update user activity on session creation/update
CREATE TRIGGER trigger_update_user_activity_on_session
    AFTER INSERT OR UPDATE ON sessions
    FOR EACH ROW
    EXECUTE FUNCTION update_user_last_activity();

-- Function to automatically update session last_activity
CREATE OR REPLACE FUNCTION update_session_last_activity()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_activity = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for session last_activity
CREATE TRIGGER trigger_update_session_activity
    BEFORE UPDATE ON sessions
    FOR EACH ROW
    EXECUTE FUNCTION update_session_last_activity();

-- Function to clean up old deleted sessions (run via cron)
CREATE OR REPLACE FUNCTION cleanup_old_deleted_sessions()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    -- Delete sessions that have been soft-deleted for more than 30 days
    DELETE FROM sessions 
    WHERE is_deleted = true 
    AND deleted_at < NOW() - INTERVAL '30 days';
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to refresh user statistics
CREATE OR REPLACE FUNCTION refresh_user_stats(user_uuid UUID)
RETURNS VOID AS $$
DECLARE
    technique_name divination_technique;
BEGIN
    -- Loop through all techniques for the user
    FOR technique_name IN SELECT DISTINCT technique FROM sessions WHERE user_id = user_uuid LOOP
        INSERT INTO user_stats (user_id, technique, total_sessions, sessions_this_week, sessions_this_month, last_session_at, updated_at)
        SELECT 
            user_uuid,
            technique_name,
            COUNT(*) as total_sessions,
            COUNT(*) FILTER (WHERE created_at >= DATE_TRUNC('week', NOW())) as sessions_this_week,
            COUNT(*) FILTER (WHERE created_at >= DATE_TRUNC('month', NOW())) as sessions_this_month,
            MAX(created_at) as last_session_at,
            NOW() as updated_at
        FROM sessions 
        WHERE user_id = user_uuid 
        AND technique = technique_name 
        AND is_deleted = false
        ON CONFLICT (user_id, technique) 
        DO UPDATE SET
            total_sessions = EXCLUDED.total_sessions,
            sessions_this_week = EXCLUDED.sessions_this_week,
            sessions_this_month = EXCLUDED.sessions_this_month,
            last_session_at = EXCLUDED.last_session_at,
            updated_at = EXCLUDED.updated_at;
    END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================================
-- INITIAL DATA
-- =====================================================================

-- Create anonymous user for guest sessions
INSERT INTO users (id, email, name, tier, preferences) VALUES (
    '00000000-0000-0000-0000-000000000000',
    null,
    'Anonymous',
    'free',
    '{
        "locale": "en",
        "theme": "auto",
        "defaultTechnique": null,
        "notifications": {
            "email": false,
            "push": false,
            "marketing": false
        }
    }'::jsonb
) ON CONFLICT (id) DO NOTHING;

-- =====================================================================
-- VIEWS (for analytics and reporting)
-- =====================================================================

-- Daily usage statistics view
CREATE VIEW daily_usage_stats AS
SELECT 
    DATE(created_at) as date,
    technique,
    COUNT(*) as session_count,
    COUNT(DISTINCT user_id) as unique_users,
    AVG(CASE WHEN metadata->>'processingTimeMs' IS NOT NULL 
        THEN (metadata->>'processingTimeMs')::integer 
        ELSE NULL END) as avg_processing_time_ms
FROM sessions
WHERE is_deleted = false
GROUP BY DATE(created_at), technique
ORDER BY date DESC, technique;

-- User engagement view
CREATE VIEW user_engagement AS
SELECT 
    u.id,
    u.tier,
    u.created_at as user_created_at,
    u.last_activity,
    COUNT(s.id) as total_sessions,
    COUNT(DISTINCT s.technique) as techniques_used,
    MIN(s.created_at) as first_session,
    MAX(s.created_at) as last_session
FROM users u
LEFT JOIN sessions s ON u.id = s.user_id AND s.is_deleted = false
GROUP BY u.id, u.tier, u.created_at, u.last_activity
ORDER BY u.last_activity DESC;

-- =====================================================================
-- GRANTS (Security)
-- =====================================================================

-- Grant necessary permissions to authenticated users
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT, INSERT, UPDATE ON users TO authenticated;
GRANT SELECT, INSERT, UPDATE ON sessions TO authenticated;
GRANT SELECT ON user_stats TO authenticated;

-- Grant service role full access
GRANT ALL ON ALL TABLES IN SCHEMA public TO service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO service_role;

-- Anonymous users can only create sessions for the anonymous user
GRANT SELECT ON users TO anon;
GRANT INSERT ON sessions TO anon;
GRANT SELECT ON sessions TO anon;

COMMENT ON TABLE users IS 'Core user profiles with preferences and subscription tiers';
COMMENT ON TABLE sessions IS 'Divination sessions with complete results and interpretations';
COMMENT ON TABLE user_stats IS 'Aggregated usage statistics per user per technique';
COMMENT ON TABLE api_usage IS 'API endpoint usage tracking for monitoring and analytics';

COMMENT ON COLUMN users.preferences IS 'User preferences stored as JSONB with locale, theme, and notification settings';
COMMENT ON COLUMN sessions.metadata IS 'Session metadata including seed, method, signature, and processing information';
COMMENT ON COLUMN sessions.results IS 'Raw divination results (cards, hexagrams, runes) stored as JSONB';

-- =====================================================================
-- COMPLETION
-- =====================================================================

-- This completes the initial database schema for the Smart Divination platform
-- Next steps:
-- 1. Set up Supabase project and run this migration
-- 2. Configure authentication providers (email, Google, Apple)
-- 3. Set up environment variables in Vercel
-- 4. Test all API endpoints with database integration