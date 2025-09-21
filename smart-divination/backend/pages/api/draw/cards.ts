import type { NextApiRequest, NextApiResponse } from 'next';
import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  getLocaleFromHeader,
  handleCorsPreflight,
  parseRequestBody,
  sendJsonError,
} from '../../../lib/utils/nextApi';

const ALLOW_HEADER_VALUE = 'OPTIONS, POST';
const MIN_CARD_COUNT = 1;
const MAX_CARD_COUNT = 78;

export default function handler(req: NextApiRequest, res: NextApiResponse): void {
  const startedAt = Date.now();
  const corsConfig = { methods: 'POST,OPTIONS' } as const;

  applyCorsHeaders(res, corsConfig);
  applyStandardResponseHeaders(res);

  if (handleCorsPreflight(req, res, corsConfig)) {
    return;
  }

  if (req.method !== 'POST') {
    res.setHeader('Allow', ALLOW_HEADER_VALUE);
    sendJsonError(res, 405, {
      code: 'METHOD_NOT_ALLOWED',
      message: 'Only POST method is allowed for draw/cards',
    });
    return;
  }

  try {
    const payload = parseRequestBody(req);
    const count = resolveCount(payload.count);
    const allowReversed = resolveAllowReversed(payload.allow_reversed);
    const seed = resolveSeed(payload.seed);
    const locale = getLocaleFromHeader(req);

    const indices = generateUniqueIndices(MAX_CARD_COUNT, count, seed);
    const results = indices.map((idx: number, index: number) => ({
      id: `card_${idx}`,
      upright: allowReversed ? randomBoolFromSeed(seed, idx) : true,
      position: index + 1,
    }));

    res.status(200).json({
      result: results,
      seed,
      timestamp: new Date().toISOString(),
      locale,
    });
  } catch (error: unknown) {
    const duration = Date.now() - startedAt;
    const details = error instanceof Error ? error.message : String(error);
    sendJsonError(
      res,
      400,
      {
        code: 'INVALID_REQUEST',
        message: 'Failed to parse request body',
        details,
      },
      { processingTimeMs: duration }
    );
  }
}

function resolveCount(value: unknown): number {
  const numeric =
    typeof value === 'number'
      ? value
      : typeof value === 'string'
        ? Number.parseInt(value, 10)
        : Number.NaN;
  if (Number.isFinite(numeric)) {
    return Math.max(MIN_CARD_COUNT, Math.min(MAX_CARD_COUNT, Math.trunc(numeric)));
  }
  return MIN_CARD_COUNT;
}

function resolveAllowReversed(value: unknown): boolean {
  if (typeof value === 'boolean') {
    return value;
  }
  if (typeof value === 'string') {
    const normalised = value.trim().toLowerCase();
    if (['true', '1', 'yes', 'on'].includes(normalised)) {
      return true;
    }
    if (['false', '0', 'no', 'off'].includes(normalised)) {
      return false;
    }
  }
  return true;
}

function resolveSeed(value: unknown): string {
  if (typeof value === 'string' && value.trim().length > 0) {
    return value;
  }
  return generateSeed();
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

function mulberry32(a: number): () => number {
  return function (): number {
    let t = (a += 0x6d2b79f5);
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function hashSeed(seed: string): number {
  let h = 2166136261 >>> 0;
  for (let i = 0; i < seed.length; i += 1) {
    h ^= seed.charCodeAt(i);
    h = Math.imul(h, 16777619);
  }
  return h >>> 0;
}

function generateUniqueIndices(deckSize: number, count: number, seed: string): number[] {
  const rnd = mulberry32(hashSeed(seed));
  const indices = Array.from({ length: deckSize }, (_, index) => index);
  for (let i = deckSize - 1; i > deckSize - 1 - count; i -= 1) {
    const j = Math.floor(rnd() * (i + 1));
    [indices[i], indices[j]] = [indices[j], indices[i]];
  }
  return indices.slice(deckSize - count);
}

function randomBoolFromSeed(seed: string, salt: number): boolean {
  const rnd = mulberry32((hashSeed(seed) + salt) >>> 0);
  return rnd() >= 0.5;
}
