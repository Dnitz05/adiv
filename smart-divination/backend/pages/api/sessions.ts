import { z } from 'zod';
import { nanoid } from 'nanoid';
import {
  createApiResponse,
  sendApiResponse,
  handleCors,
  addStandardHeaders,
  log,
  parseApiRequest,
} from '../../lib/utils/api';
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

export default async function handler(req: any): Promise<Response> {
  const startTime = Date.now();
  const requestId = nanoid();

  try {
    const cors = handleCors(req);
    if (cors) return cors;

    if (req.method !== 'POST') {
      const d = Date.now() - startTime;
      const resp = sendApiResponse(
        {
          success: false,
          error: {
            code: 'METHOD_NOT_ALLOWED',
            message: 'Only POST method is allowed for session creation',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        405
      );
      recordApiMetric('/api/sessions', 405, d);
      return resp;
    }

    log('info', 'Session creation requested', {
      method: req.method,
      requestId,
      userAgent: req.headers?.get?.('user-agent') ?? undefined,
    });

    const body = await parseApiRequest(req);
    const input = SessionRequestSchema.parse(body);

    let userTier: 'free' | 'premium' | 'premium_annual' = 'free';
    try {
      userTier = (await getUserTier(input.user_id)) ?? 'free';
    } catch (e) {
      log('warn', 'getUserTier failed, defaulting to free', { requestId, userId: input.user_id });
    }

    const sessionId = input.session_id || `session_${nanoid()}`;
    const nowIso = new Date().toISOString();

    const saved = await createSession({
      id: sessionId,
      userId: input.user_id,
      technique: (input.technique as any) || 'tarot',
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

    const ms = Date.now() - startTime;
    const response = createApiResponse(saved, { processingTimeMs: ms, requestId });
    const out = sendApiResponse(response, 201);
    addStandardHeaders(out);
    recordApiMetric('/api/sessions', 201, ms);
    return out;
  } catch (error: any) {
    const ms = Date.now() - startTime;
    if (error?.name === 'ZodError') {
      const resp = sendApiResponse(
        {
          success: false,
          error: {
            code: 'VALIDATION_ERROR',
            message: 'Invalid session data provided',
            details: error.errors,
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        400
      );
      recordApiMetric('/api/sessions', 400, ms);
      return resp;
    }
    log('error', 'Session creation failed', { requestId, error: String(error?.message || error) });
    const resp = sendApiResponse(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to create session',
          details: { message: String(error?.message || error) },
          timestamp: new Date().toISOString(),
          requestId,
        },
      },
      500
    );
    recordApiMetric('/api/sessions', 500, ms);
    return resp;
  }
}
