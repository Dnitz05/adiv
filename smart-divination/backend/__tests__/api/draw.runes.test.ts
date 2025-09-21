jest.mock('nanoid', () => ({ nanoid: () => 'test_nanoid' }));
// Tests for /api/draw/runes (canonical)
// eslint-disable-next-line @typescript-eslint/no-var-requires
const handler = require('../../pages/api/draw/runes').default as (
  req: any,
  res: any
) => void | Promise<void>;
import { invokeNodeHandler } from '../../test_utils/invokeNodeHandler';

describe('API /api/draw/runes (canonical)', () => {
  it('returns 405 on non-POST', async () => {
    const res = await invokeNodeHandler(handler, 'GET', { path: '/api/draw/runes' });
    expect(res.status).toBe(405);
  });

  it('returns a valid response on POST', async () => {
    const res = await invokeNodeHandler(handler, 'POST', {
      path: '/api/draw/runes',
      body: { count: 3, seed: 'runes-seed' },
    });
    expect(res.status).toBe(200);
    const json = (await res.json()) as any;
    expect(Array.isArray(json.result)).toBe(true);
    expect(json.result.length).toBe(3);
  });
});


