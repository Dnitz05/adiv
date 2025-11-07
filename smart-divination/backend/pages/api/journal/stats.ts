import type { NextApiRequest, NextApiResponse } from 'next';
import { z } from 'zod';

import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../../../lib/utils/nextApi';
import {
  baseRequestSchema,
  createApiResponse,
  handleApiError,
  parseApiRequest,
  type AuthContext,
} from '../../../../lib/utils/api';
import { getJournalStats, type JournalStatsPeriod } from '../../../../lib/services/journal-service';
import { recordApiMetric } from '../../../../lib/utils/metrics';

const METRICS_PATH = '/api/journal/stats';
const corsConfig = { methods: 'GET,OPTIONS' } as const;

const statsRequestSchema = baseRequestSchema.extend({
  period: z
    .enum(['week', 'month', 'year', 'all'])
    .default('month') as z.ZodType<JournalStatsPeriod>,
});

type StatsRequest = z.infer<typeof statsRequestSchema>;

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
      message: 'Only GET is allowed for journal stats',
    });
    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);
    return;
  }

  let parsed:
    | {
        data: StatsRequest;
        requestId: string;
        auth?: AuthContext;
      }
    | undefined;

  try {
    parsed = await parseApiRequest<StatsRequest>(req, statsRequestSchema, {
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
    const stats = await getJournalStats(authContext.userId, { period: data.period });
    res
      .status(200)
      .json(createApiResponse(stats, { processingTimeMs: Date.now() - startedAt }, requestId));
    recordApiMetric(METRICS_PATH, 200, Date.now() - startedAt);
  } catch (error) {
    handleApiError(res, error, requestId);
    recordApiMetric(METRICS_PATH, res.statusCode || 500, Date.now() - startedAt);
  }
}
