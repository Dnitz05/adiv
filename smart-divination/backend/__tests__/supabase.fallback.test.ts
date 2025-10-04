import { jest } from '@jest/globals';

describe('supabase utils fallback', () => {
  const originalEnv = process.env;

  beforeEach(() => {
    jest.resetModules();
    jest.unmock('../lib/utils/supabase');
    process.env = { ...originalEnv };
    delete process.env.SUPABASE_URL;
    delete process.env.SUPABASE_SERVICE_ROLE_KEY;
  });

  afterEach(() => {
    process.env = originalEnv;
  });

  it('returns an in-memory session when Supabase credentials are missing', async () => {
    const supabaseModule = await import('../lib/utils/supabase');
    const session = await supabaseModule.createDivinationSession({
      userId: 'user-test',
      technique: 'tarot',
      locale: 'en',
      question: 'What should I focus on?',
      results: {
        cards: [
          {
            id: 'card_0',
            name: 'The Fool',
            suit: 'major',
            number: 0,
            upright: true,
            position: 1,
          },
        ],
        spread: 'single_card',
      },
      metadata: {
        seed: 'fallback-seed',
        method: 'secure_rng',
      },
    });

    expect(session.userId).toBe('user-test');
    expect(session.id).toContain('tarot_');
    expect(session.artifacts).toBeDefined();
    expect(session.artifacts && session.artifacts[0].payload.cards).toHaveLength(1);
    expect(session.artifacts && session.artifacts[0].payload.seed).toBe('fallback-seed');
    expect(session.artifacts && session.artifacts[0].payload.method).toBe('secure_rng');
  });
});
