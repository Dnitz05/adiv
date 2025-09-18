import { z } from 'zod';
import { nanoid } from 'nanoid';
import { addStandardHeaders, handleCors, log, parseApiRequest, sendApiResponse } from '../../../lib/utils/api';
import { generateRandomIntegers, decodeRune } from '../../../lib/utils/randomness';
import { recordApiMetric } from '../../../lib/utils/metrics';

const DrawRunesSchema = z.object({
  count: z.coerce.number().min(1).max(5).default(3),
  allow_reversed: z.coerce.boolean().optional().default(true),
  seed: z.string().min(1).optional(),
});

export default async function handler(req: any): Promise<Response> {
  const start = Date.now();
  const requestId = nanoid();

  try {
    const cors = handleCors(req);
    if (cors) return cors;
    if (req.method !== 'POST') {
      const d = Date.now() - start;
      const resp405 = sendApiResponse(
        {
          success: false,
          error: {
            code: 'METHOD_NOT_ALLOWED',
            message: 'Only POST method is allowed for draw/runes',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        405
      );
      recordApiMetric('/api/draw/runes', 405, d);
      return resp405;
    }

    const locale: string = (req.headers?.get?.('x-locale') as string) || 'en';
    const body = await parseApiRequest(req);
    const input = DrawRunesSchema.parse(body);

    // Each rune can be encoded as (index<<1 | reversedBit)
    const maxEncoded = input.allow_reversed ? 47 : 46; // if no reversed, ensure even values
    const rng = await generateRandomIntegers({
      count: input.count,
      min: 0,
      max: maxEncoded,
      seed: input.seed,
      metadata: { technique: 'runes' },
    });

    const seen = new Set<number>();
    const picks: number[] = [];
    for (const v of rng.values) {
      const { runeIndex } = decodeRune(input.allow_reversed ? v : (v & ~1));
      if (!seen.has(runeIndex)) {
        seen.add(runeIndex);
        picks.push(input.allow_reversed ? v : (runeIndex << 1));
      }
      if (picks.length === input.count) break;
    }

    // If duplicates reduced count, top-up deterministically
    let filler = 0;
    while (picks.length < input.count && filler < 24) {
      if (!seen.has(filler)) {
        picks.push(filler << 1);
        seen.add(filler);
      }
      filler++;
    }

    const result = picks.map((enc, i) => {
      const { runeIndex, isReversed } = decodeRune(enc);
      return {
        id: `rune_${runeIndex}`,
        reversed: !!(input.allow_reversed && isReversed),
        position: i + 1,
      };
    });

    const out = sendApiResponse(
      {
        success: true,
        data: undefined,
        // Maintain legacy shape used in other draw endpoints in this backend
      } as any,
      200
    );
    const payload = {
      result,
      seed: rng.seed,
      method: rng.method,
      signature: rng.signature,
      timestamp: new Date().toISOString(),
      locale,
    };
    // Overwrite with serialized payload
    const json = JSON.stringify(payload);
    const res = new Response(json, { status: 200, headers: { 'content-type': 'application/json' } });
    addStandardHeaders(res);
    const ms = Date.now() - start;
    recordApiMetric('/api/draw/runes', 200, ms);
    return res;
  } catch (error: any) {
    const ms = Date.now() - start;
    if (error?.name === 'ZodError') {
      const resp = sendApiResponse(
        {
          success: false,
          error: {
            code: 'VALIDATION_ERROR',
            message: 'Invalid request payload',
            details: error.errors,
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        400
      );
      recordApiMetric('/api/draw/runes', 400, ms);
      return resp;
    }
    log('error', 'Runes draw failed', { requestId, error: String(error?.message || error) });
    const resp = sendApiResponse(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to draw runes',
          details: { message: String(error?.message || error) },
          timestamp: new Date().toISOString(),
          requestId,
        },
      },
      500
    );
    recordApiMetric('/api/draw/runes', 500, ms);
    return resp;
  }
}
