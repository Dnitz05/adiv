/**
 * I Ching Coins Tossing Endpoint - Ultra-Professional Implementation
 * 
 * Provides cryptographically secure coin tossing for I Ching divination with
 * complete 64-hexagram system, trigram analysis, and changing lines calculation.
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
  tossCoinsRequestSchema
} from '../../../lib/utils/api';
import { generateRandomCoins } from '../../../lib/utils/randomness';
import { createDivinationSession } from '../../../lib/utils/supabase';
import type { 
  TossCoinsRequest,
  TossCoinsResponse,
  Hexagram,
  HexagramLine
} from '../../../lib/types/api';

// =============================================================================
// I CHING HEXAGRAM SYSTEM
// =============================================================================

interface TrigramData {
  id: string;
  name: string;
  chineseName: string;
  element: string;
  attribute: string;
  family: string;
  direction: string;
  season: string;
  keywords: string[];
}

interface HexagramData {
  id: number;
  name: string;
  chineseName: string;
  trigrams: [string, string]; // [upper, lower]
  judgment: string;
  image: string;
  keywords: string[];
}

// Eight Trigrams (Ba Gua)
const TRIGRAMS: Record<string, TrigramData> = {
  'qian': {
    id: 'qian',
    name: 'Heaven',
    chineseName: '乾',
    element: 'Metal',
    attribute: 'Creative',
    family: 'Father',
    direction: 'Northwest',
    season: 'Late Autumn',
    keywords: ['strength', 'creative power', 'firmness', 'persistence']
  },
  'kun': {
    id: 'kun',
    name: 'Earth',
    chineseName: '坤',
    element: 'Earth',
    attribute: 'Receptive',
    family: 'Mother',
    direction: 'Southwest',
    season: 'Late Summer',
    keywords: ['receptivity', 'yielding', 'nurturing', 'devotion']
  },
  'zhen': {
    id: 'zhen',
    name: 'Thunder',
    chineseName: '震',
    element: 'Wood',
    attribute: 'Arousing',
    family: 'Eldest Son',
    direction: 'East',
    season: 'Spring',
    keywords: ['movement', 'initiative', 'shock', 'awakening']
  },
  'kan': {
    id: 'kan',
    name: 'Water',
    chineseName: '坎',
    element: 'Water',
    attribute: 'Abysmal',
    family: 'Middle Son',
    direction: 'North',
    season: 'Winter',
    keywords: ['danger', 'difficulty', 'depth', 'flow']
  },
  'gen': {
    id: 'gen',
    name: 'Mountain',
    chineseName: '艮',
    element: 'Earth',
    attribute: 'Stillness',
    family: 'Youngest Son',
    direction: 'Northeast',
    season: 'Late Winter',
    keywords: ['stillness', 'meditation', 'introspection', 'boundaries']
  },
  'xun': {
    id: 'xun',
    name: 'Wind',
    chineseName: '巽',
    element: 'Wood',
    attribute: 'Gentle',
    family: 'Eldest Daughter',
    direction: 'Southeast',
    season: 'Early Summer',
    keywords: ['gentleness', 'penetration', 'flexibility', 'gradual progress']
  },
  'li': {
    id: 'li',
    name: 'Fire',
    chineseName: '離',
    element: 'Fire',
    attribute: 'Clinging',
    family: 'Middle Daughter',
    direction: 'South',
    season: 'Summer',
    keywords: ['light', 'clarity', 'beauty', 'intelligence']
  },
  'dui': {
    id: 'dui',
    name: 'Lake',
    chineseName: '兌',
    element: 'Metal',
    attribute: 'Joyful',
    family: 'Youngest Daughter',
    direction: 'West',
    season: 'Autumn',
    keywords: ['joy', 'pleasure', 'openness', 'communication']
  }
};

// 64 Hexagrams
const HEXAGRAMS: HexagramData[] = [
  { id: 1, name: 'The Creative', chineseName: '乾', trigrams: ['qian', 'qian'], judgment: 'Creative power brings great success', image: 'Heaven over Heaven', keywords: ['creativity', 'leadership', 'strength', 'initiative'] },
  { id: 2, name: 'The Receptive', chineseName: '坤', trigrams: ['kun', 'kun'], judgment: 'Receptive devotion brings good fortune', image: 'Earth over Earth', keywords: ['receptivity', 'nurturing', 'cooperation', 'support'] },
  { id: 3, name: 'Difficulty at the Beginning', chineseName: '屯', trigrams: ['kan', 'zhen'], judgment: 'Initial difficulties lead to growth', image: 'Water over Thunder', keywords: ['challenges', 'new beginnings', 'perseverance', 'growth'] },
  { id: 4, name: 'Youthful Folly', chineseName: '蒙', trigrams: ['gen', 'kan'], judgment: 'Learning through experience', image: 'Mountain over Water', keywords: ['inexperience', 'learning', 'guidance', 'development'] },
  { id: 5, name: 'Waiting', chineseName: '需', trigrams: ['kan', 'qian'], judgment: 'Patient waiting brings success', image: 'Water over Heaven', keywords: ['patience', 'nourishment', 'timing', 'preparation'] },
  { id: 6, name: 'Conflict', chineseName: '訟', trigrams: ['qian', 'kan'], judgment: 'Conflict requires careful resolution', image: 'Heaven over Water', keywords: ['conflict', 'litigation', 'opposition', 'compromise'] },
  { id: 7, name: 'The Army', chineseName: '師', trigrams: ['kun', 'kan'], judgment: 'Disciplined leadership brings victory', image: 'Earth over Water', keywords: ['leadership', 'discipline', 'organization', 'strategy'] },
  { id: 8, name: 'Holding Together', chineseName: '比', trigrams: ['kan', 'kun'], judgment: 'Unity and cooperation bring strength', image: 'Water over Earth', keywords: ['unity', 'cooperation', 'alliance', 'support'] },
  { id: 9, name: 'Small Taming', chineseName: '小畜', trigrams: ['xun', 'qian'], judgment: 'Gentle persistence overcomes obstacles', image: 'Wind over Heaven', keywords: ['restraint', 'accumulation', 'gradual progress', 'patience'] },
  { id: 10, name: 'Treading', chineseName: '履', trigrams: ['qian', 'dui'], judgment: 'Proper conduct leads to success', image: 'Heaven over Lake', keywords: ['conduct', 'behavior', 'propriety', 'courage'] },
  { id: 11, name: 'Peace', chineseName: '泰', trigrams: ['kun', 'qian'], judgment: 'Heaven and Earth in harmony', image: 'Earth over Heaven', keywords: ['peace', 'harmony', 'prosperity', 'good fortune'] },
  { id: 12, name: 'Standstill', chineseName: '否', trigrams: ['qian', 'kun'], judgment: 'Stagnation requires patient endurance', image: 'Heaven over Earth', keywords: ['stagnation', 'obstruction', 'withdrawal', 'patience'] },
  { id: 13, name: 'Fellowship', chineseName: '同人', trigrams: ['qian', 'li'], judgment: 'Fellowship with others brings success', image: 'Heaven over Fire', keywords: ['fellowship', 'cooperation', 'community', 'shared goals'] },
  { id: 14, name: 'Great Possession', chineseName: '大有', trigrams: ['li', 'qian'], judgment: 'Great possession brings responsibility', image: 'Fire over Heaven', keywords: ['possession', 'wealth', 'responsibility', 'moderation'] },
  { id: 15, name: 'Modesty', chineseName: '謙', trigrams: ['kun', 'gen'], judgment: 'Modesty brings honor and success', image: 'Earth over Mountain', keywords: ['modesty', 'humility', 'balance', 'respect'] },
  { id: 16, name: 'Enthusiasm', chineseName: '豫', trigrams: ['zhen', 'kun'], judgment: 'Enthusiasm inspires others', image: 'Thunder over Earth', keywords: ['enthusiasm', 'inspiration', 'joy', 'leadership'] },
  { id: 17, name: 'Following', chineseName: '隨', trigrams: ['dui', 'zhen'], judgment: 'Following the right path brings success', image: 'Lake over Thunder', keywords: ['following', 'adaptation', 'flexibility', 'leadership'] },
  { id: 18, name: 'Work on the Decayed', chineseName: '蠱', trigrams: ['gen', 'xun'], judgment: 'Correcting corruption brings renewal', image: 'Mountain over Wind', keywords: ['decay', 'corruption', 'reform', 'renewal'] },
  { id: 19, name: 'Approach', chineseName: '臨', trigrams: ['kun', 'dui'], judgment: 'Approach with care and respect', image: 'Earth over Lake', keywords: ['approach', 'leadership', 'supervision', 'care'] },
  { id: 20, name: 'Contemplation', chineseName: '觀', trigrams: ['xun', 'kun'], judgment: 'Contemplation brings understanding', image: 'Wind over Earth', keywords: ['contemplation', 'observation', 'understanding', 'example'] },
  { id: 21, name: 'Biting Through', chineseName: '噬嗑', trigrams: ['li', 'zhen'], judgment: 'Decisive action breaks through obstacles', image: 'Fire over Thunder', keywords: ['breakthrough', 'decision', 'justice', 'action'] },
  { id: 22, name: 'Grace', chineseName: '賁', trigrams: ['gen', 'li'], judgment: 'Grace and beauty enhance success', image: 'Mountain over Fire', keywords: ['grace', 'beauty', 'culture', 'refinement'] },
  { id: 23, name: 'Splitting Apart', chineseName: '剝', trigrams: ['gen', 'kun'], judgment: 'When things fall apart, remain still', image: 'Mountain over Earth', keywords: ['decay', 'deterioration', 'patience', 'endurance'] },
  { id: 24, name: 'Return', chineseName: '復', trigrams: ['kun', 'zhen'], judgment: 'Return to the source brings renewal', image: 'Earth over Thunder', keywords: ['return', 'renewal', 'recovery', 'turning point'] },
  { id: 25, name: 'Innocence', chineseName: '無妄', trigrams: ['qian', 'zhen'], judgment: 'Innocence and spontaneity bring good fortune', image: 'Heaven over Thunder', keywords: ['innocence', 'spontaneity', 'naturalness', 'sincerity'] },
  { id: 26, name: 'Great Taming', chineseName: '大畜', trigrams: ['gen', 'qian'], judgment: 'Great restraint accumulates power', image: 'Mountain over Heaven', keywords: ['restraint', 'accumulation', 'strength', 'nourishment'] },
  { id: 27, name: 'Nourishment', chineseName: '頤', trigrams: ['gen', 'zhen'], judgment: 'Proper nourishment sustains life', image: 'Mountain over Thunder', keywords: ['nourishment', 'sustenance', 'care', 'provision'] },
  { id: 28, name: 'Great Excess', chineseName: '大過', trigrams: ['dui', 'xun'], judgment: 'Excessive weight requires support', image: 'Lake over Wind', keywords: ['excess', 'burden', 'critical moment', 'extraordinary measures'] },
  { id: 29, name: 'The Abysmal Water', chineseName: '坎', trigrams: ['kan', 'kan'], judgment: 'Danger requires courage and persistence', image: 'Water over Water', keywords: ['danger', 'difficulty', 'courage', 'persistence'] },
  { id: 30, name: 'The Clinging Fire', chineseName: '離', trigrams: ['li', 'li'], judgment: 'Clarity and understanding illuminate the way', image: 'Fire over Fire', keywords: ['clarity', 'understanding', 'illumination', 'dependence'] },
  { id: 31, name: 'Influence', chineseName: '咸', trigrams: ['dui', 'gen'], judgment: 'Mutual influence creates attraction', image: 'Lake over Mountain', keywords: ['influence', 'attraction', 'courtship', 'sensitivity'] },
  { id: 32, name: 'Duration', chineseName: '恆', trigrams: ['zhen', 'xun'], judgment: 'Duration requires consistency', image: 'Thunder over Wind', keywords: ['duration', 'persistence', 'constancy', 'endurance'] },
  { id: 33, name: 'Retreat', chineseName: '遯', trigrams: ['qian', 'gen'], judgment: 'Strategic retreat preserves strength', image: 'Heaven over Mountain', keywords: ['retreat', 'withdrawal', 'strategy', 'preservation'] },
  { id: 34, name: 'Great Power', chineseName: '大壯', trigrams: ['zhen', 'qian'], judgment: 'Great power requires righteousness', image: 'Thunder over Heaven', keywords: ['power', 'strength', 'righteousness', 'vigor'] },
  { id: 35, name: 'Progress', chineseName: '晉', trigrams: ['li', 'kun'], judgment: 'Progress brings recognition', image: 'Fire over Earth', keywords: ['progress', 'advancement', 'recognition', 'brightness'] },
  { id: 36, name: 'Darkening of the Light', chineseName: '明夷', trigrams: ['kun', 'li'], judgment: 'In dark times, preserve your light', image: 'Earth over Fire', keywords: ['darkness', 'oppression', 'persecution', 'inner light'] },
  { id: 37, name: 'The Family', chineseName: '家人', trigrams: ['xun', 'li'], judgment: 'Family harmony requires proper relationships', image: 'Wind over Fire', keywords: ['family', 'relationships', 'harmony', 'responsibility'] },
  { id: 38, name: 'Opposition', chineseName: '睽', trigrams: ['li', 'dui'], judgment: 'Opposition can be overcome through understanding', image: 'Fire over Lake', keywords: ['opposition', 'misunderstanding', 'alienation', 'small matters'] },
  { id: 39, name: 'Obstruction', chineseName: '蹇', trigrams: ['kan', 'gen'], judgment: 'Obstruction requires seeking help', image: 'Water over Mountain', keywords: ['obstruction', 'difficulty', 'impediment', 'seeking help'] },
  { id: 40, name: 'Deliverance', chineseName: '解', trigrams: ['zhen', 'kan'], judgment: 'Deliverance comes through decisive action', image: 'Thunder over Water', keywords: ['deliverance', 'liberation', 'solution', 'forgiveness'] },
  { id: 41, name: 'Decrease', chineseName: '損', trigrams: ['gen', 'dui'], judgment: 'Decrease in the lower benefits the higher', image: 'Mountain over Lake', keywords: ['decrease', 'loss', 'sacrifice', 'simplification'] },
  { id: 42, name: 'Increase', chineseName: '益', trigrams: ['xun', 'zhen'], judgment: 'Increase brings benefit to all', image: 'Wind over Thunder', keywords: ['increase', 'benefit', 'improvement', 'advancement'] },
  { id: 43, name: 'Breakthrough', chineseName: '夬', trigrams: ['dui', 'qian'], judgment: 'Breakthrough requires determined resolve', image: 'Lake over Heaven', keywords: ['breakthrough', 'resolution', 'determination', 'decision'] },
  { id: 44, name: 'Coming to Meet', chineseName: '姤', trigrams: ['qian', 'xun'], judgment: 'Unexpected encounters require caution', image: 'Heaven over Wind', keywords: ['encounter', 'temptation', 'seduction', 'caution'] },
  { id: 45, name: 'Gathering Together', chineseName: '萃', trigrams: ['dui', 'kun'], judgment: 'Gathering together requires a center', image: 'Lake over Earth', keywords: ['gathering', 'collection', 'unity', 'leadership'] },
  { id: 46, name: 'Pushing Upward', chineseName: '升', trigrams: ['kun', 'xun'], judgment: 'Gradual ascent brings great success', image: 'Earth over Wind', keywords: ['ascent', 'growth', 'advancement', 'effort'] },
  { id: 47, name: 'Oppression', chineseName: '困', trigrams: ['dui', 'kan'], judgment: 'Oppression tests inner strength', image: 'Lake over Water', keywords: ['oppression', 'exhaustion', 'adversity', 'perseverance'] },
  { id: 48, name: 'The Well', chineseName: '井', trigrams: ['kan', 'xun'], judgment: 'The well nourishes without being exhausted', image: 'Water over Wind', keywords: ['nourishment', 'source', 'community', 'inexhaustible supply'] },
  { id: 49, name: 'Revolution', chineseName: '革', trigrams: ['dui', 'li'], judgment: 'Revolution brings necessary change', image: 'Lake over Fire', keywords: ['revolution', 'change', 'transformation', 'renewal'] },
  { id: 50, name: 'The Cauldron', chineseName: '鼎', trigrams: ['li', 'xun'], judgment: 'The cauldron nourishes the worthy', image: 'Fire over Wind', keywords: ['nourishment', 'culture', 'transformation', 'refinement'] },
  { id: 51, name: 'The Arousing Thunder', chineseName: '震', trigrams: ['zhen', 'zhen'], judgment: 'Thunder brings shock and awakening', image: 'Thunder over Thunder', keywords: ['shock', 'awakening', 'movement', 'fear'] },
  { id: 52, name: 'Keeping Still', chineseName: '艮', trigrams: ['gen', 'gen'], judgment: 'Stillness brings peace and clarity', image: 'Mountain over Mountain', keywords: ['stillness', 'meditation', 'rest', 'boundaries'] },
  { id: 53, name: 'Development', chineseName: '漸', trigrams: ['xun', 'gen'], judgment: 'Gradual development ensures success', image: 'Wind over Mountain', keywords: ['development', 'gradual progress', 'steady advance', 'marriage'] },
  { id: 54, name: 'The Marrying Maiden', chineseName: '歸妹', trigrams: ['zhen', 'dui'], judgment: 'Hasty action leads to misfortune', image: 'Thunder over Lake', keywords: ['marriage', 'relationships', 'subordination', 'caution'] },
  { id: 55, name: 'Abundance', chineseName: '豐', trigrams: ['zhen', 'li'], judgment: 'Abundance requires wisdom to maintain', image: 'Thunder over Fire', keywords: ['abundance', 'fullness', 'peak', 'clarity'] },
  { id: 56, name: 'The Wanderer', chineseName: '旅', trigrams: ['li', 'gen'], judgment: 'The wanderer finds success through adaptability', image: 'Fire over Mountain', keywords: ['travel', 'wandering', 'stranger', 'adaptability'] },
  { id: 57, name: 'The Gentle Wind', chineseName: '巽', trigrams: ['xun', 'xun'], judgment: 'Gentle penetration overcomes resistance', image: 'Wind over Wind', keywords: ['gentleness', 'penetration', 'influence', 'flexibility'] },
  { id: 58, name: 'The Joyous Lake', chineseName: '兌', trigrams: ['dui', 'dui'], judgment: 'Joy brings success through openness', image: 'Lake over Lake', keywords: ['joy', 'pleasure', 'openness', 'communication'] },
  { id: 59, name: 'Dispersion', chineseName: '渙', trigrams: ['xun', 'kan'], judgment: 'Dispersion requires gathering energies', image: 'Wind over Water', keywords: ['dispersion', 'dissolution', 'scattering', 'regrouping'] },
  { id: 60, name: 'Limitation', chineseName: '節', trigrams: ['kan', 'dui'], judgment: 'Limitation creates order and saves energy', image: 'Water over Lake', keywords: ['limitation', 'restriction', 'moderation', 'economy'] },
  { id: 61, name: 'Inner Truth', chineseName: '中孚', trigrams: ['xun', 'dui'], judgment: 'Inner truth creates understanding', image: 'Wind over Lake', keywords: ['truth', 'sincerity', 'trust', 'understanding'] },
  { id: 62, name: 'Small Exceeding', chineseName: '小過', trigrams: ['zhen', 'gen'], judgment: 'Small matters require great attention', image: 'Thunder over Mountain', keywords: ['small matters', 'attention to detail', 'humility', 'carefulness'] },
  { id: 63, name: 'After Completion', chineseName: '既濟', trigrams: ['kan', 'li'], judgment: 'Completion requires vigilance', image: 'Water over Fire', keywords: ['completion', 'success', 'order', 'vigilance'] },
  { id: 64, name: 'Before Completion', chineseName: '未濟', trigrams: ['li', 'kan'], judgment: 'Before completion, careful preparation', image: 'Fire over Water', keywords: ['incompletion', 'transition', 'potential', 'preparation'] }
];

// =============================================================================
// I CHING CALCULATION FUNCTIONS
// =============================================================================

/**
 * Convert line values to hexagram number
 */
function calculateHexagram(lines: number[]): number {
  let value = 0;
  
  // Build binary representation (bottom line = bit 0)
  for (let i = 0; i < 6; i++) {
    const line = lines[i];
    // Yang lines (7, 9) = 1, Yin lines (6, 8) = 0
    if (line === 7 || line === 9) {
      value |= (1 << i);
    }
  }
  
  return value + 1; // Hexagrams are 1-indexed
}

/**
 * Apply changing lines to create resulting hexagram
 */
function applyChangingLines(lines: number[]): number[] {
  return lines.map(line => {
    switch (line) {
      case 6: return 7; // Old yin becomes young yang
      case 9: return 8; // Old yang becomes young yin
      default: return line; // Young lines don't change
    }
  });
}

/**
 * Get trigram ID from three lines
 */
function getTrigramId(line1: number, line2: number, line3: number): string {
  const binary = [line1, line2, line3].map(l => l === 7 || l === 9 ? 1 : 0);
  const value = (binary[2] << 2) | (binary[1] << 1) | binary[0];
  
  const trigramMap: Record<number, string> = {
    0: 'kun',    // ☷ Earth
    1: 'gen',    // ☶ Mountain  
    2: 'kan',    // ☵ Water
    3: 'xun',    // ☴ Wind
    4: 'zhen',   // ☳ Thunder
    5: 'li',     // ☲ Fire
    6: 'dui',    // ☱ Lake
    7: 'qian'    // ☰ Heaven
  };
  
  return trigramMap[value] || 'qian';
}

// =============================================================================
// MAIN HANDLER
// =============================================================================

export default async function handler(req: NextRequest) {
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
    const { data: requestData, requestId } = await parseApiRequest(
      req,
      tossCoinsRequestSchema
    );
    
    log('info', 'I Ching coins toss requested', {
      requestId,
      method: requestData.method,
      technique: 'iching'
    });
    
    // Generate 18 coin tosses (3 coins x 6 lines)
    const randomResult = await generateRandomCoins({
      count: 18, // 3 coins per line x 6 lines
      seed: requestData.seed
    });
    
    // Convert coin tosses to I Ching lines
    const lines: HexagramLine[] = [];
    
    for (let lineIndex = 0; lineIndex < 6; lineIndex++) {
      const coinIndices = [
        lineIndex * 3,
        lineIndex * 3 + 1,
        lineIndex * 3 + 2
      ];
      
      // Count heads (1s) in the three coins for this line
      const headsCount = coinIndices.reduce((count, index) => {
        return count + randomResult.values[index];
      }, 0);
      
      // Convert heads count to I Ching line value
      // 0 heads = 6 (old yin, changing)
      // 1 head = 8 (young yin)
      // 2 heads = 7 (young yang)  
      // 3 heads = 9 (old yang, changing)
      let value: number;
      let type: 'yin' | 'yang';
      let isChanging: boolean;
      
      switch (headsCount) {
        case 0:
          value = 6;
          type = 'yin';
          isChanging = true;
          break;
        case 1:
          value = 8;
          type = 'yin';
          isChanging = false;
          break;
        case 2:
          value = 7;
          type = 'yang';
          isChanging = false;
          break;
        case 3:
        default:
          value = 9;
          type = 'yang';
          isChanging = true;
          break;
      }
      
      lines.push({
        position: lineIndex + 1,
        type,
        isChanging,
        value
      });
    }
    
    // Calculate primary hexagram
    const lineValues = lines.map(l => l.value);
    const primaryNumber = calculateHexagram(lineValues);
    const primaryData = HEXAGRAMS[primaryNumber - 1];
    
    // Get trigrams
    const lowerTrigram = getTrigramId(lineValues[0], lineValues[1], lineValues[2]);
    const upperTrigram = getTrigramId(lineValues[3], lineValues[4], lineValues[5]);
    
    // Build primary hexagram
    const primaryHexagram: Hexagram = {
      number: primaryNumber,
      name: primaryData.name,
      lines: lines,
      trigrams: [upperTrigram, lowerTrigram]
    };
    
    // Calculate transformed hexagram if there are changing lines
    const changingLines = lines.filter(l => l.isChanging);
    let transformedHexagram: Hexagram | undefined;
    
    if (changingLines.length > 0) {
      const transformedValues = applyChangingLines(lineValues);
      const transformedNumber = calculateHexagram(transformedValues);
      const transformedData = HEXAGRAMS[transformedNumber - 1];
      
      // Create transformed lines
      const transformedLines: HexagramLine[] = transformedValues.map((value, index) => ({
        position: index + 1,
        type: value === 7 || value === 9 ? 'yang' : 'yin',
        isChanging: false, // Transformed lines are stable
        value
      }));
      
      const transformedLowerTrigram = getTrigramId(transformedValues[0], transformedValues[1], transformedValues[2]);
      const transformedUpperTrigram = getTrigramId(transformedValues[3], transformedValues[4], transformedValues[5]);
      
      transformedHexagram = {
        number: transformedNumber,
        name: transformedData.name,
        lines: transformedLines,
        trigrams: [transformedUpperTrigram, transformedLowerTrigram]
      };
      
      primaryHexagram.transformedTo = transformedHexagram;
    }
    
    // Create session for tracking
    const sessionData = {
      userId: requestData.userId || 'anonymous',
      technique: 'iching' as const,
      locale: requestData.locale || 'en',
      question: requestData.question,
      results: {
        hexagram: primaryHexagram,
        changingLines: changingLines.length,
        method: requestData.method || 'coins'
      },
      metadata: {
        seed: randomResult.seed,
        method: randomResult.method,
        signature: randomResult.signature
      }
    };
    
    const session = await createDivinationSession(sessionData);
    
    // Build response
    const responseData: TossCoinsResponse = {
      data: primaryHexagram
    };
    
    const processingTime = Date.now() - startTime;
    
    const response = createApiResponse(responseData, {
      processingTimeMs: processingTime,
    });
    
    // Add divination-specific metadata
    (response as any).seed = randomResult.seed;
    (response as any).signature = randomResult.signature;
    (response as any).method = randomResult.method;
    (response as any).sessionId = session?.id;
    
    log('info', 'I Ching coins toss completed', {
      requestId,
      primaryHexagram: primaryNumber,
      changingLines: changingLines.length,
      transformedHexagram: transformedHexagram?.number,
      method: randomResult.method,
      processingTimeMs: processingTime,
      sessionId: session?.id
    });
    
    const nextResponse = sendApiResponse(response, 200);
    addStandardHeaders(nextResponse);
    
    return nextResponse;
    
  } catch (error) {
    log('error', 'I Ching coins toss failed', { 
      error: error instanceof Error ? error.message : String(error) 
    });
    
    return handleApiError(error);
  }
}

// =============================================================================
// EDGE FUNCTION CONFIGURATION
// =============================================================================

export const runtime = 'edge';
export const preferredRegion = 'auto';