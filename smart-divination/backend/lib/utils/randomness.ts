/**
 * Randomness Service - Ultra-Professional Random Number Generation
 *
 * Provides cryptographically secure randomness with Random.org integration,
 * fallback mechanisms, seed-based reproducibility, and verification.
 */

import crypto from 'crypto';
import { log } from './api';

// =============================================================================
// TYPES & INTERFACES
// =============================================================================

export interface RandomnessRequest {
  /** Number of random integers to generate */
  count: number;
  /** Minimum value (inclusive) */
  min: number;
  /** Maximum value (inclusive) */
  max: number;
  /** Optional seed for reproducible results */
  seed?: string;
  /** Preferred method */
  method?: 'random_org' | 'crypto_secure' | 'seeded';
  /** Additional metadata */
  metadata?: Record<string, any>;
}

export interface RandomnessResponse {
  /** Generated random values */
  values: number[];
  /** Seed used for generation */
  seed: string;
  /** Method actually used */
  method: 'random_org' | 'crypto_secure' | 'seeded';
  /** Generation timestamp */
  timestamp: string;
  /** Random.org response data (if applicable) */
  randomOrgData?: any;
  /** Random.org signature (if applicable) */
  signature?: string;
  /** Processing time in milliseconds */
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

// =============================================================================
// RANDOM.ORG INTEGRATION
// =============================================================================

/**
 * Generate random numbers using Random.org API
 */
async function generateWithRandomOrg(request: RandomnessRequest): Promise<RandomnessResponse> {
  const startTime = Date.now();
  const apiKey = process.env.RANDOM_ORG_KEY || process.env.RANDOM_ORG_API_KEY;

  if (!apiKey) {
    throw new Error('Random.org API key not configured');
  }

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

  try {
    log('debug', 'Calling Random.org API', {
      count: request.count,
      range: [request.min, request.max],
    });

    const response = await fetch('https://api.random.org/json-rpc/4/invoke', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      throw new Error(`Random.org API error: ${response.status} ${response.statusText}`);
    }

    const data = await response.json();

    if (data.error) {
      throw new Error(`Random.org API error: ${data.error.message}`);
    }

    const result: RandomOrgSignedResponse = data.result;
    const processingTimeMs = Date.now() - startTime;

    // Generate seed from signature for reproducibility
    const seed = request.seed || generateSeedFromSignature(result.signature);

    log('info', 'Random.org API success', {
      count: result.random.data.length,
      serialNumber: result.random.serialNumber,
      processingTimeMs,
    });

    return {
      values: result.random.data,
      seed,
      method: 'random_org',
      timestamp: new Date().toISOString(),
      randomOrgData: result,
      signature: result.signature,
      processingTimeMs,
    };
  } catch (error) {
    const processingTimeMs = Date.now() - startTime;

    log('error', 'Random.org API failed', {
      error: error instanceof Error ? error.message : String(error),
      processingTimeMs,
    });

    throw error;
  }
}

/**
 * Verify Random.org signature
 */
export async function verifyRandomOrgSignature(
  signedData: RandomOrgSignedResponse
): Promise<boolean> {
  try {
    const response = await fetch('https://api.random.org/json-rpc/4/invoke', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        jsonrpc: '2.0',
        method: 'verifySignature',
        params: {
          random: signedData.random,
          signature: signedData.signature,
        },
        id: generateRequestId(),
      }),
    });

    if (!response.ok) return false;

    const data = await response.json();
    return data.result?.authenticity === true;
  } catch (error) {
    log('warn', 'Random.org signature verification failed', { error });
    return false;
  }
}

// =============================================================================
// CRYPTOGRAPHIC SECURE GENERATION
// =============================================================================

/**
 * Generate random numbers using cryptographically secure PRNG
 */
function generateWithCryptoSecure(request: RandomnessRequest): RandomnessResponse {
  const startTime = Date.now();

  // Use provided seed or generate one
  const seed = request.seed || generateCryptographicSeed();

  // Create deterministic generator from seed if provided
  let generator: () => number;

  if (request.seed) {
    generator = createSeededGenerator(request.seed);
  } else {
    generator = () => {
      const bytes = crypto.randomBytes(4);
      return bytes.readUInt32BE(0) / 0x100000000;
    };
  }

  const range = request.max - request.min + 1;
  const values: number[] = [];

  for (let i = 0; i < request.count; i++) {
    const randomFloat = generator();
    const randomInt = Math.floor(randomFloat * range) + request.min;
    values.push(randomInt);
  }

  const processingTimeMs = Date.now() - startTime;

  log('info', 'Crypto-secure generation complete', {
    count: values.length,
    method: request.seed ? 'seeded' : 'crypto_secure',
    processingTimeMs,
  });

  return {
    values,
    seed,
    method: 'crypto_secure',
    timestamp: new Date().toISOString(),
    processingTimeMs,
  };
}

// =============================================================================
// SEEDED GENERATION (FOR REPRODUCIBILITY)
// =============================================================================

/**
 * Generate random numbers using seeded PRNG for reproducibility
 */
function generateWithSeeded(request: RandomnessRequest): RandomnessResponse {
  const startTime = Date.now();

  if (!request.seed) {
    throw new Error('Seed is required for seeded generation');
  }

  const generator = createSeededGenerator(request.seed);
  const range = request.max - request.min + 1;
  const values: number[] = [];

  for (let i = 0; i < request.count; i++) {
    const randomFloat = generator();
    const randomInt = Math.floor(randomFloat * range) + request.min;
    values.push(randomInt);
  }

  const processingTimeMs = Date.now() - startTime;

  return {
    values,
    seed: request.seed,
    method: 'seeded',
    timestamp: new Date().toISOString(),
    processingTimeMs,
  };
}

// =============================================================================
// MAIN GENERATION FUNCTION
// =============================================================================

/**
 * Generate random integers with automatic fallback
 */
export async function generateRandomIntegers(
  request: RandomnessRequest
): Promise<RandomnessResponse> {
  // Validate request
  validateRandomnessRequest(request);

  // If seed provided and seeded method requested, use seeded generation
  if (request.seed && request.method === 'seeded') {
    return generateWithSeeded(request);
  }

  // Always use crypto-secure generation for best performance and reliability
  // Random.org is disabled to reduce latency and eliminate external dependency
  return generateWithCryptoSecure(request);
}

// =============================================================================
// TECHNIQUE-SPECIFIC GENERATORS
// =============================================================================

/**
 * Generate random cards (compatible with API endpoints)
 */
export async function generateRandomCards(options: {
  count: number;
  seed?: string;
  allowDuplicates?: boolean;
  allowReversed?: boolean;
  maxValue?: number;
}): Promise<RandomnessResponse> {
  const { count, seed, allowDuplicates = false, allowReversed = true, maxValue = 77 } = options;

  if (allowDuplicates) {
    // Simple generation with duplicates allowed
    return await generateRandomIntegers({
      count,
      min: 0,
      max: maxValue,
      seed,
      metadata: { technique: 'cards', allowDuplicates: true },
    });
  } else {
    // Generate unique cards
    return await generateTarotCards({
      count,
      allowReversed,
      deckSize: maxValue + 1,
      seed,
    });
  }
}

/**
 * Generate random coin tosses (compatible with API endpoints)
 */
export async function generateRandomCoins(options: {
  count: number;
  seed?: string;
}): Promise<RandomnessResponse> {
  return await generateRandomIntegers({
    count: options.count,
    min: 0,
    max: 1, // 0 = tails, 1 = heads
    seed: options.seed,
    metadata: { technique: 'coins' },
  });
}

/**
 * Generate tarot card draw
 */
export async function generateTarotCards(options: {
  count: number;
  allowReversed?: boolean;
  deckSize?: number;
  seed?: string;
}): Promise<RandomnessResponse> {
  const { count, allowReversed = true, deckSize = 78, seed } = options;

  // Generate more numbers to account for uniqueness and reversals
  const numbersNeeded = count * 3; // Extra for uniqueness and reversals

  const response = await generateRandomIntegers({
    count: numbersNeeded,
    min: 0,
    max: deckSize - 1,
    seed,
    metadata: { technique: 'tarot', allowReversed, deckSize },
  });

  // Extract unique card indices
  const drawnCards = new Set<number>();
  const cardIndices: number[] = [];

  for (let i = 0; i < response.values.length && cardIndices.length < count; i++) {
    const cardIndex = response.values[i];
    if (!drawnCards.has(cardIndex)) {
      drawnCards.add(cardIndex);
      cardIndices.push(cardIndex);
    }
  }

  // If we don't have enough unique cards, generate more
  if (cardIndices.length < count) {
    // Use crypto fallback to complete the set
    const remainingCount = count - cardIndices.length;
    const availableCards = Array.from({ length: deckSize }, (_, i) => i).filter(
      (i) => !drawnCards.has(i)
    );

    for (let i = 0; i < remainingCount && i < availableCards.length; i++) {
      cardIndices.push(availableCards[i]);
    }
  }

  // Generate reversal values if needed
  const reversalValues = allowReversed ? response.values.slice(count, count * 2) : [];

  // Encode cards with reversal information
  const encodedValues = cardIndices.map((cardIndex, position) => {
    // 30% probability of reversal: use modulo 10 and check if < 3 (gives 0,1,2 out of 0-9)
    const isReversed = allowReversed && reversalValues[position % reversalValues.length] % 10 < 3;

    // Encode: [31-bit card index][1-bit reversal]
    return (cardIndex << 1) | (isReversed ? 1 : 0);
  });

  return {
    ...response,
    values: encodedValues,
  };
}

/**
 * Generate I Ching hexagram
 */
export async function generateIChingHexagram(options: {
  method?: 'coins' | 'yarrow';
  seed?: string;
}): Promise<RandomnessResponse> {
  const { method = 'coins', seed } = options;

  if (method === 'coins') {
    // Traditional three-coin method
    const response = await generateRandomIntegers({
      count: 18, // 3 coins × 6 lines
      min: 0,
      max: 1, // 0 = tails, 1 = heads
      seed,
      metadata: { technique: 'iching', method },
    });

    // Convert coin tosses to line values (6, 7, 8, 9)
    const lineValues: number[] = [];
    for (let line = 0; line < 6; line++) {
      const baseIndex = line * 3;
      const coin1 = response.values[baseIndex] + 2; // 2 or 3
      const coin2 = response.values[baseIndex + 1] + 2; // 2 or 3
      const coin3 = response.values[baseIndex + 2] + 2; // 2 or 3

      const lineValue = coin1 + coin2 + coin3; // 6, 7, 8, or 9
      lineValues.push(lineValue);
    }

    return {
      ...response,
      values: lineValues,
    };
  } else {
    // Yarrow stalk method (simplified)
    return await generateRandomIntegers({
      count: 6,
      min: 6,
      max: 9,
      seed,
      metadata: { technique: 'iching', method },
    });
  }
}

/**
 * Generate runes draw
 */
export async function generateRunes(options: {
  count: number;
  allowReversed?: boolean;
  runeSetSize?: number;
  seed?: string;
}): Promise<RandomnessResponse> {
  const { count, allowReversed = true, runeSetSize = 24, seed } = options;

  // Generate enough numbers for uniqueness and reversals
  const numbersNeeded = count * 3;

  const response = await generateRandomIntegers({
    count: numbersNeeded,
    min: 0,
    max: runeSetSize - 1,
    seed,
    metadata: { technique: 'runes', allowReversed, runeSetSize },
  });

  // Extract unique rune indices
  const drawnRunes = new Set<number>();
  const runeIndices: number[] = [];

  for (let i = 0; i < response.values.length && runeIndices.length < count; i++) {
    const runeIndex = response.values[i];
    if (!drawnRunes.has(runeIndex)) {
      drawnRunes.add(runeIndex);
      runeIndices.push(runeIndex);
    }
  }

  // Generate reversal values
  const reversalValues = response.values.slice(count, count * 2);

  // Encode runes with reversal information
  const encodedValues = runeIndices.map((runeIndex, position) => {
    const isReversed = allowReversed && reversalValues[position % reversalValues.length] % 2 === 1;

    // Encode: [31-bit rune index][1-bit reversal]
    return (runeIndex << 1) | (isReversed ? 1 : 0);
  });

  return {
    ...response,
    values: encodedValues,
  };
}

// =============================================================================
// UTILITY FUNCTIONS
// =============================================================================

/**
 * Create seeded pseudorandom generator (Linear Congruential Generator)
 */
function createSeededGenerator(seed: string): () => number {
  // Convert seed to numeric value
  const seedValue = hashString(seed);
  let state = seedValue;

  return () => {
    // LCG parameters (from Numerical Recipes)
    state = (state * 1664525 + 1013904223) % 0x100000000;
    return state / 0x100000000;
  };
}

/**
 * Hash string to numeric seed
 */
function hashString(str: string): number {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    const char = str.charCodeAt(i);
    hash = (hash << 5) - hash + char;
    hash = hash & hash; // Convert to 32bit integer
  }
  return Math.abs(hash);
}

/**
 * Generate cryptographically secure seed
 */
function generateCryptographicSeed(length: number = 32): string {
  return crypto.randomBytes(length).toString('base64url');
}

/**
 * Generate seed from Random.org signature
 */
function generateSeedFromSignature(signature: string): string {
  const hash = crypto.createHash('sha256').update(signature).digest('base64url');
  return hash.substring(0, 32);
}

/**
 * Generate unique request ID
 */
function generateRequestId(): string {
  return `${Date.now()}_${crypto.randomBytes(4).toString('hex')}`;
}

/**
 * Validate randomness request
 */
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

  if (request.seed && request.seed.length < 4) {
    throw new Error('Seed must be at least 4 characters');
  }
}

// =============================================================================
// DECODERS
// =============================================================================

/**
 * Decode tarot card from encoded value
 */
export function decodeTarotCard(encodedValue: number): {
  cardIndex: number;
  isReversed: boolean;
} {
  const cardIndex = encodedValue >> 1;
  const isReversed = (encodedValue & 1) === 1;
  return { cardIndex, isReversed };
}

/**
 * Decode I Ching line value
 */
export function decodeIChingLine(lineValue: number): {
  type: 'yin' | 'yang';
  isChanging: boolean;
} {
  switch (lineValue) {
    case 6:
      return { type: 'yin', isChanging: true }; // Old Yin
    case 7:
      return { type: 'yang', isChanging: false }; // Young Yang
    case 8:
      return { type: 'yin', isChanging: false }; // Young Yin
    case 9:
      return { type: 'yang', isChanging: true }; // Old Yang
    default:
      throw new Error(`Invalid I Ching line value: ${lineValue}`);
  }
}

/**
 * Decode rune from encoded value
 */
export function decodeRune(encodedValue: number): {
  runeIndex: number;
  isReversed: boolean;
} {
  const runeIndex = encodedValue >> 1;
  const isReversed = (encodedValue & 1) === 1;
  return { runeIndex, isReversed };
}

// =============================================================================
// HEALTH CHECK
// =============================================================================

/**
 * Check Random.org service health
 */
export async function checkRandomOrgHealth(): Promise<{
  status: 'healthy' | 'unhealthy';
  responseTime: number;
  error?: string;
}> {
  const startTime = Date.now();

  try {
    const response = await generateRandomIntegers({
      count: 1,
      min: 1,
      max: 2,
      method: 'random_org',
    });

    const responseTime = Date.now() - startTime;

    return {
      status: response.method === 'random_org' ? 'healthy' : 'unhealthy',
      responseTime,
    };
  } catch (error) {
    const responseTime = Date.now() - startTime;
    return {
      status: 'unhealthy',
      responseTime,
      error: error instanceof Error ? error.message : String(error),
    };
  }
}
