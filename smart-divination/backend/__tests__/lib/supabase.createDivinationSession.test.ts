const createClientMock = jest.fn();

jest.mock('@supabase/supabase-js', () => ({
  createClient: (...args: unknown[]) => createClientMock(...args),
}));

const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

describe('createDivinationSession', () => {
  beforeEach(() => {
    jest.resetModules();
    createClientMock.mockReset();
    process.env.SUPABASE_URL = 'https://example.supabase.co';
    process.env.SUPABASE_SERVICE_ROLE_KEY = 'service-role-key';
    process.env.SUPABASE_ANON_KEY = 'anon-key';
  });

  afterEach(() => {
    jest.resetModules();
    delete process.env.SUPABASE_URL;
    delete process.env.SUPABASE_SERVICE_ROLE_KEY;
    delete process.env.SUPABASE_ANON_KEY;
  });

  it('persists a session with a UUID identifier and returns artifact preview metadata', async () => {
    const insertedRows: Array<Record<string, any>> = [];

    const mockClient = {
      from: jest.fn(() => ({
        insert: jest.fn((row: Record<string, any>) => {
          insertedRows.push(row);
          return {
            select: jest.fn(() => ({
              single: jest.fn(async () => ({ data: row, error: null })),
            })),
          };
        }),
      })),
    };

    createClientMock.mockReturnValue(mockClient as unknown as Record<string, unknown>);

    const { createDivinationSession } = await import('../../lib/utils/supabase');

    const result = await createDivinationSession({
      userId: '00000000-0000-0000-0000-000000000999',
      technique: 'tarot',
      locale: 'en',
      question: 'What awaits me next?',
      results: {
        cards: [
          {
            id: 'major_0',
            name: 'The Fool',
            suit: 'major',
            number: 0,
            upright: true,
            position: 1,
          },
        ],
        spread: 'single',
      },
      metadata: { seed: 'abc123', method: 'secure-shuffle', signature: 'sig-1' },
    });

    expect(createClientMock).toHaveBeenCalledTimes(1);
    expect(mockClient.from).toHaveBeenCalledWith('sessions');
    expect(insertedRows).toHaveLength(1);
    const inserted = insertedRows[0];

    expect(inserted.id).toMatch(UUID_REGEX);
    expect(result.id).toBe(inserted.id);
    expect(inserted.user_id).toBe('00000000-0000-0000-0000-000000000999');
    expect(inserted.technique).toBe('tarot');

    const artifact = result.artifacts?.[0];
    expect(artifact?.id).toBe(`${result.id}-artifact-preview`);
    expect(artifact?.payload.seed).toBe('abc123');
    expect(artifact?.payload.method).toBe('secure-shuffle');
    expect(Array.isArray(artifact?.payload.cards)).toBe(true);
  });
});
