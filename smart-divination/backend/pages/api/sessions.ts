/**
 * Sessions Management Endpoint - Ultra-Professional Implementation
 *
 * Handles divination session creation and storage with comprehensive
 * validation, Supabase integration, and professional error handling.
 */

import type { NextApiRequest, NextApiResponse } from 'next';
import { randomUUID } from 'crypto';
import {
  createApiResponse,
  handleApiError,
  log,
  parseApiRequest,
  baseRequestSchema,
  generateSecureSeed,
  createRequestId,
} from '../../lib/utils/api';
import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../lib/utils/nextApi';
import { createSession } from '../../lib/utils/supabase';
import { recordApiMetric } from '../../lib/utils/metrics';
import type { SessionMetadata } from '../../lib/types/api';
import { z } from 'zod';
const METRICS_PATH = '/api/sessions';
const ALLOW_HEADER_VALUE = 'OPTIONS, POST';

// =============================================================================
// SESSION REQUEST VALIDATION SCHEMAS
// =============================================================================

const SessionRequestSchema = baseRequestSchema.extend({
  session_id: z.string().uuid().optional(),
  user_id: z.string().min(1, 'User ID is required'),
  technique: z.enum(['tarot', 'iching', 'runes']).optional(),
  locale: z.string().min(2).default('en'),
  topic: z.string().optional(),
  messages: z
    .array(
      z.object({
        role: z.enum(['user', 'assistant']),
        content: z.string(),
        timestamp: z.string(),
      })
    )
    .default([]),
  is_premium: z.boolean().default(false),
  created_at: z.string().optional(),
  last_activity: z.string().optional(),
  question: z.string().optional(),
  results: z.record(z.any()).optional(),
  interpretation: z.string().optional(),
  summary: z.string().optional(),
  metadata: z
    .object({
      seed: z.string(),
      method: z.string(),
      signature: z.string().optional(),
      duration: z.number().optional(),
      rating: z.number().min(1).max(5).optional(),
    })
    .optional(),
});

type SessionRequest = z.infer<typeof SessionRequestSchema>;

// =============================================================================
// SESSIONS API HANDLER
// =============================================================================

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const startedAt = Date.now();
  let requestId = createRequestId();

  const corsConfig = { methods: 'POST,OPTIONS' } as const;
  applyCorsHeaders(res, corsConfig);
  applyStandardResponseHeaders(res);

  if (handleCorsPreflight(req, res, corsConfig)) {
    recordApiMetric(METRICS_PATH, 204, Date.now() - startedAt);
    return;
  }

  if (req.method !== 'POST') {
    res.setHeader('Allow', ALLOW_HEADER_VALUE);
    sendJsonError(res, 405, {
      code: 'METHOD_NOT_ALLOWED',
      message: 'Only POST method is allowed for session creation',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);
    return;
  }

  try {
    const { data: parsedData, requestId: parsedRequestId } = await parseApiRequest(
      req,
      SessionRequestSchema
    );
    requestId = parsedRequestId;
    const input = parsedData as SessionRequest;

    log('info', 'Session creation requested', {
      requestId,
      userId: input.user_id,
      technique: input.technique,
      hasMessages: input.messages.length > 0,
    });

    const sessionId = input.session_id ?? randomUUID();
    const nowIso = new Date().toISOString();

    const metadata = input.metadata
      ? (input.metadata as SessionMetadata)
      : ({ seed: generateSecureSeed(), method: 'unknown' } as SessionMetadata);

    const created = await createSession({
      id: sessionId,
      userId: input.user_id,
      technique: input.technique || 'tarot',
      locale: input.locale,
      createdAt: input.created_at || nowIso,
      lastActivity: input.last_activity || nowIso,
      question: input.question || input.topic || null,
      results: input.results ?? null,
      interpretation: input.interpretation ?? null,
      summary: input.summary ?? null,
      metadata,
    });

    const duration = Date.now() - startedAt;
    const response = createApiResponse(created, { processingTimeMs: duration, requestId });

    res.status(201).json(response);
    recordApiMetric(METRICS_PATH, 201, duration);
  } catch (error) {
    handleApiError(res, error, requestId);
    recordApiMetric(METRICS_PATH, res.statusCode || 500, Date.now() - startedAt);
  }
}

// =============================================================================
