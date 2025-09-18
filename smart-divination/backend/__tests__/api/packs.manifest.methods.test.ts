// Method handling test for pack manifest endpoint (canonical)
jest.mock('nanoid', () => ({ nanoid: () => 'test_nanoid' }));
// eslint-disable-next-line @typescript-eslint/no-var-requires
const handler = require('../../pages/api/packs/[packId]/manifest').default as (req: any) => Promise<Response>;
import { makeRequest } from '../../test_utils/makeRequest';

describe('API /api/packs/[packId]/manifest method handling (canonical)', () => {
  it('GET only', async () => {
    const res = await handler(makeRequest('POST', { path: '/api/packs/tarot/manifest' }));
    expect(res.status).toBe(405);
  });
});
