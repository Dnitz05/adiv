import type { NextApiRequest, NextApiResponse } from 'next';
import { z } from 'zod';

import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
} from '../../../lib/utils/nextApi';
import { baseRequestSchema, createRequestId, log, parseApiRequest } from '../../../lib/utils/api';
import { SPREADS } from '../../../lib/data/spreads';

const CORS_CONFIG = { methods: 'OPTIONS, POST' };

/**
 * Request schema for streaming spread recommendation
 */
const spreadRecommendationRequestSchema = baseRequestSchema.extend({
  question: z.string().min(1, 'question is required'),
  locale: z.string().min(2).optional().default('ca'),
});

type SpreadRecommendationRequestBody = z.infer<typeof spreadRecommendationRequestSchema>;

/**
 * Streaming handler for AI spread recommendation
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

    // Only allow POST
    if (req.method !== 'POST') {
      res.status(405).json({
        success: false,
        requestId,
        error: { type: 'method_not_allowed', message: 'Method not allowed' },
      });
      return;
    }

    // Parse and validate request
    const parsed = await parseApiRequest<SpreadRecommendationRequestBody>(
      req,
      spreadRecommendationRequestSchema,
      { requireUser: false }
    );
    const { data: body } = parsed;

    log('info', 'Processing streaming spread recommendation', {
      requestId,
      questionLength: body.question.length,
      locale: body.locale,
    });

    // Set headers for SSE (Server-Sent Events)
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache, no-transform');
    res.setHeader('Connection', 'keep-alive');

    // Import AI selector
    const { selectSpreadWithAIStreaming } = await import(
      '../../../lib/services/ai-spread-selector'
    );

    let fullReason = '';
    let spreadId = '';

    // Stream the reasoning
    const result = await selectSpreadWithAIStreaming(
      body.question,
      body.locale,
      requestId,
      (chunk: string) => {
        // Send each chunk as SSE
        fullReason += chunk;
        res.write(`data: ${JSON.stringify({ type: 'chunk', content: chunk })}\n\n`);
      }
    );

    spreadId = result.spreadId;
    fullReason = result.reason;

    // Find the spread
    const spread = SPREADS.find((s) => s.id === spreadId);

    if (!spread) {
      throw new Error(`Invalid spread ID: ${spreadId}`);
    }

    // Send final result
    const finalData = {
      type: 'complete',
      spreadId,
      spread: {
        id: spread.id,
        name: spread.name,
        nameCA: spread.nameCA,
        nameES: spread.nameES,
        description: spread.description,
        descriptionCA: spread.descriptionCA,
        descriptionES: spread.descriptionES,
        cardCount: spread.cardCount,
        layoutAspectRatio: spread.layoutAspectRatio,
      },
      reasoning: fullReason,
      confidenceScore: result.confidence,
    };

    res.write(`data: ${JSON.stringify(finalData)}\n\n`);
    res.write('data: [DONE]\n\n');
    res.end();

    log('info', 'Streaming spread recommendation completed', {
      requestId,
      spreadId,
    });
  } catch (error) {
    log('error', 'Streaming spread recommendation failed', {
      requestId,
      error: error instanceof Error ? error.message : 'Unknown error',
    });

    // Send error as SSE
    res.write(
      `data: ${JSON.stringify({
        type: 'error',
        error: error instanceof Error ? error.message : 'Unknown error',
      })}\n\n`
    );
    res.end();
  }
}
