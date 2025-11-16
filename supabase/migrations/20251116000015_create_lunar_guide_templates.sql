-- =====================================================
-- LUNAR GUIDE TEMPLATES TABLE
-- =====================================================
-- Purpose: Store base astrological templates for each lunar phase
-- These templates are the foundation layer that gets composed with
-- seasonal overlays, weekday energies, and special events

CREATE TABLE IF NOT EXISTS public.lunar_guide_templates (
  id TEXT PRIMARY KEY,
  phase_id phase_type NOT NULL,
  element element_type NULL,  -- NULL for generic templates
  zodiac_sign zodiac_sign_type NULL,  -- NULL for generic/element-only templates

  -- Multilingual content (en/es/ca)
  headline JSONB NOT NULL,
  tagline JSONB NULL,
  focus_areas JSONB NOT NULL,
  energy_description JSONB NOT NULL,
  recommended_actions JSONB NOT NULL,
  journal_prompts JSONB NULL,

  -- Template metadata
  priority INTEGER NOT NULL DEFAULT 0,  -- 0=generic, 1=element, 2=zodiac
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Index for efficient template lookup
CREATE INDEX idx_lunar_guide_templates_phase ON lunar_guide_templates(phase_id, active);
CREATE INDEX idx_lunar_guide_templates_lookup ON lunar_guide_templates(phase_id, element, zodiac_sign, active);

-- RLS Policies (read-only for all users)
ALTER TABLE lunar_guide_templates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lunar guide templates are viewable by everyone"
  ON lunar_guide_templates FOR SELECT
  USING (active = true);

-- Trigger to update updated_at
CREATE TRIGGER update_lunar_guide_templates_updated_at
  BEFORE UPDATE ON lunar_guide_templates
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE lunar_guide_templates IS 'Base astrological templates for lunar phases - foundation layer for modular composition';
