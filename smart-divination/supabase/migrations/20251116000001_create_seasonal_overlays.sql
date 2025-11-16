-- =====================================================
-- SEASONAL OVERLAYS TABLE
-- =====================================================
-- Purpose: Store seasonal variations for each lunar guide template
-- Structure: 128 rows (32 templates × 4 seasons)
-- Foundation: Based on Wheel of the Year research (docs/wheel_of_the_year.md)

CREATE TYPE season_type AS ENUM ('spring', 'summer', 'autumn', 'winter');

CREATE TABLE seasonal_overlays (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Reference to base template
  template_id UUID NOT NULL REFERENCES lunar_guide_templates(id) ON DELETE CASCADE,

  -- Season (spring, summer, autumn, winter)
  season season_type NOT NULL,

  -- Seasonal overlay content (multilingual)
  -- Modifies the base template with seasonal themes
  overlay_headline JSONB NOT NULL DEFAULT '{"en": "", "es": "", "ca": ""}',
  overlay_description JSONB NOT NULL DEFAULT '{"en": "", "es": "", "ca": ""}',

  -- Seasonal energy shift
  -- How this season modifies the base phase energy
  energy_shift JSONB NOT NULL DEFAULT '{"en": "", "es": "", "ca": ""}',

  -- Seasonal themes (keywords)
  themes JSONB NOT NULL DEFAULT '{"en": [], "es": [], "ca": []}',

  -- Seasonal recommended actions (different from base template)
  seasonal_actions JSONB NOT NULL DEFAULT '{"en": [], "es": [], "ca": []}',

  -- Metadata
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  active BOOLEAN NOT NULL DEFAULT true,

  -- Ensure unique combination of template + season
  CONSTRAINT unique_template_season UNIQUE (template_id, season)
);

-- Indexes for performance
CREATE INDEX idx_seasonal_overlays_template ON seasonal_overlays(template_id);
CREATE INDEX idx_seasonal_overlays_season ON seasonal_overlays(season);
CREATE INDEX idx_seasonal_overlays_active ON seasonal_overlays(active);

-- Enable Row Level Security
ALTER TABLE seasonal_overlays ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Public read access
CREATE POLICY "Seasonal overlays are viewable by everyone"
  ON seasonal_overlays FOR SELECT
  USING (active = true);

-- RLS Policy: Only service role can insert/update
CREATE POLICY "Seasonal overlays are insertable by service role"
  ON seasonal_overlays FOR INSERT
  WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "Seasonal overlays are updatable by service role"
  ON seasonal_overlays FOR UPDATE
  USING (auth.role() = 'service_role');

-- Trigger to update updated_at
CREATE TRIGGER update_seasonal_overlays_updated_at
  BEFORE UPDATE ON seasonal_overlays
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Comments
COMMENT ON TABLE seasonal_overlays IS 'Seasonal variations for lunar guide templates based on Wheel of the Year';
COMMENT ON COLUMN seasonal_overlays.overlay_headline IS 'Seasonal modification to template headline (multilingual)';
COMMENT ON COLUMN seasonal_overlays.energy_shift IS 'How this season shifts the base phase energy (multilingual)';
COMMENT ON COLUMN seasonal_overlays.themes IS 'Seasonal themes as keywords (multilingual arrays)';
COMMENT ON COLUMN seasonal_overlays.seasonal_actions IS 'Season-specific recommended actions (multilingual arrays)';
