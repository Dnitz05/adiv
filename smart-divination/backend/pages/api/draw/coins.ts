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
          message: 'Only POST method is allowed for draw/coins',
          timestamp: new Date().toISOString(),
        },
      }),
      { status: 405, headers: { 'content-type': 'application/json' } }
    );
  }

  try {
    const raw = await req.text();
    const payload = raw ? JSON.parse(raw) : {};

    const rounds = Math.max(1, Math.min(6, Number(payload?.rounds ?? 6)));
    let seed: string;
    if (typeof payload?.seed === 'string' && payload.seed.length > 0) {
      seed = payload.seed;
    } else {
      seed = generateSeed();
    }
    const locale: string = (req.headers?.get?.('x-locale') as string) || 'en';

    const lines = generateIChingLines(rounds, seed);
    const changingLines = lines
      .map((v, i) => ({ v, i: i + 1 }))
      .filter(({ v }) => v === 6 || v === 9)
      .map(({ i }) => i);
    const primaryHex = computeHexagram(lines);
    const resultLines = applyChanging(lines);
    const resultHex = changingLines.length > 0 ? computeHexagram(resultLines) : undefined;

    const response = {
      result: {
        lines,
        primary_hex: primaryHex,
        changing_lines: changingLines,
        ...(resultHex ? { result_hex: resultHex } : {}),
      },
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
      meta: { processingTimeMs: Date.now() - start },
    };
    return new Response(JSON.stringify(body), {
      status: 400,
      headers: { 'content-type': 'application/json' },
    });
  }
}

function generateSeed(): string {
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

// Generate 6..9 line values according to coin method distribution:
// mapping of 3-coin outcomes (0..7) -> [6,7,7,7,8,8,8,9]
function generateIChingLines(rounds: number, seed: string): number[] {
  const map = [6, 7, 7, 7, 8, 8, 8, 9];
  const rnd = mulberry32(hashSeed(seed));
  const lines: number[] = [];
  for (let i = 0; i < rounds; i++) {
    const roll = Math.floor(rnd() * 8);
    lines.push(map[roll]);
  }
  return lines;
}

function computeHexagram(lines: number[]): number {
  // 0 = yin (6 or 8), 1 = yang (7 or 9). Bottom line is index 0.
  let v = 0;
  for (let i = 0; i < Math.min(6, lines.length); i++) {
    const bit = lines[i] === 7 || lines[i] === 9 ? 1 : 0;
    v |= bit << i;
  }
  // simple binary index (non King-Wen). Add 1 to make range 1..64.
  return (v % 64) + 1;
}

function applyChanging(lines: number[]): number[] {
  return lines.map((v) => (v === 6 ? 7 : v === 9 ? 8 : v));
}
