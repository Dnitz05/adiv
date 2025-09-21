import type { NextApiRequest, NextApiResponse } from 'next';
import { z } from 'zod';
import { nanoid } from 'nanoid';
import { createApiResponse, log } from '../../lib/utils/api';
import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  parseRequestBody,
  sendJsonError,
} from '../../lib/utils/nextApi';
import { createSession, getUserTier } from '../../lib/utils/supabase';
import { recordApiMetric } from '../../lib/utils/metrics';

const SessionRequestSchema = z.object({
  session_id: z.string().optional(),
  user_id: z.string().min(1, 'user_id is required'),
  technique: z.enum(['tarot', 'iching', 'runes']).optional(),
  locale: z.string().min(2).default('en'),
  topic: z.string().optional(),
  question: z.string().optional(),
  messages: z
    .array(
      z.object({
        role: z.enum(['user', 'assistant']),
        content: z.string(),
        timestamp: z.string(),
      })
    )
    .default([]),
  is_premium: z.boolean().optional().default(false),
  created_at: z.string().optional(),
  last_activity: z.string().optional(),
  results: z.record(z.any()).optional(),
  interpretation: z.string().optional(),
  summary: z.string().optional(),
  metadata: z
    .object({
      seed: z.string().optional(),
      method: z.string().optional(),
      signature: z.string().optional(),
      duration: z.number().optional(),
      rating: z.number().min(1).max(5).optional(),
    })
    .optional(),
});

const METRICS_PATH = '/api/sessions';
const ALLOW_HEADER_VALUE = 'OPTIONS, POST';

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const startedAt = Date.now();
  const requestId = nanoid();

  const corsConfig = { methods: 'POST,OPTIONS' };
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
    log('info', 'Session creation requested', {
      method: req.method,
      requestId,
      userAgent: req.headers['user-agent'],
    });

    const payload = parseRequestBody(req);
    const input = SessionRequestSchema.parse(payload);

    let userTier: 'free' | 'premium' | 'premium_annual' = 'free';
    try {
      userTier = (await getUserTier(input.user_id)) ?? 'free';
    } catch (error) {
      log('warn', 'getUserTier failed, defaulting to free', { requestId, userId: input.user_id });
    }

    const sessionId = input.session_id || `session_${nanoid()}`;
    const nowIso = new Date().toISOString();

    const saved = await createSession({
      id: sessionId,
      userId: input.user_id,
      technique: input.technique ?? 'tarot',
      locale: input.locale,
      createdAt: input.created_at || nowIso,
      lastActivity: input.last_activity || nowIso,
      question: input.question || input.topic,
      results: input.results ?? null,
      interpretation: input.interpretation ?? null,
      summary: input.summary ?? null,
      metadata: input.metadata ?? undefined,
    });

    log('info', 'Session created successfully', {
      requestId,
      sessionId: saved.id,
      userId: saved.userId,
      technique: saved.technique,
      userTier,
    });

    const duration = Date.now() - startedAt;
    res.status(201).json(createApiResponse(saved, { processingTimeMs: duration, requestId }));
    recordApiMetric(METRICS_PATH, 201, duration);
  } catch (error: unknown) {
    const duration = Date.now() - startedAt;

    if (error instanceof z.ZodError) {
      sendJsonError(res, 400, {
        code: 'VALIDATION_ERROR',
        message: 'Invalid session data provided',
        details: error.errors,
        requestId,
      });
      recordApiMetric(METRICS_PATH, 400, duration);
      return;
    }

    log('error', 'Session creation failed', {
      requestId,
      error: error instanceof Error ? error.message : String(error),
    });
    sendJsonError(res, 500, {
      code: 'INTERNAL_ERROR',
      message: 'Failed to create session',
      details: { message: error instanceof Error ? error.message : String(error) },
      requestId,
    });
    recordApiMetric(METRICS_PATH, 500, duration);
  }
}
