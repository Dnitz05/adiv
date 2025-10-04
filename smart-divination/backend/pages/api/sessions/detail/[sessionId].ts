import type { NextApiRequest, NextApiResponse } from 'next';
import { z } from 'zod';

import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../../../lib/utils/nextApi';
import {
  baseRequestSchema,
  createApiResponse,
  createRequestId,
  handleApiError,
  parseApiRequest,
  resolveAuthContext,
  createApiError,
  type AuthContext,
} from '../../../../lib/utils/api';
import { getSession } from '../../../../lib/utils/supabase';
import { recordApiMetric } from '../../../../lib/utils/metrics';

const METRICS_PATH = '/api/sessions/detail/[sessionId]';
const ALLOW_HEADER_VALUE = 'OPTIONS, GET';

const sessionDetailRequestSchema = baseRequestSchema.extend({
  sessionId: z.string().min(1, 'sessionId is required'),
});

type SessionDetailRequest = z.infer<typeof sessionDetailRequestSchema>;

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const startedAt = Date.now();
  const requestId = createRequestId();

  const corsConfig = { methods: 'GET,OPTIONS' } as const;
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
      message: 'Only GET method is allowed for session detail',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);
    return;
  }

  let authContext: AuthContext | null = null;
  try {
    authContext = await resolveAuthContext(req, { requireUser: true, requestId });
  } catch (error) {
    handleApiError(res, error, requestId, 401);
    recordApiMetric(METRICS_PATH, res.statusCode || 401, Date.now() - startedAt);
    return;
  }

  if (!authContext) {
    handleApiError(
      res,
      createApiError(
        'UNAUTHENTICATED',
        'Authentication required',
        401,
        { statusCode: 401 },
        requestId
      ),
      requestId,
      401
    );
    recordApiMetric(METRICS_PATH, 401, Date.now() - startedAt);
    return;
  }

  let parsed: { data: SessionDetailRequest; requestId: string };
  try {
    parsed = await parseApiRequest<SessionDetailRequest>(req, sessionDetailRequestSchema, {
      requireUser: true,
    });
  } catch (error) {
    handleApiError(res, error, requestId, 400);
    recordApiMetric(METRICS_PATH, res.statusCode || 400, Date.now() - startedAt);
    return;
  }

  const { data: input } = parsed;
  const supabaseAvailable = Boolean(
    process.env.SUPABASE_URL && process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  if (!supabaseAvailable) {
    sendJsonError(res, 503, {
      code: 'SUPABASE_UNAVAILABLE',
      message: 'Session detail requires Supabase credentials.',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 503, Date.now() - startedAt);
    return;
  }

  try {
    const session = await getSession(input.sessionId);
    if (!session) {
      sendJsonError(res, 404, {
        code: 'SESSION_NOT_FOUND',
        message: 'Session not found.',
        requestId,
      });
      recordApiMetric(METRICS_PATH, 404, Date.now() - startedAt);
      return;
    }

    if (session.userId !== authContext.userId) {
      sendJsonError(res, 403, {
        code: 'FORBIDDEN',
        message: 'You are not allowed to view this session.',
        requestId,
      });
      recordApiMetric(METRICS_PATH, 403, Date.now() - startedAt);
      return;
    }

    const response = createApiResponse(session, {
      processingTimeMs: Date.now() - startedAt,
      requestId,
    });

    res.status(200).json(response);
    recordApiMetric(METRICS_PATH, 200, Date.now() - startedAt);
  } catch (error) {
    handleApiError(res, error, requestId);
    recordApiMetric(METRICS_PATH, res.statusCode || 500, Date.now() - startedAt);
  }
}
