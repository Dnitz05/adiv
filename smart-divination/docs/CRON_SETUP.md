# Automated Daily Lunar Insights - Cron Setup

## Method 1: Manual Setup via Supabase Dashboard (Recommended)

### Step 1: Access Database Extensions
1. Go to: https://supabase.com/dashboard/project/vanrixxzaawybszeuivb/database/extensions
2. Enable **pg_cron** extension (if not already enabled)
3. Enable **pg_net** extension (for HTTP requests)

### Step 2: Configure Cron Job
1. Go to: https://supabase.com/dashboard/project/vanrixxzaawybszeuivb/database/cron-jobs
2. Click **"Create a new cron job"**
3. Configure:
   - **Name**: `generate-daily-lunar-insight`
   - **Schedule**: `5 0 * * *` (Every day at 00:05 UTC)
   - **Command**:
   ```sql
   SELECT net.http_post(
     url := 'https://vanrixxzaawybszeuivb.supabase.co/functions/v1/generate-daily-lunar-insight',
     headers := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhbnJpeHh6YWF3eWJzemV1aXZiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyNzk3MDQ2NSwiZXhwIjoyMDQzNTQ2NDY1fQ.l4lwDL0cfG4LxJr-YH24EMNZ6T1FtWi-b5lPwWujVDw"}'::jsonb,
     body := '{}'::jsonb
   ) AS request_id;
   ```
4. Click **"Create"**

### Step 3: Verify Setup
Run this query in SQL Editor to check the cron job:
```sql
SELECT * FROM cron.job WHERE jobname = 'generate-daily-lunar-insight';
```

View recent executions:
```sql
SELECT * FROM cron.job_run_details
WHERE jobid IN (SELECT jobid FROM cron.job WHERE jobname = 'generate-daily-lunar-insight')
ORDER BY start_time DESC
LIMIT 10;
```

---

## Method 2: SQL Migration (Automated)

If you prefer, you can run the migration:
```bash
cd smart-divination
supabase db push --linked
```

This will apply: `20251116000017_setup_automated_daily_insights.sql`

---

## Method 3: External Cron (Alternative)

If database cron is not available, use an external service:

### Option A: GitHub Actions
Create `.github/workflows/daily-lunar-insight.yml`:
```yaml
name: Generate Daily Lunar Insight
on:
  schedule:
    - cron: '5 0 * * *'  # 00:05 UTC daily
  workflow_dispatch:

jobs:
  generate:
    runs-on: ubuntu-latest
    steps:
      - name: Call Edge Function
        run: |
          curl -X POST \
            https://vanrixxzaawybszeuivb.supabase.co/functions/v1/generate-daily-lunar-insight \
            -H "Authorization: Bearer ${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}"
```

### Option B: Vercel Cron (if backend is on Vercel)
Add to `vercel.json`:
```json
{
  "crons": [{
    "path": "/api/generate-lunar-insight",
    "schedule": "5 0 * * *"
  }]
}
```

---

## Testing

Generate insight for today manually:
```bash
curl -X POST \
  https://vanrixxzaawybszeuivb.supabase.co/functions/v1/generate-daily-lunar-insight \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhbnJpeHh6YWF3eWJzemV1aXZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc5NzA0NjUsImV4cCI6MjA0MzU0NjQ2NX0.WZBRgZxdCuaB_a7udjzFQH8ufyHLxBKiUWKVazppUK8"
```

Generate for specific date:
```bash
curl -X POST \
  "https://vanrixxzaawybszeuivb.supabase.co/functions/v1/generate-daily-lunar-insight?date=2025-11-17" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhbnJpeHh6YWF3eWJzemV1aXZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc5NzA0NjUsImV4cCI6MjA0MzU0NjQ2NX0.WZBRgZxdCuaB_a7udjzFQH8ufyHLxBKiUWKVazppUK8"
```

---

## Why 00:05 UTC?

Running at 00:05 (instead of 00:00) ensures:
1. Date has definitely changed in all timezones
2. Avoids potential midnight race conditions
3. 5-minute buffer for any database maintenance

---

## Troubleshooting

If insights are not generating automatically:

1. **Check cron job status**:
   ```sql
   SELECT * FROM cron.job WHERE jobname = 'generate-daily-lunar-insight';
   ```

2. **Check recent runs**:
   ```sql
   SELECT * FROM cron.job_run_details
   WHERE jobid IN (SELECT jobid FROM cron.job WHERE jobname = 'generate-daily-lunar-insight')
   ORDER BY start_time DESC;
   ```

3. **Manually trigger** to test:
   ```bash
   curl -X POST https://vanrixxzaawybszeuivb.supabase.co/functions/v1/generate-daily-lunar-insight \
     -H "Authorization: Bearer SERVICE_ROLE_KEY"
   ```

4. **Check Edge Function logs** in Supabase Dashboard

---

## Cost

- **pg_cron**: Free (included in Supabase)
- **Edge Function execution**: Free tier includes 500K requests/month
- **Database queries**: Minimal (1 insert + a few selects per day)

**Total cost: $0.00** ✅
