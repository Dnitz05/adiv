// Temporary delegation to legacy handler during migration
export default async function handler(req: any): Promise<Response> {
  const start = Date.now();

  if (req.method === 'OPTIONS') {
    return new Response(null, { status: 204 });
  }
  if (req.method !== 'POST') {
    return new Response(
      JSON.stringify({
        success: false,
        error: {
          code: 'METHOD_NOT_ALLOWED',
          message: 'Only POST method is allowed for draw/cards',
          timestamp: new Date().toISOString(),
        },
      }),
      { status: 405, headers: { 'content-type': 'application/json' } }
    );
  }

  try {
    const raw = await req.text();
    const payload = raw ? JSON.parse(raw) : {};

    const count = Math.max(1, Math.min(78, Number(payload?.count ?? 1)));
    const allowReversed = Boolean(payload?.allow_reversed ?? true);
    let seed: string;
    if (typeof payload?.seed === 'string' && payload.seed.length > 0) {
      seed = payload.seed;
    } else {
      seed = generateSeed();
    }
    const locale: string = (req.headers?.get?.('x-locale') as string) || 'en';

    const indices = generateUniqueIndices(78, count, seed);
    const results = indices.map((idx: number, i: number) => ({
      id: `card_${idx}`,
      upright: allowReversed ? randomBoolFromSeed(seed, idx) : true,
      position: i + 1,
    }));

    const response = {
      result: results,
      seed,
      timestamp: new Date().toISOString(),
      locale,
    };

    return new Response(JSON.stringify(response), {
      status: 200,
      headers: { 'content-type': 'application/json' },
    });
  } catch (error) {
    const body = {
      success: false,
      error: {
        code: 'INVALID_REQUEST',
        message: 'Failed to parse request body',
        timestamp: new Date().toISOString(),
        details: error instanceof Error ? error.message : String(error),
      },
      meta: {
        processingTimeMs: Date.now() - start,
      },
    };
    return new Response(JSON.stringify(body), {
      status: 400,
      headers: { 'content-type': 'application/json' },
    });
  }
}

function generateSeed(): string {
  // Node crypto may not be available in all runtimes; fallback to Math.random
  try {
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    const crypto = require('node:crypto');
    return crypto.randomBytes(16).toString('hex');
  } catch {
    return Math.random().toString(36).slice(2) + Date.now().toString(36);
  }
}

function mulberry32(a: number) {
  return function () {
    let t = (a += 0x6d2b79f5);
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function hashSeed(seed: string): number {
  let h = 2166136261 >>> 0;
  for (let i = 0; i < seed.length; i++) {
    h ^= seed.charCodeAt(i);
    h = Math.imul(h, 16777619);
  }
  return h >>> 0;
}

function generateUniqueIndices(deckSize: number, count: number, seed: string): number[] {
  const rnd = mulberry32(hashSeed(seed));
  const indices = Array.from({ length: deckSize }, (_, i) => i);
  // Fisher-Yates shuffle (partial)
  for (let i = deckSize - 1; i > deckSize - 1 - count; i--) {
    const j = Math.floor(rnd() * (i + 1));
    [indices[i], indices[j]] = [indices[j], indices[i]];
  }
  return indices.slice(deckSize - count);
}

function randomBoolFromSeed(seed: string, salt: number): boolean {
  const rnd = mulberry32((hashSeed(seed) + salt) >>> 0);
  return rnd() >= 0.5;
}
