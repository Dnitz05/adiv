/**
 * Session Validation Endpoint - Ultra-Professional Implementation
 * 
 * Validates if a user can start a new divination session based on
 * their tier limits, current usage, and account status.
 */

import type { NextRequest } from 'next/server';
import { 
  sendApiResponse, 
  createApiResponse, 
  handleApiError,
  handleCors,
  addStandardHeaders,
  log
} from '../../../lib/utils/api';
import { 
  getUserTier,
  getUserStats,
  getUserSessions
} from '../../../lib/utils/supabase';
import type { 
  ApiResponse
} from '../../../lib/types/api';
import { nanoid } from 'nanoid';

// =============================================================================
// SESSION VALIDATION TYPES
// =============================================================================

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

// =============================================================================
// SESSION VALIDATION API HANDLER
// =============================================================================

export default async function handler(req: NextRequest) {
  const startTime = Date.now();
  const requestId = nanoid();
  
  try {
    // Handle CORS
    const corsResponse = handleCors(req);
    if (corsResponse) return corsResponse;
    
    // Only allow GET requests
    if (req.method !== 'GET') {
      return sendApiResponse(
        { 
          success: false,
          error: {
            code: 'METHOD_NOT_ALLOWED', 
            message: 'Only GET method is allowed for session validation',
            timestamp: new Date().toISOString(),
            requestId
          }
        },
        405
      );
    }

    // Extract userId from URL path
    const url = new URL(req.url);
    const pathSegments = url.pathname.split('/');
    const userId = pathSegments[pathSegments.length - 2]; // can-start-session is the last segment
    
    if (!userId || userId === '[userId]') {
      return sendApiResponse(
        { 
          success: false,
          error: {
            code: 'MISSING_USER_ID', 
            message: 'User ID is required in URL path',
            timestamp: new Date().toISOString(),
            requestId
          }
        },
        400
      );
    }

    log('info', 'Session validation requested', {
      method: req.method,
      requestId,
      userId,
      userAgent: req.headers.get('user-agent'),
    });
    
    // Get user tier
    const userTier = await getUserTier(userId);
    
    if (!userTier) {
      log('info', 'User not found during session validation', {
        requestId,
        userId
      });
      
      return sendApiResponse(
        { 
          success: false,
          error: {
            code: 'USER_NOT_FOUND', 
            message: 'User not found in database',
            timestamp: new Date().toISOString(),
            requestId
          }
        },
        404
      );
    }

    // Get user session statistics
    let userStats;
    try {
      userStats = await getUserStats(userId);
    } catch (error) {
      log('warn', 'Could not get user stats for session validation', {
        requestId,
        userId,
        error: error instanceof Error ? error.message : String(error)
      });
      
      userStats = {
        totalSessions: 0,
        sessionsThisWeek: 0,
        sessionsThisMonth: 0
      };
    }

    // Get recent sessions to calculate daily usage
    const now = new Date();
    const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    
    let sessionsToday = 0;
    try {
      const recentSessions = await getUserSessions(userId, {
        limit: 50 // Get recent sessions to count today's
      });
      
      sessionsToday = recentSessions.filter(session => {
        const sessionDate = new Date(session.createdAt);
        return sessionDate >= startOfDay;
      }).length;
    } catch (error) {
      log('warn', 'Could not get recent sessions for daily count', {
        requestId,
        userId,
        error: error instanceof Error ? error.message : String(error)
      });
    }

    // Define limits based on tier
    const limits = getTierLimits(userTier);
    
    // Check if user can start a new session
    const validation: SessionValidation = {
      can_start: true,
      tier: userTier,
      limits,
      usage: {
        sessionsToday,
        sessionsThisWeek: userStats.sessionsThisWeek || 0,
        sessionsThisMonth: userStats.sessionsThisMonth || 0
      }
    };

    // Apply tier-specific validation rules
    if (userTier === 'free') {
      // Free tier has daily, weekly, and monthly limits
      if (sessionsToday >= limits.sessionsPerDay) {
        validation.can_start = false;
        validation.reason = 'Daily session limit reached';
        
        // Calculate next allowed time (tomorrow)
        const tomorrow = new Date(startOfDay);
        tomorrow.setDate(tomorrow.getDate() + 1);
        validation.nextAllowedAt = tomorrow.toISOString();
      } else if (validation.usage.sessionsThisWeek >= limits.sessionsPerWeek) {
        validation.can_start = false;
        validation.reason = 'Weekly session limit reached';
        
        // Calculate next Monday
        const nextMonday = new Date(now);
        const daysUntilMonday = (7 - nextMonday.getDay() + 1) % 7 || 7;
        nextMonday.setDate(nextMonday.getDate() + daysUntilMonday);
        nextMonday.setHours(0, 0, 0, 0);
        validation.nextAllowedAt = nextMonday.toISOString();
      } else if (validation.usage.sessionsThisMonth >= limits.sessionsPerMonth) {
        validation.can_start = false;
        validation.reason = 'Monthly session limit reached';
        
        // Calculate first day of next month
        const nextMonth = new Date(now.getFullYear(), now.getMonth() + 1, 1);
        validation.nextAllowedAt = nextMonth.toISOString();
      }
    }
    // Premium tiers have no limits, can_start remains true

    log('info', 'Session validation completed', {
      requestId,
      userId,
      tier: userTier,
      canStart: validation.can_start,
      reason: validation.reason,
      usage: validation.usage
    });

    const processingTime = Date.now() - startTime;
    
    // Create success response
    const response: ApiResponse<SessionValidation> = createApiResponse(validation, {
      processingTimeMs: processingTime,
      requestId
    });
    
    // Send response
    const nextResponse = sendApiResponse(response, 200);
    addStandardHeaders(nextResponse);
    
    return nextResponse;
    
  } catch (error) {
    log('error', 'Session validation failed', { 
      requestId,
      error: error instanceof Error ? error.message : String(error) 
    });
    
    return handleApiError(error, requestId);
  }
}

// =============================================================================
// HELPER FUNCTIONS
// =============================================================================

/**
 * Get tier-specific limits
 */
function getTierLimits(tier: 'free' | 'premium' | 'premium_annual') {
  switch (tier) {
    case 'premium':
    case 'premium_annual':
      return {
        sessionsPerDay: 999, // Effectively unlimited
        sessionsPerWeek: 999,
        sessionsPerMonth: 999
      };
    
    case 'free':
    default:
      return {
        sessionsPerDay: 3,
        sessionsPerWeek: 10,
        sessionsPerMonth: 20
      };
  }
}

// =============================================================================
// EDGE FUNCTION CONFIGURATION
// =============================================================================

export const runtime = 'edge';
export const preferredRegion = 'auto';