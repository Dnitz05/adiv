// Method handling tests for sessions endpoints (canonical)
jest.mock('nanoid', () => ({ nanoid: () => 'test_nanoid' }));
// eslint-disable-next-line @typescript-eslint/no-var-requires
const rootHandler = require('../../pages/api/sessions').default as (req: any) => Promise<Response>;
// eslint-disable-next-line @typescript-eslint/no-var-requires
const userHandler = require('../../pages/api/sessions/[userId]').default as (req: any) => Promise<Response>;
// eslint-disable-next-line @typescript-eslint/no-var-requires
const detailHandler = require('../../pages/api/sessions/detail/[sessionId]').default as (req: any) => Promise<Response>;
import { makeRequest } from '../../test_utils/makeRequest';

describe('API /api/sessions method handling (canonical)', () => {
  it('POST allowed, GET not allowed on /api/sessions', async () => {
    const res = await rootHandler(makeRequest('GET', { path: '/api/sessions' }));
    expect(res.status).toBe(405);
  });

  it('GET allowed, POST not allowed on /api/sessions/[userId]', async () => {
    const res = await userHandler(makeRequest('POST', { path: '/api/sessions/test-user' }));
    expect(res.status).toBe(405);
  });

  it('GET allowed, POST not allowed on /api/sessions/detail/[sessionId]', async () => {
    const res = await detailHandler(
      makeRequest('POST', { path: '/api/sessions/detail/session_123' })
    );
    expect(res.status).toBe(405);
  });
});
