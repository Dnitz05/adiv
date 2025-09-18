import { nanoid } from 'nanoid';
import { addStandardHeaders, createApiResponse, handleCors, log, sendApiResponse } from '../../../../lib/utils/api';
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
  assets: { images: { format: string; resolution: string; count: number }; audio?: { format: string; count: number } };
  compatibility: { min_app_version: string; supported_platforms: string[] };
  premium_required: boolean;
  download_size: number;
  checksum: string;
}

const AVAILABLE_PACKS: Record<string, PackManifest> = {
  'tarot-rider-waite': {
    id: 'tarot-rider-waite',
    name: 'Rider-Waite Tarot Deck',
    description: 'The classic and most widely recognized tarot deck, featuring beautiful traditional artwork',
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

export default async function handler(req: any): Promise<Response> {
  const start = Date.now();
  const requestId = nanoid();
  try {
    const cors = handleCors(req);
    if (cors) return cors;
    if (req.method !== 'GET') {
      const d = Date.now() - start;
      const resp405 = sendApiResponse(
        {
          success: false,
          error: {
            code: 'METHOD_NOT_ALLOWED',
            message: 'Only GET method is allowed for pack manifest',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        405
      );
      recordApiMetric('/api/packs/[packId]/manifest', 405, d);
      return resp405;
    }

    const url = new URL(req.url);
    const seg = url.pathname.split('/');
    const packId = seg[seg.length - 2];
    if (!packId || packId === '[packId]') {
      const d = Date.now() - start;
      const resp400 = sendApiResponse(
        {
          success: false,
          error: {
            code: 'MISSING_PACK_ID',
            message: 'Pack ID is required in URL path',
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        400
      );
      recordApiMetric('/api/packs/[packId]/manifest', 400, d);
      return resp400;
    }

    const manifest = AVAILABLE_PACKS[packId];
    if (!manifest) {
      const d = Date.now() - start;
      const resp404 = sendApiResponse(
        {
          success: false,
          error: {
            code: 'PACK_NOT_FOUND',
            message: 'Pack not found or not available',
            details: { packId, availablePacks: Object.keys(AVAILABLE_PACKS) },
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        404
      );
      recordApiMetric('/api/packs/[packId]/manifest', 404, d);
      return resp404;
    }

    const requestedVersion = url.searchParams.get('version');
    if (requestedVersion && requestedVersion !== manifest.version) {
      const d = Date.now() - start;
      const resp404 = sendApiResponse(
        {
          success: false,
          error: {
            code: 'VERSION_MISMATCH',
            message: 'Requested version not available',
            details: { requestedVersion, availableVersion: manifest.version },
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
        404
      );
      recordApiMetric('/api/packs/[packId]/manifest', 404, d);
      return resp404;
    }

    const ms = Date.now() - start;
    const response = createApiResponse(manifest, { processingTimeMs: ms, requestId });
    const out = sendApiResponse(response, 200);
    addStandardHeaders(out);
    out.headers.set('Cache-Control', 'public, max-age=3600, s-maxage=3600');
    out.headers.set('ETag', `"${manifest.checksum}"`);
    recordApiMetric('/api/packs/[packId]/manifest', 200, ms);
    return out;
  } catch (error: any) {
    const ms = Date.now() - start;
    log('error', 'Pack manifest retrieval failed', { requestId, error: String(error?.message || error) });
    const resp = sendApiResponse(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to retrieve pack manifest',
          details: { message: String(error?.message || error) },
          timestamp: new Date().toISOString(),
          requestId,
        },
      },
      500
    );
    recordApiMetric('/api/packs/[packId]/manifest', 500, ms);
    return resp;
  }
}
