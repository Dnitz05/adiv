import type { NextApiRequest, NextApiResponse } from 'next';
import { nanoid } from 'nanoid';
import { createApiResponse, log } from '../../../../lib/utils/api';
import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../../../lib/utils/nextApi';
import { getSession, getUserTier } from '../../../../lib/utils/supabase';
import { recordApiMetric } from '../../../../lib/utils/metrics';

const METRICS_PATH = '/api/sessions/detail/[sessionId]';
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
      message: 'Only GET method is allowed for session details',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);
    return;
  }

  try {
    const sessionIdParam = req.query.sessionId;
    const sessionId = Array.isArray(sessionIdParam) ? sessionIdParam[0] : sessionIdParam;
    if (!sessionId || sessionId.trim().length === 0) {
      sendJsonError(res, 400, {
        code: 'MISSING_SESSION_ID',
        message: 'Session ID is required in URL path',
        requestId,
      });
      recordApiMetric(METRICS_PATH, 400, Date.now() - startedAt);
      return;
    }

    log('info', 'Session details requested', { requestId, sessionId });

    const session = await getSession(sessionId);
    if (!session) {
      sendJsonError(res, 404, {
        code: 'SESSION_NOT_FOUND',
        message: 'Session not found or has been deleted',
        requestId,
      });
      recordApiMetric(METRICS_PATH, 404, Date.now() - startedAt);
      return;
    }

    let userTier: 'free' | 'premium' | 'premium_annual' = 'free';
    try {
      userTier = (await getUserTier(session.userId)) ?? 'free';
    } catch (error) {}

    const responseBody = {
      ...session,
      _premium:
        userTier === 'premium' || userTier === 'premium_annual'
          ? { analyticsEnabled: true, exportAvailable: true, shareableLinks: true }
          : undefined,
    };

    const duration = Date.now() - startedAt;
    res
      .status(200)
      .json(createApiResponse(responseBody, { processingTimeMs: duration, requestId }));
    recordApiMetric(METRICS_PATH, 200, duration);
  } catch (error: unknown) {
    const duration = Date.now() - startedAt;
    log('error', 'Session details retrieval failed', {
      requestId,
      error: error instanceof Error ? error.message : String(error),
    });
    sendJsonError(res, 500, {
      code: 'INTERNAL_ERROR',
      message: 'Failed to retrieve session details',
      details: { message: error instanceof Error ? error.message : String(error) },
      requestId,
    });
    recordApiMetric(METRICS_PATH, 500, duration);
  }
}
