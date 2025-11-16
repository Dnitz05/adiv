-- =====================================================
-- WEEKDAY ENERGIES TABLE
-- =====================================================
-- Purpose: Store planetary energies for each day of the week
-- Structure: 7 fixed rows (Sunday-Saturday)
-- Foundation: Based on Chaldean Order research (docs/planetary_weekday_correspondences.md)

CREATE TYPE weekday_type AS ENUM (
  'sunday',    -- Sun
  'monday',    -- Moon
  'tuesday',   -- Mars
  'wednesday', -- Mercury
  'thursday',  -- Jupiter
  'friday',    -- Venus
  'saturday'   -- Saturn
);

CREATE TYPE planet_type AS ENUM (
  'sun',
  'moon',
  'mercury',
  'venus',
  'mars',
  'jupiter',
  'saturn'
);

CREATE TYPE element_type AS ENUM (
  'fire',
  'earth',
  'air',
  'water'
);

CREATE TABLE weekday_energies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Weekday (unique, only 7 rows)
  weekday weekday_type NOT NULL UNIQUE,

  -- Ruling planet (from Chaldean Order)
  planet planet_type NOT NULL,

  -- Element of the ruling planet
  element element_type NOT NULL,

  -- Traditional qualities
  qualities JSONB NOT NULL DEFAULT '{}',
  -- Example: {"polarity": "yang", "temperature": "hot", "moisture": "dry"}

  -- Weekday energy description (multilingual)
  description JSONB NOT NULL DEFAULT '{"en": "", "es": "", "ca": ""}',

  -- Traditional meaning (multilingual)
  traditional_meaning JSONB NOT NULL DEFAULT '{"en": "", "es": "", "ca": ""}',

  -- Areas of influence (multilingual)
  areas_of_influence JSONB NOT NULL DEFAULT '{"en": [], "es": [], "ca": []}',

  -- Favorable activities (multilingual)
  favorable_activities JSONB NOT NULL DEFAULT '{"en": [], "es": [], "ca": []}',

  -- Traditional correspondences
  color TEXT,
  metal TEXT,
  stones JSONB DEFAULT '[]', -- Array of stones
  herbs JSONB DEFAULT '[]',  -- Array of herbs

  -- Emoji/symbol for display
  planet_emoji TEXT,
  element_emoji TEXT,

  -- Metadata
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  active BOOLEAN NOT NULL DEFAULT true
);

-- Index for lookups
CREATE INDEX idx_weekday_energies_weekday ON weekday_energies(weekday);
CREATE INDEX idx_weekday_energies_planet ON weekday_energies(planet);
CREATE INDEX idx_weekday_energies_active ON weekday_energies(active);

-- Enable Row Level Security
ALTER TABLE weekday_energies ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Public read access
CREATE POLICY "Weekday energies are viewable by everyone"
  ON weekday_energies FOR SELECT
  USING (active = true);

-- RLS Policy: Only service role can insert/update
CREATE POLICY "Weekday energies are insertable by service role"
  ON weekday_energies FOR INSERT
  WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "Weekday energies are updatable by service role"
  ON weekday_energies FOR UPDATE
  USING (auth.role() = 'service_role');

-- Trigger to update updated_at
CREATE TRIGGER update_weekday_energies_updated_at
  BEFORE UPDATE ON weekday_energies
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Comments
COMMENT ON TABLE weekday_energies IS 'Planetary energies for each day of the week based on Chaldean Order';
COMMENT ON COLUMN weekday_energies.weekday IS 'Day of the week (sunday-saturday)';
COMMENT ON COLUMN weekday_energies.planet IS 'Ruling planet from Chaldean Order';
COMMENT ON COLUMN weekday_energies.qualities IS 'Traditional qualities: polarity (yang/yin), temperature, moisture';
COMMENT ON COLUMN weekday_energies.description IS 'Description of weekday energy (multilingual)';
COMMENT ON COLUMN weekday_energies.traditional_meaning IS 'Traditional astrological meaning (multilingual)';
COMMENT ON COLUMN weekday_energies.areas_of_influence IS 'Life areas influenced by this planet (multilingual arrays)';
COMMENT ON COLUMN weekday_energies.favorable_activities IS 'Activities favored on this day (multilingual arrays)';
