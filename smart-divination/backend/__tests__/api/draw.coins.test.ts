// Tests for /api/draw/coins (canonical)
// eslint-disable-next-line @typescript-eslint/no-var-requires
const handler = require('../../pages/api/draw/coins').default as (req: any) => Promise<Response>;
import { makeRequest } from '../../test_utils/makeRequest';

describe('API /api/draw/coins (canonical)', () => {
  it('returns 405 on non-POST', async () => {
    const res = await handler(makeRequest('GET', { path: '/api/draw/coins' }));
    expect(res.status).toBe(405);
  });

  it('returns valid iching result on POST', async () => {
    const body = { rounds: 6, seed: 'seed123' };
    const req = makeRequest('POST', { path: '/api/draw/coins', body });
    const res = await handler(req);
    expect(res.status).toBe(200);
    const json = (await res.json()) as any;
    expect(json).toHaveProperty('result');
    expect(json.result).toHaveProperty('lines');
    expect(Array.isArray(json.result.lines)).toBe(true);
    expect(json.result.lines.length).toBe(6);
    for (const n of json.result.lines) {
      expect([6, 7, 8, 9]).toContain(n);
    }
    expect(json.result).toHaveProperty('primary_hex');
    expect(json.result).toHaveProperty('changing_lines');
    expect(Array.isArray(json.result.changing_lines)).toBe(true);
  });
});

