// Tests for /api/draw/cards (canonical)
// Keep simple to validate contract shape and method handling
// eslint-disable-next-line @typescript-eslint/no-var-requires
const handler = require('../../pages/api/draw/cards').default as (
  req: any,
  res: any
) => void | Promise<void>;
import { invokeNodeHandler } from '../../test_utils/invokeNodeHandler';

describe('API /api/draw/cards (canonical)', () => {
  it('returns 405 on non-POST', async () => {
    const res = await invokeNodeHandler(handler, 'GET', { path: '/api/draw/cards' });
    expect(res.status).toBe(405);
  });

  it('returns a valid response on POST', async () => {
    const body = { count: 3, allow_reversed: true, seed: 'seed123' };
    const res = await invokeNodeHandler(handler, 'POST', {
      path: '/api/draw/cards',
      body,
    });
    expect(res.status).toBe(200);
    const json = (await res.json()) as any;
    expect(json).toHaveProperty('result');
    expect(Array.isArray(json.result)).toBe(true);
    expect(json.result.length).toBe(3);
    for (const c of json.result) {
      expect(typeof c.id).toBe('string');
      expect(typeof c.upright).toBe('boolean');
      expect(typeof c.position).toBe('number');
    }
    expect(json).toHaveProperty('seed');
    expect(json).toHaveProperty('timestamp');
    expect(json).toHaveProperty('locale');
  });
});

