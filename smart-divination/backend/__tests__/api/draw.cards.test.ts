// Tests for /api/draw/cards (canonical)
// Keep simple to validate contract shape and method handling
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
    createDivinationSession: jest.fn().mockResolvedValue({ id: 'test-session' }),
    createSessionArtifact: jest.fn().mockResolvedValue({ id: 'artifact-1' }),
    createSessionMessage: jest.fn().mockResolvedValue({ id: 'message-1' }),
  };
});
const handler = require('../../pages/api/draw/cards').default as (
  req: any,
  res: any
) => void | Promise<void>;
import { createSessionArtifact, createSessionMessage } from '../../lib/utils/supabase';
import { invokeNodeHandler } from '../../test_utils/invokeNodeHandler';

const AUTH_HEADERS = { authorization: 'Bearer test-access-token' };

describe('API /api/draw/cards (canonical)', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    delete process.env.SUPABASE_URL;
    delete process.env.SUPABASE_SERVICE_ROLE_KEY;
  });

  afterEach(() => {
    delete process.env.SUPABASE_URL;
    delete process.env.SUPABASE_SERVICE_ROLE_KEY;
  });

  it('returns 405 on non-POST', async () => {
    const res = await invokeNodeHandler(handler, 'GET', { path: '/api/draw/cards' });
    expect(res.status).toBe(405);
  });

  it('returns a valid response on POST', async () => {
    const body = { count: 3, allow_reversed: true, seed: 'seed123' };
    const res = await invokeNodeHandler(handler, 'POST', {
      path: '/api/draw/cards',
      body,
      headers: AUTH_HEADERS,
    });
    expect(res.status).toBe(200);
    const json = (await res.json()) as any;
    expect(json).toHaveProperty('result');
    expect(Array.isArray(json.result)).toBe(true);
    expect(json.result.length).toBe(3);
    const seen = new Set<number>();
    for (const c of json.result) {
      expect(typeof c.id).toBe('string');
      expect(typeof c.upright).toBe('boolean');
      expect(typeof c.position).toBe('number');
      const numericId = Number(c.id.replace('card_', ''));
      expect(Number.isNaN(numericId)).toBe(false);
      expect(numericId).toBeGreaterThanOrEqual(0);
      expect(numericId).toBeLessThan(78);
      expect(seen.has(numericId)).toBe(false);
      seen.add(numericId);
    }
    expect(seen.size).toBe(json.result.length);
    expect(json).toHaveProperty('seed');
    expect(json).toHaveProperty('timestamp');
    expect(json).toHaveProperty('locale');
    expect(createSessionArtifact).not.toHaveBeenCalled();
    expect(createSessionMessage).not.toHaveBeenCalled();
  });

  it('persists session artifact when Supabase credentials provided', async () => {
    process.env.SUPABASE_URL = 'https://example.supabase.co';
    process.env.SUPABASE_SERVICE_ROLE_KEY = 'service-key';

    const res = await invokeNodeHandler(handler, 'POST', {
      path: '/api/draw/cards',
      body: { count: 3 },
      headers: AUTH_HEADERS,
    });

    expect(res.status).toBe(200);
    expect(createSessionArtifact).toHaveBeenCalledTimes(1);
    const artifactArgs = (createSessionArtifact as jest.Mock).mock.calls[0][0];
    expect(artifactArgs.sessionId).toBe('test-session');
    expect(artifactArgs.type).toBe('tarot_draw');
    expect(Array.isArray(artifactArgs.payload.cards)).toBe(true);
    expect(artifactArgs.payload.cards.length).toBe(3);
    expect(artifactArgs.payload).toHaveProperty('seed');
    expect(artifactArgs.payload).toHaveProperty('timestamp');

    expect(createSessionMessage).toHaveBeenCalledTimes(1);
    const messageArgs = (createSessionMessage as jest.Mock).mock.calls[0][0];
    expect(messageArgs.sessionId).toBe('test-session');
    expect(messageArgs.sender).toBe('system');
    expect(typeof messageArgs.content).toBe('string');
    expect(messageArgs.metadata).toMatchObject({
      seed: expect.any(String),
      method: expect.any(String),
      spread: expect.any(String),
    });
    expect(Array.isArray(messageArgs.metadata.keywords)).toBe(true);
  });

  it('stores user question message when provided', async () => {
    process.env.SUPABASE_URL = 'https://example.supabase.co';
    process.env.SUPABASE_SERVICE_ROLE_KEY = 'service-key';

    const res = await invokeNodeHandler(handler, 'POST', {
      path: '/api/draw/cards',
      body: { count: 3, question: 'Should I travel soon?' },
      headers: AUTH_HEADERS,
    });

    expect(res.status).toBe(200);
    expect(createSessionMessage).toHaveBeenCalledTimes(2);
    const [firstCall, secondCall] = (createSessionMessage as jest.Mock).mock.calls;
    expect(firstCall[0].sender).toBe('user');
    expect(firstCall[0].content).toBe('Should I travel soon?');
    expect(Array.isArray(firstCall[0].metadata.keywords)).toBe(true);
    expect(firstCall[0].metadata.keywords).toEqual(expect.arrayContaining(['should', 'travel']));
    expect(secondCall[0].sender).toBe('system');
    expect(typeof secondCall[0].content).toBe('string');
    expect(secondCall[0].metadata.keywords).toEqual(expect.arrayContaining(['should', 'travel']));
  });
});

