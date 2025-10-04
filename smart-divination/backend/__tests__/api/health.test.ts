jest.mock('../../lib/utils/supabase', () => {
  const actual = jest.requireActual('../../lib/utils/supabase');
  return { ...actual, checkSupabaseHealth: jest.fn().mockResolvedValue({ status: 'healthy', responseTime: 5 }) };
});
jest.mock('../../lib/utils/randomness', () => {
  const actual = jest.requireActual('../../lib/utils/randomness');
  return { ...actual, checkRandomOrgHealth: jest.fn().mockResolvedValue({ status: 'healthy', responseTime: 2 }) };
});
// Tests for /api/health (canonical) using NextApi handler
const handler = require('../../pages/api/health').default as (
  req: any,
  res: any
) => void | Promise<void>;
import { invokeNodeHandler } from '../../test_utils/invokeNodeHandler';

describe('API /api/health (canonical)', () => {
  it('returns status and data on GET', async () => {
    const res = await invokeNodeHandler(handler, 'GET', { path: '/api/health' });
    expect(res.status).toBe(200);
    const json = await res.json();
    expect(json).toHaveProperty('success', true);
    expect(json).toHaveProperty('data.status');
  });

  it('returns 405 on non-GET', async () => {
    const res = await invokeNodeHandler(handler, 'POST', { path: '/api/health' });
    expect(res.status).toBe(405);
  });
});
