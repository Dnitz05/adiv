-- dev_seed.sql
-- Sample data for Smart Divination local development.
-- Run with: psql < dev_seed.sql (using service role).

begin;

-- Demo user
insert into users (id, email, name, tier, preferences, metadata)
values (
  '00000000-0000-0000-0000-000000000001',
  'demo@smartdivination.local',
  'Demo Seeker',
  'free',
  jsonb_build_object(
    'locale', 'en',
    'theme', 'light',
    'defaultTechnique', 'tarot',
    'notifications', jsonb_build_object('email', true, 'push', false, 'marketing', false)
  ),
  jsonb_build_object('seedData', true)
)
on conflict (id) do update
set email = excluded.email,
    name = excluded.name,
    tier = excluded.tier,
    preferences = excluded.preferences,
    metadata = excluded.metadata;

-- Stats per technique
insert into user_stats (user_id, technique, total_sessions, sessions_this_week, sessions_this_month, last_session_at, favorite_spread)
values
  ('00000000-0000-0000-0000-000000000001', 'tarot', 3, 1, 2, now() - interval '2 days', 'three_card'),
  ('00000000-0000-0000-0000-000000000001', 'iching', 1, 1, 1, now() - interval '5 days', null),
  ('00000000-0000-0000-0000-000000000001', 'runes', 2, 0, 1, now() - interval '9 days', null)
on conflict (user_id, technique) do update
set total_sessions = excluded.total_sessions,
    sessions_this_week = excluded.sessions_this_week,
    sessions_this_month = excluded.sessions_this_month,
    last_session_at = excluded.last_session_at,
    favorite_spread = excluded.favorite_spread;

-- Tarot session
insert into sessions (id, user_id, technique, locale, question, results, interpretation, summary, metadata)
values (
  '10000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000001',
  'tarot',
  'en',
  'What should I focus on this week?',
  jsonb_build_object(
    'cards', jsonb_build_array(
      jsonb_build_object('id', 'card_0', 'name', 'The Fool', 'suit', 'major', 'number', 0, 'upright', true, 'position', 1),
      jsonb_build_object('id', 'card_1', 'name', 'Two of Cups', 'suit', 'cups', 'number', 2, 'upright', true, 'position', 2),
      jsonb_build_object('id', 'card_2', 'name', 'Six of Swords', 'suit', 'swords', 'number', 6, 'upright', false, 'position', 3)
    ),
    'spread', 'three_card',
    'cardCount', 3
  ),
  'Take bold steps but nurture your partnerships; release what no longer serves you.',
  'Balance action with trust in allies.',
  jsonb_build_object('seed', 'demo-seed-111', 'method', 'secure_rng')
)
on conflict (id) do update
set question = excluded.question,
    results = excluded.results,
    interpretation = excluded.interpretation,
    summary = excluded.summary,
    metadata = excluded.metadata,
    last_activity = now();

-- I Ching session
insert into sessions (id, user_id, technique, locale, question, results, interpretation, summary, metadata)
values (
  '20000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000001',
  'iching',
  'en',
  'Guidance for upcoming decision',
  jsonb_build_object(
    'hexagram', jsonb_build_object('number', 46, 'name', 'Pushing Upward'),
    'changingLines', jsonb_build_array(3),
    'method', 'three_coins'
  ),
  'Rise steadily by remaining humble and seeking support from wise allies.',
  'Progress through humility.',
  jsonb_build_object('seed', 'demo-seed-222', 'method', 'coins')
)
on conflict (id) do update
set question = excluded.question,
    results = excluded.results,
    interpretation = excluded.interpretation,
    summary = excluded.summary,
    metadata = excluded.metadata,
    last_activity = now();

-- Runes session
insert into sessions (id, user_id, technique, locale, question, results, interpretation, summary, metadata)
values (
  '30000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000001',
  'runes',
  'en',
  'Where should I invest my creative energy?',
  jsonb_build_object(
    'runes', jsonb_build_array(
      jsonb_build_object('id', 4, 'name', 'Ansuz', 'symbol', 'ANSUZ', 'isReversed', false, 'position', 1, 'meaning', 'Inspiration and communication'),
      jsonb_build_object('id', 11, 'name', 'Jera', 'symbol', 'JERA', 'isReversed', false, 'position', 2, 'meaning', 'Cycles and steady progress'),
      jsonb_build_object('id', 18, 'name', 'Berkano', 'symbol', 'BERKANO', 'isReversed', true, 'position', 3, 'meaning', 'Growth and emergence')
    ),
    'spread', 'three_runes'
  ),
  'Seek inspiration through communication, trust natural cycles, and nurture emerging ideas.',
  'Cultivate ideas patiently.',
  jsonb_build_object('seed', 'demo-seed-333', 'method', 'bag_draw')
)
on conflict (id) do update
set question = excluded.question,
    results = excluded.results,
    interpretation = excluded.interpretation,
    summary = excluded.summary,
    metadata = excluded.metadata,
    last_activity = now();

-- Artefacts & messages for tarot session
insert into session_artifacts (id, session_id, artifact_type, source, payload, metadata)
values (
  '40000000-0000-0000-0000-000000000001',
  '10000000-0000-0000-0000-000000000001',
  'tarot_draw',
  'system',
  jsonb_build_object(
    'seed', 'demo-seed-111',
    'method', 'secure_rng',
    'cards', jsonb_build_array(
      jsonb_build_object('id', 'card_0', 'name', 'The Fool', 'upright', true, 'position', 1),
      jsonb_build_object('id', 'card_1', 'name', 'Two of Cups', 'upright', true, 'position', 2),
      jsonb_build_object('id', 'card_2', 'name', 'Six of Swords', 'upright', false, 'position', 3)
    ),
    'keywords', jsonb_build_array('beginnings', 'partnerships', 'transition')
  ),
  jsonb_build_object('source', 'seed_script')
)
on conflict (id) do update
set payload = excluded.payload,
    metadata = excluded.metadata;

insert into session_messages (id, session_id, sender, content, metadata)
values
  (
    '50000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000001',
    'user',
    'What should I focus on this week?',
    jsonb_build_object('keywords', jsonb_build_array('focus', 'week'))
  ),
  (
    '50000000-0000-0000-0000-000000000002',
    '10000000-0000-0000-0000-000000000001',
    'assistant',
    'Embrace new opportunities, deepen partnerships, and transition gracefully from old patterns.',
    jsonb_build_object('summary', 'Balance courage with collaboration.')
  )
on conflict (id) do update
set content = excluded.content,
    metadata = excluded.metadata;

commit;
