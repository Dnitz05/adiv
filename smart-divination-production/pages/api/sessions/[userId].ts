/**
 * User Sessions Retrieval Endpoint - Ultra-Professional Implementation
 *
 * Retrieves user's divination sessions with pagination, filtering,
 * and comprehensive session metadata.
 */

import type { NextRequest } from 'next/server';
import {
  sendApiResponse,
  createApiResponse,
  handleApiError,
  handleCors,
  addStandardHeaders,
  log,
} from '../../../lib/utils/api';
import { getUserSessions, getUserTier } from '../../../lib/utils/supabase';
import { recordApiMetric } from '../../../lib/utils/metrics';
import type { ApiResponse } from '../../../lib/types/api';
import { nanoid } from 'nanoid';

// =============================================================================
// USER SESSIONS API HANDLER
// =============================================================================

export default async function handler(req: NextRequest): Promise<Response> {
  const startTime = Date.now();
  const requestId = nanoid();

  try {
    // Handle CORS
    const corsResponse = handleCors(req);
    if (corsResponse) return corsResponse;

    // Only allow GET requests
    if (req.method !== 'GET') {
      const d405 = Date.now() - startTime;
      const resp = sendApiResponse(
        {
          success: false,
          error: {
            code: 'METHOD_NOT_ALLOWED',
            message: 'Only GET method is allowed for sessions retrieval',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        405
      );
      recordApiMetric('/api/sessions/[userId]', 405, d405);
      return resp;
    }

    // Extract userId from URL path
    const url = new URL(req.url);
    const pathSegments = url.pathname.split('/');
    const userId = pathSegments[pathSegments.length - 1];

    if (!userId || userId === '[userId]') {
      const d400 = Date.now() - startTime;
      const resp = sendApiResponse(
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
      recordApiMetric('/api/sessions/[userId]', 400, d400);
      return resp;
    }

    log('info', 'User sessions requested', {
      method: req.method,
      requestId,
      userId,
      userAgent: req.headers['user-agent'],
    });

    // Parse query parameters
    const limit = parseInt(url.searchParams.get('limit') || '20');
    const offset = parseInt(url.searchParams.get('offset') || '0');
    const technique = url.searchParams.get('technique') as 'tarot' | 'iching' | 'runes' | null;
    const orderBy = url.searchParams.get('orderBy') || 'created_at';
    const orderDir = url.searchParams.get('orderDir') || 'desc';

    // Validate pagination parameters
    if (limit < 1 || limit > 100) {
      return sendApiResponse(
        {
          success: false,
          error: {
            code: 'INVALID_LIMIT',
            message: 'Limit must be between 1 and 100',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        400
      );
    }

    if (offset < 0) {
      return sendApiResponse(
        {
          success: false,
          error: {
            code: 'INVALID_OFFSET',
            message: 'Offset must be non-negative',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        400
      );
    }

    log('info', 'Session query parameters validated', {
      requestId,
      userId,
      limit,
      offset,
      technique,
      orderBy,
      orderDir,
    });

    // Check user tier for premium features
    let userTier: 'free' | 'premium' | 'premium_annual' = 'free';
    try {
      const tier = await getUserTier(userId);
      userTier = tier || 'free';
    } catch (error) {
      log('warn', 'Could not determine user tier, defaulting to free', {
        requestId,
        userId,
        error: error instanceof Error ? error.message : String(error),
      });
    }

    // Retrieve user sessions with filters
    const sessions = await getUserSessions(userId, {
      limit,
      offset,
      technique,
      orderBy: orderBy as 'created_at' | 'last_activity',
      order: orderDir as 'asc' | 'desc',
    });

    log('info', 'User sessions retrieved successfully', {
      requestId,
      userId,
      sessionsCount: sessions.length,
      userTier,
      appliedFilters: { technique, limit, offset },
    });

    const processingTime = Date.now() - startTime;

    // Create response payload
    const responseData = {
      sessions,
      pagination: {
        limit,
        offset,
        total: sessions.length, // In a real implementation, you'd get the total count separately
        hasMore: sessions.length === limit, // Simple check, could be improved
      },
      filters: {
        technique: technique || null,
        orderBy,
        orderDirection: orderDir,
      },
      userTier,
    };

    // Create success response
    const response: ApiResponse<typeof responseData> = createApiResponse(responseData, {
      processingTimeMs: processingTime,
      requestId,
    });

    // Send response
    const nextResponse = sendApiResponse(response, 200);
    addStandardHeaders(nextResponse);
    recordApiMetric('/api/sessions/[userId]', 200, processingTime);

    return nextResponse;
  } catch (error) {
    log('error', 'User sessions retrieval failed', {
      requestId,
      error: error instanceof Error ? error.message : String(error),
    });

    const d500 = Date.now() - startTime;
    recordApiMetric('/api/sessions/[userId]', 500, d500);
    return handleApiError(error, requestId);
  }
}

// =============================================================================
// EDGE FUNCTION CONFIGURATION
// =============================================================================

export const runtime = 'edge';
export const preferredRegion = 'auto';
