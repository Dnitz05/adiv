// Basic health endpoint tests
// Mock ESM-only deps to avoid Jest parse issues
jest.mock('nanoid', () => ({ nanoid: () => 'test_nanoid' }));
// Import handler via relative path to pages
// eslint-disable-next-line @typescript-eslint/no-var-requires
const handler = require('../../pages/api/health').default as (req: any) => Promise<Response>;
import { makeRequest } from '../../test_utils/makeRequest';

describe('API /api/health', () => {
  it('returns status and data on GET', async () => {
    const res = await handler(makeRequest('GET', { path: '/api/health' }));
    expect([200, 503]).toContain(res.status);
    const json = await res.json();
    expect(json).toHaveProperty('success', true);
    expect(json).toHaveProperty('data.status');
  });

  it('returns 405 on non-GET', async () => {
    const res = await handler(makeRequest('POST', { path: '/api/health' }));
    expect(res.status).toBe(405);
  });
});
