import type { NextApiRequest, NextApiResponse } from 'next';
import { z } from 'zod';
import { nanoid } from 'nanoid';
import { log } from '../../../lib/utils/api';
import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  getLocaleFromHeader,
  handleCorsPreflight,
  parseRequestBody,
  sendJsonError,
} from '../../../lib/utils/nextApi';
import { generateRandomIntegers, decodeRune } from '../../../lib/utils/randomness';
import { recordApiMetric } from '../../../lib/utils/metrics';

const DrawRunesSchema = z.object({
  count: z.coerce.number().min(1).max(5).default(3),
  allow_reversed: z.coerce.boolean().optional().default(true),
  seed: z.string().min(1).optional(),
});

const METRICS_PATH = '/api/draw/runes';
const ALLOW_HEADER_VALUE = 'OPTIONS, POST';

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const startedAt = Date.now();
  const requestId = nanoid();

  const corsConfig = { methods: 'POST,OPTIONS' };
  applyCorsHeaders(res, corsConfig);
  applyStandardResponseHeaders(res);

  if (handleCorsPreflight(req, res, corsConfig)) {
    recordApiMetric(METRICS_PATH, 204, Date.now() - startedAt);
    return;
  }

  if (req.method !== 'POST') {
    res.setHeader('Allow', ALLOW_HEADER_VALUE);
    sendJsonError(res, 405, {
      code: 'METHOD_NOT_ALLOWED',
      message: 'Only POST method is allowed for draw/runes',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);
    return;
  }

  try {
    const payload = parseRequestBody(req);
    const input = DrawRunesSchema.parse(payload);

    const locale = getLocaleFromHeader(req);
    const maxEncoded = input.allow_reversed ? 47 : 46;
    const rng = await generateRandomIntegers({
      count: input.count,
      min: 0,
      max: maxEncoded,
      seed: input.seed,
      metadata: { technique: 'runes' },
    });

    const seen = new Set<number>();
    const picks: number[] = [];
    for (const value of rng.values) {
      const { runeIndex } = decodeRune(input.allow_reversed ? value : value & ~1);
      if (!seen.has(runeIndex)) {
        seen.add(runeIndex);
        picks.push(input.allow_reversed ? value : runeIndex << 1);
      }
      if (picks.length === input.count) break;
    }

    let filler = 0;
    while (picks.length < input.count && filler < 24) {
      if (!seen.has(filler)) {
        picks.push(filler << 1);
        seen.add(filler);
      }
      filler += 1;
    }

    const result = picks.map((encoded, index) => {
      const { runeIndex, isReversed } = decodeRune(encoded);
      return {
        id: `rune_${runeIndex}`,
        reversed: Boolean(input.allow_reversed && isReversed),
        position: index + 1,
      };
    });

    const duration = Date.now() - startedAt;
    res.status(200).json({
      result,
      seed: rng.seed,
      method: rng.method,
      signature: rng.signature,
      timestamp: new Date().toISOString(),
      locale,
    });
    recordApiMetric(METRICS_PATH, 200, duration);
  } catch (error: unknown) {
    const duration = Date.now() - startedAt;
    if (error instanceof z.ZodError) {
      sendJsonError(res, 400, {
        code: 'VALIDATION_ERROR',
        message: 'Invalid request payload',
        details: error.errors,
        requestId,
      });
      recordApiMetric(METRICS_PATH, 400, duration);
      return;
    }

    const message = error instanceof Error ? error.message : String(error);
    log('error', 'Runes draw failed', { requestId, error: message });
    sendJsonError(res, 500, {
      code: 'INTERNAL_ERROR',
      message: 'Failed to draw runes',
      details: { message },
      requestId,
    });
    recordApiMetric(METRICS_PATH, 500, duration);
  }
}
