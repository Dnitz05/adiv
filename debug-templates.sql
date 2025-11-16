-- Debug: Check what we have in the database
SELECT 'Total templates:' as info, COUNT(*)::text as value FROM lunar_guide_templates
UNION ALL
SELECT 'Active templates:', COUNT(*)::text FROM lunar_guide_templates WHERE active = true
UNION ALL
SELECT 'Phases in DB:', string_agg(DISTINCT phase_id, ', ') FROM lunar_guide_templates;

-- Show all templates
SELECT id, phase_id, element, zodiac_sign, active,
       headline->>'en' as headline_en,
       LENGTH(energy_description::text) as desc_length
FROM lunar_guide_templates
ORDER BY phase_id;

-- Test query exactly like the app does for waning_gibbous (today's phase)
SELECT id, phase_id, element, zodiac_sign, active
FROM lunar_guide_templates
WHERE phase_id = 'waning_gibbous'
  AND active = true
ORDER BY priority DESC
LIMIT 10;
