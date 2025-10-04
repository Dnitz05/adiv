-- Smart Divination development seed data
-- Provides a demo user and tarot session for local validation of email/password flows.

BEGIN;

-- Ensure demo seeker exists in Supabase Auth with a confirmed email.
DO 
DECLARE
  target_user UUID := '11111111-1111-4111-8111-111111111111';
BEGIN
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE id = target_user) THEN
    PERFORM auth.create_user(
      user_id => target_user,
      email => 'demo-seeker@smartdivination.test',
      password => 'TarotDemo1!',
      email_confirm => true,
      user_metadata => jsonb_build_object('display_name', 'Demo Seeker')
    );
  END IF;
END;
;

-- Mirror the auth user into the public.users profile table.
INSERT INTO public.users (id, email, name, tier, preferences)
VALUES (
  '11111111-1111-4111-8111-111111111111',
  'demo-seeker@smartdivination.test',
  'Demo Seeker',
  'free',
  jsonb_build_object(
    'locale', 'en',
    'theme', 'auto',
    'defaultTechnique', 'tarot',
    'notifications', jsonb_build_object(
      'email', true,
      'push', false,
      'marketing', false
    )
  )
)
ON CONFLICT (id) DO UPDATE
SET email = EXCLUDED.email,
    name = EXCLUDED.name,
    preferences = EXCLUDED.preferences,
    last_activity = NOW();

-- Provide a reference tarot session linked to the demo user.
INSERT INTO public.sessions (
  id,
  user_id,
  technique,
  locale,
  question,
  results,
  interpretation,
  summary,
  metadata,
  created_at,
  last_activity
)
VALUES (
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  '11111111-1111-4111-8111-111111111111',
  'tarot',
  'en',
  'How can I prepare for the upcoming launch?',
  jsonb_build_object(
    'spread', 'three_card',
    'cards', jsonb_build_array(
      jsonb_build_object('name', 'The Fool', 'position', 'past', 'orientation', 'upright'),
      jsonb_build_object('name', 'The Magician', 'position', 'present', 'orientation', 'upright'),
      jsonb_build_object('name', 'The World', 'position', 'future', 'orientation', 'upright')
    ),
    'seed', 'demo-seed'
  ),
  'Lean into curiosity, channel your skills deliberately, and celebrate progress to stay grounded.',
  'Curiosity ignites momentum; mindful execution keeps it on track.',
  jsonb_build_object('source', 'seed.sql', 'demo', true),
  NOW() - INTERVAL '1 day',
  NOW() - INTERVAL '1 day'
)
ON CONFLICT (id) DO NOTHING;

-- Attach interpretation artifacts for richer history cards.
INSERT INTO public.session_artifacts (
  id,
  session_id,
  artifact_type,
  source,
  payload,
  created_at
)
VALUES (
  'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  'tarot_draw',
  'system',
  jsonb_build_object(
    'spread', 'three_card',
    'cards', jsonb_build_array('The Fool', 'The Magician', 'The World'),
    'seed', 'demo-seed'
  ),
  NOW() - INTERVAL '1 day'
), (
  'cccccccc-cccc-4ccc-8ccc-cccccccccccc',
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  'interpretation',
  'assistant',
  jsonb_build_object(
    'summary', 'Curiosity meets craftsmanship for a confident launch.',
    'keywords', jsonb_build_array('curiosity', 'craftsmanship', 'momentum')
  ),
  NOW() - INTERVAL '23 hours'
)
ON CONFLICT (id) DO NOTHING;

-- Ensure stats stay in sync for the demo user.
PERFORM public.refresh_user_stats('11111111-1111-4111-8111-111111111111');

COMMIT;