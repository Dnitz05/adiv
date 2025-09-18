// Method handling tests for users endpoints (canonical)
jest.mock('nanoid', () => ({ nanoid: () => 'test_nanoid' }));
// eslint-disable-next-line @typescript-eslint/no-var-requires
const premiumHandler = require('../../pages/api/users/[userId]/premium').default as (req: any) => Promise<Response>;
// eslint-disable-next-line @typescript-eslint/no-var-requires
const canStartHandler = require('../../pages/api/users/[userId]/can-start-session').default as (req: any) => Promise<Response>;
import { makeRequest } from '../../test_utils/makeRequest';

describe('API /api/users endpoints method handling (canonical)', () => {
  it('GET only on /api/users/[userId]/premium', async () => {
    const res = await premiumHandler(
      makeRequest('POST', { path: '/api/users/some-user/premium' })
    );
    expect(res.status).toBe(405);
  });

  it('GET only on /api/users/[userId]/can-start-session', async () => {
    const res = await canStartHandler(
      makeRequest('POST', { path: '/api/users/some-user/can-start-session' })
    );
    expect(res.status).toBe(405);
  });
});
