
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
    getSession: jest.fn(),
  };
});
const handler = require('../../pages/api/sessions/detail/[sessionId]').default as (
  req: any,
  res: any
) => void | Promise<void>;
import { getSession } from '../../lib/utils/supabase';
import { invokeNodeHandler } from '../../test_utils/invokeNodeHandler';

const AUTH_HEADERS = { authorization: 'Bearer test-access-token' };

describe('API /api/sessions/detail/[sessionId]', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    delete process.env.SUPABASE_URL;
    delete process.env.SUPABASE_SERVICE_ROLE_KEY;
  });

  it('returns 405 on non-GET', async () => {
    const res = await invokeNodeHandler(handler, 'POST', {
      path: '/api/sessions/detail/session-1',
      query: { sessionId: 'session-1' },
      headers: AUTH_HEADERS,
    });
    expect(res.status).toBe(405);
  });

  it('returns 400 when sessionId missing', async () => {
    const res = await invokeNodeHandler(handler, 'GET', {
      path: '/api/sessions/detail',
      query: {},
      headers: AUTH_HEADERS,
    });
    expect(res.status).toBe(400);
  });

  it('returns 503 when Supabase credentials are missing', async () => {
    const res = await invokeNodeHandler(handler, 'GET', {
      path: '/api/sessions/detail/session-1',
      query: { sessionId: 'session-1' },
      headers: AUTH_HEADERS,
    });
    expect(res.status).toBe(503);
  });

  it('returns 404 when session not found', async () => {
    process.env.SUPABASE_URL = 'https://example.supabase.co';
    process.env.SUPABASE_SERVICE_ROLE_KEY = 'service-key';

    (getSession as jest.Mock).mockResolvedValue(null);

    const res = await invokeNodeHandler(handler, 'GET', {
      path: '/api/sessions/detail/session-404',
      query: { sessionId: 'session-404' },
      headers: AUTH_HEADERS,
    });

    expect(getSession).toHaveBeenCalledWith('session-404');
    expect(res.status).toBe(404);
  });

  it('returns session detail when available', async () => {
    process.env.SUPABASE_URL = 'https://example.supabase.co';
    process.env.SUPABASE_SERVICE_ROLE_KEY = 'service-key';

    (getSession as jest.Mock).mockResolvedValue({
      id: 'session-2',
      userId: 'test-user',
      technique: 'tarot',
      locale: 'en',
      createdAt: new Date().toISOString(),
      lastActivity: new Date().toISOString(),
      question: 'What awaits me?',
      metadata: null,
      results: { cards: [] },
      artifacts: [],
      messages: [],
    });

    const res = await invokeNodeHandler(handler, 'GET', {
      path: '/api/sessions/detail/session-2',
      query: { sessionId: 'session-2' },
      headers: AUTH_HEADERS,
    });

    expect(getSession).toHaveBeenCalledWith('session-2');
    expect(res.status).toBe(200);
    const payload = await res.json();
    expect(payload.success).toBe(true);
    expect(payload.data.id).toBe('session-2');
    expect(payload.data.technique).toBe('tarot');
  });
});
