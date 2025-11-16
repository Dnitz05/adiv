-- =====================================================
-- DROP OLD AI INSIGHT COLUMNS
-- =====================================================
-- Purpose: Remove old AI-generated insight columns that may still exist
-- These columns are replaced by the new composed content columns

-- Drop old AI insight columns if they exist
ALTER TABLE daily_lunar_insights
  DROP COLUMN IF EXISTS universal_insight CASCADE,
  DROP COLUMN IF EXISTS specific_insight CASCADE,
  DROP COLUMN IF EXISTS generation_model CASCADE,
  DROP COLUMN IF EXISTS generation_cost CASCADE,
  DROP COLUMN IF EXISTS is_special_event CASCADE,
  DROP COLUMN IF EXISTS special_event_type CASCADE,
  DROP COLUMN IF EXISTS generated_at CASCADE;

COMMENT ON TABLE daily_lunar_insights IS 'Daily lunar guides composed from templates + seasonal overlays + weekday energies + special events (NO AI)';
