/**
 * Session Details Endpoint - Ultra-Professional Implementation
 *
 * Retrieves detailed information for a specific divination session,
 * including results, interpretations, and comprehensive metadata.
 */

import type { NextRequest } from 'next/server';
import {
  sendApiResponse,
  createApiResponse,
  handleApiError,
  handleCors,
  addStandardHeaders,
  log,
} from '../../../../lib/utils/api';
import { getSession, getUserTier } from '../../../../lib/utils/supabase';
import { recordApiMetric } from '../../../../lib/utils/metrics';
import type { DivinationSession, ApiResponse } from '../../../../lib/types/api';
import { nanoid } from 'nanoid';

// =============================================================================
// SESSION DETAILS API HANDLER
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
            message: 'Only GET method is allowed for session details',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        405
      );
      recordApiMetric('/api/sessions/detail/[sessionId]', 405, d405);
      return resp;
    }

    // Extract sessionId from URL path
    const url = new URL(req.url);
    const pathSegments = url.pathname.split('/');
    const sessionId = pathSegments[pathSegments.length - 1];

    if (!sessionId || sessionId === '[sessionId]') {
      const d400 = Date.now() - startTime;
      const resp = sendApiResponse(
        {
          success: false,
          error: {
            code: 'MISSING_SESSION_ID',
            message: 'Session ID is required in URL path',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        400
      );
      recordApiMetric('/api/sessions/detail/[sessionId]', 400, d400);
      return resp;
    }

    log('info', 'Session details requested', {
      method: req.method,
      requestId,
      sessionId,
      userAgent: req.headers['user-agent'],
    });

    // Retrieve session from database
    const session = await getSession(sessionId);

    if (!session) {
      log('info', 'Session not found', {
        requestId,
        sessionId,
      });

      const d404 = Date.now() - startTime;
      const resp404 = sendApiResponse(
        {
          success: false,
          error: {
            code: 'SESSION_NOT_FOUND',
            message: 'Session not found or has been deleted',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        404
      );
      recordApiMetric('/api/sessions/detail/[sessionId]', 404, d404);
      return resp404;
    }

    // Check user tier for enhanced details
    let userTier: 'free' | 'premium' | 'premium_annual' = 'free';
    try {
      const tier = await getUserTier(session.userId);
      userTier = tier || 'free';
    } catch (error) {
      log('warn', 'Could not determine user tier, defaulting to free', {
        requestId,
        userId: session.userId,
        sessionId,
        error: error instanceof Error ? error.message : String(error),
      });
    }

    // Prepare session details response
    type PremiumExtras = {
      _premium: { analyticsEnabled: boolean; exportAvailable: boolean; shareableLinks: boolean };
    };
    let sessionDetails: DivinationSession | (DivinationSession & PremiumExtras) = {
      ...session,
    } as DivinationSession;

    // Add premium-specific enhancements
    if (userTier === 'premium' || userTier === 'premium_annual') {
      // Premium users get additional metadata and analytics
      sessionDetails = {
        ...session,
        _premium: {
          analyticsEnabled: true,
          exportAvailable: true,
          shareableLinks: true,
        },
      } as DivinationSession & PremiumExtras;
    }

    log('info', 'Session details retrieved successfully', {
      requestId,
      sessionId,
      userId: session.userId,
      technique: session.technique,
      userTier,
      hasResults: !!session.results,
      hasInterpretation: !!session.interpretation,
    });

    const processingTime = Date.now() - startTime;

    // Create success response
    const response: ApiResponse<DivinationSession> = createApiResponse(sessionDetails, {
      processingTimeMs: processingTime,
      requestId,
    });

    // Send response
    const nextResponse = sendApiResponse(response, 200);
    addStandardHeaders(nextResponse);
    recordApiMetric('/api/sessions/detail/[sessionId]', 200, processingTime);

    return nextResponse;
  } catch (error) {
    log('error', 'Session details retrieval failed', {
      requestId,
      error: error instanceof Error ? error.message : String(error),
    });

    const d500 = Date.now() - startTime;
    recordApiMetric('/api/sessions/detail/[sessionId]', 500, d500);
    return handleApiError(error, requestId);
  }
}

// =============================================================================
// EDGE FUNCTION CONFIGURATION
// =============================================================================

export const runtime = 'edge';
export const preferredRegion = 'auto';
