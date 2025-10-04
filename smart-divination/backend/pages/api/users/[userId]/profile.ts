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
  log,
  parseApiRequest,
  resolveAuthContext,
  createApiError,
  type AuthContext,
} from '../../../../lib/utils/api';
import { getUserSessions } from '../../../../lib/utils/supabase';
import { recordApiMetric } from '../../../../lib/utils/metrics';

const METRICS_PATH = '/api/users/[userId]/profile';
const ALLOW_HEADER_VALUE = 'OPTIONS, GET';

const userProfileRequestSchema = baseRequestSchema.extend({
  userId: z.string().min(1, 'userId is required'),
  limit: z.coerce.number().int().min(1).max(100).default(50),
});

type UserProfileRequest = z.infer<typeof userProfileRequestSchema>;

interface KeywordEntry {
  value: string;
  count: number;
}

interface TechniqueEntry {
  value: string;
  count: number;
}

function addKeyword(counter: Map<string, number>, keyword: string | undefined | null): void {
  if (!keyword) {
    return;
  }
  const normalised = keyword.trim().toLowerCase();
  if (!normalised) {
    return;
  }
  counter.set(normalised, (counter.get(normalised) ?? 0) + 1);
}

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
      message: 'Only GET method is allowed for user profile',
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

  const userIdParam = req.query.userId;
  const pathUserId = Array.isArray(userIdParam) ? userIdParam[0] : userIdParam;
  if (!pathUserId || typeof pathUserId !== 'string' || pathUserId.trim().length === 0) {
    sendJsonError(res, 400, {
      code: 'MISSING_USER_ID',
      message: 'User ID is required in URL path',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 400, Date.now() - startedAt);
    return;
  }

  if (pathUserId !== authContext.userId) {
    sendJsonError(res, 403, {
      code: 'FORBIDDEN',
      message: 'You can only view your own profile.',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 403, Date.now() - startedAt);
    return;
  }

  let parsed: { data: UserProfileRequest; requestId: string; auth?: AuthContext };
  try {
    parsed = await parseApiRequest<UserProfileRequest>(req, userProfileRequestSchema, {
      requireUser: true,
    });
  } catch (error) {
    handleApiError(res, error, requestId, 400);
    recordApiMetric(METRICS_PATH, res.statusCode || 400, Date.now() - startedAt);
    return;
  }

  const { data: input } = parsed;
  const userId = authContext.userId;
  const supabaseAvailable = Boolean(
    process.env.SUPABASE_URL && process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  if (!supabaseAvailable) {
    sendJsonError(res, 503, {
      code: 'SUPABASE_UNAVAILABLE',
      message: 'User profile requires Supabase credentials.',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 503, Date.now() - startedAt);
    return;
  }

  try {
    const sessions = await getUserSessions(userId, {
      limit: input.limit,
      orderBy: 'last_activity',
      order: 'desc',
    });

    if (!sessions.length) {
      const response = createApiResponse(
        {
          userId,
          sessionCount: 0,
          techniques: [],
          techniqueCounts: [],
          recentQuestion: null,
          recentInterpretation: null,
          topKeywords: [],
          keywords: [],
          lastSessionAt: null,
        },
        { processingTimeMs: Date.now() - startedAt, requestId },
        requestId
      );
      res.status(200).json(response);
      recordApiMetric(METRICS_PATH, 200, Date.now() - startedAt);
      return;
    }

    const keywordCounter = new Map<string, number>();
    const techniqueCounter = new Map<string, number>();
    let recentQuestion: string | null = null;
    let recentInterpretation: string | null = null;
    let lastSessionAt: string | null = null;

    for (const session of sessions) {
      const technique = session.technique ?? 'unknown';
      techniqueCounter.set(technique, (techniqueCounter.get(technique) ?? 0) + 1);

      if (!lastSessionAt) {
        lastSessionAt = session.lastActivity ?? session.createdAt;
      }

      if (!recentQuestion) {
        const question = typeof session.question === 'string' ? session.question.trim() : '';
        if (question.length) {
          recentQuestion = question;
        }
      }

      if (!recentInterpretation) {
        const interpretation =
          typeof session.interpretation === 'string' ? session.interpretation.trim() : '';
        if (interpretation.length) {
          recentInterpretation = interpretation;
        }
      }

      const keywords = Array.isArray(session.keywords)
        ? (session.keywords as Array<unknown>).filter(
            (value): value is string => typeof value === 'string'
          )
        : [];
      for (const keyword of keywords) {
        addKeyword(keywordCounter, keyword);
      }
    }

    const keywordsList: KeywordEntry[] = Array.from(keywordCounter.entries())
      .map(([value, count]) => ({ value, count }))
      .sort((a, b) => b.count - a.count);

    const techniquesList: TechniqueEntry[] = Array.from(techniqueCounter.entries())
      .map(([value, count]) => ({ value, count }))
      .sort((a, b) => b.count - a.count);

    const response = createApiResponse(
      {
        userId,
        sessionCount: sessions.length,
        techniques: techniquesList.map((item) => item.value),
        techniqueCounts: techniquesList,
        recentQuestion,
        recentInterpretation,
        topKeywords: keywordsList.slice(0, 10),
        keywords: keywordsList,
        lastSessionAt,
      },
      { processingTimeMs: Date.now() - startedAt, requestId },
      requestId
    );

    res.status(200).json(response);
    recordApiMetric(METRICS_PATH, 200, Date.now() - startedAt);
  } catch (error) {
    log('error', 'Failed to build user profile', {
      requestId,
      userId,
      error: error instanceof Error ? error.message : String(error),
    });
    handleApiError(res, error, requestId);
    recordApiMetric(METRICS_PATH, res.statusCode || 500, Date.now() - startedAt);
  }
}
