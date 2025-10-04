
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
    getUserSessions: jest.fn(),
  };
});
const handler = require('../../pages/api/users/[userId]/profile').default as (
  req: any,
  res: any
) => void | Promise<void>;
import { getUserSessions } from '../../lib/utils/supabase';
import { invokeNodeHandler } from '../../test_utils/invokeNodeHandler';

const AUTH_HEADERS = { authorization: 'Bearer test-access-token' };

describe('API /api/users/[userId]/profile', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    delete process.env.SUPABASE_URL;
    delete process.env.SUPABASE_SERVICE_ROLE_KEY;
  });

  it('returns 405 on non-GET', async () => {
    const res = await invokeNodeHandler(handler, 'POST', {
      path: '/api/users/test-user/profile',
      query: { userId: 'test-user' },
      headers: AUTH_HEADERS,
    });
    expect(res.status).toBe(405);
  });

  it('returns 400 when userId missing', async () => {
    const res = await invokeNodeHandler(handler, 'GET', {
      path: '/api/users/profile',
      query: {},
      headers: AUTH_HEADERS,
    });
    expect(res.status).toBe(400);
  });

  it('returns 503 when Supabase credentials missing', async () => {
    const res = await invokeNodeHandler(handler, 'GET', {
      path: '/api/users/test-user/profile',
      query: { userId: 'test-user' },
      headers: AUTH_HEADERS,
    });
    expect(res.status).toBe(503);
  });

  it('returns empty profile when user has no sessions', async () => {
    process.env.SUPABASE_URL = 'https://example.supabase.co';
    process.env.SUPABASE_SERVICE_ROLE_KEY = 'service-key';

    (getUserSessions as jest.Mock).mockResolvedValue([]);

    const res = await invokeNodeHandler(handler, 'GET', {
      path: '/api/users/test-user/profile',
      query: { userId: 'test-user' },
      headers: AUTH_HEADERS,
    });

    expect(res.status).toBe(200);
    const payload = await res.json();
    expect(payload.success).toBe(true);
    expect(payload.data.sessionCount).toBe(0);
    expect(payload.data.keywords).toEqual([]);
  });

  it('aggregates keywords and techniques from sessions', async () => {
    process.env.SUPABASE_URL = 'https://example.supabase.co';
    process.env.SUPABASE_SERVICE_ROLE_KEY = 'service-key';

    const now = new Date().toISOString();
    (getUserSessions as jest.Mock).mockResolvedValue([
      {
        id: 'session-1',
        userId: 'test-user',
        technique: 'tarot',
        locale: 'en',
        createdAt: now,
        lastActivity: now,
        question: 'Should I travel soon?',
        results: { cards: [] },
        interpretation: 'Travel looks favourable.',
        interpretationSummary: 'Favourable travel',
        keywords: ['travel', 'favourable'],
      },
      {
        id: 'session-2',
        userId: 'test-user',
        technique: 'tarot',
        locale: 'en',
        createdAt: now,
        lastActivity: now,
        question: null,
        results: { cards: [] },
        interpretation: 'Focus on balance.',
        interpretationSummary: 'Seek balance',
        keywords: ['balance', 'travel'],
      },
    ]);

    const res = await invokeNodeHandler(handler, 'GET', {
      path: '/api/users/test-user/profile',
      query: { userId: 'test-user' },
      headers: AUTH_HEADERS,
    });

    expect(getUserSessions).toHaveBeenCalledWith('test-user', expect.objectContaining({ limit: 50 }));
    expect(res.status).toBe(200);
    const payload = await res.json();
    expect(payload.data.sessionCount).toBe(2);
    expect(payload.data.recentQuestion).toBe('Should I travel soon?');
    expect(payload.data.topKeywords[0].value).toBe('travel');
    expect(payload.data.topKeywords[0].count).toBe(2);
    expect(payload.data.techniqueCounts[0]).toEqual({ value: 'tarot', count: 2 });
  });
});
