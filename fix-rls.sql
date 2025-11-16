-- Fix RLS policies for lunar_guide_templates
DROP POLICY IF EXISTS "Lunar guide templates are viewable by everyone" ON lunar_guide_templates;

CREATE POLICY "Lunar guide templates are viewable by everyone"
  ON lunar_guide_templates FOR SELECT
  TO public
  USING (true);

-- Verify we have data
SELECT COUNT(*) as total_templates FROM lunar_guide_templates;

-- Show all templates
SELECT id, phase_id, element, zodiac_sign, active FROM lunar_guide_templates ORDER BY phase_id;
