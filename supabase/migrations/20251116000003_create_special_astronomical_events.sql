-- =====================================================
-- SPECIAL ASTRONOMICAL EVENTS TABLE
-- =====================================================
-- Purpose: Store special astronomical events (eclipses, retrogrades, supermoons, etc.)
-- Structure: Variable rows (populated with events from 2025-2030+)
-- Foundation: Based on astronomical events research (docs/astronomical_events.md)

CREATE TYPE astronomical_event_type AS ENUM (
  -- Eclipses
  'solar_eclipse_total',
  'solar_eclipse_partial',
  'solar_eclipse_annular',
  'lunar_eclipse_total',
  'lunar_eclipse_partial',
  'lunar_eclipse_penumbral',

  -- Lunar phenomena
  'supermoon',
  'blue_moon',

  -- Planetary retrogrades
  'mercury_retrograde',
  'venus_retrograde',
  'mars_retrograde',
  'jupiter_retrograde',
  'saturn_retrograde'
);

CREATE TABLE special_astronomical_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Event type
  event_type astronomical_event_type NOT NULL,

  -- Date range (start and end)
  -- For eclipses: start_date = date of eclipse, end_date = null or same
  -- For retrogrades: start_date = retrograde begins, end_date = retrograde ends
  -- For supermoon/blue moon: start_date = date of full moon, end_date = null
  start_date DATE NOT NULL,
  end_date DATE,

  -- Event name (multilingual)
  event_name JSONB NOT NULL DEFAULT '{"en": "", "es": "", "ca": ""}',

  -- Traditional meaning (multilingual)
  traditional_meaning JSONB NOT NULL DEFAULT '{"en": "", "es": "", "ca": ""}',

  -- Guidance for this event (multilingual)
  guidance JSONB NOT NULL DEFAULT '{"en": "", "es": "", "ca": ""}',

  -- Recommended actions during this event (multilingual)
  recommended_actions JSONB NOT NULL DEFAULT '{"en": [], "es": [], "ca": []}',

  -- Things to avoid during this event (multilingual)
  avoid_actions JSONB NOT NULL DEFAULT '{"en": [], "es": [], "ca": []}',

  -- Intensity/importance (1-10)
  -- Eclipses: 8-10, Retrogrades: 6-8, Supermoon/Blue Moon: 4-6
  intensity INTEGER NOT NULL DEFAULT 5 CHECK (intensity >= 1 AND intensity <= 10),

  -- Visibility/applicability
  -- For eclipses: geographic regions where visible
  -- For retrogrades: 'global'
  visibility TEXT,

  -- Zodiac sign where event occurs (if applicable)
  -- For eclipses: zodiac sign of luminaries
  -- For retrogrades: zodiac sign where retrograde occurs
  zodiac_sign zodiac_sign_type,

  -- Additional metadata (JSONB for flexibility)
  -- Can store: exact time (UTC), eclipse path, retrograde shadow period, etc.
  metadata JSONB DEFAULT '{}',

  -- Metadata
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  active BOOLEAN NOT NULL DEFAULT true
);

-- Indexes for performance
CREATE INDEX idx_special_events_type ON special_astronomical_events(event_type);
CREATE INDEX idx_special_events_start_date ON special_astronomical_events(start_date);
CREATE INDEX idx_special_events_end_date ON special_astronomical_events(end_date);
CREATE INDEX idx_special_events_active ON special_astronomical_events(active);

-- Index for date range queries (find events active on a given date)
CREATE INDEX idx_special_events_date_range ON special_astronomical_events(start_date, end_date)
  WHERE active = true;

-- Enable Row Level Security
ALTER TABLE special_astronomical_events ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Public read access
CREATE POLICY "Special events are viewable by everyone"
  ON special_astronomical_events FOR SELECT
  USING (active = true);

-- RLS Policy: Only service role can insert/update
CREATE POLICY "Special events are insertable by service role"
  ON special_astronomical_events FOR INSERT
  WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "Special events are updatable by service role"
  ON special_astronomical_events FOR UPDATE
  USING (auth.role() = 'service_role');

-- Trigger to update updated_at
CREATE TRIGGER update_special_events_updated_at
  BEFORE UPDATE ON special_astronomical_events
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Helper function to find active events on a given date
CREATE OR REPLACE FUNCTION get_active_events_for_date(check_date DATE)
RETURNS SETOF special_astronomical_events
LANGUAGE sql
STABLE
AS $$
  SELECT *
  FROM special_astronomical_events
  WHERE active = true
    AND start_date <= check_date
    AND (end_date IS NULL OR end_date >= check_date)
  ORDER BY intensity DESC, start_date ASC;
$$;

-- Comments
COMMENT ON TABLE special_astronomical_events IS 'Special astronomical events (eclipses, retrogrades, rare lunar phenomena)';
COMMENT ON COLUMN special_astronomical_events.event_type IS 'Type of astronomical event';
COMMENT ON COLUMN special_astronomical_events.start_date IS 'Start date of event';
COMMENT ON COLUMN special_astronomical_events.end_date IS 'End date of event (null for single-day events like eclipses)';
COMMENT ON COLUMN special_astronomical_events.traditional_meaning IS 'Traditional astrological meaning (multilingual)';
COMMENT ON COLUMN special_astronomical_events.guidance IS 'Specific guidance for this event (multilingual)';
COMMENT ON COLUMN special_astronomical_events.intensity IS 'Importance/intensity of event (1-10)';
COMMENT ON COLUMN special_astronomical_events.visibility IS 'Geographic visibility or applicability';
COMMENT ON COLUMN special_astronomical_events.zodiac_sign IS 'Zodiac sign where event occurs (if applicable)';

COMMENT ON FUNCTION get_active_events_for_date IS 'Returns all active events occurring on a given date, ordered by intensity';
