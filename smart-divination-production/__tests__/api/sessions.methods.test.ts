// Sessions method guard tests
// Mock ESM-only deps to avoid Jest parse issues
jest.mock('nanoid', () => ({ nanoid: () => 'test_nanoid' }));
// eslint-disable-next-line @typescript-eslint/no-var-requires
const handler = require('../../pages/api/sessions').default as (req: any) => Promise<Response>;
import { makeRequest } from '../../test_utils/makeRequest';

describe('API /api/sessions', () => {
  it('returns 405 for non-POST', async () => {
    const res = await handler(makeRequest('GET', { path: '/api/sessions' }));
    expect(res.status).toBe(405);
  });
});
