-- =====================================================================
-- Smart Divination Platform - Lunar Cache Schema Migration
-- Adds persistent cache for lunar metadata to support home panel.
-- =====================================================================

BEGIN;

-- ---------------------------------------------------------------------
-- Enumerated lunar phases for consistent taxonomy
-- ---------------------------------------------------------------------
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
-- Cache table storing daily lunar details and generated guidance
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS lunar_daily_cache (
    date DATE PRIMARY KEY,
    phase lunar_phase NOT NULL,
    illumination NUMERIC(5,2) NOT NULL CHECK (illumination >= 0 AND illumination <= 100),
    age NUMERIC(5,2) NOT NULL CHECK (age >= 0),
    zodiac_sign TEXT NOT NULL CHECK (zodiac_sign IN (
        'aries','taurus','gemini','cancer','leo','virgo',
        'libra','scorpio','sagittarius','capricorn','aquarius','pisces'
    )),
    guidance TEXT,
    data JSONB NOT NULL DEFAULT '{}'::jsonb,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE lunar_daily_cache IS 'Daily lunar metadata cache used by the home experience (phase, illumination, zodiac, AI guidance).';

-- ---------------------------------------------------------------------
-- Row level security policies: only service role may mutate, public read
-- ---------------------------------------------------------------------
ALTER TABLE lunar_daily_cache ENABLE ROW LEVEL SECURITY;

CREATE POLICY IF NOT EXISTS lunar_daily_cache_service_all ON lunar_daily_cache
    FOR ALL TO service_role
    USING (true)
    WITH CHECK (true);

CREATE POLICY IF NOT EXISTS lunar_daily_cache_read ON lunar_daily_cache
    FOR SELECT TO authenticated, anon
    USING (true);

COMMIT;
