import { nanoid } from 'nanoid';
import { addStandardHeaders, createApiResponse, handleCors, log, sendApiResponse } from '../../../../lib/utils/api';
import { getUserStats, getUserTier } from '../../../../lib/utils/supabase';
import { recordApiMetric } from '../../../../lib/utils/metrics';

interface PremiumStatus {
  tier: 'free' | 'premium' | 'premium_annual';
  isActive: boolean;
  expiresAt?: string;
  billingCycle?: 'monthly' | 'annual';
  subscriptionId?: string;
  features: {
    unlimitedSessions: boolean;
    advancedInterpretations: boolean;
    sessionHistory: boolean;
    exportCapabilities: boolean;
    prioritySupport: boolean;
    customSpreads: boolean;
  };
  limits: {
    sessionsPerDay: number;
    sessionsPerWeek: number;
    sessionsPerMonth: number;
    historyRetention: number;
  };
  usage: {
    sessionsThisWeek: number;
    sessionsThisMonth: number;
    totalSessions: number;
  };
}

function getPremiumFeatures(tier: 'free' | 'premium' | 'premium_annual') {
  switch (tier) {
    case 'premium':
    case 'premium_annual':
      return {
        unlimitedSessions: true,
        advancedInterpretations: true,
        sessionHistory: true,
        exportCapabilities: true,
        prioritySupport: true,
        customSpreads: true,
      };
    default:
      return {
        unlimitedSessions: false,
        advancedInterpretations: false,
        sessionHistory: false,
        exportCapabilities: false,
        prioritySupport: false,
        customSpreads: false,
      };
  }
}

function getUserLimits(tier: 'free' | 'premium' | 'premium_annual') {
  switch (tier) {
    case 'premium':
    case 'premium_annual':
      return { sessionsPerDay: 999, sessionsPerWeek: 999, sessionsPerMonth: 999, historyRetention: 365 };
    default:
      return { sessionsPerDay: 3, sessionsPerWeek: 10, sessionsPerMonth: 20, historyRetention: 30 };
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
            message: 'Only GET method is allowed for premium status',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        405
      );
      recordApiMetric('/api/users/[userId]/premium', 405, d);
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
      recordApiMetric('/api/users/[userId]/premium', 400, d);
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
      recordApiMetric('/api/users/[userId]/premium', 404, d);
      return resp404;
    }

    let stats = { totalSessions: 0, sessionsThisWeek: 0, sessionsThisMonth: 0 };
    try {
      stats = await getUserStats(userId);
    } catch (e) {
      log('warn', 'getUserStats failed, using defaults', { requestId, userId });
    }

    const premiumStatus: PremiumStatus = {
      tier,
      isActive: tier !== 'free',
      features: getPremiumFeatures(tier),
      limits: getUserLimits(tier),
      usage: {
        sessionsThisWeek: stats.sessionsThisWeek || 0,
        sessionsThisMonth: stats.sessionsThisMonth || 0,
        totalSessions: stats.totalSessions || 0,
      },
    };
    if (tier !== 'free') {
      premiumStatus.billingCycle = tier === 'premium_annual' ? 'annual' : 'monthly';
      premiumStatus.subscriptionId = `sub_${userId.slice(-8)}`;
      const now = new Date();
      const exp = new Date(now);
      if (tier === 'premium_annual') exp.setFullYear(now.getFullYear() + 1);
      else exp.setMonth(now.getMonth() + 1);
      premiumStatus.expiresAt = exp.toISOString();
    }

    const ms = Date.now() - start;
    const response = createApiResponse(premiumStatus, { processingTimeMs: ms, requestId });
    const out = sendApiResponse(response, 200);
    addStandardHeaders(out);
    recordApiMetric('/api/users/[userId]/premium', 200, ms);
    return out;
  } catch (error: any) {
    const ms = Date.now() - start;
    log('error', 'Premium status retrieval failed', { requestId, error: String(error?.message || error) });
    const resp = sendApiResponse(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to retrieve premium status',
          details: { message: String(error?.message || error) },
          timestamp: new Date().toISOString(),
          requestId,
        },
      },
      500
    );
    recordApiMetric('/api/users/[userId]/premium', 500, ms);
    return resp;
  }
}
