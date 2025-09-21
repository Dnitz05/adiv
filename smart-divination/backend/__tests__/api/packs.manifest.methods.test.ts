jest.mock('nanoid', () => ({ nanoid: () => 'test_nanoid' }));
// Method handling test for packs manifest endpoint (canonical)
// eslint-disable-next-line @typescript-eslint/no-var-requires
const handler = require('../../pages/api/packs/[packId]/manifest').default as (
  req: any,
  res: any
) => void | Promise<void>;
import { invokeNodeHandler } from '../../test_utils/invokeNodeHandler';

describe('/api/packs/[packId]/manifest method handling', () => {
  it('rejects POST requests', async () => {
    const res = await invokeNodeHandler(handler, 'POST', {
      path: '/api/packs/sample-pack/manifest',
      query: { packId: 'sample-pack' },
    });
    expect(res.status).toBe(405);
  });

  it('allows GET requests', async () => {
    const res = await invokeNodeHandler(handler, 'GET', {
      path: '/api/packs/sample-pack/manifest',
      query: { packId: 'sample-pack' },
    });
    expect([200, 404]).toContain(res.status);
  });
});
