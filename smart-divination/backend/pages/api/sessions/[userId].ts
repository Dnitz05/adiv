import type { NextApiRequest, NextApiResponse } from 'next';
import { z } from 'zod';

import {
  baseRequestSchema,
  createApiResponse,
  handleApiError,
  log,
  parseApiRequest,
  createApiError,
  type AuthContext,
} from '../../../lib/utils/api';
import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../../lib/utils/nextApi';
import { getUserSessions } from '../../../lib/utils/supabase';
import type { DivinationSession } from '../../../lib/types/api';
import { recordApiMetric } from '../../../lib/utils/metrics';

const METRICS_PATH = '/api/sessions/[userId]';
const ALLOW_HEADER_VALUE = 'OPTIONS, GET';

const SessionHistoryRequestSchema = baseRequestSchema.extend({
  userId: z.string().min(1, 'User ID is required'),
  limit: z.coerce.number().int().min(1).max(50).default(10),
  offset: z.coerce.number().int().min(0).optional(),
  technique: z.enum(['tarot', 'iching', 'runes']).optional(),
  orderBy: z.enum(['created_at', 'last_activity']).default('created_at'),
  orderDir: z.enum(['asc', 'desc']).default('desc'),
});

type SessionHistoryRequest = z.infer<typeof SessionHistoryRequestSchema>;

type SerializedSession = {
  id: string;
  userId: string;
  technique: DivinationSession['technique'];
  locale: string;
  createdAt: string;
  lastActivity: string;
  question: string | null;
  results?: Record<string, unknown>;
  interpretation?: string | null;
  summary?: string | null;
  metadata?: DivinationSession['metadata'];
  artifacts: NonNullable<DivinationSession['artifacts']>;
  messages: NonNullable<DivinationSession['messages']>;
};

const corsConfig = { methods: 'GET,OPTIONS' } as const;

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const startedAt = Date.now();
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
      message: 'Only GET method is allowed for session history',
    });
    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);
    return;
  }

  let parsed: { data: SessionHistoryRequest; requestId: string; auth?: AuthContext };
  try {
    parsed = await parseApiRequest<SessionHistoryRequest>(req, SessionHistoryRequestSchema, {
      requireUser: true,
    });
  } catch (error) {
    handleApiError(res, error);
    recordApiMetric(METRICS_PATH, res.statusCode || 400, Date.now() - startedAt);
    return;
  }

  const { data: input, requestId, auth } = parsed;
  const authContext = auth;
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

  if (input.userId !== authContext.userId) {
    sendJsonError(res, 403, {
      code: 'FORBIDDEN',
      message: 'You can only view your own sessions.',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 403, Date.now() - startedAt);
    return;
  }

  try {
    const supabaseAvailable = Boolean(
      process.env.SUPABASE_URL && process.env.SUPABASE_SERVICE_ROLE_KEY
    );

    let sessions: DivinationSession[] = [];
    if (supabaseAvailable) {
      sessions = await getUserSessions(input.userId, {
        technique: input.technique ?? null,
        limit: input.limit,
        offset: input.offset,
        orderBy: input.orderBy,
        order: input.orderDir,
      });
    } else {
      log('warn', 'Supabase credentials missing, returning empty session history', {
        requestId,
        userId: input.userId,
      });
    }

    const serialised = sessions.map(serializeSession);
    const response = createApiResponse(
      {
        sessions: serialised,
        limit: input.limit,
        offset: input.offset ?? 0,
        orderBy: input.orderBy,
        orderDir: input.orderDir,
        technique: input.technique ?? null,
        hasMore: supabaseAvailable ? serialised.length === input.limit : false,
      },
      { processingTimeMs: Date.now() - startedAt },
      requestId
    );

    res.status(200).json(response);
    recordApiMetric(METRICS_PATH, 200, Date.now() - startedAt);
  } catch (error) {
    handleApiError(res, error, requestId);
    recordApiMetric(METRICS_PATH, res.statusCode || 500, Date.now() - startedAt);
  }
}

function serializeSession(session: DivinationSession): SerializedSession {
  const artifacts = (session.artifacts ?? []) as NonNullable<DivinationSession['artifacts']>;
  const messages = (session.messages ?? []) as NonNullable<DivinationSession['messages']>;

  return {
    id: session.id,
    userId: session.userId,
    technique: session.technique,
    locale: session.locale,
    createdAt: session.createdAt,
    lastActivity: session.lastActivity,
    question: session.question,
    results: session.results ?? undefined,
    interpretation: session.interpretation ?? undefined,
    summary: session.summary ?? undefined,
    metadata: session.metadata ?? undefined,
    artifacts,
    messages,
  };
}
