-- Migration: Lunar Guide Templates
-- Created: 2025-11-15
-- Description: Base templates for lunar phase guidance (32 phase+element combinations)

CREATE TABLE IF NOT EXISTS lunar_guide_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Identificadors
  phase_id text NOT NULL,
  element text,
  zodiac_sign text,

  -- Contingut base (multiidioma)
  headline jsonb NOT NULL,
  tagline jsonb,

  -- Focus i energia
  focus_areas jsonb NOT NULL,
  energy_description jsonb NOT NULL,
  polarity_note jsonb,

  -- Accions recomanades
  recommended_actions jsonb NOT NULL,
  journal_prompts jsonb,

  -- Metadata
  priority integer DEFAULT 0,
  active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),

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
    element IS NULL OR element IN ('fire', 'earth', 'air', 'water')
  ),
  CONSTRAINT valid_zodiac CHECK (
    zodiac_sign IS NULL OR zodiac_sign IN (
      'aries', 'taurus', 'gemini', 'cancer',
      'leo', 'virgo', 'libra', 'scorpio',
      'sagittarius', 'capricorn', 'aquarius', 'pisces'
    )
  )
);

-- Índexs per queries ràpides
CREATE INDEX idx_lunar_guide_phase_element ON lunar_guide_templates(phase_id, element);
CREATE INDEX idx_lunar_guide_active ON lunar_guide_templates(active) WHERE active = true;
CREATE INDEX idx_lunar_guide_priority ON lunar_guide_templates(priority DESC);

-- Trigger per updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_lunar_guide_templates_updated_at
    BEFORE UPDATE ON lunar_guide_templates
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- RLS (Row Level Security)
ALTER TABLE lunar_guide_templates ENABLE ROW LEVEL SECURITY;

-- Política: Tots poden llegir templates actius
CREATE POLICY "Anyone can read active templates"
  ON lunar_guide_templates
  FOR SELECT
  USING (active = true);

-- Política: Només service_role pot modificar
CREATE POLICY "Only service role can modify templates"
  ON lunar_guide_templates
  FOR ALL
  USING (auth.role() = 'service_role');

-- Comentaris
COMMENT ON TABLE lunar_guide_templates IS 'Base templates for lunar phase guidance organized by phase and element';
COMMENT ON COLUMN lunar_guide_templates.phase_id IS 'Lunar phase identifier (new_moon, waxing_crescent, etc.)';
COMMENT ON COLUMN lunar_guide_templates.element IS 'Zodiac element (fire, earth, air, water). NULL = applies to all';
COMMENT ON COLUMN lunar_guide_templates.zodiac_sign IS 'Specific zodiac sign. NULL = applies to all signs of element';
COMMENT ON COLUMN lunar_guide_templates.headline IS 'Main title in multiple languages: {en, es, ca}';
COMMENT ON COLUMN lunar_guide_templates.focus_areas IS 'Focus keywords by language: {en: [...], es: [...], ca: [...]}';
COMMENT ON COLUMN lunar_guide_templates.priority IS '0=generic, 1=element-specific, 2=zodiac-specific (higher = more specific)';
