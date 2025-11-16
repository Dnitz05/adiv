-- =====================================================
-- ADD COMPOSED CONTENT COLUMNS TO DAILY LUNAR INSIGHTS
-- =====================================================
-- Purpose: Add missing JSONB columns for composed content
-- These columns store the final composed content from:
-- Base Template + Seasonal Overlay + Weekday Energy + Special Events

-- Add composed content columns
ALTER TABLE daily_lunar_insights
  ADD COLUMN IF NOT EXISTS template_id UUID REFERENCES lunar_guide_templates(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS composed_headline JSONB NOT NULL DEFAULT '{"en": "", "es": "", "ca": ""}',
  ADD COLUMN IF NOT EXISTS composed_description JSONB NOT NULL DEFAULT '{"en": "", "es": "", "ca": ""}',
  ADD COLUMN IF NOT EXISTS composed_guidance JSONB NOT NULL DEFAULT '{"en": "", "es": "", "ca": ""}',
  ADD COLUMN IF NOT EXISTS focus_areas JSONB NOT NULL DEFAULT '{"en": [], "es": [], "ca": []}',
  ADD COLUMN IF NOT EXISTS recommended_actions JSONB NOT NULL DEFAULT '{"en": [], "es": [], "ca": []}';

-- Add index for template_id
CREATE INDEX IF NOT EXISTS idx_daily_insights_template ON daily_lunar_insights(template_id);

-- Add comments for new columns
COMMENT ON COLUMN daily_lunar_insights.template_id IS 'Reference to base lunar guide template used';
COMMENT ON COLUMN daily_lunar_insights.composed_headline IS 'Composed headline (base template + seasonal overlay, multilingual)';
COMMENT ON COLUMN daily_lunar_insights.composed_description IS 'Composed description (base + seasonal + weekday, multilingual)';
COMMENT ON COLUMN daily_lunar_insights.composed_guidance IS 'Composed guidance (tagline + overlay + events, multilingual)';
COMMENT ON COLUMN daily_lunar_insights.focus_areas IS 'Composed focus areas (template + overlay + weekday, multilingual)';
COMMENT ON COLUMN daily_lunar_insights.recommended_actions IS 'Composed recommended actions (template + overlay + weekday + events, multilingual)';
