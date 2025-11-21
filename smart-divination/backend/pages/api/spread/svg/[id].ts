import type { NextApiRequest, NextApiResponse } from 'next';
import * as fs from 'fs';
import * as path from 'path';

import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
} from '../../../../lib/utils/nextApi';
import { SPREADS } from '../../../../lib/data/spreads';

const CORS_CONFIG = { methods: 'OPTIONS, GET' };

/**
 * GET /api/spread/svg/[id]
 *
 * Returns the SVG visualization for a specific spread
 *
 * @param id - Spread ID (e.g., 'celtic_cross', 'five_card_cross')
 * @returns SVG content with proper content-type header
 */
export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  try {
    // Apply headers
    applyStandardResponseHeaders(res);

    // Handle CORS and preflight
    if (handleCorsPreflight(req, res, CORS_CONFIG)) {
      return;
    }

    applyCorsHeaders(res, CORS_CONFIG);

    // Only allow GET
    if (req.method !== 'GET') {
      return res.status(405).json({
        success: false,
        error: { type: 'method_not_allowed', message: `Method ${req.method} not allowed` },
      });
    }

    // Extract spread ID from query
    const { id } = req.query;

    if (!id || typeof id !== 'string') {
      return res.status(400).json({
        success: false,
        error: { type: 'invalid_request', message: 'Spread ID is required' },
      });
    }

    // Verify spread exists
    const spreadExists = SPREADS.some((spread) => spread.id === id);
    if (!spreadExists) {
      return res.status(404).json({
        success: false,
        error: { type: 'not_found', message: `Spread with ID '${id}' not found` },
      });
    }

    // Try to read the minified SVG file
    const svgPath = path.join(process.cwd(), 'public', 'spreads', `${id}.min.svg`);

    if (!fs.existsSync(svgPath)) {
      return res.status(404).json({
        success: false,
        error: { type: 'not_found', message: `SVG visualization not available for spread '${id}'` },
      });
    }

    const svgContent = fs.readFileSync(svgPath, 'utf-8');

    // Set SVG content-type
    res.setHeader('Content-Type', 'image/svg+xml');
    res.setHeader('Cache-Control', 'public, max-age=31536000, immutable'); // Cache for 1 year

    return res.status(200).send(svgContent);
  } catch (error) {
    console.error('Error serving SVG:', error);
    return res.status(500).json({
      success: false,
      error: { type: 'internal_error', message: 'Failed to serve SVG' },
    });
  }
}
