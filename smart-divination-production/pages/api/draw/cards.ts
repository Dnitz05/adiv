/**
 * Tarot Cards Drawing Endpoint - Ultra-Professional Implementation
 *
 * Provides cryptographically secure tarot card drawing with full 78-card
 * Rider-Waite-Smith deck, configurable spreads, and verifiable randomness.
 */

import type { NextRequest } from 'next/server';
import {
  sendApiResponse,
  createApiResponse,
  handleApiError,
  handleCors,
  addStandardHeaders,
  log,
  parseApiRequest,
  drawCardsRequestSchema,
} from '../../../lib/utils/api';
import { generateRandomCards, generateRandomOrientations } from '../../../lib/utils/randomness';
import { createDivinationSession } from '../../../lib/utils/supabase';
import { recordApiMetric } from '../../../lib/utils/metrics';
import type { TarotCard } from '../../../lib/types/api';

// =============================================================================
// COMPLETE 78-CARD TAROT DECK DATA
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

// =============================================================================
// TAROT SPREADS CONFIGURATION
// =============================================================================

interface SpreadPosition {
  id: string;
  name: string;
  meaning: string;
  x?: number;
  y?: number;
}

interface SpreadDefinition {
  id: string;
  name: string;
  description: string;
  cardCount: number;
  positions: SpreadPosition[];
}

const TAROT_SPREADS: SpreadDefinition[] = [
  {
    id: 'single',
    name: 'Single Card',
    description: 'A simple one-card draw for quick guidance',
    cardCount: 1,
    positions: [{ id: 'card1', name: 'Your Card', meaning: 'General guidance for your situation' }],
  },
  {
    id: 'three_card',
    name: 'Three Card Spread',
    description: 'Past, Present, Future or Situation, Action, Outcome',
    cardCount: 3,
    positions: [
      { id: 'past', name: 'Past/Situation', meaning: 'What has led to this moment' },
      { id: 'present', name: 'Present/Action', meaning: 'Current energies and what to focus on' },
      { id: 'future', name: 'Future/Outcome', meaning: 'Likely outcome if current path continues' },
    ],
  },
  {
    id: 'celtic_cross',
    name: 'Celtic Cross',
    description: 'The classic 10-card spread for comprehensive readings',
    cardCount: 10,
    positions: [
      { id: 'present', name: 'Present Situation', meaning: 'Your current situation' },
      { id: 'challenge', name: 'Challenge/Cross', meaning: 'What crosses you or challenges you' },
      {
        id: 'distant_past',
        name: 'Distant Past',
        meaning: 'Distant past or root of the situation',
      },
      { id: 'recent_past', name: 'Recent Past', meaning: 'Recent past events' },
      { id: 'possible_outcome', name: 'Possible Outcome', meaning: 'What may come to pass' },
      { id: 'near_future', name: 'Near Future', meaning: 'Immediate future' },
      { id: 'your_approach', name: 'Your Approach', meaning: 'How you approach the situation' },
      {
        id: 'external_influences',
        name: 'External Influences',
        meaning: 'External influences affecting you',
      },
      { id: 'hopes_fears', name: 'Hopes and Fears', meaning: 'Your hopes and fears' },
      { id: 'final_outcome', name: 'Final Outcome', meaning: 'Final outcome or resolution' },
    ],
  },
  {
    id: 'relationship',
    name: 'Relationship Spread',
    description: 'Seven-card spread for relationship insights',
    cardCount: 7,
    positions: [
      { id: 'you', name: 'You', meaning: 'Your role in the relationship' },
      { id: 'them', name: 'Them', meaning: 'Their role in the relationship' },
      { id: 'connection', name: 'Connection', meaning: 'The connection between you' },
      { id: 'challenges', name: 'Challenges', meaning: 'Current challenges' },
      { id: 'strengths', name: 'Strengths', meaning: 'Relationship strengths' },
      { id: 'advice', name: 'Advice', meaning: 'Guidance for moving forward' },
      { id: 'outcome', name: 'Potential Outcome', meaning: 'Where this is heading' },
    ],
  },
  {
    id: 'career',
    name: 'Career Guidance',
    description: 'Five-card spread for career and professional life',
    cardCount: 5,
    positions: [
      {
        id: 'current_position',
        name: 'Current Position',
        meaning: 'Your current professional state',
      },
      { id: 'skills_talents', name: 'Skills & Talents', meaning: 'Your key strengths to leverage' },
      { id: 'obstacles', name: 'Obstacles', meaning: 'What stands in your way' },
      { id: 'opportunities', name: 'Opportunities', meaning: 'Available opportunities' },
      { id: 'guidance', name: 'Guidance', meaning: 'Next steps to take' },
    ],
  },
];

// =============================================================================
// MAIN HANDLER
// =============================================================================

export default async function handler(req: NextRequest): Promise<Response> {
  const startTime = Date.now();

  try {
    // Handle CORS
    const corsResponse = handleCors(req);
    if (corsResponse) return corsResponse;

    // Only allow POST requests
    if (req.method !== 'POST') {
      return sendApiResponse(
        {
          code: 'METHOD_NOT_ALLOWED',
          message: 'Method not allowed',
          timestamp: new Date().toISOString(),
        },
        405
      );
    }

    // Parse and validate request
    const { data: requestData, requestId } = await parseApiRequest(req, drawCardsRequestSchema);

    log('info', 'Tarot cards draw requested', {
      requestId,
      count: requestData.count,
      spread: requestData.spread,
      allowReversed: requestData.allowReversed,
      technique: 'tarot',
    });

    // Validate spread if provided
    let selectedSpread: SpreadDefinition | undefined;
    if (requestData.spread) {
      selectedSpread = TAROT_SPREADS.find((s) => s.id === requestData.spread);
      if (!selectedSpread) {
        return sendApiResponse(
          {
            code: 'INVALID_SPREAD',
            message: `Invalid spread: ${requestData.spread}. Available spreads: ${TAROT_SPREADS.map((s) => s.id).join(', ')}`,
            timestamp: new Date().toISOString(),
            requestId,
          },
          400
        );
      }

      // Validate card count matches spread
      if (requestData.count !== selectedSpread.cardCount) {
        return sendApiResponse(
          {
            code: 'COUNT_SPREAD_MISMATCH',
            message: `Spread '${selectedSpread.name}' requires ${selectedSpread.cardCount} cards, but ${requestData.count} requested`,
            timestamp: new Date().toISOString(),
            requestId,
          },
          400
        );
      }
    }

    // Generate random cards
    const randomResult = await generateRandomCards({
      count: requestData.count,
      seed: requestData.seed,
      allowDuplicates: false, // Tarot never allows duplicates
    });

    // Generate independent orientations if reversals are allowed
    type OrientationMeta = { seed: string; method: string; signature?: string; values: number[] };
    let orientationResult: OrientationMeta | null = null;
    if (requestData.allowReversed) {
      orientationResult = await generateRandomOrientations({
        count: requestData.count,
        baseSeed: randomResult.seed, // Derive from card seed but ensure independence
      });
    }

    // Convert to tarot cards with positioning
    const cards: TarotCard[] = randomResult.values.map((encodedValue, position) => {
      // Decode the card index and reversal from encoded value
      const cardIndex = encodedValue >> 1; // Extract card index (remove last bit)
      const encodedReversal = encodedValue & 1; // Extract reversal bit (last bit)

      const cardData = TAROT_DECK[cardIndex];
      if (!cardData) {
        throw new Error(`Invalid card index: ${cardIndex} (encoded: ${encodedValue})`);
      }

      // const positionInfo = selectedSpread?.positions[position];

      // Determine if card is reversed - use encoded reversal if available, otherwise use separate orientation
      const isReversed = requestData.allowReversed
        ? orientationResult
          ? orientationResult.values[position] === 1
          : encodedReversal === 1
        : false;

      return {
        id: cardIndex,
        name: cardData.name,
        suit: cardData.suit,
        number: cardData.number,
        isReversed,
        position: position + 1,
      };
    });

    // Create session for tracking
    const sessionData = {
      userId: requestData.userId || 'anonymous',
      technique: 'tarot' as const,
      locale: requestData.locale || 'en',
      question: requestData.question,
      results: {
        cards,
        spread: selectedSpread?.id || 'custom',
        cardCount: requestData.count,
      },
      metadata: {
        seed: randomResult.seed,
        method: randomResult.method,
        signature: randomResult.signature,
        // Include orientation metadata for transparency
        orientationMethod: orientationResult?.method,
        orientationSeed: orientationResult?.seed,
        orientationSignature: orientationResult?.signature,
        independentOrientations: !!orientationResult,
      },
    };

    const session = await createDivinationSession(sessionData);

    // Build response
    const responseData = {
      data: cards,
      spread: selectedSpread?.id || 'custom',
    };

    const processingTime = Date.now() - startTime;

    const baseResponse = createApiResponse(responseData, {
      processingTimeMs: processingTime,
    });

    const response = {
      ...baseResponse,
      seed: randomResult.seed,
      signature: randomResult.signature,
      method: randomResult.method,
      sessionId: session?.id,
      ...(orientationResult
        ? {
            orientationSeed: orientationResult.seed,
            orientationMethod: orientationResult.method,
            orientationSignature: orientationResult.signature,
            independentOrientations: true,
          }
        : { independentOrientations: false }),
    };

    log('info', 'Tarot cards draw completed', {
      requestId,
      cardsDrawn: cards.length,
      spreadUsed: selectedSpread?.id || 'custom',
      method: randomResult.method,
      processingTimeMs: processingTime,
      sessionId: session?.id,
    });

    const nextResponse = sendApiResponse(response, 200);
    addStandardHeaders(nextResponse);
    recordApiMetric('/api/draw/cards', 200, processingTime);
    return nextResponse;
  } catch (error) {
    log('error', 'Tarot cards draw failed', {
      error: error instanceof Error ? error.message : String(error),
    });

    const d500 = Date.now() - startTime;
    recordApiMetric('/api/draw/cards', 500, d500);
    return handleApiError(error);
  }
}

// =============================================================================
// EDGE FUNCTION CONFIGURATION
// =============================================================================

export const runtime = 'edge';
export const preferredRegion = 'auto';
