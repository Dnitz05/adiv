import type { NextApiRequest, NextApiResponse } from 'next';
import { z } from 'zod';

import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../../lib/utils/nextApi';
import {
  baseRequestSchema,
  createApiResponse,
  createRequestId,
  handleApiError,
  parseApiRequest,
} from '../../../lib/utils/api';
import {
  fetchLunarAdviceHistory,
  hasServiceCredentials,
} from '../../../lib/utils/supabase';
import type { LunarAdviceHistoryItem, LunarAdviceTopic } from '../../../lib/types/api';

const historyRequestSchema = baseRequestSchema.extend({
  limit: z.coerce.number().int().min(1).max(50).default(10),
  from: z.string().optional(),
  to: z.string().optional(),
  topic: z.enum(['intentions', 'projects', 'relationships', 'wellbeing', 'creativity']).optional(),
});

type HistoryRequest = z.infer<typeof historyRequestSchema>;

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse,
) {
  const requestId = createRequestId();
  const startedAt = Date.now();

  applyCorsHeaders(res);
  applyStandardResponseHeaders(res);

  if (req.method === 'OPTIONS') {
    return handleCorsPreflight(req, res);
  }

  if (req.method !== 'GET') {
    return sendJsonError(res, 405, {
      code: 'METHOD_NOT_ALLOWED',
      message: 'Method not allowed',
      requestId,
      details: { allowedMethods: ['GET'] },
    });
  }

  try {
    const { data: query, auth } = await parseApiRequest<HistoryRequest>(
      req,
      historyRequestSchema,
    );

    const userId = (auth?.userId ?? query.userId ?? '').trim();
    if (!userId) {
      return sendJsonError(res, 401, {
        code: 'UNAUTHENTICATED',
        message: 'User authentication required',
        requestId,
      });
    }

    if (!hasServiceCredentials()) {
      return res.status(200).json(
        createApiResponse<{ items: LunarAdviceHistoryItem[] }>(
          { items: [] },
          { processingTimeMs: Date.now() - startedAt },
          requestId,
        ),
      );
    }

    const items = await fetchLunarAdviceHistory(userId, {
      limit: query.limit,
      locale: query.locale,
      topic: query.topic as LunarAdviceTopic | undefined,
      from: query.from,
      to: query.to,
    });

    return res.status(200).json(
      createApiResponse<{ items: LunarAdviceHistoryItem[] }>(
        { items },
        { processingTimeMs: Date.now() - startedAt },
        requestId,
      ),
    );
  } catch (error) {
    return handleApiError(res, error, requestId);
  }
}
