import type { NextApiRequest, NextApiResponse } from 'next';

import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
} from '../../../lib/utils/nextApi';
import { createApiResponse, createRequestId, handleApiError, log } from '../../../lib/utils/api';
import { SPREADS } from '../../../lib/data/spreads';

const CORS_CONFIG = { methods: 'OPTIONS, GET' };

/**
 * List all available spreads
 * GET /api/spread/list
 */
export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const requestId = createRequestId();

  try {
    // Handle CORS preflight
    if (handleCorsPreflight(req, res, CORS_CONFIG)) {
      return;
    }

    // Apply headers
    applyCorsHeaders(res, CORS_CONFIG);
    applyStandardResponseHeaders(res);

    // Only allow GET
    if (req.method !== 'GET') {
      res.status(405).json(
        createApiResponse({
          requestId,
          error: { type: 'method_not_allowed', message: 'Method not allowed' },
        })
      );
      return;
    }

    log('info', 'Listing all spreads', {
      requestId,
      totalSpreads: SPREADS.length,
    });

    // Group spreads by category
    const spreadsByCategory = SPREADS.reduce(
      (acc, spread) => {
        if (!acc[spread.category]) {
          acc[spread.category] = [];
        }
        acc[spread.category].push({
          id: spread.id,
          name: spread.name,
          nameCA: spread.nameCA,
          nameES: spread.nameES,
          cardCount: spread.cardCount,
          complexity: spread.complexity,
          category: spread.category,
          isFreemium: spread.isFreemium,
          estimatedDurationMinutes: spread.estimatedDurationMinutes,
        });
        return acc;
      },
      {} as Record<string, any[]>
    );

    // Count by category
    const categoryCounts = Object.entries(spreadsByCategory).reduce(
      (acc, [category, spreads]) => {
        acc[category] = spreads.length;
        return acc;
      },
      {} as Record<string, number>
    );

    // Count by complexity
    const complexityCounts = SPREADS.reduce(
      (acc, spread) => {
        acc[spread.complexity] = (acc[spread.complexity] || 0) + 1;
        return acc;
      },
      {} as Record<string, number>
    );

    // Send response
    res.status(200).json(
      createApiResponse({
        requestId,
        data: {
          total: SPREADS.length,
          categoryCounts,
          complexityCounts,
          spreadsByCategory,
        },
      })
    );
  } catch (error) {
    handleApiError(res, error, requestId);
  }
}
