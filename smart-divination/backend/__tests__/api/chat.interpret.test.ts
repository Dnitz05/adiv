
// Tests for /api/chat/interpret endpoint
// eslint-disable-next-line @typescript-eslint/no-var-requires
jest.mock('../../lib/utils/supabase', () => {
  const actual = jest.requireActual('../../lib/utils/supabase');
  const mockUser = {
    id: 'test-user',
    email: 'user@test.dev',
    user_metadata: {},
  };
  return {
    ...actual,
    getSupabaseServiceClient: jest.fn(() => ({
      auth: {
        getUser: jest.fn(async (token: string) => {
          if (token === 'test-access-token') {
            return { data: { user: mockUser }, error: null };
          }
          return { data: { user: null }, error: { message: 'Invalid token' } };
        }),
      },
    })),
    ensureUserRecord: jest.fn().mockResolvedValue(undefined),
    getUserTier: jest.fn().mockResolvedValue('free'),
    getSession: jest.fn(async (sessionId: string) => ({
      id: sessionId,
      userId: mockUser.id,
      technique: 'tarot',
      locale: 'en',
      createdAt: new Date().toISOString(),
      lastActivity: new Date().toISOString(),
      question: null,
      results: {},
      interpretation: null,
      summary: null,
      metadata: {},
    })),
    createSessionArtifact: jest.fn().mockResolvedValue({ id: 'artifact-interpret' }),
    createSessionMessage: jest.fn().mockResolvedValue({ id: 'message-interpret' }),
  };
});
const handler = require('../../pages/api/chat/interpret').default as (
  req: any,
  res: any
) => void | Promise<void>;
import { createSessionArtifact, createSessionMessage } from '../../lib/utils/supabase';
import { invokeNodeHandler } from '../../test_utils/invokeNodeHandler';

const AUTH_HEADERS = { authorization: 'Bearer test-access-token' };
const ORIGINAL_FETCH = global.fetch;
const baseResults = {
  cards: [
    {
      id: 'card_0',
      name: 'The Fool',
      suit: 'Major Arcana',
      upright: true,
      position: 1,
    },
    {
      id: 'card_1',
      name: 'The Magician',
      suit: 'Major Arcana',
      upright: false,
      position: 2,
    },
  ],
  spread: 'three_card',
  seed: 'seed123',
  method: 'crypto_secure',
};

describe('API /api/chat/interpret', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    delete process.env.SUPABASE_URL;
    delete process.env.SUPABASE_SERVICE_ROLE_KEY;
    delete process.env.DEEPSEEK_API_KEY;
    global.fetch = ORIGINAL_FETCH;
  });

  afterAll(() => {
    global.fetch = ORIGINAL_FETCH;
  });

  it('returns 405 on GET', async () => {
    const res = await invokeNodeHandler(handler, 'GET', { path: '/api/chat/interpret' });
    expect(res.status).toBe(405);
  });

  it('returns 400 when sessionId missing', async () => {
    const res = await invokeNodeHandler(handler, 'POST', {
      path: '/api/chat/interpret',
      headers: AUTH_HEADERS,
      body: {
        results: baseResults,
        interpretation: 'Meaningful guidance',
      },
    });
    expect(res.status).toBe(400);
  });

  it('returns success without persistence when Supabase unavailable', async () => {
    const res = await invokeNodeHandler(handler, 'POST', {
      path: '/api/chat/interpret',
      headers: AUTH_HEADERS,
      body: {
        sessionId: 'session-1',
        results: baseResults,
        interpretation: 'You should follow your heart.',
        summary: 'Follow your heart',
        question: 'Should I take the new job?',
      },
    });

    expect(res.status).toBe(200);
    const payload = await res.json();
    expect(payload.success).toBe(true);
    expect(payload.data.sessionId).toBe('session-1');
    expect(payload.data.stored).toBe(false);
    expect(payload.data.keywords).toEqual(
      expect.arrayContaining(['should', 'follow', 'heart']),
    );
    expect(createSessionArtifact).not.toHaveBeenCalled();
    expect(createSessionMessage).not.toHaveBeenCalled();
  });

  it('persists interpretation when Supabase available', async () => {
    process.env.SUPABASE_URL = 'https://example.supabase.co';
    process.env.SUPABASE_SERVICE_ROLE_KEY = 'service-key';

    const res = await invokeNodeHandler(handler, 'POST', {
      path: '/api/chat/interpret',
      headers: AUTH_HEADERS,
      body: {
        sessionId: 'session-2',
        results: baseResults,
        interpretation: 'Balance logic with intuition.',
        summary: 'Balance both sides',
        question: 'How do I decide between offers?',
        model: 'deepseek-v3',
        technique: 'tarot',
      },
    });

    expect(res.status).toBe(200);
    const payload = await res.json();
    expect(payload.success).toBe(true);
    expect(payload.data.stored).toBe(true);
    expect(payload.data.keywords).toEqual(
      expect.arrayContaining(['balance', 'logic', 'offers']),
    );

    expect(createSessionArtifact).toHaveBeenCalledTimes(1);
    const artifactArgs = (createSessionArtifact as jest.Mock).mock.calls[0][0];
    expect(artifactArgs.sessionId).toBe('session-2');
    expect(artifactArgs.type).toBe('interpretation');
    expect(artifactArgs.payload.interpretation).toBe('Balance logic with intuition.');
    expect(artifactArgs.payload.keywords).toEqual(
      expect.arrayContaining(['balance', 'logic', 'offers']),
    );

    expect(createSessionMessage).toHaveBeenCalledTimes(1);
    const messageArgs = (createSessionMessage as jest.Mock).mock.calls[0][0];
    expect(messageArgs.sessionId).toBe('session-2');
    expect(messageArgs.sender).toBe('assistant');
    expect(messageArgs.content).toBe('Balance logic with intuition.');
    expect(messageArgs.metadata).toMatchObject({
      model: 'deepseek-v3',
      question: 'How do I decide between offers?',
    });
    expect(messageArgs.metadata.keywords).toEqual(
      expect.arrayContaining(['balance', 'offers']),
    );
  });

  it('generates interpretation via DeepSeek when not provided', async () => {
    process.env.SUPABASE_URL = 'https://example.supabase.co';
    process.env.SUPABASE_SERVICE_ROLE_KEY = 'service-key';
    process.env.DEEPSEEK_API_KEY = 'test-key';

    const mockFetch = jest.fn().mockResolvedValue({
      ok: true,
      json: async () => ({
        choices: [
          {
            message: {
              content: JSON.stringify({
                interpretation: 'Unexpected journeys lie ahead. Embrace change.',
                summary: 'Embrace upcoming change.',
                keywords: ['journey', 'change', 'growth'],
              }),
            },
          },
        ],
      }),
    });
    (global as any).fetch = mockFetch;

    const res = await invokeNodeHandler(handler, 'POST', {
      path: '/api/chat/interpret',
      headers: AUTH_HEADERS,
      body: {
        sessionId: 'session-3',
        results: baseResults,
        question: 'What should I focus on next?',
      },
    });

    expect(mockFetch).toHaveBeenCalledTimes(1);
    expect(res.status).toBe(200);
    const payload = await res.json();
    expect(payload.data.generated).toBe(true);
    expect(payload.data.interpretation).toContain('Unexpected journeys');
    expect(payload.data.keywords).toEqual(
      expect.arrayContaining(['journey', 'change']),
    );
    expect(createSessionArtifact).toHaveBeenCalledTimes(1);
    const artifactArgs = (createSessionArtifact as jest.Mock).mock.calls[0][0];
    expect(artifactArgs.payload.keywords).toEqual(
      expect.arrayContaining(['journey', 'change']),
    );
  });
});
