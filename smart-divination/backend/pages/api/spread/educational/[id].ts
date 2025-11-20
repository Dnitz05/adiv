import type { NextApiRequest, NextApiResponse } from 'next';

import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
} from '../../../../lib/utils/nextApi';
import {
  createApiResponse,
  createRequestId,
  handleApiError,
  log,
} from '../../../../lib/utils/api';
import { recordApiMetric } from '../../../../lib/utils/metrics';
import { SPREADS_EDUCATIONAL } from '../../../../lib/data/spreads-educational';
import { SPREADS } from '../../../../lib/data/spreads';

const METRICS_PATH = '/api/spread/educational/[id]';
const CORS_CONFIG = { methods: 'OPTIONS, GET' };

/**
 * GET /api/spread/educational/[id]
 *
 * Fetch educational content for a specific spread by ID.
 *
 * FASE 3: Position Interactions & AI Enhancement
 *
 * @param id - Spread ID (e.g., 'celtic_cross', 'three_card', 'relationship')
 * @returns Educational content including purpose, when to use/avoid, interpretation method,
 *          position interactions, and AI selection criteria
 *
 * @example
 * GET /api/spread/educational/celtic_cross
 *
 * Response:
 * {
 *   "success": true,
 *   "data": {
 *     "spreadId": "celtic_cross",
 *     "educational": {
 *       "purpose": { "en": "...", "es": "...", "ca": "..." },
 *       "whenToUse": { "en": "...", "es": "...", "ca": "..." },
 *       "whenToAvoid": { "en": "...", "es": "...", "ca": "..." },
 *       "interpretationMethod": { "en": "...", "es": "...", "ca": "..." },
 *       "positionInteractions": [...],
 *       "aiSelectionCriteria": {...}
 *     }
 *   }
 * }
 */
export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  const requestId = createRequestId();
  const startTime = Date.now();

  try {
    // Apply standard headers
    applyStandardResponseHeaders(res);

    // Handle CORS and preflight
    if (handleCorsPreflight(req, res, CORS_CONFIG)) {
      return;
    }

    // Only allow GET
    if (req.method !== 'GET') {
      return res.status(405).json({
        success: false,
        error: { type: 'method_not_allowed', message: `Method ${req.method} not allowed` },
        meta: {
          processingTimeMs: 0,
          timestamp: new Date().toISOString(),
          version: '1.0.0',
          requestId,
        },
      });
    }

    // Extract spread ID from query
    const { id } = req.query;

    if (!id || typeof id !== 'string') {
      log('error', 'Missing or invalid spread ID', { requestId, id });
      return res.status(400).json({
        success: false,
        error: { type: 'invalid_request', message: 'Spread ID is required' },
        meta: {
          processingTimeMs: 0,
          timestamp: new Date().toISOString(),
          version: '1.0.0',
          requestId,
        },
      });
    }

    // Verify spread exists
    const spreadExists = SPREADS.some(spread => spread.id === id);
    if (!spreadExists) {
      log('warn', 'Spread not found', { requestId, spreadId: id });
      return res.status(404).json({
        success: false,
        error: { type: 'not_found', message: `Spread with ID '${id}' not found` },
        meta: {
          processingTimeMs: 0,
          timestamp: new Date().toISOString(),
          version: '1.0.0',
          requestId,
        },
      });
    }

    // Get educational content
    const educational = SPREADS_EDUCATIONAL[id];

    if (!educational) {
      log('warn', 'Educational content not found for spread', { requestId, spreadId: id });
      return res.status(404).json({
        success: false,
        error: { type: 'not_found', message: `Educational content not available for spread '${id}'` },
        meta: {
          processingTimeMs: 0,
          timestamp: new Date().toISOString(),
          version: '1.0.0',
          requestId,
        },
      });
    }

    // Record metrics
    const duration = Date.now() - startTime;
    recordApiMetric(METRICS_PATH, 200, duration);

    log('info', 'Educational content retrieved successfully', {
      requestId,
      spreadId: id,
      duration,
    });

    // Return educational content
    return res.status(200).json(
      createApiResponse(
        {
          spreadId: id,
          educational,
        },
        undefined,
        requestId
      )
    );
  } catch (error) {
    const duration = Date.now() - startTime;
    recordApiMetric(METRICS_PATH, 500, duration);

    return handleApiError(res, error, requestId);
  }
}
