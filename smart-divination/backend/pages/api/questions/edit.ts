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
import { editQuestion } from '../../../lib/services/ai-provider';

const METRICS_PATH = '/api/questions/edit';
const CORS_CONFIG = { methods: 'OPTIONS, POST' };

const editRequestSchema = baseRequestSchema.extend({
  question: z.string().min(1, 'question is required'),
  locale: z.string().min(2).optional().default('ca'),
});

type EditRequestBody = z.infer<typeof editRequestSchema>;

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

    const parsed = await parseApiRequest<EditRequestBody>(req, editRequestSchema, {
      requireUser: false,
    });
    const { data: body, auth } = parsed;

    log('info', 'Editing consultation question', {
      requestId,
      userId: auth?.userId,
      locale: body.locale,
      questionLength: body.question.length,
    });

    const edited = await editQuestion(body.question, body.locale, requestId);

    const duration = Date.now() - startTime;
    recordApiMetric(METRICS_PATH, 200, duration);

    res.status(200).json(
      createApiResponse({
        requestId,
        data: {
          original: body.question,
          edited: edited,
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
