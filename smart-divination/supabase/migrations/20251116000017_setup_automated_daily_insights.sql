-- =====================================================
-- AUTOMATED DAILY LUNAR INSIGHTS
-- =====================================================
-- Purpose: Configure automatic daily generation of lunar insights
-- Method: pg_cron + direct Edge Function invocation
-- Schedule: Every day at 00:05 UTC (5 minutes after midnight)

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Unschedule any existing job with this name
DO $$
BEGIN
  PERFORM cron.unschedule('generate-daily-lunar-insight');
EXCEPTION
  WHEN undefined_table THEN NULL;
  WHEN others THEN NULL;
END $$;

-- Schedule daily lunar insight generation
-- Runs at 00:05 UTC (after midnight to ensure correct date)
SELECT cron.schedule(
  'generate-daily-lunar-insight',
  '5 0 * * *', -- Every day at 00:05 UTC
  $$
  SELECT net.http_post(
    url := 'https://vanrixxzaawybszeuivb.supabase.co/functions/v1/generate-daily-lunar-insight',
    headers := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhbnJpeHh6YWF3eWJzemV1aXZiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyNzk3MDQ2NSwiZXhwIjoyMDQzNTQ2NDY1fQ.l4lwDL0cfG4LxJr-YH24EMNZ6T1FtWi-b5lPwWujVDw"}'::jsonb,
    body := '{}'::jsonb
  ) AS request_id;
  $$
);

-- View scheduled jobs
COMMENT ON EXTENSION pg_cron IS 'Job scheduler for PostgreSQL - generates daily lunar insights at 00:05 UTC';

-- Query to check if cron job is scheduled:
-- SELECT * FROM cron.job WHERE jobname = 'generate-daily-lunar-insight';

-- Query to check recent cron runs:
-- SELECT * FROM cron.job_run_details WHERE jobid IN (SELECT jobid FROM cron.job WHERE jobname = 'generate-daily-lunar-insight') ORDER BY start_time DESC LIMIT 10;
