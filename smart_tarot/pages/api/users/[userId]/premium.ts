/**
 * User Premium Status Endpoint - Ultra-Professional Implementation
 * 
 * Provides comprehensive premium tier information, billing status,
 * usage limits, and subscription details for a specific user.
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
  getUserStats
} from '../../../lib/utils/supabase';
import type { 
  ApiResponse
} from '../../../lib/types/api';
import { nanoid } from 'nanoid';

// =============================================================================
// USER PREMIUM STATUS TYPES
// =============================================================================

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
    historyRetention: number; // days
  };
  usage: {
    sessionsThisWeek: number;
    sessionsThisMonth: number;
    totalSessions: number;
  };
}

// =============================================================================
// USER PREMIUM STATUS API HANDLER
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
            message: 'Only GET method is allowed for premium status',
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
    const userId = pathSegments[pathSegments.length - 2]; // premium is the last segment
    
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

    log('info', 'User premium status requested', {
      method: req.method,
      requestId,
      userId,
      userAgent: req.headers.get('user-agent'),
    });
    
    // Get user tier from database
    const userTier = await getUserTier(userId);
    
    if (!userTier) {
      log('info', 'User not found', {
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

    // Get user statistics for usage information
    let userStats;
    try {
      userStats = await getUserStats(userId);
    } catch (error) {
      log('warn', 'Could not get user stats, using defaults', {
        requestId,
        userId,
        error: error instanceof Error ? error.message : String(error)
      });
      
      // Default stats if not available
      userStats = {
        totalSessions: 0,
        sessionsThisWeek: 0,
        sessionsThisMonth: 0
      };
    }

    // Build premium status based on tier
    const premiumStatus: PremiumStatus = {
      tier: userTier,
      isActive: userTier !== 'free',
      features: getPremiumFeatures(userTier),
      limits: getUserLimits(userTier),
      usage: {
        sessionsThisWeek: userStats.sessionsThisWeek || 0,
        sessionsThisMonth: userStats.sessionsThisMonth || 0,
        totalSessions: userStats.totalSessions || 0
      }
    };

    // Add premium-specific metadata
    if (userTier === 'premium' || userTier === 'premium_annual') {
      premiumStatus.billingCycle = userTier === 'premium_annual' ? 'annual' : 'monthly';
      // In a real implementation, you'd get these from your billing provider
      premiumStatus.subscriptionId = `sub_${userId.slice(-8)}`;
      
      // Calculate expiration (mock data - in real app, get from billing provider)
      const now = new Date();
      const expiresAt = new Date(now);
      if (userTier === 'premium_annual') {
        expiresAt.setFullYear(now.getFullYear() + 1);
      } else {
        expiresAt.setMonth(now.getMonth() + 1);
      }
      premiumStatus.expiresAt = expiresAt.toISOString();
    }
    
    log('info', 'User premium status retrieved successfully', {
      requestId,
      userId,
      tier: userTier,
      isActive: premiumStatus.isActive,
      totalSessions: premiumStatus.usage.totalSessions
    });

    const processingTime = Date.now() - startTime;
    
    // Create success response
    const response: ApiResponse<PremiumStatus> = createApiResponse(premiumStatus, {
      processingTimeMs: processingTime,
      requestId
    });
    
    // Send response
    const nextResponse = sendApiResponse(response, 200);
    addStandardHeaders(nextResponse);
    
    return nextResponse;
    
  } catch (error) {
    log('error', 'Premium status retrieval failed', { 
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
 * Get premium features based on user tier
 */
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
        customSpreads: true
      };
    
    case 'free':
    default:
      return {
        unlimitedSessions: false,
        advancedInterpretations: false,
        sessionHistory: false,
        exportCapabilities: false,
        prioritySupport: false,
        customSpreads: false
      };
  }
}

/**
 * Get usage limits based on user tier
 */
function getUserLimits(tier: 'free' | 'premium' | 'premium_annual') {
  switch (tier) {
    case 'premium':
    case 'premium_annual':
      return {
        sessionsPerDay: 999, // Effectively unlimited
        sessionsPerWeek: 999,
        sessionsPerMonth: 999,
        historyRetention: 365 // 1 year
      };
    
    case 'free':
    default:
      return {
        sessionsPerDay: 3,
        sessionsPerWeek: 10,
        sessionsPerMonth: 20,
        historyRetention: 30 // 30 days
      };
  }
}

// =============================================================================
// EDGE FUNCTION CONFIGURATION
// =============================================================================

export const runtime = 'edge';
export const preferredRegion = 'auto';