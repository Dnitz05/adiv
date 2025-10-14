import type { NextApiRequest, NextApiResponse } from 'next';
import {
  createApiResponse,
  log,
  createRequestId,
  resolveAuthContext,
  type AuthContext,
  createApiError,
  handleApiError,
} from '../../../../lib/utils/api';
import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../../../lib/utils/nextApi';
import { getUserSessions, getUserStats, getUserTier } from '../../../../lib/utils/supabase';
import { recordApiMetric } from '../../../../lib/utils/metrics';

interface SessionValidation {
  can_start: boolean;
  reason?: string;
  limits: {
    sessionsPerDay: number;
    sessionsPerWeek: number;
    sessionsPerMonth: number;
  };
  usage: {
    sessionsToday: number;
    sessionsThisWeek: number;
    sessionsThisMonth: number;
  };
  nextAllowedAt?: string;
  tier: 'free' | 'premium' | 'premium_annual';
}

function getTierLimits(tier: 'free' | 'premium' | 'premium_annual'): SessionValidation['limits'] {
  switch (tier) {
    case 'premium':
    case 'premium_annual':
      return { sessionsPerDay: 999, sessionsPerWeek: 999, sessionsPerMonth: 999 };
    default:
      return { sessionsPerDay: 3, sessionsPerWeek: 10, sessionsPerMonth: 20 };
  }
}

const METRICS_PATH = '/api/users/[userId]/can-start-session';
const ALLOW_HEADER_VALUE = 'OPTIONS, GET';

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const startedAt = Date.now();
  const requestId = createRequestId();

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
      message: 'Only GET method is allowed for session validation',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);
    return;
  }

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

  // Anonymous users: return unlimited sessions
  if (userId.startsWith('anon_')) {
    const response = createApiResponse<SessionValidation>(
      {
        can_start: true,
        tier: 'free',
        limits: { sessionsPerDay: 999, sessionsPerWeek: 999, sessionsPerMonth: 999 },
        usage: { sessionsToday: 0, sessionsThisWeek: 0, sessionsThisMonth: 0 },
      },
      { processingTimeMs: Date.now() - startedAt },
      requestId
    );
    res.status(200).json(response);
    recordApiMetric(METRICS_PATH, 200, Date.now() - startedAt);
    return;
  }

  // Registered users: require authentication
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

  try {
    if (authContext.userId !== userId) {
      sendJsonError(res, 403, {
        code: 'FORBIDDEN',
        message: 'You can only check limits for your own account.',
        requestId,
      });
      recordApiMetric(METRICS_PATH, 403, Date.now() - startedAt);
      return;
    }

    let tier = await getUserTier(userId);
    if (!tier) {
      // Auto-create user with free tier if they don't exist yet
      log('info', 'Auto-creating user with free tier', { userId, requestId });
      try {
        const { createClient } = await import('@supabase/supabase-js');
        const supabaseUrl = process.env.SUPABASE_URL;
        const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

        if (!supabaseUrl || !supabaseServiceKey) {
          throw new Error('Supabase configuration missing');
        }

        const supabase = createClient(supabaseUrl, supabaseServiceKey);
        const { error: insertError } = await supabase
          .from('users')
          .insert({ id: userId, tier: 'free' });

        if (insertError) {
          log('error', 'Failed to auto-create user', {
            userId,
            error: insertError.message,
            requestId,
          });
          sendJsonError(res, 500, {
            code: 'USER_CREATION_FAILED',
            message: 'Failed to create user record',
            requestId,
          });
          recordApiMetric(METRICS_PATH, 500, Date.now() - startedAt);
          return;
        }

        tier = 'free';
        log('info', 'User auto-created successfully', { userId, requestId });
      } catch (error) {
        log('error', 'Error during user auto-creation', {
          userId,
          error: error instanceof Error ? error.message : String(error),
          requestId,
        });
        sendJsonError(res, 500, {
          code: 'USER_CREATION_ERROR',
          message: 'Error creating user record',
          requestId,
        });
        recordApiMetric(METRICS_PATH, 500, Date.now() - startedAt);
        return;
      }
    }

    let stats = { totalSessions: 0, sessionsThisWeek: 0, sessionsThisMonth: 0 };
    try {
      stats = await getUserStats(userId);
    } catch (error) {}

    let sessionsToday = 0;
    try {
      const now = new Date();
      const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
      const recent = await getUserSessions(userId, { limit: 50 });
      sessionsToday = recent.filter((session) => new Date(session.createdAt) >= startOfDay).length;
    } catch (error) {
      log('warn', 'Failed to compute sessionsToday', { requestId, userId });
    }

    const limits = getTierLimits(tier);
    const validation: SessionValidation = {
      can_start: true,
      tier,
      limits,
      usage: {
        sessionsToday,
        sessionsThisWeek: stats.sessionsThisWeek || 0,
        sessionsThisMonth: stats.sessionsThisMonth || 0,
      },
    };

    if (tier === 'free') {
      const now = new Date();
      const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
      if (sessionsToday >= limits.sessionsPerDay) {
        validation.can_start = false;
        validation.reason = 'Daily session limit reached';
        const tomorrow = new Date(startOfDay);
        tomorrow.setDate(tomorrow.getDate() + 1);
        validation.nextAllowedAt = tomorrow.toISOString();
      } else if (validation.usage.sessionsThisWeek >= limits.sessionsPerWeek) {
        validation.can_start = false;
        validation.reason = 'Weekly session limit reached';
        const nextMonday = new Date(now);
        const daysUntilMonday = (7 - nextMonday.getDay() + 1) % 7 || 7;
        nextMonday.setDate(nextMonday.getDate() + daysUntilMonday);
        nextMonday.setHours(0, 0, 0, 0);
        validation.nextAllowedAt = nextMonday.toISOString();
      } else if (validation.usage.sessionsThisMonth >= limits.sessionsPerMonth) {
        validation.can_start = false;
        validation.reason = 'Monthly session limit reached';
        const nextMonth = new Date(now.getFullYear(), now.getMonth() + 1, 1);
        validation.nextAllowedAt = nextMonth.toISOString();
      }
    }

    const duration = Date.now() - startedAt;
    res.status(200).json(createApiResponse(validation, { processingTimeMs: duration, requestId }));
    recordApiMetric(METRICS_PATH, 200, duration);
  } catch (error: unknown) {
    const duration = Date.now() - startedAt;
    log('error', 'Session validation failed', {
      requestId,
      error: error instanceof Error ? error.message : String(error),
    });
    sendJsonError(res, 500, {
      code: 'INTERNAL_ERROR',
      message: 'Failed to validate session start',
      details: { message: error instanceof Error ? error.message : String(error) },
      requestId,
    });
    recordApiMetric(METRICS_PATH, 500, duration);
  }
}
