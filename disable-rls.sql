-- Disable RLS completely for lunar_guide_templates
ALTER TABLE lunar_guide_templates DISABLE ROW LEVEL SECURITY;

-- Disable RLS for daily_lunar_insights
ALTER TABLE daily_lunar_insights DISABLE ROW LEVEL SECURITY;

-- Verify
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
AND tablename IN ('lunar_guide_templates', 'daily_lunar_insights');
