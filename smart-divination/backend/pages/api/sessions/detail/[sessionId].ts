import { nanoid } from 'nanoid';
import { addStandardHeaders, createApiResponse, handleCors, log, sendApiResponse } from '../../../../lib/utils/api';
import { getSession, getUserTier } from '../../../../lib/utils/supabase';
import { recordApiMetric } from '../../../../lib/utils/metrics';

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
            message: 'Only GET method is allowed for session details',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        405
      );
      recordApiMetric('/api/sessions/detail/[sessionId]', 405, d);
      return resp405;
    }

    const url = new URL(req.url);
    const seg = url.pathname.split('/');
    const sessionId = seg[seg.length - 1];
    if (!sessionId || sessionId === '[sessionId]') {
      const d = Date.now() - start;
      const resp400 = sendApiResponse(
        {
          success: false,
          error: {
            code: 'MISSING_SESSION_ID',
            message: 'Session ID is required in URL path',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        400
      );
      recordApiMetric('/api/sessions/detail/[sessionId]', 400, d);
      return resp400;
    }

    log('info', 'Session details requested', { requestId, sessionId });

    const session = await getSession(sessionId);
    if (!session) {
      const d = Date.now() - start;
      const resp404 = sendApiResponse(
        {
          success: false,
          error: {
            code: 'SESSION_NOT_FOUND',
            message: 'Session not found or has been deleted',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        404
      );
      recordApiMetric('/api/sessions/detail/[sessionId]', 404, d);
      return resp404;
    }

    let userTier: 'free' | 'premium' | 'premium_annual' = 'free';
    try {
      userTier = (await getUserTier(session.userId)) ?? 'free';
    } catch {}

    const ms = Date.now() - start;
    const response = createApiResponse(
      {
        ...session,
        _premium:
          userTier === 'premium' || userTier === 'premium_annual'
            ? { analyticsEnabled: true, exportAvailable: true, shareableLinks: true }
            : undefined,
      },
      { processingTimeMs: ms, requestId }
    );
    const out = sendApiResponse(response, 200);
    addStandardHeaders(out);
    recordApiMetric('/api/sessions/detail/[sessionId]', 200, ms);
    return out;
  } catch (error: any) {
    const ms = Date.now() - start;
    log('error', 'Session details retrieval failed', { requestId, error: String(error?.message || error) });
    const resp = sendApiResponse(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to retrieve session details',
          details: { message: String(error?.message || error) },
          timestamp: new Date().toISOString(),
          requestId,
        },
      },
      500
    );
    recordApiMetric('/api/sessions/detail/[sessionId]', 500, ms);
    return resp;
  }
}
