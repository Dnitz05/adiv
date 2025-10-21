import type { NextApiRequest, NextApiResponse } from 'next';
import { z } from 'zod';

import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
} from '../../../lib/utils/nextApi';
import {
  baseRequestSchema,
  createApiResponse,
  createRequestId,
  handleApiError,
  log,
  parseApiRequest,
} from '../../../lib/utils/api';
import { recordApiMetric } from '../../../lib/utils/metrics';
import { formatQuestion } from '../../../lib/services/ai-provider';

const METRICS_PATH = '/api/questions/format';
const CORS_CONFIG = { methods: 'OPTIONS, POST' };

const formatRequestSchema = baseRequestSchema.extend({
  question: z.string().min(1, 'question is required'),
  locale: z.string().min(2).optional().default('ca'),
});

type FormatRequestBody = z.infer<typeof formatRequestSchema>;

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const requestId = createRequestId();
  const startTime = Date.now();

  try {
    if (handleCorsPreflight(req, res, CORS_CONFIG)) {
      return;
    }

    applyCorsHeaders(res, CORS_CONFIG);
    applyStandardResponseHeaders(res);

    if (req.method !== 'POST') {
      res.status(405).json(
        createApiResponse({
          requestId,
          error: { type: 'method_not_allowed', message: 'Method not allowed' },
        })
      );
      return;
    }

    const parsed = await parseApiRequest<FormatRequestBody>(req, formatRequestSchema, {
      requireUser: false,
    });
    const { data: body, auth } = parsed;

    log('info', 'Formatting question for header', {
      requestId,
      userId: auth?.userId,
      locale: body.locale,
      questionLength: body.question.length,
    });

    const formatted = await formatQuestion(body.question, body.locale, requestId);

    const duration = Date.now() - startTime;
    recordApiMetric(METRICS_PATH, 200, duration);

    res.status(200).json(
      createApiResponse({
        requestId,
        data: {
          formattedQuestion: formatted,
          usedAI: true,
        },
      })
    );
  } catch (error) {
    const duration = Date.now() - startTime;
    recordApiMetric(METRICS_PATH, 500, duration);
    handleApiError(res, error, requestId);
  }
}
