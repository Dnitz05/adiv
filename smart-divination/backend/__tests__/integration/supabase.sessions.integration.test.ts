import type { NextApiHandler, NextApiRequest } from 'next';

import { invokeNodeHandler } from '../../test_utils/invokeNodeHandler';
import {
  describeSupabaseIntegration,
  SUPABASE_SEED_TAROT_SESSION_ID,
  SUPABASE_SEED_USER_ID,
} from './supabaseTestHarness';
import {
  createSession,
  createSessionArtifact,
  createSessionMessage,
  getSupabaseServiceClient,
} from '../../lib/utils/supabase';

jest.mock('../../lib/utils/api', () => {
  const actual = jest.requireActual<typeof import('../../lib/utils/api')>(
    '../../lib/utils/api'
  );
  return {
    ...actual,
    parseApiRequest: jest.fn(async (req: NextApiRequest, schema: any, options: any = {}) => {
      const requestId = 'integration-test-request';
      const userId =
        typeof req.query.userId === 'string' && req.query.userId.length > 0
          ? req.query.userId
          : SUPABASE_SEED_USER_ID;
      const baseRequest = {
        timestamp: new Date().toISOString(),
        requestId,
        userId,
        locale: 'en',
        technique: Array.isArray(req.query.technique)
          ? req.query.technique[0]
          : req.query.technique,
        limit: Array.isArray(req.query.limit) ? req.query.limit[0] : req.query.limit ?? '10',
        offset: Array.isArray(req.query.offset) ? req.query.offset[0] : req.query.offset,
        orderBy: Array.isArray(req.query.orderBy) ? req.query.orderBy[0] : req.query.orderBy,
        orderDir: Array.isArray(req.query.orderDir) ? req.query.orderDir[0] : req.query.orderDir,
      };
      const data = schema ? schema.parse(baseRequest) : (baseRequest as any);

      if (options.requireUser && !data.userId) {
        throw actual.createApiError(
          'UNAUTHENTICATED',
          'Authentication required',
          401,
          { statusCode: 401 },
          requestId
        );
      }

      return {
        data,
        requestId,
        auth: {
          userId: SUPABASE_SEED_USER_ID,
          tier: 'free',
          token: 'integration-test-token',
          user: { id: SUPABASE_SEED_USER_ID } as any,
        },
      };
    }),
  };
});

describeSupabaseIntegration('Supabase integration (session history)', () => {
  let handler: NextApiHandler;

  beforeAll(async () => {
    handler = (await import('../../pages/api/sessions/[userId]')).default as NextApiHandler;
    await resetSeedSession();
  });

  afterAll(async () => {
    const client = getSupabaseServiceClient();
    await client.from('sessions').delete().eq('id', SUPABASE_SEED_TAROT_SESSION_ID);
  });

  it('returns seeded sessions with artifacts and messages', async () => {
    const res = await invokeNodeHandler(handler, 'GET', {
      path: `/api/sessions/${SUPABASE_SEED_USER_ID}`,
      headers: { authorization: 'Bearer integration-test-token' },
      query: {
        userId: SUPABASE_SEED_USER_ID,
        technique: 'tarot',
        limit: '5',
      },
    });

    expect(res.status).toBe(200);
    const body = (await res.json()) as any;
    expect(body.success).toBe(true);
    expect(Array.isArray(body.data.sessions)).toBe(true);
    expect(body.data.sessions.length).toBeGreaterThan(0);

    const sessionIds = body.data.sessions.map((session: any) => session.id);
    expect(sessionIds).toContain(SUPABASE_SEED_TAROT_SESSION_ID);

    const seededSession = body.data.sessions.find(
      (session: any) => session.id === SUPABASE_SEED_TAROT_SESSION_ID
    );
    expect(seededSession).toBeDefined();
    expect(seededSession.userId).toBe(SUPABASE_SEED_USER_ID);
    expect(seededSession.technique).toBe('tarot');
    expect(seededSession.artifacts?.length ?? 0).toBeGreaterThan(0);

    const [artifact] = seededSession.artifacts;
    expect(Array.isArray(artifact?.payload?.cards)).toBe(true);
    expect(artifact?.payload?.cards?.length ?? 0).toBeGreaterThan(0);

    expect(seededSession.messages?.length ?? 0).toBeGreaterThan(0);
  });
});

async function resetSeedSession(): Promise<void> {
  const client = getSupabaseServiceClient();

  await client
    .from('users')
    .upsert(
      {
        id: SUPABASE_SEED_USER_ID,
        email: 'demo@smartdivination.local',
        name: 'Demo Seeker',
        tier: 'free',
        preferences: {
          locale: 'en',
          theme: 'light',
          defaultTechnique: 'tarot',
          notifications: {
            email: true,
            push: false,
            marketing: false,
          },
        },
        metadata: { seedData: true },
      },
      { onConflict: 'id' }
    );

  await client.from('sessions').delete().eq('id', SUPABASE_SEED_TAROT_SESSION_ID);

  await createSession({
    id: SUPABASE_SEED_TAROT_SESSION_ID,
    userId: SUPABASE_SEED_USER_ID,
    technique: 'tarot',
    locale: 'en',
    question: 'What should I focus on this week?',
    results: {
      cards: [
        {
          id: 'card_0',
          name: 'The Fool',
          suit: 'major',
          number: 0,
          upright: true,
          position: 1,
        },
        {
          id: 'card_1',
          name: 'Two of Cups',
          suit: 'cups',
          number: 2,
          upright: true,
          position: 2,
        },
        {
          id: 'card_2',
          name: 'Six of Swords',
          suit: 'swords',
          number: 6,
          upright: false,
          position: 3,
        },
      ],
      spread: 'three_card',
      cardCount: 3,
    },
    interpretation:
      'Take bold steps but nurture your partnerships; release what no longer serves you.',
    summary: 'Balance action with trust in allies.',
    metadata: {
      seed: 'demo-seed-111',
      method: 'secure_rng',
    },
  });

  await createSessionArtifact({
    sessionId: SUPABASE_SEED_TAROT_SESSION_ID,
    type: 'tarot_draw',
    source: 'system',
    payload: {
      seed: 'demo-seed-111',
      method: 'secure_rng',
      cards: [
        { id: 'card_0', name: 'The Fool', upright: true, position: 1 },
        { id: 'card_1', name: 'Two of Cups', upright: true, position: 2 },
        { id: 'card_2', name: 'Six of Swords', upright: false, position: 3 },
      ],
      keywords: ['beginnings', 'partnerships', 'transition'],
    },
    metadata: { source: 'integration-test' },
  });

  await createSessionMessage({
    sessionId: SUPABASE_SEED_TAROT_SESSION_ID,
    sender: 'user',
    content: 'What should I focus on this week?',
    metadata: { keywords: ['focus', 'week'], locale: 'en' },
  });

  await createSessionMessage({
    sessionId: SUPABASE_SEED_TAROT_SESSION_ID,
    sender: 'assistant',
    content: 'Embrace new opportunities, deepen partnerships, and transition gracefully.',
    metadata: { summary: 'Balance courage with collaboration.' },
  });
}
