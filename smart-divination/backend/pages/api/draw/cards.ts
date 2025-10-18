/**

 * Tarot Cards Drawing Endpoint - Ultra-Professional Implementation

 * 

 * Provides cryptographically secure tarot card drawing with full 78-card

 * Rider-Waite-Smith deck, configurable spreads, and verifiable randomness.

 */

import type { NextApiRequest, NextApiResponse } from 'next';

import {
  handleApiError,
  log,
  parseApiRequest,
  drawCardsRequestSchema,
  createRequestId,
  createApiError,
} from '../../../lib/utils/api';

import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../../lib/utils/nextApi';

import { generateRandomCards, decodeTarotCard } from '../../../lib/utils/randomness';
import { SPREADS as TAROT_SPREADS, SpreadDefinition } from '../../../lib/data/spreads';

import {
  createDivinationSession,
  createSessionArtifact,
  createSessionMessage,
} from '../../../lib/utils/supabase';

import { recordApiMetric } from '../../../lib/utils/metrics';

import type { DrawCardsRequest } from '../../../lib/types/api';
import { extractKeywords } from '../../../lib/utils/text';

const METRICS_PATH = '/api/draw/cards';

const ALLOW_HEADER_VALUE = 'OPTIONS, POST';

function buildTarotMessageContent(params: {
  cards: Array<{
    name: string;
    upright: boolean;
    position: number;
  }>;
  spreadId: string;
  seed: string;
  method: string;
  question?: string | null;
}): string {
  const cardSummaries = params.cards
    .slice()
    .sort((a, b) => a.position - b.position)
    .map((card) => `${card.name}${card.upright ? '' : ' (reversed)'}`);
  const summary = cardSummaries.join(', ');
  const parts = [`Spread: ${params.spreadId}`, `Cards: ${summary}`];
  if (params.question && params.question.trim().length > 0) {
    parts.push(`Question: ${params.question.trim()}`);
  }
  parts.push(`Seed: ${params.seed}`);
  parts.push(`Method: ${params.method}`);
  return `Tarot draw completed. ${parts.join(' | ')}`;
}

// =============================================================================

// COMPLETE 78-CARD TAROT DECK DATA

function buildTarotArtifactPayload(params: {
  cards: Array<{
    id: string;
    name: string;
    suit: string;
    number: number | null;
    upright: boolean;
    position: number;
  }>;
  spreadId: string;
  request: DrawCardsRequest;
  seed: string;
  method: string;
  signature?: string | null;
  timestamp: string;
  keywords?: string[];
}): Record<string, unknown> {
  const cards = params.cards.map((card) => ({
    id: card.id,
    name: card.name,
    suit: card.suit,
    number: card.number,
    upright: card.upright,
    position: card.position,
  }));

  const payload: Record<string, unknown> = {
    cards,
    spread: params.spreadId,
    cardCount: cards.length,
    seed: params.seed,
    method: params.method,
    timestamp: params.timestamp,
    allowReversed: params.request.allowReversed ?? true,
  };

  if (params.keywords && params.keywords.length > 0) {
    payload.keywords = params.keywords;
  }

  if (params.signature) {
    payload.signature = params.signature;
  }
  if (params.request.question) {
    payload.question = params.request.question;
  }
  if (params.request.spread) {
    payload.requestedSpread = params.request.spread;
  }
  if (params.request.locale) {
    payload.locale = params.request.locale;
  }
  if (params.request.userId) {
    payload.userId = params.request.userId;
  }

  return payload;
}

// =============================================================================

interface TarotCardData {
  id: number;

  name: string;

  suit: string;

  number: number | null;

  arcana: 'major' | 'minor';

  element?: 'fire' | 'water' | 'air' | 'earth';

  keywords: string[];
}

const TAROT_DECK: TarotCardData[] = [
  // Major Arcana (0-21)

  {
    id: 0,
    name: 'The Fool',
    suit: 'Major Arcana',
    number: 0,
    arcana: 'major',
    keywords: ['new beginnings', 'innocence', 'adventure'],
  },

  {
    id: 1,
    name: 'The Magician',
    suit: 'Major Arcana',
    number: 1,
    arcana: 'major',
    keywords: ['manifestation', 'power', 'skill'],
  },

  {
    id: 2,
    name: 'The High Priestess',
    suit: 'Major Arcana',
    number: 2,
    arcana: 'major',
    keywords: ['intuition', 'mystery', 'inner wisdom'],
  },

  {
    id: 3,
    name: 'The Empress',
    suit: 'Major Arcana',
    number: 3,
    arcana: 'major',
    keywords: ['fertility', 'abundance', 'nature'],
  },

  {
    id: 4,
    name: 'The Emperor',
    suit: 'Major Arcana',
    number: 4,
    arcana: 'major',
    keywords: ['authority', 'structure', 'control'],
  },

  {
    id: 5,
    name: 'The Hierophant',
    suit: 'Major Arcana',
    number: 5,
    arcana: 'major',
    keywords: ['tradition', 'learning', 'guidance'],
  },

  {
    id: 6,
    name: 'The Lovers',
    suit: 'Major Arcana',
    number: 6,
    arcana: 'major',
    keywords: ['love', 'harmony', 'choices'],
  },

  {
    id: 7,
    name: 'The Chariot',
    suit: 'Major Arcana',
    number: 7,
    arcana: 'major',
    keywords: ['determination', 'success', 'control'],
  },

  {
    id: 8,
    name: 'Strength',
    suit: 'Major Arcana',
    number: 8,
    arcana: 'major',
    keywords: ['courage', 'inner strength', 'patience'],
  },

  {
    id: 9,
    name: 'The Hermit',
    suit: 'Major Arcana',
    number: 9,
    arcana: 'major',
    keywords: ['introspection', 'guidance', 'solitude'],
  },

  {
    id: 10,
    name: 'Wheel of Fortune',
    suit: 'Major Arcana',
    number: 10,
    arcana: 'major',
    keywords: ['destiny', 'change', 'cycles'],
  },

  {
    id: 11,
    name: 'Justice',
    suit: 'Major Arcana',
    number: 11,
    arcana: 'major',
    keywords: ['balance', 'fairness', 'truth'],
  },

  {
    id: 12,
    name: 'The Hanged Man',
    suit: 'Major Arcana',
    number: 12,
    arcana: 'major',
    keywords: ['sacrifice', 'perspective', 'letting go'],
  },

  {
    id: 13,
    name: 'Death',
    suit: 'Major Arcana',
    number: 13,
    arcana: 'major',
    keywords: ['transformation', 'endings', 'renewal'],
  },

  {
    id: 14,
    name: 'Temperance',
    suit: 'Major Arcana',
    number: 14,
    arcana: 'major',
    keywords: ['balance', 'moderation', 'patience'],
  },

  {
    id: 15,
    name: 'The Devil',
    suit: 'Major Arcana',
    number: 15,
    arcana: 'major',
    keywords: ['temptation', 'bondage', 'materialism'],
  },

  {
    id: 16,
    name: 'The Tower',
    suit: 'Major Arcana',
    number: 16,
    arcana: 'major',
    keywords: ['sudden change', 'upheaval', 'revelation'],
  },

  {
    id: 17,
    name: 'The Star',
    suit: 'Major Arcana',
    number: 17,
    arcana: 'major',
    keywords: ['hope', 'inspiration', 'healing'],
  },

  {
    id: 18,
    name: 'The Moon',
    suit: 'Major Arcana',
    number: 18,
    arcana: 'major',
    keywords: ['illusion', 'intuition', 'subconscious'],
  },

  {
    id: 19,
    name: 'The Sun',
    suit: 'Major Arcana',
    number: 19,
    arcana: 'major',
    keywords: ['joy', 'success', 'vitality'],
  },

  {
    id: 20,
    name: 'Judgement',
    suit: 'Major Arcana',
    number: 20,
    arcana: 'major',
    keywords: ['rebirth', 'awakening', 'forgiveness'],
  },

  {
    id: 21,
    name: 'The World',
    suit: 'Major Arcana',
    number: 21,
    arcana: 'major',
    keywords: ['completion', 'achievement', 'fulfillment'],
  },

  // Minor Arcana - Wands (Fire)

  {
    id: 22,
    name: 'Ace of Wands',
    suit: 'Wands',
    number: 1,
    arcana: 'minor',
    element: 'fire',
    keywords: ['inspiration', 'new opportunity', 'creative spark'],
  },

  {
    id: 23,
    name: 'Two of Wands',
    suit: 'Wands',
    number: 2,
    arcana: 'minor',
    element: 'fire',
    keywords: ['planning', 'foresight', 'personal power'],
  },

  {
    id: 24,
    name: 'Three of Wands',
    suit: 'Wands',
    number: 3,
    arcana: 'minor',
    element: 'fire',
    keywords: ['expansion', 'foresight', 'overseas opportunities'],
  },

  {
    id: 25,
    name: 'Four of Wands',
    suit: 'Wands',
    number: 4,
    arcana: 'minor',
    element: 'fire',
    keywords: ['celebration', 'harmony', 'homecoming'],
  },

  {
    id: 26,
    name: 'Five of Wands',
    suit: 'Wands',
    number: 5,
    arcana: 'minor',
    element: 'fire',
    keywords: ['conflict', 'competition', 'disagreement'],
  },

  {
    id: 27,
    name: 'Six of Wands',
    suit: 'Wands',
    number: 6,
    arcana: 'minor',
    element: 'fire',
    keywords: ['victory', 'success', 'recognition'],
  },

  {
    id: 28,
    name: 'Seven of Wands',
    suit: 'Wands',
    number: 7,
    arcana: 'minor',
    element: 'fire',
    keywords: ['defensiveness', 'perseverance', 'maintaining position'],
  },

  {
    id: 29,
    name: 'Eight of Wands',
    suit: 'Wands',
    number: 8,
    arcana: 'minor',
    element: 'fire',
    keywords: ['speed', 'action', 'swift change'],
  },

  {
    id: 30,
    name: 'Nine of Wands',
    suit: 'Wands',
    number: 9,
    arcana: 'minor',
    element: 'fire',
    keywords: ['resilience', 'persistence', 'last stand'],
  },

  {
    id: 31,
    name: 'Ten of Wands',
    suit: 'Wands',
    number: 10,
    arcana: 'minor',
    element: 'fire',
    keywords: ['burden', 'responsibility', 'hard work'],
  },

  {
    id: 32,
    name: 'Page of Wands',
    suit: 'Wands',
    number: 11,
    arcana: 'minor',
    element: 'fire',
    keywords: ['enthusiasm', 'exploration', 'new ideas'],
  },

  {
    id: 33,
    name: 'Knight of Wands',
    suit: 'Wands',
    number: 12,
    arcana: 'minor',
    element: 'fire',
    keywords: ['action', 'adventure', 'impulsiveness'],
  },

  {
    id: 34,
    name: 'Queen of Wands',
    suit: 'Wands',
    number: 13,
    arcana: 'minor',
    element: 'fire',
    keywords: ['confidence', 'courage', 'determination'],
  },

  {
    id: 35,
    name: 'King of Wands',
    suit: 'Wands',
    number: 14,
    arcana: 'minor',
    element: 'fire',
    keywords: ['leadership', 'vision', 'entrepreneur'],
  },

  // Minor Arcana - Cups (Water)

  {
    id: 36,
    name: 'Ace of Cups',
    suit: 'Cups',
    number: 1,
    arcana: 'minor',
    element: 'water',
    keywords: ['love', 'intuition', 'spiritual connection'],
  },

  {
    id: 37,
    name: 'Two of Cups',
    suit: 'Cups',
    number: 2,
    arcana: 'minor',
    element: 'water',
    keywords: ['partnership', 'unity', 'mutual attraction'],
  },

  {
    id: 38,
    name: 'Three of Cups',
    suit: 'Cups',
    number: 3,
    arcana: 'minor',
    element: 'water',
    keywords: ['friendship', 'celebration', 'community'],
  },

  {
    id: 39,
    name: 'Four of Cups',
    suit: 'Cups',
    number: 4,
    arcana: 'minor',
    element: 'water',
    keywords: ['apathy', 'contemplation', 'missed opportunities'],
  },

  {
    id: 40,
    name: 'Five of Cups',
    suit: 'Cups',
    number: 5,
    arcana: 'minor',
    element: 'water',
    keywords: ['loss', 'regret', 'disappointment'],
  },

  {
    id: 41,
    name: 'Six of Cups',
    suit: 'Cups',
    number: 6,
    arcana: 'minor',
    element: 'water',
    keywords: ['nostalgia', 'childhood', 'innocence'],
  },

  {
    id: 42,
    name: 'Seven of Cups',
    suit: 'Cups',
    number: 7,
    arcana: 'minor',
    element: 'water',
    keywords: ['illusion', 'choices', 'wishful thinking'],
  },

  {
    id: 43,
    name: 'Eight of Cups',
    suit: 'Cups',
    number: 8,
    arcana: 'minor',
    element: 'water',
    keywords: ['abandonment', 'seeking', 'spiritual quest'],
  },

  {
    id: 44,
    name: 'Nine of Cups',
    suit: 'Cups',
    number: 9,
    arcana: 'minor',
    element: 'water',
    keywords: ['satisfaction', 'contentment', 'wish fulfillment'],
  },

  {
    id: 45,
    name: 'Ten of Cups',
    suit: 'Cups',
    number: 10,
    arcana: 'minor',
    element: 'water',
    keywords: ['happiness', 'fulfillment', 'family harmony'],
  },

  {
    id: 46,
    name: 'Page of Cups',
    suit: 'Cups',
    number: 11,
    arcana: 'minor',
    element: 'water',
    keywords: ['creativity', 'intuition', 'new emotions'],
  },

  {
    id: 47,
    name: 'Knight of Cups',
    suit: 'Cups',
    number: 12,
    arcana: 'minor',
    element: 'water',
    keywords: ['romance', 'charm', 'idealism'],
  },

  {
    id: 48,
    name: 'Queen of Cups',
    suit: 'Cups',
    number: 13,
    arcana: 'minor',
    element: 'water',
    keywords: ['compassion', 'intuition', 'emotional security'],
  },

  {
    id: 49,
    name: 'King of Cups',
    suit: 'Cups',
    number: 14,
    arcana: 'minor',
    element: 'water',
    keywords: ['emotional maturity', 'compassion', 'diplomatic'],
  },

  // Minor Arcana - Swords (Air)

  {
    id: 50,
    name: 'Ace of Swords',
    suit: 'Swords',
    number: 1,
    arcana: 'minor',
    element: 'air',
    keywords: ['breakthrough', 'clarity', 'mental force'],
  },

  {
    id: 51,
    name: 'Two of Swords',
    suit: 'Swords',
    number: 2,
    arcana: 'minor',
    element: 'air',
    keywords: ['difficult choice', 'indecision', 'stalemate'],
  },

  {
    id: 52,
    name: 'Three of Swords',
    suit: 'Swords',
    number: 3,
    arcana: 'minor',
    element: 'air',
    keywords: ['heartbreak', 'sorrow', 'grief'],
  },

  {
    id: 53,
    name: 'Four of Swords',
    suit: 'Swords',
    number: 4,
    arcana: 'minor',
    element: 'air',
    keywords: ['rest', 'meditation', 'contemplation'],
  },

  {
    id: 54,
    name: 'Five of Swords',
    suit: 'Swords',
    number: 5,
    arcana: 'minor',
    element: 'air',
    keywords: ['defeat', 'betrayal', 'loss'],
  },

  {
    id: 55,
    name: 'Six of Swords',
    suit: 'Swords',
    number: 6,
    arcana: 'minor',
    element: 'air',
    keywords: ['transition', 'moving forward', 'travel'],
  },

  {
    id: 56,
    name: 'Seven of Swords',
    suit: 'Swords',
    number: 7,
    arcana: 'minor',
    element: 'air',
    keywords: ['deception', 'strategy', 'stealth'],
  },

  {
    id: 57,
    name: 'Eight of Swords',
    suit: 'Swords',
    number: 8,
    arcana: 'minor',
    element: 'air',
    keywords: ['restriction', 'imprisonment', 'victim mentality'],
  },

  {
    id: 58,
    name: 'Nine of Swords',
    suit: 'Swords',
    number: 9,
    arcana: 'minor',
    element: 'air',
    keywords: ['anxiety', 'worry', 'nightmares'],
  },

  {
    id: 59,
    name: 'Ten of Swords',
    suit: 'Swords',
    number: 10,
    arcana: 'minor',
    element: 'air',
    keywords: ['rock bottom', 'betrayal', 'endings'],
  },

  {
    id: 60,
    name: 'Page of Swords',
    suit: 'Swords',
    number: 11,
    arcana: 'minor',
    element: 'air',
    keywords: ['curiosity', 'new ideas', 'mental agility'],
  },

  {
    id: 61,
    name: 'Knight of Swords',
    suit: 'Swords',
    number: 12,
    arcana: 'minor',
    element: 'air',
    keywords: ['action', 'haste', 'impatience'],
  },

  {
    id: 62,
    name: 'Queen of Swords',
    suit: 'Swords',
    number: 13,
    arcana: 'minor',
    element: 'air',
    keywords: ['independence', 'clear thinking', 'direct communication'],
  },

  {
    id: 63,
    name: 'King of Swords',
    suit: 'Swords',
    number: 14,
    arcana: 'minor',
    element: 'air',
    keywords: ['authority', 'intellectual power', 'truth'],
  },

  // Minor Arcana - Pentacles (Earth)

  {
    id: 64,
    name: 'Ace of Pentacles',
    suit: 'Pentacles',
    number: 1,
    arcana: 'minor',
    element: 'earth',
    keywords: ['opportunity', 'manifestation', 'new venture'],
  },

  {
    id: 65,
    name: 'Two of Pentacles',
    suit: 'Pentacles',
    number: 2,
    arcana: 'minor',
    element: 'earth',
    keywords: ['balance', 'adaptability', 'time management'],
  },

  {
    id: 66,
    name: 'Three of Pentacles',
    suit: 'Pentacles',
    number: 3,
    arcana: 'minor',
    element: 'earth',
    keywords: ['teamwork', 'collaboration', 'skill building'],
  },

  {
    id: 67,
    name: 'Four of Pentacles',
    suit: 'Pentacles',
    number: 4,
    arcana: 'minor',
    element: 'earth',
    keywords: ['security', 'possessiveness', 'conservation'],
  },

  {
    id: 68,
    name: 'Five of Pentacles',
    suit: 'Pentacles',
    number: 5,
    arcana: 'minor',
    element: 'earth',
    keywords: ['hardship', 'insecurity', 'worry'],
  },

  {
    id: 69,
    name: 'Six of Pentacles',
    suit: 'Pentacles',
    number: 6,
    arcana: 'minor',
    element: 'earth',
    keywords: ['generosity', 'charity', 'sharing'],
  },

  {
    id: 70,
    name: 'Seven of Pentacles',
    suit: 'Pentacles',
    number: 7,
    arcana: 'minor',
    element: 'earth',
    keywords: ['investment', 'long-term view', 'perseverance'],
  },

  {
    id: 71,
    name: 'Eight of Pentacles',
    suit: 'Pentacles',
    number: 8,
    arcana: 'minor',
    element: 'earth',
    keywords: ['apprenticeship', 'skill development', 'quality work'],
  },

  {
    id: 72,
    name: 'Nine of Pentacles',
    suit: 'Pentacles',
    number: 9,
    arcana: 'minor',
    element: 'earth',
    keywords: ['luxury', 'self-reliance', 'financial independence'],
  },

  {
    id: 73,
    name: 'Ten of Pentacles',
    suit: 'Pentacles',
    number: 10,
    arcana: 'minor',
    element: 'earth',
    keywords: ['wealth', 'legacy', 'family'],
  },

  {
    id: 74,
    name: 'Page of Pentacles',
    suit: 'Pentacles',
    number: 11,
    arcana: 'minor',
    element: 'earth',
    keywords: ['study', 'planning', 'new financial opportunity'],
  },

  {
    id: 75,
    name: 'Knight of Pentacles',
    suit: 'Pentacles',
    number: 12,
    arcana: 'minor',
    element: 'earth',
    keywords: ['routine', 'hard work', 'reliability'],
  },

  {
    id: 76,
    name: 'Queen of Pentacles',
    suit: 'Pentacles',
    number: 13,
    arcana: 'minor',
    element: 'earth',
    keywords: ['nurturing', 'practical', 'down-to-earth'],
  },

  {
    id: 77,
    name: 'King of Pentacles',
    suit: 'Pentacles',
    number: 14,
    arcana: 'minor',
    element: 'earth',
    keywords: ['financial security', 'business acumen', 'generosity'],
  },
];

// MAIN HANDLER

// =============================================================================

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const startedAt = Date.now();

  let requestId = createRequestId();

  const corsConfig = { methods: 'POST,OPTIONS' } as const;

  applyCorsHeaders(res, corsConfig);

  applyStandardResponseHeaders(res);

  if (handleCorsPreflight(req, res, corsConfig)) {
    recordApiMetric(METRICS_PATH, 204, Date.now() - startedAt);

    return;
  }

  if (req.method !== 'POST') {
    res.setHeader('Allow', ALLOW_HEADER_VALUE);

    sendJsonError(res, 405, {
      code: 'METHOD_NOT_ALLOWED',

      message: 'Only POST method is allowed for draw/cards',

      requestId,
    });

    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);

    return;
  }

  try {
    const {
      data: parsedData,
      requestId: parsedRequestId,
      auth,
    } = await parseApiRequest(req, drawCardsRequestSchema, { requireUser: false });

    requestId = parsedRequestId;

    const requestData = parsedData as DrawCardsRequest & {
      allowReversed: boolean;
      spread?: string;
    };

    // Allow both authenticated users and anonymous users (with x-user-id header)
    const requestUserId = auth?.userId ?? requestData.userId;
    if (!requestUserId) {
      throw createApiError(
        'INVALID_REQUEST',
        'User ID is required (either via Bearer token or x-user-id header)',
        400,
        { statusCode: 400 },
        requestId
      );
    }

    log('info', 'Tarot cards draw requested', {
      requestId,

      count: requestData.count,

      spread: requestData.spread,

      allowReversed: requestData.allowReversed,

      technique: 'tarot',
    });

    let selectedSpread: SpreadDefinition | undefined;

    if (requestData.spread) {
      selectedSpread = TAROT_SPREADS.find((spread) => spread.id === requestData.spread);

      if (!selectedSpread) {
        sendJsonError(res, 400, {
          code: 'INVALID_SPREAD',

          message:
            'Invalid spread: ' +
            requestData.spread +
            '. Available spreads: ' +
            TAROT_SPREADS.map((spread) => spread.id).join(', '),

          requestId,
        });

        recordApiMetric(METRICS_PATH, 400, Date.now() - startedAt);

        return;
      }

      if (requestData.count !== selectedSpread.cardCount) {
        sendJsonError(res, 400, {
          code: 'COUNT_SPREAD_MISMATCH',

          message:
            "Spread '" +
            selectedSpread.name +
            "' requires " +
            selectedSpread.cardCount +
            ' cards, but ' +
            requestData.count +
            ' requested',

          requestId,
        });

        recordApiMetric(METRICS_PATH, 400, Date.now() - startedAt);

        return;
      }
    }

    const randomResult = await generateRandomCards({
      count: requestData.count,

      seed: requestData.seed,

      allowDuplicates: false,
    });

    const cards = randomResult.values.map((encodedValue, position) => {
      const { cardIndex, isReversed } = decodeTarotCard(encodedValue);

      const cardData = TAROT_DECK[cardIndex];

      if (!cardData) {
        throw new Error(`Invalid tarot card index generated: ${cardIndex}`);
      }

      const upright = requestData.allowReversed ? !isReversed : true;

      return {
        id: `card_${cardIndex}`,

        name: cardData.name,

        suit: cardData.suit,

        number: cardData.number,

        upright,

        position: position + 1,
      };
    });

    const session = await createDivinationSession({
      userId: requestUserId,

      technique: 'tarot',

      locale: requestData.locale || 'en',

      question: requestData.question || undefined,

      results: {
        cards,

        spread: selectedSpread?.id || 'custom',

        cardCount: requestData.count,
      },

      metadata: {
        seed: randomResult.seed,

        method: randomResult.method,

        signature: randomResult.signature,
      },
    });

    const responseTimestamp = new Date().toISOString();
    const supabaseAvailable = Boolean(
      process.env.SUPABASE_URL && process.env.SUPABASE_SERVICE_ROLE_KEY
    );

    if (supabaseAvailable && session?.id) {
      const questionKeywords = extractKeywords(requestData.question);

      try {
        await createSessionArtifact({
          sessionId: session.id,
          type: 'tarot_draw',
          source: 'system',
          payload: buildTarotArtifactPayload({
            cards,
            spreadId: selectedSpread?.id || 'custom',
            request: requestData,
            seed: randomResult.seed,
            method: randomResult.method,
            signature: randomResult.signature,
            timestamp: responseTimestamp,
            keywords: questionKeywords,
          }),
        });
      } catch (artifactError) {
        log('warn', 'Failed to persist tarot draw artifact', {
          requestId,
          sessionId: session.id,
          error: artifactError instanceof Error ? artifactError.message : String(artifactError),
        });
      }

      if (requestData.question && requestData.question.trim().length > 0) {
        try {
          await createSessionMessage({
            sessionId: session.id,
            sender: 'user',
            content: requestData.question.trim(),
            metadata: {
              locale: requestData.locale ?? 'en',
              seed: randomResult.seed,
              method: randomResult.method,
              spread: selectedSpread?.id || 'custom',
              keywords: questionKeywords,
            },
          });
        } catch (questionError) {
          log('warn', 'Failed to persist tarot question message', {
            requestId,
            sessionId: session.id,
            error: questionError instanceof Error ? questionError.message : String(questionError),
          });
        }
      }

      try {
        const messageContent = buildTarotMessageContent({
          cards: cards.map((card) => ({
            name: card.name,
            upright: card.upright,
            position: card.position,
          })),
          spreadId: selectedSpread?.id || 'custom',
          seed: randomResult.seed,
          method: randomResult.method,
          question: requestData.question ?? null,
        });

        await createSessionMessage({
          sessionId: session.id,
          sender: 'system',
          content: messageContent,
          metadata: {
            seed: randomResult.seed,
            method: randomResult.method,
            spread: selectedSpread?.id || 'custom',
            cardCount: cards.length,
            locale: requestData.locale ?? 'en',
            keywords: questionKeywords,
          },
        });
      } catch (messageError) {
        log('warn', 'Failed to persist tarot draw message', {
          requestId,
          sessionId: session.id,
          error: messageError instanceof Error ? messageError.message : String(messageError),
        });
      }
    }

    const duration = Date.now() - startedAt;

    res.status(200).json({
      success: true,

      result: cards,

      spread: selectedSpread?.id || 'custom',

      seed: randomResult.seed,

      signature: randomResult.signature,

      method: randomResult.method,

      sessionId: session?.id,

      timestamp: responseTimestamp,

      locale: requestData.locale || 'en',

      requestId,
    });

    recordApiMetric(METRICS_PATH, 200, duration);
  } catch (error) {
    handleApiError(res, error, requestId);

    recordApiMetric(METRICS_PATH, res.statusCode || 500, Date.now() - startedAt);
  }
}

// =============================================================================
