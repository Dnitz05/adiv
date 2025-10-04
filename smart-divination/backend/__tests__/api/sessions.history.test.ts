
import type { DivinationSession } from '../../lib/types/api';
import { invokeNodeHandler } from '../../test_utils/invokeNodeHandler';
import { getUserSessions } from '../../lib/utils/supabase';

jest.mock('../../lib/utils/api', () => {
  const actual = jest.requireActual('../../lib/utils/api');
  return { ...actual, createRequestId: () => 'test_request_id' };
});

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

const handler = require('../../pages/api/sessions/[userId]').default as (
  req: any,
  res: any,
) => void | Promise<void>;

const AUTH_HEADERS = { authorization: 'Bearer test-access-token' };

describe('API /api/sessions/[userId] history handler', () => {
  let warnSpy: jest.SpyInstance;

  beforeEach(() => {
    jest.clearAllMocks();
    warnSpy = jest.spyOn(console, 'warn').mockImplementation(() => undefined);
    delete process.env.SUPABASE_URL;
    delete process.env.SUPABASE_SERVICE_ROLE_KEY;
  });

  afterEach(() => {
    warnSpy.mockRestore();
  });

  it('returns empty list when Supabase credentials are missing', async () => {
    const res = await invokeNodeHandler(handler, 'GET', {
      path: '/api/sessions/test-user',
      query: { userId: 'test-user' },
      headers: AUTH_HEADERS,
    });

    expect(res.status).toBe(200);
    const payload = await res.json();
    expect(payload.success).toBe(true);
    expect(payload.data.sessions).toEqual([]);
    expect(payload.data.limit).toBe(10);
    expect(getUserSessions).not.toHaveBeenCalled();
  });

  it('returns sessions from Supabase when credentials are available', async () => {
    process.env.SUPABASE_URL = 'https://example.supabase.co';
    process.env.SUPABASE_SERVICE_ROLE_KEY = 'service-key';

    const session: DivinationSession = {
      id: 'session-1',
      userId: 'test-user',
      technique: 'tarot',
      locale: 'en',
      createdAt: new Date().toISOString(),
      lastActivity: new Date().toISOString(),
      question: 'What awaits me?',
      results: { cards: [] },
      interpretation: null,
      summary: null,
      metadata: { seed: 'abc' },
      artifacts: [
        {
          id: 'artifact-1',
          type: 'tarot_draw',
          source: 'system',
          createdAt: new Date().toISOString(),
          version: 1,
          payload: { cards: [] },
        },
      ],
      messages: [],
    };

    (getUserSessions as jest.Mock).mockResolvedValue([session]);

    const res = await invokeNodeHandler(handler, 'GET', {
      path: '/api/sessions/test-user',
      query: {
        userId: 'test-user',
        limit: '5',
        technique: 'tarot',
        orderBy: 'created_at',
        orderDir: 'desc',
      },
      headers: AUTH_HEADERS,
    });

    expect(getUserSessions).toHaveBeenCalledWith('test-user', expect.objectContaining({
      technique: 'tarot',
      limit: 5,
      orderBy: 'created_at',
      order: 'desc',
    }));

    expect(res.status).toBe(200);
    const payload = await res.json();
    expect(payload.success).toBe(true);
    expect(payload.data.sessions).toHaveLength(1);
    expect(payload.data.sessions[0].id).toBe('session-1');
    expect(payload.data.limit).toBe(5);
    expect(payload.data.hasMore).toBe(false);
  });
});
