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
  handleApiError,
  parseApiRequest,
  type AuthContext,
} from '../../../lib/utils/api';
import {
  getJournalTimeline,
  type JournalActivityType,
} from '../../../lib/services/journal-service';
import { recordApiMetric } from '../../../lib/utils/metrics';

const METRICS_PATH = '/api/journal/timeline';
const corsConfig = { methods: 'GET,OPTIONS' } as const;

const timelineRequestSchema = baseRequestSchema.extend({
  limit: z.coerce.number().int().min(1).max(100).default(25),
  cursor: z.string().optional(),
  from: z.string().optional(),
  to: z.string().optional(),
  types: z
    .string()
    .optional()
    .transform((value): string[] | undefined =>
      value
        ? value
            .split(',')
            .map((token) => token.trim())
            .filter((token) => token.length > 0)
        : undefined
    ),
  phase: z.string().optional(),
  search: z.string().optional(),
});

type TimelineRequest = z.infer<typeof timelineRequestSchema>;

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
      message: 'Only GET is allowed for journal timeline',
    });
    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);
    return;
  }

  let parsed:
    | {
        data: TimelineRequest;
        requestId: string;
        auth?: AuthContext;
      }
    | undefined;

  try {
    parsed = await parseApiRequest<TimelineRequest>(req, timelineRequestSchema, {
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
    const response = await getJournalTimeline(authContext.userId, {
      limit: data.limit,
      cursor: data.cursor ?? null,
      from: data.from ?? null,
      to: data.to ?? null,
      types: Array.isArray(data.types) ? (data.types as JournalActivityType[]) : undefined,
      phase: (data.phase ?? 'any') as any,
      search: data.search ?? null,
    });

    res
      .status(200)
      .json(createApiResponse(response, { processingTimeMs: Date.now() - startedAt }, requestId));
    recordApiMetric(METRICS_PATH, 200, Date.now() - startedAt);
  } catch (error) {
    handleApiError(res, error, requestId);
    recordApiMetric(METRICS_PATH, res.statusCode || 500, Date.now() - startedAt);
  }
}
