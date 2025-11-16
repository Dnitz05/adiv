-- Grant all necessary permissions for lunar tables

-- Grant usage on schema
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;

-- Grant SELECT on tables to anon and authenticated
GRANT SELECT ON public.lunar_guide_templates TO anon, authenticated;
GRANT SELECT ON public.daily_lunar_insights TO anon, authenticated;

-- Make sure RLS is disabled
ALTER TABLE public.lunar_guide_templates DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_lunar_insights DISABLE ROW LEVEL SECURITY;

-- Verify permissions
SELECT
    grantee,
    table_schema,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE table_name IN ('lunar_guide_templates', 'daily_lunar_insights')
AND grantee IN ('anon', 'authenticated')
ORDER BY table_name, grantee;
