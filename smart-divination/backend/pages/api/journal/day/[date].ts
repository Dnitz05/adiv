import type { NextApiRequest, NextApiResponse } from 'next';
import { z } from 'zod';

import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../../../../lib/utils/nextApi';
import {
  baseRequestSchema,
  createApiResponse,
  handleApiError,
  parseApiRequest,
  type AuthContext,
} from '../../../../../lib/utils/api';
import { getJournalDaySummary } from '../../../../../lib/services/journal-service';
import { recordApiMetric } from '../../../../../lib/utils/metrics';

const METRICS_PATH = '/api/journal/day/[date]';
const corsConfig = { methods: 'GET,OPTIONS' } as const;

const dayRequestSchema = baseRequestSchema.extend({
  date: z
    .string()
    .regex(/^\d{4}-\d{2}-\d{2}$/, 'date must follow YYYY-MM-DD format')
    .default(''),
});

type DayRequest = z.infer<typeof dayRequestSchema>;

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const startedAt = Date.now();
  applyCorsHeaders(res, corsConfig);
  applyStandardResponseHeaders(res);

  if (handleCorsPreflight(req, res, corsConfig)) {
    recordApiMetric(METRICS_PATH, 204, Date.now() - startedAt);
    return;
  }

  if (req.method !== 'GET') {
    sendJsonError(res, 405, {
      code: 'METHOD_NOT_ALLOWED',
      message: 'Only GET is allowed for journal day summary',
    });
    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);
    return;
  }

  // Ensure the dynamic route parameter is exposed to the schema
  const dateParam = req.query.date;
  if (typeof dateParam === 'string') {
    req.query.date = dateParam;
  } else if (Array.isArray(dateParam)) {
    req.query.date = dateParam[0];
  }

  let parsed:
    | {
        data: DayRequest;
        requestId: string;
        auth?: AuthContext;
      }
    | undefined;

  try {
    parsed = await parseApiRequest<DayRequest>(req, dayRequestSchema, {
      requireUser: true,
    });
  } catch (error) {
    handleApiError(res, error);
    recordApiMetric(METRICS_PATH, res.statusCode || 400, Date.now() - startedAt);
    return;
  }

  const { data, requestId, auth } = parsed;
  const authContext = auth;
  if (!authContext) {
    sendJsonError(res, 401, {
      code: 'UNAUTHENTICATED',
      message: 'Authentication required',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 401, Date.now() - startedAt);
    return;
  }

  try {
    const summary = await getJournalDaySummary(authContext.userId, data.date);
    res
      .status(200)
      .json(createApiResponse(summary, { processingTimeMs: Date.now() - startedAt }, requestId));
    recordApiMetric(METRICS_PATH, 200, Date.now() - startedAt);
  } catch (error) {
    handleApiError(res, error, requestId);
    recordApiMetric(METRICS_PATH, res.statusCode || 500, Date.now() - startedAt);
  }
}
