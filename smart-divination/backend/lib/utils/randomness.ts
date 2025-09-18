import crypto from 'crypto';
import { log } from './api';

export interface RandomnessRequest {
  count: number;
  min: number;
  max: number;
  seed?: string;
  method?: 'random_org' | 'crypto_secure' | 'seeded';
  metadata?: Record<string, any>;
}

export interface RandomnessResponse {
  values: number[];
  seed: string;
  method: 'random_org' | 'crypto_secure' | 'seeded';
  timestamp: string;
  randomOrgData?: any;
  signature?: string;
  processingTimeMs: number;
}

export interface RandomOrgSignedResponse {
  random: {
    method: string;
    hashedApiKey: string;
    n: number;
    min: number;
    max: number;
    replacement: boolean;
    base: number;
    data: number[];
    completionTime: string;
    serialNumber: number;
  };
  signature: string;
}

function generateRequestId(): string {
  return `${Date.now()}_${crypto.randomBytes(4).toString('hex')}`;
}

function generateCryptographicSeed(length: number = 32): string {
  return crypto.randomBytes(length).toString('base64url');
}

function validateRandomnessRequest(request: RandomnessRequest): void {
  if (!Number.isInteger(request.count) || request.count < 1 || request.count > 10000) {
    throw new Error('Count must be an integer between 1 and 10000');
  }
  if (!Number.isInteger(request.min) || !Number.isInteger(request.max)) {
    throw new Error('Min and max must be integers');
  }
  if (request.min >= request.max) {
    throw new Error('Min must be less than max');
  }
  if (request.max - request.min > 1000000) {
    throw new Error('Range too large for efficient generation');
  }
  if (request.seed && request.seed.length < 8) {
    throw new Error('Seed must be at least 8 characters');
  }
}

function seededRng(seed: string): () => number {
  let h = 1779033703 ^ seed.length;
  for (let i = 0; i < seed.length; i++) {
    h = Math.imul(h ^ seed.charCodeAt(i), 3432918353);
    h = (h << 13) | (h >>> 19);
  }
  let t = () => {
    h = Math.imul(h ^ (h >>> 16), 2246822507);
    h = Math.imul(h ^ (h >>> 13), 3266489909);
    h ^= h >>> 16;
    return (h >>> 0) / 4294967296;
  };
  t(); t();
  return t;
}

function generateWithCryptoSecure(request: RandomnessRequest): RandomnessResponse {
  const start = Date.now();
  const seed = request.seed || generateCryptographicSeed();
  const values: number[] = [];
  for (let i = 0; i < request.count; i++) {
    const rand = crypto.randomInt(request.min, request.max + 1);
    values.push(rand);
  }
  return {
    values,
    seed,
    method: 'crypto_secure',
    timestamp: new Date().toISOString(),
    processingTimeMs: Date.now() - start,
  };
}

function generateWithSeeded(request: RandomnessRequest): RandomnessResponse {
  const start = Date.now();
  const seed = request.seed || generateCryptographicSeed();
  const rng = seededRng(seed);
  const values: number[] = [];
  for (let i = 0; i < request.count; i++) {
    const r = rng();
    const val = request.min + Math.floor(r * (request.max - request.min + 1));
    values.push(val);
  }
  return {
    values,
    seed,
    method: 'seeded',
    timestamp: new Date().toISOString(),
    processingTimeMs: Date.now() - start,
  };
}

function generateSeedFromSignature(signature: string): string {
  const hash = crypto.createHash('sha256').update(signature).digest('base64url');
  return hash.substring(0, 32);
}

async function generateWithRandomOrg(request: RandomnessRequest): Promise<RandomnessResponse> {
  const startTime = Date.now();
  const apiKey = process.env.RANDOM_ORG_KEY || process.env.RANDOM_ORG_API_KEY;
  if (!apiKey) throw new Error('Random.org API key not configured');

  const payload = {
    jsonrpc: '2.0',
    method: 'generateSignedIntegers',
    params: {
      apiKey,
      n: request.count,
      min: request.min,
      max: request.max,
      replacement: true,
      base: 10,
      userData: {
        technique: request.metadata?.technique || 'unknown',
        timestamp: new Date().toISOString(),
        seed: request.seed || null,
      },
    },
    id: generateRequestId(),
  };

  log('debug', 'Calling Random.org API', { count: request.count, range: [request.min, request.max] });
  const response = await fetch('https://api.random.org/json-rpc/4/invoke', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!response.ok) throw new Error(`Random.org API error: ${response.status} ${response.statusText}`);
  const data = await response.json();
  if (data.error) throw new Error(`Random.org API error: ${data.error.message}`);

  const result: RandomOrgSignedResponse = data.result;
  const processingTimeMs = Date.now() - startTime;
  const seed = request.seed || generateSeedFromSignature(result.signature);
  log('info', 'Random.org API success', { count: result.random.data.length, processingTimeMs });

  return {
    values: result.random.data,
    seed,
    method: 'random_org',
    timestamp: new Date().toISOString(),
    randomOrgData: result,
    signature: result.signature,
    processingTimeMs,
  };
}

export async function verifyRandomOrgSignature(signedData: RandomOrgSignedResponse): Promise<boolean> {
  try {
    const res = await fetch('https://api.random.org/json-rpc/4/invoke', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        jsonrpc: '2.0',
        method: 'verifySignature',
        params: { random: signedData.random, signature: signedData.signature },
        id: generateRequestId(),
      }),
    });
    if (!res.ok) return false;
    const data = await res.json();
    return data.result?.authenticity === true;
  } catch (e) {
    log('warn', 'Random.org signature verification failed', { error: String(e) });
    return false;
  }
}

export async function generateRandomIntegers(request: RandomnessRequest): Promise<RandomnessResponse> {
  validateRandomnessRequest(request);
  const preferred = request.method;
  if (preferred === 'seeded') return generateWithSeeded(request);
  if (preferred === 'crypto_secure') return generateWithCryptoSecure(request);
  try {
    if (process.env.RANDOM_ORG_KEY || process.env.RANDOM_ORG_API_KEY) {
      return await generateWithRandomOrg(request);
    }
  } catch (error: any) {
    log('warn', 'Random.org failed, falling back to crypto', { error: error?.message ?? String(error) });
  }
  return generateWithCryptoSecure(request);
}

export function decodeTarotCard(encodedValue: number): { cardIndex: number; isReversed: boolean } {
  const cardIndex = encodedValue >> 1;
  const isReversed = (encodedValue & 1) === 1;
  return { cardIndex, isReversed };
}

export function decodeIChingLine(lineValue: number): { type: 'yin' | 'yang'; isChanging: boolean } {
  switch (lineValue) {
    case 6: return { type: 'yin', isChanging: true };
    case 7: return { type: 'yang', isChanging: false };
    case 8: return { type: 'yin', isChanging: false };
    case 9: return { type: 'yang', isChanging: true };
    default: throw new Error(`Invalid I Ching line value: ${lineValue}`);
  }
}

export function decodeRune(encodedValue: number): { runeIndex: number; isReversed: boolean } {
  const runeIndex = encodedValue >> 1;
  const isReversed = (encodedValue & 1) === 1;
  return { runeIndex, isReversed };
}

export async function checkRandomOrgHealth(): Promise<{ status: 'healthy' | 'unhealthy'; responseTime: number; error?: string }>{
  const startTime = Date.now();
  try {
    const res = await generateRandomIntegers({ count: 1, min: 1, max: 2, method: 'random_org' });
    const ms = Date.now() - startTime;
    return { status: res.method === 'random_org' ? 'healthy' : 'unhealthy', responseTime: ms };
  } catch (e: any) {
    const ms = Date.now() - startTime;
    return { status: 'unhealthy', responseTime: ms, error: e?.message ?? String(e) };
  }
}
