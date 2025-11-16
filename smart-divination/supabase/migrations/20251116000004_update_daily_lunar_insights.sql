-- =====================================================
-- UPDATE DAILY LUNAR INSIGHTS TABLE
-- =====================================================
-- Purpose: Remove OpenAI fields and add composition references
-- Changes:
--   - Remove: ai_universal_insight, ai_specific_insight, openai_model, tokens_used
--   - Add: seasonal_overlay_id, weekday, special_event_ids
--   - Add: composed_at (when the guide was composed)

-- First, create zodiac_sign_type if it doesn't exist
DO $$ BEGIN
  CREATE TYPE zodiac_sign_type AS ENUM (
    'aries', 'taurus', 'gemini', 'cancer',
    'leo', 'virgo', 'libra', 'scorpio',
    'sagittarius', 'capricorn', 'aquarius', 'pisces'
  );
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

-- Drop old OpenAI columns
ALTER TABLE daily_lunar_insights
  DROP COLUMN IF EXISTS ai_universal_insight,
  DROP COLUMN IF EXISTS ai_specific_insight,
  DROP COLUMN IF EXISTS openai_model,
  DROP COLUMN IF EXISTS tokens_used;

-- Add new composition reference columns
ALTER TABLE daily_lunar_insights
  ADD COLUMN IF NOT EXISTS template_id UUID REFERENCES lunar_guide_templates(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS composed_headline JSONB NOT NULL DEFAULT '{"en": "", "es": "", "ca": ""}',
  ADD COLUMN IF NOT EXISTS composed_description JSONB NOT NULL DEFAULT '{"en": "", "es": "", "ca": ""}',
  ADD COLUMN IF NOT EXISTS composed_guidance JSONB NOT NULL DEFAULT '{"en": "", "es": "", "ca": ""}',
  ADD COLUMN IF NOT EXISTS focus_areas JSONB NOT NULL DEFAULT '{"en": [], "es": [], "ca": []}',
  ADD COLUMN IF NOT EXISTS recommended_actions JSONB NOT NULL DEFAULT '{"en": [], "es": [], "ca": []}',
  ADD COLUMN IF NOT EXISTS seasonal_overlay_id UUID REFERENCES seasonal_overlays(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS weekday weekday_type NOT NULL DEFAULT 'sunday',
  ADD COLUMN IF NOT EXISTS zodiac_sign zodiac_sign_type,
  ADD COLUMN IF NOT EXISTS special_event_ids UUID[] DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS composed_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS composition_version TEXT DEFAULT 'v1.0';

-- Add indexes for new columns
CREATE INDEX IF NOT EXISTS idx_daily_insights_template ON daily_lunar_insights(template_id);
CREATE INDEX IF NOT EXISTS idx_daily_insights_seasonal_overlay ON daily_lunar_insights(seasonal_overlay_id);
CREATE INDEX IF NOT EXISTS idx_daily_insights_weekday ON daily_lunar_insights(weekday);
CREATE INDEX IF NOT EXISTS idx_daily_insights_zodiac ON daily_lunar_insights(zodiac_sign);

-- Add constraint to ensure date + template combo is still unique
-- (already exists from previous migration, but ensure it's there)
DO $$ BEGIN
  ALTER TABLE daily_lunar_insights
    ADD CONSTRAINT unique_date_insight UNIQUE (date);
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

-- Update comments
COMMENT ON COLUMN daily_lunar_insights.template_id IS 'Reference to base lunar guide template used';
COMMENT ON COLUMN daily_lunar_insights.composed_headline IS 'Composed headline (base template + seasonal overlay, multilingual)';
COMMENT ON COLUMN daily_lunar_insights.composed_description IS 'Composed description (base + seasonal + weekday, multilingual)';
COMMENT ON COLUMN daily_lunar_insights.composed_guidance IS 'Composed guidance (tagline + overlay + events, multilingual)';
COMMENT ON COLUMN daily_lunar_insights.focus_areas IS 'Composed focus areas (template + overlay + weekday, multilingual)';
COMMENT ON COLUMN daily_lunar_insights.recommended_actions IS 'Composed recommended actions (template + overlay + weekday + events, multilingual)';
COMMENT ON COLUMN daily_lunar_insights.seasonal_overlay_id IS 'Reference to seasonal overlay used in composition';
COMMENT ON COLUMN daily_lunar_insights.weekday IS 'Day of week for weekday energy overlay';
COMMENT ON COLUMN daily_lunar_insights.zodiac_sign IS 'Zodiac sign of the Sun on this date';
COMMENT ON COLUMN daily_lunar_insights.special_event_ids IS 'Array of special astronomical event IDs active on this date';
COMMENT ON COLUMN daily_lunar_insights.composed_at IS 'Timestamp when this guide was composed';
COMMENT ON COLUMN daily_lunar_insights.composition_version IS 'Version of composition algorithm used';

-- Update table comment
COMMENT ON TABLE daily_lunar_insights IS 'Daily lunar guides composed from templates + seasonal overlays + weekday energies + special events';
