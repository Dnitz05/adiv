import type { NextApiRequest, NextApiResponse } from 'next';
import { z } from 'zod';

import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../../lib/utils/nextApi';
import { createApiResponse, createRequestId, handleApiError, log } from '../../../lib/utils/api';
import { recordApiMetric } from '../../../lib/utils/metrics';
import { getLunarRange } from '../../../lib/services/lunar-service';

const METRICS_PATH = '/api/lunar/range';
const CORS_CONFIG = { methods: 'GET,OPTIONS' } as const;

const querySchema = z.object({
  from: z
    .string()
    .trim()
    .regex(/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/),
  to: z
    .string()
    .trim()
    .regex(/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/),
  locale: z.string().trim().optional(),
  userId: z.string().trim().min(1).optional(),
});

function coerceQuery<T extends Record<string, unknown>>(req: NextApiRequest): Partial<T> {
  const result: Record<string, unknown> = {};
  for (const key of Object.keys(req.query)) {
    const value = req.query[key];
    if (Array.isArray(value)) {
      result[key] = value[0];
    } else {
      result[key] = value;
    }
  }
  return result as Partial<T>;
}

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const startedAt = Date.now();
  const requestId = createRequestId();

  applyCorsHeaders(res, CORS_CONFIG);
  applyStandardResponseHeaders(res);

  if (handleCorsPreflight(req, res, CORS_CONFIG)) {
    recordApiMetric(METRICS_PATH, 204, Date.now() - startedAt);
    return;
  }

  if (req.method !== 'GET') {
    sendJsonError(res, 405, {
      code: 'METHOD_NOT_ALLOWED',
      message: 'Only GET is supported for this endpoint',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);
    return;
  }

  try {
    const raw = coerceQuery<typeof req.query>(req);
    const parsed = querySchema.safeParse(raw);
    if (!parsed.success) {
      sendJsonError(res, 400, {
        code: 'INVALID_QUERY',
        message: parsed.error.issues[0]?.message ?? 'Invalid query parameters',
        requestId,
      });
      recordApiMetric(METRICS_PATH, 400, Date.now() - startedAt);
      return;
    }

    const { from, to, locale, userId } = parsed.data;

    if (from > to) {
      sendJsonError(res, 400, {
        code: 'INVALID_RANGE',
        message: '`from` must be before or equal to `to`',
        requestId,
      });
      recordApiMetric(METRICS_PATH, 400, Date.now() - startedAt);
      return;
    }

    const items = await getLunarRange({
      from: `${from}T00:00:00Z`,
      to: `${to}T00:00:00Z`,
      locale,
      userId,
      requestId,
    });

    const response = createApiResponse(items, {
      requestId,
      processingTimeMs: Date.now() - startedAt,
    });

    res.status(200).json(response);
    recordApiMetric(METRICS_PATH, 200, Date.now() - startedAt);
  } catch (error) {
    log('error', 'Lunar range endpoint failed', {
      requestId,
      error: error instanceof Error ? error.message : 'Unknown error',
    });
    handleApiError(res, error, requestId);
    recordApiMetric(METRICS_PATH, res.statusCode || 500, Date.now() - startedAt);
  }
}
