-- Comprehensive diagnostics for lunar_guide_templates and daily_lunar_insights

-- 1. Check table ownership and schema
SELECT
    schemaname,
    tablename,
    tableowner
FROM pg_tables
WHERE tablename IN ('lunar_guide_templates', 'daily_lunar_insights')
ORDER BY tablename;

-- 2. Check all grants for these tables
SELECT
    grantee,
    table_schema,
    table_name,
    privilege_type,
    is_grantable
FROM information_schema.table_privileges
WHERE table_name IN ('lunar_guide_templates', 'daily_lunar_insights')
ORDER BY table_name, grantee, privilege_type;

-- 3. Check RLS status
SELECT
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables
WHERE tablename IN ('lunar_guide_templates', 'daily_lunar_insights')
ORDER BY tablename;

-- 4. Check if there are any RLS policies (even if disabled)
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE tablename IN ('lunar_guide_templates', 'daily_lunar_insights')
ORDER BY tablename;

-- 5. Check schema permissions
SELECT
    nspname as schema_name,
    r.rolname as grantee,
    pg_catalog.has_schema_privilege(r.oid, n.oid, 'USAGE') as has_usage,
    pg_catalog.has_schema_privilege(r.oid, n.oid, 'CREATE') as has_create
FROM pg_namespace n
CROSS JOIN pg_roles r
WHERE nspname = 'public'
AND r.rolname IN ('anon', 'authenticated', 'postgres', 'authenticator')
ORDER BY grantee;

-- 6. Test actual SELECT as different roles
SET ROLE anon;
SELECT COUNT(*) as anon_can_count FROM lunar_guide_templates;
SELECT COUNT(*) as anon_can_count FROM daily_lunar_insights;
RESET ROLE;

-- 7. Check table columns and types
SELECT
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name IN ('lunar_guide_templates', 'daily_lunar_insights')
ORDER BY table_name, ordinal_position;

-- 8. Verify data exists
SELECT 'lunar_guide_templates' as table_name, COUNT(*) as row_count FROM lunar_guide_templates
UNION ALL
SELECT 'daily_lunar_insights', COUNT(*) FROM daily_lunar_insights;

-- 9. Check for any triggers or constraints that might interfere
SELECT
    trigger_name,
    event_object_table,
    action_statement,
    action_timing,
    event_manipulation
FROM information_schema.triggers
WHERE event_object_table IN ('lunar_guide_templates', 'daily_lunar_insights')
ORDER BY event_object_table;
