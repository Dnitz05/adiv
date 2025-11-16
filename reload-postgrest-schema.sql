-- Reload PostgREST schema cache
-- This tells PostgREST to recognize newly created tables

NOTIFY pgrst, 'reload schema';
NOTIFY pgrst, 'reload config';

-- Verify the notification was sent
SELECT 'PostgREST schema reload notification sent' as status;
