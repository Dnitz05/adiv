import { nanoid } from 'nanoid';
import { addStandardHeaders, createApiResponse, handleCors, log, sendApiResponse } from '../../../../lib/utils/api';
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

function getTierLimits(tier: 'free' | 'premium' | 'premium_annual') {
  switch (tier) {
    case 'premium':
    case 'premium_annual':
      return { sessionsPerDay: 999, sessionsPerWeek: 999, sessionsPerMonth: 999 };
    default:
      return { sessionsPerDay: 3, sessionsPerWeek: 10, sessionsPerMonth: 20 };
  }
}

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
            message: 'Only GET method is allowed for session validation',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        405
      );
      recordApiMetric('/api/users/[userId]/can-start-session', 405, d);
      return resp405;
    }

    const url = new URL(req.url);
    const seg = url.pathname.split('/');
    const userId = seg[seg.length - 2];
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
      recordApiMetric('/api/users/[userId]/can-start-session', 400, d);
      return resp400;
    }

    const tier = await getUserTier(userId);
    if (!tier) {
      const d = Date.now() - start;
      const resp404 = sendApiResponse(
        {
          success: false,
          error: {
            code: 'USER_NOT_FOUND',
            message: 'User not found in database',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        404
      );
      recordApiMetric('/api/users/[userId]/can-start-session', 404, d);
      return resp404;
    }

    let stats = { totalSessions: 0, sessionsThisWeek: 0, sessionsThisMonth: 0 };
    try {
      stats = await getUserStats(userId);
    } catch {}

    // Compute today's sessions using recent sessions
    let sessionsToday = 0;
    try {
      const now = new Date();
      const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
      const recent = await getUserSessions(userId, { limit: 50 });
      sessionsToday = recent.filter((s) => new Date(s.createdAt) >= startOfDay).length;
    } catch (e) {
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

    const ms = Date.now() - start;
    const response = createApiResponse(validation, { processingTimeMs: ms, requestId });
    const out = sendApiResponse(response, 200);
    addStandardHeaders(out);
    recordApiMetric('/api/users/[userId]/can-start-session', 200, ms);
    return out;
  } catch (error: any) {
    const ms = Date.now() - start;
    log('error', 'Session validation failed', { requestId, error: String(error?.message || error) });
    const resp = sendApiResponse(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to validate session start',
          details: { message: String(error?.message || error) },
          timestamp: new Date().toISOString(),
          requestId,
        },
      },
      500
    );
    recordApiMetric('/api/users/[userId]/can-start-session', 500, ms);
    return resp;
  }
}
