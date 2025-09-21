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
const MIN_ROUNDS = 1;
const MAX_ROUNDS = 6;

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
      message: 'Only POST method is allowed for draw/coins',
    });
    return;
  }

  try {
    const payload = parseRequestBody(req);
    const rounds = resolveRounds(payload.rounds);
    const seed = resolveSeed(payload.seed);
    const locale = getLocaleFromHeader(req);

    const lines = generateIChingLines(rounds, seed);
    const changingLines = lines
      .map((value, index) => ({ value, index: index + 1 }))
      .filter(({ value }) => value === 6 || value === 9)
      .map(({ index }) => index);
    const primaryHex = computeHexagram(lines);
    const resultLines = applyChanging(lines);
    const resultHex = changingLines.length > 0 ? computeHexagram(resultLines) : undefined;

    res.status(200).json({
      result: {
        lines,
        primary_hex: primaryHex,
        changing_lines: changingLines,
        ...(resultHex ? { result_hex: resultHex } : {}),
      },
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

function resolveRounds(value: unknown): number {
  const numeric =
    typeof value === 'number'
      ? value
      : typeof value === 'string'
        ? Number.parseInt(value, 10)
        : Number.NaN;
  if (Number.isFinite(numeric)) {
    return Math.max(MIN_ROUNDS, Math.min(MAX_ROUNDS, Math.trunc(numeric)));
  }
  return MAX_ROUNDS;
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

function generateIChingLines(rounds: number, seed: string): number[] {
  const map = [6, 7, 7, 7, 8, 8, 8, 9];
  const rnd = mulberry32(hashSeed(seed));
  const lines: number[] = [];
  for (let i = 0; i < rounds; i += 1) {
    const roll = Math.floor(rnd() * 8);
    lines.push(map[roll]);
  }
  return lines;
}

function computeHexagram(lines: number[]): number {
  let value = 0;
  for (let i = 0; i < Math.min(6, lines.length); i += 1) {
    const bit = lines[i] === 7 || lines[i] === 9 ? 1 : 0;
    value |= bit << i;
  }
  return (value % 64) + 1;
}

function applyChanging(lines: number[]): number[] {
  return lines.map((value) => (value === 6 ? 7 : value === 9 ? 8 : value));
}
