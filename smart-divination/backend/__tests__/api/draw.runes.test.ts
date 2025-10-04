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
  };
});

import type { NextApiHandler } from 'next';
import { invokeNodeHandler } from '../../test_utils/invokeNodeHandler';

const AUTH_HEADERS = { authorization: 'Bearer test-access-token' };

type Handler = NextApiHandler | ((req: any, res: any) => void | Promise<void>);

describe('API /api/draw/runes (canonical)', () => {
  const originalEnv = { ...process.env };

  beforeEach(() => {
    jest.resetModules();
    process.env = { ...originalEnv };
    delete process.env.SUPABASE_URL;
    delete process.env.SUPABASE_SERVICE_ROLE_KEY;
    delete process.env.SUPABASE_ANON_KEY;
    delete process.env.SUPABASE_DB_URL;
  });

  afterAll(() => {
    process.env = originalEnv;
  });

  const loadHandler = async (): Promise<Handler> => {
    const module = await import('../../pages/api/draw/runes');
    return module.default as Handler;
  };

  it('returns 405 on non-POST', async () => {
    const handler = await loadHandler();
    const res = await invokeNodeHandler(handler, 'GET', { path: '/api/draw/runes', headers: AUTH_HEADERS });
    expect(res.status).toBe(405);
  });

  describe('feature flag', () => {
    it('returns 503 when the feature is disabled', async () => {
      delete process.env.ENABLE_RUNES;
      const handler = await loadHandler();
      const res = await invokeNodeHandler(handler, 'POST', {
        path: '/api/draw/runes',
        body: { count: 3, seed: 'runes-seed' },
      });
      expect(res.status).toBe(503);
      const json = (await res.json()) as any;
      expect(json?.success).toBe(false);
      expect(json?.error?.code).toBe('TECHNIQUE_DISABLED');
    });

    it('returns a draw payload when the feature is enabled', async () => {
      process.env.ENABLE_RUNES = 'true';
      const handler = await loadHandler();
      const res = await invokeNodeHandler(handler, 'POST', {
        path: '/api/draw/runes',
        body: { count: 3, seed: 'runes-seed' },
        headers: AUTH_HEADERS,
      });
      expect(res.status).toBe(200);
      const json = (await res.json()) as any;
      expect(Array.isArray(json.result)).toBe(true);
      expect(json.result.length).toBe(3);
      expect(json).toHaveProperty('seed');
      expect(json).toHaveProperty('timestamp');
      expect(json).toHaveProperty('locale');
    });
  });
});
