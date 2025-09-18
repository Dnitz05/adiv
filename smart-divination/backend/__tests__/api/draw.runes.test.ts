// Tests for /api/draw/runes (canonical)
jest.mock('nanoid', () => ({ nanoid: () => 'test_nanoid' }));
// eslint-disable-next-line @typescript-eslint/no-var-requires
const handler = require('../../pages/api/draw/runes').default as (req: any) => Promise<Response>;
import { makeRequest } from '../../test_utils/makeRequest';

describe('API /api/draw/runes (canonical)', () => {
  it('returns 405 on non-POST', async () => {
    const res = await handler(makeRequest('GET', { path: '/api/draw/runes' }));
    expect(res.status).toBe(405);
  });

  it('returns a valid runes draw on POST', async () => {
    const body = { count: 3, allow_reversed: true, seed: 'seed123' };
    const req = makeRequest('POST', { path: '/api/draw/runes', body });
    const res = await handler(req);
    expect(res.status).toBe(200);
    const json = (await res.json()) as any;
    expect(json).toHaveProperty('result');
    expect(Array.isArray(json.result)).toBe(true);
    expect(json.result.length).toBe(3);
    for (const r of json.result) {
      expect(typeof r.id).toBe('string');
      expect(typeof r.reversed).toBe('boolean');
      expect(typeof r.position).toBe('number');
    }
    expect(json).toHaveProperty('seed');
    expect(json).toHaveProperty('timestamp');
    expect(json).toHaveProperty('locale');
  });
});
