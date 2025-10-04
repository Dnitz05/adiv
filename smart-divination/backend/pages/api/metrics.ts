import type { NextApiRequest, NextApiResponse } from 'next';
import { createApiResponse, handleApiError, log } from '../../lib/utils/api';
import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../lib/utils/nextApi';
import { getAllEndpointSummaries } from '../../lib/utils/metrics';
import { recordApiMetric } from '../../lib/utils/metrics';

const METRICS_PATH = '/api/metrics';
const ALLOW_HEADER_VALUE = 'OPTIONS, GET';

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const startedAt = Date.now();

  const corsConfig = { methods: 'GET,OPTIONS' } as const;
  applyCorsHeaders(res, corsConfig);
  applyStandardResponseHeaders(res);

  if (handleCorsPreflight(req, res, corsConfig)) {
    recordApiMetric(METRICS_PATH, 204, Date.now() - startedAt);
    return;
  }

  if (req.method !== 'GET') {
    res.setHeader('Allow', ALLOW_HEADER_VALUE);
    sendJsonError(res, 405, {
      code: 'METHOD_NOT_ALLOWED',
      message: 'Only GET method is allowed for metrics',
    });
    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);
    return;
  }

  try {
    const expose = process.env.METRICS_EXPOSE === 'true' || process.env.NODE_ENV !== 'production';
    if (!expose) {
      sendJsonError(res, 403, {
        code: 'FORBIDDEN',
        message: 'Metrics endpoint is not exposed',
      });
      recordApiMetric(METRICS_PATH, 403, Date.now() - startedAt);
      return;
    }

    const summaries = getAllEndpointSummaries();
    const response = createApiResponse(
      { endpoints: summaries },
      { processingTimeMs: Date.now() - startedAt }
    );

    res.status(200).json(response);
    recordApiMetric(METRICS_PATH, 200, Date.now() - startedAt);
  } catch (error) {
    log('error', 'Metrics endpoint failed', {
      error: error instanceof Error ? error.message : String(error),
    });
    handleApiError(res, error);
    recordApiMetric(METRICS_PATH, res.statusCode || 500, Date.now() - startedAt);
  }
}
