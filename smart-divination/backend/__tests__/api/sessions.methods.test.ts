// Method handling tests for sessions endpoints (canonical)
jest.mock('../../lib/utils/api', () => {
  const actual = jest.requireActual('../../lib/utils/api');
  return { ...actual, createRequestId: () => 'test_request_id' };
});
// eslint-disable-next-line @typescript-eslint/no-var-requires
const rootHandler = require('../../pages/api/sessions').default as (
  req: any,
  res: any
) => void | Promise<void>;
// eslint-disable-next-line @typescript-eslint/no-var-requires
const userHandler = require('../../pages/api/sessions/[userId]').default as (
  req: any,
  res: any
) => void | Promise<void>;
// eslint-disable-next-line @typescript-eslint/no-var-requires
const detailHandler = require('../../pages/api/sessions/detail/[sessionId]').default as (
  req: any,
  res: any
) => void | Promise<void>;
import { invokeNodeHandler } from '../../test_utils/invokeNodeHandler';

describe('API /api/sessions method handling (canonical)', () => {
  it('POST allowed, GET not allowed on /api/sessions', async () => {
    const res = await invokeNodeHandler(rootHandler, 'GET', { path: '/api/sessions' });
    expect(res.status).toBe(405);
  });

  it('GET allowed, POST not allowed on /api/sessions/[userId]', async () => {
    const res = await invokeNodeHandler(userHandler, 'POST', {
      path: '/api/sessions/test-user',
    });
    expect(res.status).toBe(405);
  });

  it('GET allowed, POST not allowed on /api/sessions/detail/[sessionId]', async () => {
    const res = await invokeNodeHandler(detailHandler, 'POST', {
      path: '/api/sessions/detail/session_123',
    });
    expect(res.status).toBe(405);
  });
});

