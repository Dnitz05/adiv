/**
 * Pack Manifest Endpoint - Ultra-Professional Implementation
 * 
 * Provides detailed metadata and configuration for divination content packs,
 * including card data, localization info, and versioning.
 */

import type { NextRequest } from 'next/server';
import { 
  sendApiResponse, 
  createApiResponse, 
  handleApiError,
  handleCors,
  addStandardHeaders,
  log
} from '../../../../lib/utils/api';
import type { 
  ApiResponse
} from '../../../../lib/types/api';
import { nanoid } from 'nanoid';

// =============================================================================
// PACK MANIFEST TYPES
// =============================================================================

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
  content: {
    cards?: number;
    hexagrams?: number;
    runes?: number;
    spreads?: string[];
  };
  assets: {
    images: {
      format: string;
      resolution: string;
      count: number;
    };
    audio?: {
      format: string;
      count: number;
    };
  };
  compatibility: {
    min_app_version: string;
    supported_platforms: string[];
  };
  premium_required: boolean;
  download_size: number; // bytes
  checksum: string;
}

// =============================================================================
// AVAILABLE PACKS REGISTRY
// =============================================================================

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
    content: {
      cards: 78,
      spreads: ['single', 'three-card', 'celtic-cross', 'five-card']
    },
    assets: {
      images: {
        format: 'PNG',
        resolution: '400x700',
        count: 78
      }
    },
    compatibility: {
      min_app_version: '1.0.0',
      supported_platforms: ['ios', 'android', 'web']
    },
    premium_required: false,
    download_size: 15728640, // ~15MB
    checksum: 'sha256:a1b2c3d4e5f6...'
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
    content: {
      hexagrams: 64
    },
    assets: {
      images: {
        format: 'SVG',
        resolution: 'vector',
        count: 64
      }
    },
    compatibility: {
      min_app_version: '1.0.0',
      supported_platforms: ['ios', 'android', 'web']
    },
    premium_required: false,
    download_size: 2097152, // ~2MB
    checksum: 'sha256:b2c3d4e5f6g7...'
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
    content: {
      runes: 24
    },
    assets: {
      images: {
        format: 'PNG',
        resolution: '300x300',
        count: 24
      }
    },
    compatibility: {
      min_app_version: '1.0.0',
      supported_platforms: ['ios', 'android', 'web']
    },
    premium_required: false,
    download_size: 1048576, // ~1MB
    checksum: 'sha256:c3d4e5f6g7h8...'
  },
  
  'tarot-marseille-premium': {
    id: 'tarot-marseille-premium',
    name: 'Marseille Tarot Deck',
    description: 'Historic French tarot deck with traditional Marseille imagery (Premium)',
    version: '1.0.0',
    technique: 'tarot',
    author: 'Smart Divination Team',
    license: 'Premium License',
    created_at: '2024-01-01T00:00:00Z',
    updated_at: '2024-01-01T00:00:00Z',
    languages: ['en', 'fr', 'es', 'ca', 'it'],
    content: {
      cards: 78,
      spreads: ['single', 'three-card', 'celtic-cross', 'five-card', 'horseshoe', 'star']
    },
    assets: {
      images: {
        format: 'PNG',
        resolution: '600x1000',
        count: 78
      },
      audio: {
        format: 'MP3',
        count: 78
      }
    },
    compatibility: {
      min_app_version: '1.0.0',
      supported_platforms: ['ios', 'android', 'web']
    },
    premium_required: true,
    download_size: 52428800, // ~50MB
    checksum: 'sha256:d4e5f6g7h8i9...'
  }
};

// =============================================================================
// PACK MANIFEST API HANDLER
// =============================================================================

export default async function handler(req: NextRequest) {
  const startTime = Date.now();
  const requestId = nanoid();
  
  try {
    // Handle CORS
    const corsResponse = handleCors(req);
    if (corsResponse) return corsResponse;
    
    // Only allow GET requests
    if (req.method !== 'GET') {
      return sendApiResponse(
        { 
          success: false,
          error: {
            code: 'METHOD_NOT_ALLOWED', 
            message: 'Only GET method is allowed for pack manifest',
            timestamp: new Date().toISOString(),
            requestId
          }
        },
        405
      );
    }

    // Extract packId from URL path
    const url = new URL(req.url);
    const pathSegments = url.pathname.split('/');
    const packId = pathSegments[pathSegments.length - 2]; // manifest is the last segment
    
    if (!packId || packId === '[packId]') {
      return sendApiResponse(
        { 
          success: false,
          error: {
            code: 'MISSING_PACK_ID', 
            message: 'Pack ID is required in URL path',
            timestamp: new Date().toISOString(),
            requestId
          }
        },
        400
      );
    }

    log('info', 'Pack manifest requested', {
      method: req.method,
      requestId,
      packId,
      userAgent: req.headers['user-agent'],
    });
    
    // Find the requested pack
    const packManifest = AVAILABLE_PACKS[packId];
    
    if (!packManifest) {
      log('info', 'Pack not found', {
        requestId,
        packId,
        availablePacks: Object.keys(AVAILABLE_PACKS)
      });
      
      return sendApiResponse(
        { 
          success: false,
          error: {
            code: 'PACK_NOT_FOUND', 
            message: 'Pack not found or not available',
            details: {
              packId,
              availablePacks: Object.keys(AVAILABLE_PACKS)
            },
            timestamp: new Date().toISOString(),
            requestId
          }
        },
        404
      );
    }

    // Check for version parameter
    const requestedVersion = url.searchParams.get('version');
    if (requestedVersion && requestedVersion !== packManifest.version) {
      log('warn', 'Version mismatch for pack', {
        requestId,
        packId,
        requestedVersion,
        availableVersion: packManifest.version
      });
      
      return sendApiResponse(
        { 
          success: false,
          error: {
            code: 'VERSION_MISMATCH', 
            message: 'Requested version not available',
            details: {
              requestedVersion,
              availableVersion: packManifest.version
            },
            timestamp: new Date().toISOString(),
            requestId
          }
        },
        404
      );
    }
    
    log('info', 'Pack manifest retrieved successfully', {
      requestId,
      packId,
      version: packManifest.version,
      technique: packManifest.technique,
      premiumRequired: packManifest.premium_required,
      downloadSize: packManifest.download_size
    });

    const processingTime = Date.now() - startTime;
    
    // Create success response
    const response: ApiResponse<PackManifest> = createApiResponse(packManifest, {
      processingTimeMs: processingTime,
      requestId
    });
    
    // Send response with caching headers for static content
    const nextResponse = sendApiResponse(response, 200);
    addStandardHeaders(nextResponse);
    
    // Add cache headers (manifest data doesn't change often)
    nextResponse.headers.set('Cache-Control', 'public, max-age=3600, s-maxage=3600');
    nextResponse.headers.set('ETag', `"${packManifest.checksum}"`);
    
    return nextResponse;
    
  } catch (error) {
    log('error', 'Pack manifest retrieval failed', { 
      requestId,
      error: error instanceof Error ? error.message : String(error) 
    });
    
    return handleApiError(error, requestId);
  }
}

// =============================================================================
// EDGE FUNCTION CONFIGURATION
// =============================================================================

export const runtime = 'edge';
export const preferredRegion = 'auto';