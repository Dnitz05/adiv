jest.mock('../../lib/utils/api', () => {
  const actual = jest.requireActual('../../lib/utils/api');
  return { ...actual, createRequestId: () => 'test_request_id' };
});
// Method handling tests for users endpoints (canonical)
// eslint-disable-next-line @typescript-eslint/no-var-requires
const premiumHandler = require('../../pages/api/users/[userId]/premium').default as (
  req: any,
  res: any
) => void | Promise<void>;
// eslint-disable-next-line @typescript-eslint/no-var-requires
const canStartHandler = require('../../pages/api/users/[userId]/can-start-session').default as (
  req: any,
  res: any
) => void | Promise<void>;
import { invokeNodeHandler } from '../../test_utils/invokeNodeHandler';

describe('API /api/users endpoints (canonical)', () => {
  it('only allows GET on premium endpoint', async () => {
    const res = await invokeNodeHandler(premiumHandler, 'POST', {
      path: '/api/users/test-user/premium',
    });
    expect(res.status).toBe(405);
  });

  it('only allows GET on can-start-session endpoint', async () => {
    const res = await invokeNodeHandler(canStartHandler, 'POST', {
      path: '/api/users/test-user/can-start-session',
    });
    expect(res.status).toBe(405);
  });
});


