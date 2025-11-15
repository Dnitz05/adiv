-- Migration: Setup Daily Lunar Insight Generation Cron Job
-- Created: 2025-11-15
-- Description: Configure pg_cron to run daily lunar insight generation

-- Enable pg_cron extension if not already enabled
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Schedule daily lunar insight generation at 00:00 UTC
-- This will call the Supabase Edge Function via HTTP
SELECT cron.schedule(
  'generate-daily-lunar-insight',
  '0 0 * * *', -- Every day at midnight UTC
  $$
  SELECT
    net.http_post(
      url := current_setting('app.supabase_url') || '/functions/v1/generate-daily-lunar-insight',
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer ' || current_setting('app.supabase_service_role_key')
      ),
      body := '{}'::jsonb
    ) AS request_id;
  $$
);

-- Grant necessary permissions
GRANT USAGE ON SCHEMA cron TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA cron TO postgres;

-- Note: You'll need to set these config values in Supabase Dashboard:
-- app.supabase_url = https://your-project.supabase.co
-- app.supabase_service_role_key = your-service-role-key
--
-- Or use pg_net extension to call the Edge Function directly
