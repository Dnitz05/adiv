import type { NextApiRequest, NextApiResponse } from 'next';
import { nanoid } from 'nanoid';
import { z } from 'zod';
import { createApiResponse, log } from '../../../lib/utils/api';
import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../../lib/utils/nextApi';
import { getUserSessions, getUserTier } from '../../../lib/utils/supabase';
import { recordApiMetric } from '../../../lib/utils/metrics';

const QuerySchema = z.object({
  limit: z.coerce.number().min(1).max(100).default(20),
  offset: z.coerce.number().min(0).default(0),
  technique: z.enum(['tarot', 'iching', 'runes']).nullish(),
  orderBy: z.enum(['created_at', 'last_activity']).default('created_at'),
  orderDir: z.enum(['asc', 'desc']).default('desc'),
});

const METRICS_PATH = '/api/sessions/[userId]';
const ALLOW_HEADER_VALUE = 'OPTIONS, GET';

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const startedAt = Date.now();
  const requestId = nanoid();

  const corsConfig = { methods: 'GET,OPTIONS' };
  applyCorsHeaders(res, corsConfig);
  applyStandardResponseHeaders(res);

  if (handleCorsPreflight(req, res, corsConfig)) {
    recordApiMetric(METRICS_PATH, 204, Date.now() - startedAt);
    return;
  }

  if (req.method !== 'GET') {
    res.setHeader('Allow', ALLOW_HEADER_VALUE);
    sendJsonError(res, 405, {
      code: 'METHOD_NOT_ALLOWED',
      message: 'Only GET method is allowed for sessions retrieval',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);
    return;
  }

  try {
    const userIdParam = req.query.userId;
    const userId = Array.isArray(userIdParam) ? userIdParam[0] : userIdParam;
    if (!userId || userId.trim().length === 0) {
      sendJsonError(res, 400, {
        code: 'MISSING_USER_ID',
        message: 'User ID is required in URL path',
        requestId,
      });
      recordApiMetric(METRICS_PATH, 400, Date.now() - startedAt);
      return;
    }

    log('info', 'User sessions requested', { requestId, userId });

    const queryInput = {
      limit: normalizeQueryValue(req.query.limit),
      offset: normalizeQueryValue(req.query.offset),
      technique: normalizeQueryValue(req.query.technique),
      orderBy: normalizeQueryValue(req.query.orderBy),
      orderDir: normalizeQueryValue(req.query.orderDir),
    };

    const qs = QuerySchema.parse(queryInput);

    let userTier: 'free' | 'premium' | 'premium_annual' = 'free';
    try {
      userTier = (await getUserTier(userId)) ?? 'free';
    } catch (error) {}

    const sessions = await getUserSessions(userId, {
      limit: qs.limit,
      offset: qs.offset,
      technique: qs.technique ?? undefined,
      orderBy: qs.orderBy,
      order: qs.orderDir,
    });

    const duration = Date.now() - startedAt;
    const payload = {
      sessions,
      pagination: {
        limit: qs.limit,
        offset: qs.offset,
        total: sessions.length,
        hasMore: sessions.length === qs.limit,
      },
      filters: {
        technique: qs.technique ?? null,
        orderBy: qs.orderBy,
        orderDirection: qs.orderDir,
      },
      userTier,
    };
    res.status(200).json(createApiResponse(payload, { processingTimeMs: duration, requestId }));
    recordApiMetric(METRICS_PATH, 200, duration);
  } catch (error: unknown) {
    const duration = Date.now() - startedAt;
    log('error', 'User sessions retrieval failed', {
      requestId,
      error: error instanceof Error ? error.message : String(error),
    });
    sendJsonError(res, 500, {
      code: 'INTERNAL_ERROR',
      message: 'Failed to retrieve sessions',
      details: { message: error instanceof Error ? error.message : String(error) },
      requestId,
    });
    recordApiMetric(METRICS_PATH, 500, duration);
  }
}

function normalizeQueryValue(value: string | string[] | undefined): string | undefined {
  if (Array.isArray(value)) {
    return value[0];
  }
  return value;
}
