# Quick Setup: Lunar Guide Templates

The Supabase CLI is having authentication issues. Please run these SQL commands manually in the Supabase Dashboard:

## Step 1: Open SQL Editor

Go to: https://supabase.com/dashboard/project/vanrixxzaawybszeuivb/sql/new

## Step 2: Run Migration 15 (Create Table)

Copy and paste this entire block into the SQL editor and click "Run":

```sql
-- Create lunar_guide_templates table
CREATE TABLE IF NOT EXISTS public.lunar_guide_templates (
  id TEXT PRIMARY KEY,
  phase_id phase_type NOT NULL,
  element element_type NULL,
  zodiac_sign zodiac_sign_type NULL,
  headline JSONB NOT NULL,
  tagline JSONB NULL,
  focus_areas JSONB NOT NULL,
  energy_description JSONB NOT NULL,
  recommended_actions JSONB NOT NULL,
  journal_prompts JSONB NULL,
  priority INTEGER NOT NULL DEFAULT 0,
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_lunar_guide_templates_phase ON lunar_guide_templates(phase_id, active);
CREATE INDEX idx_lunar_guide_templates_lookup ON lunar_guide_templates(phase_id, element, zodiac_sign, active);

ALTER TABLE lunar_guide_templates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lunar guide templates are viewable by everyone"
  ON lunar_guide_templates FOR SELECT
  USING (active = true);

CREATE TRIGGER update_lunar_guide_templates_updated_at
  BEFORE UPDATE ON lunar_guide_templates
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
```

## Step 3: Run Migration 16 (Seed Data)

After the table is created, run this in a new SQL query (copy the content from the file):

`supabase/migrations/20251116000016_seed_base_templates.sql`

The file contains 8 INSERT statements for the base templates.

## Step 4: Verify

Run this to confirm templates were created:

```sql
SELECT phase_id, element, zodiac_sign, priority, active
FROM lunar_guide_templates
ORDER BY phase_id, priority;
```

You should see 8 rows (one for each lunar phase).

## Step 5: Test the App

After running the migrations, clear the app cache and relaunch:

```bash
adb shell pm clear com.smartdivination.tarot && adb shell am start -n com.smartdivination.tarot/com.smartdivination.tarot.MainActivity
```

The Guide tab should now load correctly!
