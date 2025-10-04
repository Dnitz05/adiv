import { randomUUID } from 'crypto';

import {
  describeSupabaseIntegration,
  ensureSupabaseTestHarness,
  SUPABASE_SEED_USER_ID,
} from './supabaseTestHarness';
import {
  createSession,
  createSessionArtifact,
  createSessionMessage,
  getSession,
  getSupabaseServiceClient,
  getUserSessions,
} from '../../lib/utils/supabase';

describeSupabaseIntegration('Supabase integration (session persistence)', () => {
  const createdSessionIds: string[] = [];

  beforeAll(async () => {
    await ensureSeedUser();
  });

  afterAll(async () => {
    if (!ensureSupabaseTestHarness() || createdSessionIds.length === 0) {
      return;
    }
    const client = getSupabaseServiceClient();
    for (const sessionId of createdSessionIds) {
      await client.from('sessions').delete().eq('id', sessionId);
    }
  });

  it('persists sessions, artifacts, and messages accessible via session views', async () => {
    const baseMetadata = {
      seed: `integration-${randomUUID()}`,
      method: 'integration-test',
    };
    const question = 'What does the integration test reveal?';
    const results = {
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
      cardCount: 1,
    };

    const session = await createSession({
      userId: SUPABASE_SEED_USER_ID,
      technique: 'tarot',
      locale: 'en',
      question,
      results,
      metadata: baseMetadata,
    });
    createdSessionIds.push(session.id);

    await createSessionArtifact({
      sessionId: session.id,
      type: 'tarot_draw',
      source: 'system',
      payload: {
        technique: 'tarot',
        seed: baseMetadata.seed,
        method: baseMetadata.method,
        spread: 'single_card',
        cards: results.cards,
        keywords: ['integration', 'test'],
      },
      metadata: { origin: 'jest-integration' },
    });

    await createSessionMessage({
      sessionId: session.id,
      sender: 'user',
      content: question,
      metadata: { locale: 'en', intent: 'integration-test' },
    });

    await createSessionMessage({
      sessionId: session.id,
      sender: 'assistant',
      content: 'Trust the path ahead and iterate with confidence.',
      metadata: { summary: 'integration-response' },
    });

    const fetched = await getSession(session.id);
    expect(fetched).not.toBeNull();
    expect(fetched?.artifacts?.length ?? 0).toBeGreaterThan(0);

    const [artifact] = fetched!.artifacts!;
    expect(artifact.payload.seed).toBe(baseMetadata.seed);
    expect(artifact.payload.cards?.[0]?.name).toBe('The Fool');

    expect(fetched?.messages?.length ?? 0).toBeGreaterThanOrEqual(2);
    const assistantMessage = fetched!.messages!.find((message) => message.sender === 'assistant');
    expect(assistantMessage?.content).toContain('Trust the path ahead');

    const sessions = await getUserSessions(SUPABASE_SEED_USER_ID, { limit: 1 });
    expect(sessions.length).toBeGreaterThan(0);
    expect(sessions[0].id).toBe(session.id);
    expect(sessions[0].artifacts?.length ?? 0).toBeGreaterThan(0);
  });
});

async function ensureSeedUser(): Promise<void> {
  const client = getSupabaseServiceClient();
  await client
    .from('users')
    .upsert(
      {
        id: SUPABASE_SEED_USER_ID,
        email: 'demo@smartdivination.local',
        name: 'Demo Seeker',
        tier: 'free',
        preferences: {
          locale: 'en',
          theme: 'light',
          defaultTechnique: 'tarot',
          notifications: {
            email: true,
            push: false,
            marketing: false,
          },
        },
        metadata: { seedData: true },
      },
      { onConflict: 'id' }
    );
}
