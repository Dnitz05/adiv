import { nanoid } from 'nanoid';
import { z } from 'zod';
import { addStandardHeaders, createApiResponse, handleCors, log, sendApiResponse } from '../../../lib/utils/api';
import { getUserSessions, getUserTier } from '../../../lib/utils/supabase';
import { recordApiMetric } from '../../../lib/utils/metrics';

const QuerySchema = z.object({
  limit: z.coerce.number().min(1).max(100).default(20),
  offset: z.coerce.number().min(0).default(0),
  technique: z.enum(['tarot', 'iching', 'runes']).nullish(),
  orderBy: z.enum(['created_at', 'last_activity']).default('created_at'),
  orderDir: z.enum(['asc', 'desc']).default('desc'),
});

export default async function handler(req: any): Promise<Response> {
  const start = Date.now();
  const requestId = nanoid();

  try {
    const cors = handleCors(req);
    if (cors) return cors;

    if (req.method !== 'GET') {
      const d = Date.now() - start;
      const resp405 = sendApiResponse(
        {
          success: false,
          error: {
            code: 'METHOD_NOT_ALLOWED',
            message: 'Only GET method is allowed for sessions retrieval',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        405
      );
      recordApiMetric('/api/sessions/[userId]', 405, d);
      return resp405;
    }

    const url = new URL(req.url);
    const seg = url.pathname.split('/');
    const userId = seg[seg.length - 1];
    if (!userId || userId === '[userId]') {
      const d = Date.now() - start;
      const resp400 = sendApiResponse(
        {
          success: false,
          error: {
            code: 'MISSING_USER_ID',
            message: 'User ID is required in URL path',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        400
      );
      recordApiMetric('/api/sessions/[userId]', 400, d);
      return resp400;
    }

    log('info', 'User sessions requested', { requestId, userId });

    const qs = QuerySchema.parse({
      limit: url.searchParams.get('limit') ?? undefined,
      offset: url.searchParams.get('offset') ?? undefined,
      technique: url.searchParams.get('technique') ?? undefined,
      orderBy: url.searchParams.get('orderBy') ?? undefined,
      orderDir: url.searchParams.get('orderDir') ?? undefined,
    });

    let userTier: 'free' | 'premium' | 'premium_annual' = 'free';
    try {
      userTier = (await getUserTier(userId)) ?? 'free';
    } catch {}

    const sessions = await getUserSessions(userId, {
      limit: qs.limit,
      offset: qs.offset,
      technique: (qs.technique as any) ?? undefined,
      orderBy: qs.orderBy,
      order: qs.orderDir,
    });

    const ms = Date.now() - start;
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
    const response = createApiResponse(payload, { processingTimeMs: ms, requestId });
    const out = sendApiResponse(response, 200);
    addStandardHeaders(out);
    recordApiMetric('/api/sessions/[userId]', 200, ms);
    return out;
  } catch (error: any) {
    const ms = Date.now() - start;
    log('error', 'User sessions retrieval failed', { requestId, error: String(error?.message || error) });
    const resp = sendApiResponse(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to retrieve sessions',
          details: { message: String(error?.message || error) },
          timestamp: new Date().toISOString(),
          requestId,
        },
      },
      500
    );
    recordApiMetric('/api/sessions/[userId]', 500, ms);
    return resp;
  }
}
