import type { NextApiRequest, NextApiResponse } from 'next';
import { createApiResponse, log, createRequestId } from '../../../../lib/utils/api';
import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../../../lib/utils/nextApi';
import { recordApiMetric } from '../../../../lib/utils/metrics';

interface PackManifest {
  id: string;
  name: string;
  description: string;
  version: string;
  technique: 'tarot' | 'iching' | 'runes';
  author: string;
  license: string;
  created_at: string;
  updated_at: string;
  languages: string[];
  content: { cards?: number; hexagrams?: number; runes?: number; spreads?: string[] };
  assets: {
    images: { format: string; resolution: string; count: number };
    audio?: { format: string; count: number };
  };
  compatibility: { min_app_version: string; supported_platforms: string[] };
  premium_required: boolean;
  download_size: number;
  checksum: string;
}

const AVAILABLE_PACKS: Record<string, PackManifest> = {
  'tarot-rider-waite': {
    id: 'tarot-rider-waite',
    name: 'Rider-Waite Tarot Deck',
    description:
      'The classic and most widely recognized tarot deck, featuring beautiful traditional artwork',
    version: '1.0.0',
    technique: 'tarot',
    author: 'Smart Divination Team',
    license: 'CC BY-NC-SA 4.0',
    created_at: '2024-01-01T00:00:00Z',
    updated_at: '2024-01-01T00:00:00Z',
    languages: ['en', 'es', 'ca', 'fr', 'de', 'it'],
    content: { cards: 78, spreads: ['single', 'three-card', 'celtic-cross', 'five-card'] },
    assets: { images: { format: 'PNG', resolution: '400x700', count: 78 } },
    compatibility: { min_app_version: '1.0.0', supported_platforms: ['ios', 'android', 'web'] },
    premium_required: false,
    download_size: 15728640,
    checksum: 'sha256:a1b2c3d4e5f6...',
  },
  'iching-classic': {
    id: 'iching-classic',
    name: 'Classic I Ching',
    description: 'Traditional Chinese I Ching with 64 hexagrams and classical interpretations',
    version: '1.0.0',
    technique: 'iching',
    author: 'Smart Divination Team',
    license: 'CC BY-NC-SA 4.0',
    created_at: '2024-01-01T00:00:00Z',
    updated_at: '2024-01-01T00:00:00Z',
    languages: ['en', 'zh', 'es', 'ca'],
    content: { hexagrams: 64 },
    assets: { images: { format: 'SVG', resolution: 'vector', count: 64 } },
    compatibility: { min_app_version: '1.0.0', supported_platforms: ['ios', 'android', 'web'] },
    premium_required: false,
    download_size: 2097152,
    checksum: 'sha256:b2c3d4e5f6g7...',
  },
  'runes-elder-futhark': {
    id: 'runes-elder-futhark',
    name: 'Elder Futhark Runes',
    description: 'The oldest form of the runic alphabets, used by Germanic peoples',
    version: '1.0.0',
    technique: 'runes',
    author: 'Smart Divination Team',
    license: 'CC BY-NC-SA 4.0',
    created_at: '2024-01-01T00:00:00Z',
    updated_at: '2024-01-01T00:00:00Z',
    languages: ['en', 'no', 'sv', 'da', 'es', 'ca'],
    content: { runes: 24 },
    assets: { images: { format: 'PNG', resolution: '300x300', count: 24 } },
    compatibility: { min_app_version: '1.0.0', supported_platforms: ['ios', 'android', 'web'] },
    premium_required: false,
    download_size: 1048576,
    checksum: 'sha256:c3d4e5f6g7h8...',
  },
};

const METRICS_PATH = '/api/packs/[packId]/manifest';
const ALLOW_HEADER_VALUE = 'OPTIONS, GET';

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const startedAt = Date.now();
  const requestId = createRequestId();

  const corsConfig = { methods: 'GET,OPTIONS' };
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
      message: 'Only GET method is allowed for pack manifest',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);
    return;
  }

  try {
    const packIdParam = req.query.packId;
    const packId = Array.isArray(packIdParam) ? packIdParam[0] : packIdParam;
    if (!packId || packId.trim().length === 0) {
      sendJsonError(res, 400, {
        code: 'MISSING_PACK_ID',
        message: 'Pack ID is required in URL path',
        requestId,
      });
      recordApiMetric(METRICS_PATH, 400, Date.now() - startedAt);
      return;
    }

    const manifest = AVAILABLE_PACKS[packId];
    if (!manifest) {
      sendJsonError(res, 404, {
        code: 'PACK_NOT_FOUND',
        message: 'Pack not found or not available',
        details: { packId, availablePacks: Object.keys(AVAILABLE_PACKS) },
        requestId,
      });
      recordApiMetric(METRICS_PATH, 404, Date.now() - startedAt);
      return;
    }

    const requestedVersion = getQueryValue(req.query.version);
    if (requestedVersion && requestedVersion !== manifest.version) {
      sendJsonError(res, 404, {
        code: 'VERSION_MISMATCH',
        message: 'Requested version not available',
        details: { requestedVersion, availableVersion: manifest.version },
        requestId,
      });
      recordApiMetric(METRICS_PATH, 404, Date.now() - startedAt);
      return;
    }

    res.setHeader('Cache-Control', 'public, max-age=3600, s-maxage=3600');
    res.setHeader('ETag', `"${manifest.checksum}"`);

    const duration = Date.now() - startedAt;
    res.status(200).json(createApiResponse(manifest, { processingTimeMs: duration, requestId }));
    recordApiMetric(METRICS_PATH, 200, duration);
  } catch (error: unknown) {
    const duration = Date.now() - startedAt;
    log('error', 'Pack manifest retrieval failed', {
      requestId,
      error: error instanceof Error ? error.message : String(error),
    });
    sendJsonError(res, 500, {
      code: 'INTERNAL_ERROR',
      message: 'Failed to retrieve pack manifest',
      details: { message: error instanceof Error ? error.message : String(error) },
      requestId,
    });
    recordApiMetric(METRICS_PATH, 500, duration);
  }
}

function getQueryValue(value: string | string[] | undefined): string | undefined {
  if (Array.isArray(value)) {
    return value[0];
  }
  return value;
}
