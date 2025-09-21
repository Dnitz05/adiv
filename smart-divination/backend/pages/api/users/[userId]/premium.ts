import type { NextApiRequest, NextApiResponse } from 'next';
import { nanoid } from 'nanoid';
import { createApiResponse, log } from '../../../../lib/utils/api';
import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../../../lib/utils/nextApi';
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

function getPremiumFeatures(
  tier: 'free' | 'premium' | 'premium_annual'
): PremiumStatus['features'] {
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

function getUserLimits(tier: 'free' | 'premium' | 'premium_annual'): PremiumStatus['limits'] {
  switch (tier) {
    case 'premium':
    case 'premium_annual':
      return {
        sessionsPerDay: 999,
        sessionsPerWeek: 999,
        sessionsPerMonth: 999,
        historyRetention: 365,
      };
    default:
      return { sessionsPerDay: 3, sessionsPerWeek: 10, sessionsPerMonth: 20, historyRetention: 30 };
  }
}

const METRICS_PATH = '/api/users/[userId]/premium';
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
      message: 'Only GET method is allowed for premium status',
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

    const tier = await getUserTier(userId);
    if (!tier) {
      sendJsonError(res, 404, {
        code: 'USER_NOT_FOUND',
        message: 'User not found in database',
        requestId,
      });
      recordApiMetric(METRICS_PATH, 404, Date.now() - startedAt);
      return;
    }

    let stats = { totalSessions: 0, sessionsThisWeek: 0, sessionsThisMonth: 0 };
    try {
      stats = await getUserStats(userId);
    } catch (error) {
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
      const expiration = new Date(now);
      if (tier === 'premium_annual') {
        expiration.setFullYear(now.getFullYear() + 1);
      } else {
        expiration.setMonth(now.getMonth() + 1);
      }
      premiumStatus.expiresAt = expiration.toISOString();
    }

    const duration = Date.now() - startedAt;
    res
      .status(200)
      .json(createApiResponse(premiumStatus, { processingTimeMs: duration, requestId }));
    recordApiMetric(METRICS_PATH, 200, duration);
  } catch (error: unknown) {
    const duration = Date.now() - startedAt;
    log('error', 'Premium status retrieval failed', {
      requestId,
      error: error instanceof Error ? error.message : String(error),
    });
    sendJsonError(res, 500, {
      code: 'INTERNAL_ERROR',
      message: 'Failed to retrieve premium status',
      details: { message: error instanceof Error ? error.message : String(error) },
      requestId,
    });
    recordApiMetric(METRICS_PATH, 500, duration);
  }
}
