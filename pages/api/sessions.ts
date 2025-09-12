/**
 * Sessions Management Endpoint - Ultra-Professional Implementation
 * 
 * Handles divination session creation and storage with comprehensive
 * validation, Supabase integration, and professional error handling.
 */

import type { NextRequest } from 'next/server';
import { 
  sendApiResponse, 
  createApiResponse, 
  handleApiError,
  handleCors,
  addStandardHeaders,
  log,
  parseApiRequest
} from '../../lib/utils/api';
import { 
  createSession, 
  updateSession,
  getUserTier
} from '../../lib/utils/supabase';
import type { 
  DivinationSession,
  SessionMetadata,
  ApiResponse
} from '../../lib/types/api';
import { z } from 'zod';
import { nanoid } from 'nanoid';

// =============================================================================
// SESSION REQUEST VALIDATION SCHEMAS
// =============================================================================

const SessionRequestSchema = z.object({
  session_id: z.string().optional(),
  user_id: z.string().min(1, 'User ID is required'),
  technique: z.enum(['tarot', 'iching', 'runes']).optional(),
  locale: z.string().min(2).default('en'),
  topic: z.string().optional(),
  messages: z.array(z.object({
    role: z.enum(['user', 'assistant']),
    content: z.string(),
    timestamp: z.string()
  })).default([]),
  is_premium: z.boolean().default(false),
  created_at: z.string().optional(),
  last_activity: z.string().optional(),
  question: z.string().optional(),
  results: z.record(z.any()).optional(),
  interpretation: z.string().optional(),
  summary: z.string().optional(),
  metadata: z.object({
    seed: z.string(),
    method: z.string(),
    signature: z.string().optional(),
    duration: z.number().optional(),
    rating: z.number().min(1).max(5).optional()
  }).optional()
});

type SessionRequest = z.infer<typeof SessionRequestSchema>;

// =============================================================================
// SESSIONS API HANDLER
// =============================================================================

export default async function handler(req: NextRequest) {
  const startTime = Date.now();
  const requestId = nanoid();
  
  try {
    // Handle CORS
    const corsResponse = handleCors(req);
    if (corsResponse) return corsResponse;
    
    // Only allow POST requests for session creation
    if (req.method !== 'POST') {
      return sendApiResponse(
        { 
          success: false,
          error: {
            code: 'METHOD_NOT_ALLOWED', 
            message: 'Only POST method is allowed for session creation',
            timestamp: new Date().toISOString(),
            requestId
          }
        },
        405
      );
    }
    
    log('info', 'Session creation requested', {
      method: req.method,
      requestId,
      userAgent: req.headers['user-agent'],
    });
    
    // Parse and validate request body
    const body = await parseApiRequest(req);
    const sessionData = SessionRequestSchema.parse(body);
    
    log('info', 'Session data validated', {
      requestId,
      userId: sessionData.user_id,
      technique: sessionData.technique,
      hasMessages: sessionData.messages.length > 0
    });

    // Check user tier for premium features validation
    let userTier: 'free' | 'premium' | 'premium_annual' = 'free';
    try {
      const tier = await getUserTier(sessionData.user_id);
      userTier = tier || 'free';
    } catch (error) {
      log('warn', 'Could not determine user tier, defaulting to free', {
        requestId,
        userId: sessionData.user_id,
        error: error instanceof Error ? error.message : String(error)
      });
    }

    // Generate session ID if not provided
    const sessionId = sessionData.session_id || `session_${nanoid()}`;
    
    // Create comprehensive session object
    const now = new Date().toISOString();
    const divinationSession: DivinationSession = {
      id: sessionId,
      userId: sessionData.user_id,
      technique: sessionData.technique || 'tarot',
      locale: sessionData.locale,
      createdAt: sessionData.created_at || now,
      lastActivity: sessionData.last_activity || now,
      question: sessionData.question || sessionData.topic,
      results: sessionData.results,
      interpretation: sessionData.interpretation,
      summary: sessionData.summary,
      metadata: sessionData.metadata || {
        seed: `seed_${nanoid()}`,
        method: 'crypto_secure'
      }
    };

    // Store session in Supabase
    const savedSession = await createSession(divinationSession);
    
    log('info', 'Session created successfully', {
      requestId,
      sessionId: savedSession.id,
      userId: savedSession.userId,
      technique: savedSession.technique,
      userTier
    });

    const processingTime = Date.now() - startTime;
    
    // Create success response
    const response: ApiResponse<DivinationSession> = createApiResponse(savedSession, {
      processingTimeMs: processingTime,
      requestId
    });
    
    // Send response
    const nextResponse = sendApiResponse(response, 201);
    addStandardHeaders(nextResponse);
    
    return nextResponse;
    
  } catch (error) {
    log('error', 'Session creation failed', { 
      requestId,
      error: error instanceof Error ? error.message : String(error) 
    });
    
    // Handle validation errors specifically
    if (error instanceof z.ZodError) {
      return sendApiResponse(
        {
          success: false,
          error: {
            code: 'VALIDATION_ERROR',
            message: 'Invalid session data provided',
            details: error.errors,
            timestamp: new Date().toISOString(),
            requestId
          }
        },
        400
      );
    }
    
    return handleApiError(error, requestId);
  }
}

// =============================================================================
// EDGE FUNCTION CONFIGURATION
// =============================================================================

export const runtime = 'edge';
export const preferredRegion = 'auto';