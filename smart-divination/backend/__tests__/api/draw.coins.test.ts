// Tests for /api/draw/coins (canonical)
// eslint-disable-next-line @typescript-eslint/no-var-requires
const handler = require('../../pages/api/draw/coins').default as (
  req: any,
  res: any
) => void | Promise<void>;
import { invokeNodeHandler } from '../../test_utils/invokeNodeHandler';

describe('API /api/draw/coins (canonical)', () => {
  it('returns 405 on non-POST', async () => {
    const res = await invokeNodeHandler(handler, 'GET', { path: '/api/draw/coins' });
    expect(res.status).toBe(405);
  });

  it('returns a valid response on POST', async () => {
    const res = await invokeNodeHandler(handler, 'POST', {
      path: '/api/draw/coins',
      body: { count: 6, allow_reversed: false, seed: 'coins-seed' },
    });
    expect(res.status).toBe(200);
    const json = (await res.json()) as any;
    expect(json).toHaveProperty('result.lines');
    expect(Array.isArray(json.result.lines)).toBe(true);
    expect(json.result.lines.length).toBe(6);
    expect(json).toHaveProperty('seed');
    expect(json).toHaveProperty('timestamp');
    expect(json).toHaveProperty('locale');
  });
});



