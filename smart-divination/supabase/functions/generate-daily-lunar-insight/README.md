# Generate Daily Lunar Insight - Supabase Edge Function

## Overview

This Edge Function generates AI-powered daily lunar insights combining:
- Real-time lunar phase calculations
- Zodiac sign and elemental correspondences
- Astrologically accurate base templates
- OpenAI GPT-4o-mini for personalized daily guidance
- Automatic translation to English, Spanish, and Catalan

## Architecture

```
┌─────────────────┐
│  Cron Trigger   │  (Daily at 00:00 UTC)
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────┐
│  Edge Function (Deno)               │
│                                     │
│  1. Calculate Lunar Phase           │ ← lunar-calculator.ts
│  2. Get Zodiac Sign & Element       │
│  3. Fetch Matching Template         │ ← Supabase DB
│  4. Generate AI Insights            │ ← openai-generator.ts
│     - Universal (collective)        │
│     - Specific (personal)           │
│  5. Translate to ES & CA            │
│  6. Save to Database                │
└─────────────────────────────────────┘
         │
         ▼
┌─────────────────┐
│ daily_lunar_    │
│    insights     │ (Supabase table)
└─────────────────┘
```

## Files

- `index.ts` - Main Edge Function entry point
- `lunar-calculator.ts` - Lunar phase & zodiac calculations
- `openai-generator.ts` - OpenAI integration for insights & translation

## Environment Variables Required

```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
OPENAI_API_KEY=sk-your-openai-api-key
```

## Deployment

### 1. Deploy the Edge Function

```bash
cd smart-divination
supabase functions deploy generate-daily-lunar-insight --project-ref your-project-ref
```

### 2. Set Secrets

```bash
supabase secrets set OPENAI_API_KEY=sk-your-openai-api-key --project-ref your-project-ref
```

### 3. Apply Cron Migration

The cron job is configured in migration `20251115000004_setup_daily_lunar_cron.sql`.

Apply it with:

```bash
supabase db push --linked
```

## Testing

### Manual Trigger (Today)

```bash
curl -X POST 'https://your-project.supabase.co/functions/v1/generate-daily-lunar-insight' \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json"
```

### Manual Trigger (Specific Date)

```bash
curl -X POST 'https://your-project.supabase.co/functions/v1/generate-daily-lunar-insight?date=2025-12-25' \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json"
```

### Expected Response

```json
{
  "success": true,
  "date": "2025-11-15",
  "insight": {
    "id": "uuid",
    "date": "2025-11-15",
    "phase_id": "waxing_gibbous",
    "zodiac_sign": "taurus",
    "element": "earth",
    "lunar_age": 13.45,
    "illumination": 87.3,
    "universal_insight": {
      "en": "As the moon swells...",
      "es": "Mientras la luna crece...",
      "ca": "Mentre la lluna creix..."
    },
    "specific_insight": {
      "en": "Today invites you...",
      "es": "Hoy te invita...",
      "ca": "Avui et convida..."
    },
    "is_special_event": false,
    "special_event_type": null
  },
  "cost": 0.0023
}
```

## Cost Estimate

Using GPT-4o-mini:
- ~6 API calls per day (2 insights × 3 languages)
- ~1000 tokens total per day
- **Estimated cost: $0.002 - $0.004 per day**
- **Monthly: ~$0.06 - $0.12**

## Monitoring

Check Supabase Edge Functions logs:

```bash
supabase functions logs generate-daily-lunar-insight --project-ref your-project-ref
```

Or in the Supabase Dashboard → Edge Functions → Logs

## Troubleshooting

### Issue: Cron not triggering

Check pg_cron status:

```sql
SELECT * FROM cron.job;
SELECT * FROM cron.job_run_details ORDER BY start_time DESC LIMIT 10;
```

### Issue: OpenAI API errors

- Verify `OPENAI_API_KEY` secret is set correctly
- Check OpenAI account has available credits
- Review rate limits

### Issue: Template not found

- Verify all 32 templates exist in `lunar_guide_templates`
- Check phase_id, element, zodiac_sign values match

## Future Enhancements

- [ ] More precise lunar position calculation (using astronomy library)
- [ ] Detect eclipses, supermoons, blue moons
- [ ] Personalized insights based on user birth chart
- [ ] Cache translations to reduce API calls
- [ ] A/B test different prompt styles
