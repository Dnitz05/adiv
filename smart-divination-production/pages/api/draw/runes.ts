/**
 * Runes Drawing Endpoint - Ultra-Professional Implementation
 *
 * Provides cryptographically secure rune drawing with complete Elder Futhark
 * system, configurable spreads, and verifiable randomness.
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
  drawRunesRequestSchema,
} from '../../../lib/utils/api';
import { generateRandomCards } from '../../../lib/utils/randomness';
import { createDivinationSession } from '../../../lib/utils/supabase';
import type { Rune } from '../../../lib/types/api';

// =============================================================================
// COMPLETE ELDER FUTHARK RUNE SYSTEM
// =============================================================================

interface RuneData {
  id: number;
  name: string;
  symbol: string;
  phonetic: string;
  element: string;
  aett: number; // Which group (1st, 2nd, or 3rd aett)
  meaning: string;
  keywords: {
    upright: string[];
    reversed: string[];
  };
  divinatory: {
    upright: string;
    reversed: string;
  };
  description: string;
}

// Complete Elder Futhark (24 runes) with detailed meanings
const ELDER_FUTHARK: RuneData[] = [
  // First Aett - Freyr's Eight
  {
    id: 0,
    name: 'Fehu',
    symbol: 'ᚠ',
    phonetic: 'F',
    element: 'Fire',
    aett: 1,
    meaning: 'Cattle, Wealth',
    keywords: {
      upright: ['wealth', 'prosperity', 'abundance', 'success', 'fertility', 'new beginnings'],
      reversed: ['loss', 'poverty', 'greed', 'failure', 'cowardice', 'material obsession'],
    },
    divinatory: {
      upright: 'Material wealth and spiritual richness are coming into your life',
      reversed: 'Loss or misuse of resources, be careful with finances',
    },
    description: 'The first rune represents moveable wealth and new beginnings',
  },
  {
    id: 1,
    name: 'Uruz',
    symbol: 'ᚢ',
    phonetic: 'U',
    element: 'Earth',
    aett: 1,
    meaning: 'Aurochs, Wild Ox',
    keywords: {
      upright: ['strength', 'vitality', 'courage', 'determination', 'healing', 'primal power'],
      reversed: ['weakness', 'sickness', 'brutality', 'misdirected force', 'domination'],
    },
    divinatory: {
      upright: 'Raw strength and vitality will help you overcome challenges',
      reversed: 'Misuse of power or lack of inner strength',
    },
    description: 'Represents raw, primal strength and the power to overcome obstacles',
  },
  {
    id: 2,
    name: 'Thurisaz',
    symbol: 'ᚦ',
    phonetic: 'TH',
    element: 'Fire',
    aett: 1,
    meaning: 'Thorn, Giant',
    keywords: {
      upright: ['protection', 'conflict', 'catalyst', 'breakthrough', 'cleansing', 'defense'],
      reversed: ['danger', 'malice', 'hatred', 'torment', 'spite', 'villany'],
    },
    divinatory: {
      upright: 'Protective force and necessary conflict leading to growth',
      reversed: 'Destructive forces or malicious attacks',
    },
    description: 'The thorn that protects the rose; catalyst for change through conflict',
  },
  {
    id: 3,
    name: 'Ansuz',
    symbol: 'ᚨ',
    phonetic: 'A',
    element: 'Air',
    aett: 1,
    meaning: 'Divine Breath, Odin',
    keywords: {
      upright: ['communication', 'wisdom', 'inspiration', 'divine guidance', 'truth', 'revelation'],
      reversed: ['misunderstanding', 'delusion', 'manipulation', 'vanity', 'grandiloquence'],
    },
    divinatory: {
      upright: 'Divine inspiration and clear communication guide your path',
      reversed: 'Miscommunication or being deceived by false wisdom',
    },
    description: 'The breath of Odin that brings divine inspiration and communication',
  },
  {
    id: 4,
    name: 'Raidho',
    symbol: 'ᚱ',
    phonetic: 'R',
    element: 'Air',
    aett: 1,
    meaning: 'Journey, Riding',
    keywords: {
      upright: ['journey', 'movement', 'evolution', 'perspective', 'quest', 'rhythm'],
      reversed: [
        'stagnation',
        'injustice',
        'rigidity',
        'irrationality',
        'disruption',
        'dislocation',
      ],
    },
    divinatory: {
      upright: 'A journey or quest that brings growth and new perspectives',
      reversed: 'Delays, disruption of plans, or stagnation',
    },
    description: 'The cosmic rhythm and the journey of personal evolution',
  },
  {
    id: 5,
    name: 'Kenaz',
    symbol: 'ᚲ',
    phonetic: 'K/C',
    element: 'Fire',
    aett: 1,
    meaning: 'Torch, Fire',
    keywords: {
      upright: ['knowledge', 'inspiration', 'learning', 'creativity', 'passion', 'illumination'],
      reversed: ['ignorance', 'instability', 'lack of creativity', 'arrogance', 'false hope'],
    },
    divinatory: {
      upright: 'The light of knowledge and creative inspiration illuminates your path',
      reversed: 'Lack of vision or false illumination leading you astray',
    },
    description: 'The controlled fire of knowledge and artistic inspiration',
  },
  {
    id: 6,
    name: 'Gebo',
    symbol: 'ᚷ',
    phonetic: 'G',
    element: 'Air',
    aett: 1,
    meaning: 'Gift',
    keywords: {
      upright: ['gift', 'generosity', 'partnership', 'balance', 'exchange', 'sacrifice'],
      reversed: ['greed', 'loneliness', 'dependence', 'over-sacrifice', 'obligations', 'bribes'],
    },
    divinatory: {
      upright: 'Gifts and partnerships bring mutual benefit and growth',
      reversed: 'Imbalanced exchanges or excessive dependence',
    },
    description: 'The gift that creates bonds and the balance of giving and receiving',
  },
  {
    id: 7,
    name: 'Wunjo',
    symbol: 'ᚹ',
    phonetic: 'W/V',
    element: 'Earth',
    aett: 1,
    meaning: 'Joy, Perfection',
    keywords: {
      upright: ['joy', 'comfort', 'pleasure', 'fellowship', 'harmony', 'prosperity'],
      reversed: ['strive', 'alienation', 'delusion', 'intoxication', 'possession by higher forces'],
    },
    divinatory: {
      upright: 'Joy and harmony fill your life; goals are achieved',
      reversed: 'Delays in happiness or false joy masking deeper issues',
    },
    description: 'The perfection of joy and the completion of the first cycle',
  },

  // Second Aett - Heimdall's Eight
  {
    id: 8,
    name: 'Hagalaz',
    symbol: 'ᚺ',
    phonetic: 'H',
    element: 'Water',
    aett: 2,
    meaning: 'Hail',
    keywords: {
      upright: [
        'crisis',
        'disruption',
        'awakening',
        'natural forces',
        'elemental power',
        'destruction',
      ],
      reversed: ['natural disaster', 'catastrophe', 'uncontrolled forces', 'hardship', 'crisis'],
    },
    divinatory: {
      upright: 'Sudden disruption that leads to awakening and growth',
      reversed: 'Severe disruption or natural forces beyond your control',
    },
    description: 'The hailstone that disrupts but also awakens new possibilities',
  },
  {
    id: 9,
    name: 'Nauthiz',
    symbol: 'ᚾ',
    phonetic: 'N',
    element: 'Fire',
    aett: 2,
    meaning: 'Need, Necessity',
    keywords: {
      upright: ['need', 'resistance', 'survival', 'determination', 'self-reliance', 'innovation'],
      reversed: ['distress', 'toil', 'drudgery', 'laxity', 'villainy', 'want'],
    },
    divinatory: {
      upright: 'Through necessity and constraint, you develop strength and wisdom',
      reversed: 'Excessive need or want that leads to desperation',
    },
    description: 'The need-fire that ignites innovation and self-reliance',
  },
  {
    id: 10,
    name: 'Isa',
    symbol: 'ᛁ',
    phonetic: 'I',
    element: 'Water',
    aett: 2,
    meaning: 'Ice',
    keywords: {
      upright: ['stillness', 'introspection', 'contemplation', 'standstill', 'clarity', 'focus'],
      reversed: ['ego', 'dullness', 'blindness', 'dissipation', 'plots', 'treachery'],
    },
    divinatory: {
      upright: 'A time for stillness, patience, and inner reflection',
      reversed: 'Stagnation due to ego or inability to see clearly',
    },
    description: 'The ice that preserves and provides clarity through stillness',
  },
  {
    id: 11,
    name: 'Jera',
    symbol: 'ᛃ',
    phonetic: 'J/Y',
    element: 'Earth',
    aett: 2,
    meaning: 'Year, Harvest',
    keywords: {
      upright: ['harvest', 'reward', 'cycle', 'patience', 'natural timing', 'fruition'],
      reversed: ['bad timing', 'poverty', 'conflict', 'repetition', 'regression'],
    },
    divinatory: {
      upright: 'Your efforts will bear fruit in due season; patience pays off',
      reversed: 'Poor timing or failure to reap what you have sown',
    },
    description: 'The natural cycle of sowing and reaping; good harvest after hard work',
  },
  {
    id: 12,
    name: 'Eihwaz',
    symbol: 'ᛇ',
    phonetic: 'EI',
    element: 'All',
    aett: 2,
    meaning: 'Yew Tree',
    keywords: {
      upright: [
        'transformation',
        'initiation',
        'protection',
        'regeneration',
        'wisdom',
        'endurance',
      ],
      reversed: ['destruction', 'weakness', 'confusion', 'dissatisfaction', 'weakness'],
    },
    divinatory: {
      upright: 'Deep transformation and spiritual initiation bring wisdom',
      reversed: 'Resistance to necessary change or spiritual confusion',
    },
    description: 'The World Tree that connects all worlds; death and rebirth',
  },
  {
    id: 13,
    name: 'Perthro',
    symbol: 'ᛈ',
    phonetic: 'P',
    element: 'Water',
    aett: 2,
    meaning: 'Dice Cup, Mystery',
    keywords: {
      upright: [
        'mystery',
        'hidden knowledge',
        'occult',
        'feminine mysteries',
        'divination',
        'chance',
      ],
      reversed: ['addiction', 'stagnation', 'loneliness', 'malaise'],
    },
    divinatory: {
      upright: 'Hidden knowledge and mysteries are revealed to you',
      reversed: 'Secrets withheld or addiction to the unknown',
    },
    description: 'The cup of fate that holds the mysteries of wyrd and chance',
  },
  {
    id: 14,
    name: 'Algiz',
    symbol: 'ᛉ',
    phonetic: 'Z',
    element: 'Air',
    aett: 2,
    meaning: 'Elk, Protection',
    keywords: {
      upright: ['protection', 'shield', 'connection to divine', 'sanctuary', 'guardian', 'warning'],
      reversed: ['vulnerability', 'taboo', 'turning away from divine', 'danger'],
    },
    divinatory: {
      upright: 'Divine protection surrounds you; you are shielded from harm',
      reversed: 'Vulnerability due to disconnection from divine protection',
    },
    description: 'The protective hand reaching toward the divine; spiritual protection',
  },
  {
    id: 15,
    name: 'Sowilo',
    symbol: 'ᛊ',
    phonetic: 'S',
    element: 'Fire',
    aett: 2,
    meaning: 'Sun',
    keywords: {
      upright: ['success', 'vitality', 'power', 'strength', 'health', 'achievement'],
      reversed: ['false goals', 'bad counsel', 'false success', 'gullibility', 'vindictiveness'],
    },
    divinatory: {
      upright: 'Success and victory shine upon your endeavors',
      reversed: 'False success or misdirected energy leading to failure',
    },
    description: 'The unconquerable sun; power, success, and life force',
  },

  // Third Aett - Tyr's Eight
  {
    id: 16,
    name: 'Tiwaz',
    symbol: 'ᛏ',
    phonetic: 'T',
    element: 'Air',
    aett: 3,
    meaning: 'Tyr, Warrior',
    keywords: {
      upright: ['victory', 'honor', 'justice', 'leadership', 'authority', 'analysis'],
      reversed: ['injustice', 'dishonor', 'loss', 'defeat', 'imbalance', 'over-analysis'],
    },
    divinatory: {
      upright: 'Justice and honor guide you to victory in your endeavors',
      reversed: 'Injustice or dishonorable defeat; lack of moral compass',
    },
    description: 'The spear of Tyr; justice, sacrifice, and the warrior spirit',
  },
  {
    id: 17,
    name: 'Berkano',
    symbol: 'ᛒ',
    phonetic: 'B',
    element: 'Earth',
    aett: 3,
    meaning: 'Birch, Growth',
    keywords: {
      upright: ['growth', 'renewal', 'fertility', 'healing', 'recovery', 'family'],
      reversed: ['family problems', 'domestic troubles', 'anxiety', 'carelessness', 'abandon'],
    },
    divinatory: {
      upright: 'New growth and healing energy bring renewal to your life',
      reversed: 'Family troubles or obstacles to growth and healing',
    },
    description: 'The birch tree of new beginnings; growth, fertility, and renewal',
  },
  {
    id: 18,
    name: 'Ehwaz',
    symbol: 'ᛖ',
    phonetic: 'E',
    element: 'Earth',
    aett: 3,
    meaning: 'Horse',
    keywords: {
      upright: ['partnership', 'trust', 'loyalty', 'teamwork', 'friendship', 'cooperation'],
      reversed: ['betrayal', 'disloyalty', 'mistrust', 'disharmony', 'reckless haste'],
    },
    divinatory: {
      upright: 'Partnerships and loyal friendships support your journey',
      reversed: 'Betrayal or breakdown in partnerships and trust',
    },
    description: 'The horse that carries its rider; partnership between human and nature',
  },
  {
    id: 19,
    name: 'Mannaz',
    symbol: 'ᛗ',
    phonetic: 'M',
    element: 'Air',
    aett: 3,
    meaning: 'Man, Humanity',
    keywords: {
      upright: ['humanity', 'community', 'interdependence', 'cooperation', 'social', 'support'],
      reversed: ['isolation', 'depression', 'cunning', 'manipulation', 'craftiness', 'calculation'],
    },
    divinatory: {
      upright: 'Human community and cooperation bring support and growth',
      reversed: 'Isolation from others or manipulative behavior',
    },
    description: 'The divine structure of human consciousness and community',
  },
  {
    id: 20,
    name: 'Laguz',
    symbol: 'ᛚ',
    phonetic: 'L',
    element: 'Water',
    aett: 3,
    meaning: 'Water, Lake',
    keywords: {
      upright: ['flow', 'intuition', 'psychic abilities', 'healing', 'cleansing', 'renewal'],
      reversed: ['confusion', 'lack of creativity', 'insecurity', 'fear', 'avoidance', 'madness'],
    },
    divinatory: {
      upright: 'Flow with intuition and let healing waters cleanse your spirit',
      reversed: 'Confusion and lack of direction; fear of the unknown',
    },
    description: 'The primal waters of life; intuition, emotions, and the unconscious',
  },
  {
    id: 21,
    name: 'Ingwaz',
    symbol: 'ᛜ',
    phonetic: 'ING',
    element: 'Earth',
    aett: 3,
    meaning: 'Ing, Fertility God',
    keywords: {
      upright: ['fertility', 'new life', 'internal growth', 'virtue', 'peace', 'harmony'],
      reversed: ['impotence', 'movement without change', 'toil', 'labor', 'work'],
    },
    divinatory: {
      upright: 'Fertility and new life emerge from your inner growth',
      reversed: 'Lack of growth or movement without real progress',
    },
    description: 'The seed of new life; internal growth that will manifest externally',
  },
  {
    id: 22,
    name: 'Dagaz',
    symbol: 'ᛞ',
    phonetic: 'D',
    element: 'Fire',
    aett: 3,
    meaning: 'Day, Dawn',
    keywords: {
      upright: ['breakthrough', 'awakening', 'awareness', 'daylight', 'hope', 'balance'],
      reversed: ['completion', 'final ending', 'blindness', 'hopelessness'],
    },
    divinatory: {
      upright: 'A breakthrough brings new awareness and hope',
      reversed: 'Final ending or inability to see the light',
    },
    description: 'The light of day that brings clarity and new beginnings',
  },
  {
    id: 23,
    name: 'Othala',
    symbol: 'ᛟ',
    phonetic: 'O',
    element: 'Earth',
    aett: 3,
    meaning: 'Inheritance, Homeland',
    keywords: {
      upright: [
        'inheritance',
        'legacy',
        'spiritual heritage',
        'experience',
        'value',
        'ancestral wisdom',
      ],
      reversed: ['prejudice', 'clannishness', 'provincialism', 'narrow-mindedness', 'poverty'],
    },
    divinatory: {
      upright: 'Ancestral wisdom and inherited gifts support your path',
      reversed: 'Narrow-mindedness or loss of valuable heritage',
    },
    description: 'The ancestral homeland; inherited wisdom and spiritual legacy',
  },
];

// =============================================================================
// RUNE SPREADS CONFIGURATION
// =============================================================================

interface RuneSpreadPosition {
  id: string;
  name: string;
  meaning: string;
  x?: number;
  y?: number;
}

interface RuneSpreadDefinition {
  id: string;
  name: string;
  description: string;
  runeCount: number;
  positions: RuneSpreadPosition[];
}

const _RUNE_SPREADS: RuneSpreadDefinition[] = [
  {
    id: 'single',
    name: 'Single Rune',
    description: 'A simple one-rune draw for daily guidance',
    runeCount: 1,
    positions: [
      { id: 'rune1', name: 'Your Rune', meaning: 'Guidance for today or your current situation' },
    ],
  },
  {
    id: 'past_present_future',
    name: 'Past Present Future',
    description: 'Three runes revealing the flow of time',
    runeCount: 3,
    positions: [
      { id: 'past', name: 'Past', meaning: 'What has influenced your current situation' },
      { id: 'present', name: 'Present', meaning: 'Your current state and immediate influences' },
      { id: 'future', name: 'Future', meaning: 'Likely outcome if current path continues' },
    ],
  },
  {
    id: 'problem_solution',
    name: 'Problem and Solution',
    description: 'Two runes showing challenge and resolution',
    runeCount: 2,
    positions: [
      { id: 'problem', name: 'Problem', meaning: 'The core challenge or obstacle you face' },
      { id: 'solution', name: 'Solution', meaning: 'The key to resolving your challenge' },
    ],
  },
  {
    id: 'norn_spread',
    name: 'The Norns Spread',
    description: 'Five-rune spread based on the Norse Fates',
    runeCount: 5,
    positions: [
      {
        id: 'past_influence',
        name: 'Past Influence',
        meaning: 'What shapes your destiny from the past',
      },
      { id: 'present_challenge', name: 'Present Challenge', meaning: 'Current test or lesson' },
      { id: 'hidden_influence', name: 'Hidden Influence', meaning: 'Unseen forces affecting you' },
      { id: 'guidance', name: 'Divine Guidance', meaning: 'Wisdom from the gods' },
      { id: 'future_potential', name: 'Future Potential', meaning: 'Where your wyrd may lead' },
    ],
  },
  {
    id: 'thor_hammer',
    name: "Thor's Hammer",
    description: 'Seven-rune spread shaped like Mjolnir',
    runeCount: 7,
    positions: [
      { id: 'handle_base', name: 'Foundation', meaning: 'Your basic strength and foundation' },
      { id: 'handle_grip', name: 'Control', meaning: 'What you can control and direct' },
      { id: 'handle_top', name: 'Connection', meaning: 'Your connection to divine power' },
      { id: 'hammer_left', name: 'Challenge', meaning: 'Opposition you must overcome' },
      { id: 'hammer_center', name: 'Power', meaning: 'Your core strength and ability' },
      { id: 'hammer_right', name: 'Support', meaning: 'Allies and helpful forces' },
      { id: 'hammer_top', name: 'Outcome', meaning: 'The final result of your efforts' },
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
    const { data: requestData, requestId } = await parseApiRequest(req, drawRunesRequestSchema);

    log('info', 'Runes draw requested', {
      requestId,
      count: requestData.count,
      allowReversed: requestData.allowReversed,
      runeSet: requestData.runeSet,
      technique: 'runes',
    });

    // Only Elder Futhark supported for now
    if (requestData.runeSet && requestData.runeSet !== 'elder_futhark') {
      return sendApiResponse(
        {
          code: 'INVALID_RUNE_SET',
          message: 'Only Elder Futhark rune set is currently supported',
          timestamp: new Date().toISOString(),
          requestId,
        },
        400
      );
    }

    // Generate random runes
    const randomResult = await generateRandomCards({
      count: requestData.count,
      seed: requestData.seed,
      allowDuplicates: false, // Runes are typically drawn without replacement
      maxValue: 23, // 24 runes (0-23)
    });

    // Convert to runes with positioning
    const runes: Rune[] = randomResult.values.map((encodedValue, position) => {
      // Decode the rune index from encoded value (remove reversal bit)
      const runeIndex = encodedValue >> 1; // Remove last bit to get real index
      const encodedReversed = (encodedValue & 1) === 1; // Extract reversal bit

      // Validate rune index
      if (runeIndex < 0 || runeIndex >= ELDER_FUTHARK.length) {
        throw new Error(
          `Invalid rune index: ${runeIndex}. Must be between 0 and ${ELDER_FUTHARK.length - 1}`
        );
      }

      const runeData = ELDER_FUTHARK[runeIndex];

      // Use encoded reversal if allowed, otherwise false
      const isReversed = requestData.allowReversed ? encodedReversed : false;

      return {
        id: runeIndex,
        name: runeData.name,
        symbol: runeData.symbol,
        isReversed,
        position: position + 1,
        meaning: isReversed ? runeData.divinatory.reversed : runeData.divinatory.upright,
      };
    });

    // Create session for tracking
    const sessionData = {
      userId: requestData.userId || 'anonymous',
      technique: 'runes' as const,
      locale: requestData.locale || 'en',
      question: requestData.question,
      results: {
        runes,
        runeSet: 'elder_futhark',
        runeCount: requestData.count,
      },
      metadata: {
        seed: randomResult.seed,
        method: randomResult.method,
        signature: randomResult.signature,
      },
    };

    const session = await createDivinationSession(sessionData);

    // Build response
    const responseData = {
      data: runes,
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
    };

    log('info', 'Runes draw completed', {
      requestId,
      runesDrawn: runes.length,
      runeSet: 'elder_futhark',
      method: randomResult.method,
      processingTimeMs: processingTime,
      sessionId: session?.id,
    });

    const nextResponse = sendApiResponse(response, 200);
    addStandardHeaders(nextResponse);

    return nextResponse;
  } catch (error) {
    log('error', 'Runes draw failed', {
      error: error instanceof Error ? error.message : String(error),
    });

    return handleApiError(error);
  }
}

// =============================================================================
// EDGE FUNCTION CONFIGURATION
// =============================================================================

export const runtime = 'edge';
export const preferredRegion = 'auto';
