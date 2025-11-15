-- Migration: Daily Lunar Insights
-- Created: 2025-11-15
-- Description: AI-generated daily insights for each lunar day

CREATE TABLE IF NOT EXISTS daily_lunar_insights (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Identificació
  date date NOT NULL UNIQUE,
  phase_id text NOT NULL,
  zodiac_sign text NOT NULL,
  element text NOT NULL,
  lunar_age numeric(5,2) NOT NULL,
  illumination numeric(5,2) NOT NULL,

  -- Insights generats per IA (multiidioma)
  universal_insight jsonb NOT NULL,
  specific_insight jsonb NOT NULL,

  -- Context de generació
  generation_prompt text,
  generation_model text DEFAULT 'gpt-4o-mini',
  generation_cost numeric(10,6),

  -- Metadata
  generated_at timestamptz DEFAULT now(),
  reviewed boolean DEFAULT false,
  quality_score integer,

  -- Special events
  is_special_event boolean DEFAULT false,
  special_event_type text,

  -- Constraints
  CONSTRAINT valid_phase CHECK (phase_id IN (
    'new_moon',
    'waxing_crescent',
    'first_quarter',
    'waxing_gibbous',
    'full_moon',
    'waning_gibbous',
    'last_quarter',
    'waning_crescent'
  )),
  CONSTRAINT valid_element CHECK (
    element IN ('fire', 'earth', 'air', 'water')
  ),
  CONSTRAINT valid_zodiac CHECK (
    zodiac_sign IN (
      'aries', 'taurus', 'gemini', 'cancer',
      'leo', 'virgo', 'libra', 'scorpio',
      'sagittarius', 'capricorn', 'aquarius', 'pisces'
    )
  ),
  CONSTRAINT valid_illumination CHECK (
    illumination >= 0 AND illumination <= 100
  ),
  CONSTRAINT valid_quality_score CHECK (
    quality_score IS NULL OR (quality_score >= 1 AND quality_score <= 5)
  )
);

-- Índexs per queries ràpides
CREATE INDEX idx_daily_insights_date ON daily_lunar_insights(date DESC);
CREATE INDEX idx_daily_insights_phase ON daily_lunar_insights(phase_id);
CREATE INDEX idx_daily_insights_special ON daily_lunar_insights(is_special_event)
  WHERE is_special_event = true;
CREATE INDEX idx_daily_insights_reviewed ON daily_lunar_insights(reviewed)
  WHERE reviewed = false;

-- RLS (Row Level Security)
ALTER TABLE daily_lunar_insights ENABLE ROW LEVEL SECURITY;

-- Política: Tots poden llegir insights
CREATE POLICY "Anyone can read insights"
  ON daily_lunar_insights
  FOR SELECT
  USING (true);

-- Política: Només service_role pot inserir/modificar
CREATE POLICY "Only service role can modify insights"
  ON daily_lunar_insights
  FOR ALL
  USING (auth.role() = 'service_role');

-- Comentaris
COMMENT ON TABLE daily_lunar_insights IS 'AI-generated daily lunar insights';
COMMENT ON COLUMN daily_lunar_insights.date IS 'Date for this insight (unique)';
COMMENT ON COLUMN daily_lunar_insights.universal_insight IS 'Universal daily insight in multiple languages: {en, es, ca}';
COMMENT ON COLUMN daily_lunar_insights.specific_insight IS 'Phase+element specific insight: {en, es, ca}';
COMMENT ON COLUMN daily_lunar_insights.generation_cost IS 'Cost in USD for generating this insight';
COMMENT ON COLUMN daily_lunar_insights.quality_score IS 'Manual quality rating 1-5 (optional)';
COMMENT ON COLUMN daily_lunar_insights.is_special_event IS 'True if this day has a special astronomical event';
