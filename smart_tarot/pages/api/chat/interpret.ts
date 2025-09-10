/**
 * AI Interpretation Endpoint - Ultra-Professional Implementation
 * 
 * Provides sophisticated AI-powered interpretations for all divination techniques
 * using DeepSeek V3 with specialized prompts and context-aware responses.
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
  interpretationRequestSchema
} from '../../../lib/utils/api';
import { updateDivinationSession } from '../../../lib/utils/supabase';
import type { 
  InterpretationRequest,
  InterpretationResponse,
  DivinationTechnique
} from '../../../lib/types/api';

// =============================================================================
// DEEPSEEK V3 CONFIGURATION
// =============================================================================

const DEEPSEEK_API_URL = 'https://api.deepseek.com/v1/chat/completions';
const DEEPSEEK_MODEL = 'deepseek-chat';

interface DeepSeekMessage {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

interface DeepSeekRequest {
  model: string;
  messages: DeepSeekMessage[];
  max_tokens: number;
  temperature: number;
  top_p?: number;
  stream: boolean;
}

interface DeepSeekResponse {
  id: string;
  object: string;
  created: number;
  model: string;
  choices: Array<{
    index: number;
    message: {
      role: string;
      content: string;
    };
    finish_reason: string;
  }>;
  usage: {
    prompt_tokens: number;
    completion_tokens: number;
    total_tokens: number;
  };
}

// =============================================================================
// SPECIALIZED SYSTEM PROMPTS
// =============================================================================

const SYSTEM_PROMPTS: Record<DivinationTechnique, string> = {
  tarot: `You are a master tarot reader with deep understanding of the Rider-Waite-Smith deck and centuries of tarot tradition. Your interpretations are:

**Professional Standards:**
- Grounded in traditional tarot symbolism and meanings
- Considerate of card positions in spreads
- Balanced between upright and reversed meanings
- Psychologically insightful without being prescriptive
- Respectful of the querent's autonomy and free will

**Interpretation Style:**
- Begin with the overall energy and theme of the reading
- Address each card individually with its position meaning
- Weave connections between cards to create a cohesive narrative
- Offer practical guidance while respecting the querent's decision-making
- Use rich symbolism but remain accessible
- End with empowering summary and potential actions

**Ethical Guidelines:**
- Never make definitive predictions about death, health, or legal matters
- Frame challenges as opportunities for growth
- Emphasize the querent's power to shape their destiny
- Provide hope while acknowledging difficulties
- Respect all belief systems and backgrounds`,

  iching: `You are a sage versed in the ancient wisdom of the I Ching (Book of Changes), with deep understanding of Chinese philosophy, Taoist principles, and the 64 hexagrams. Your interpretations are:

**Philosophical Foundation:**
- Grounded in Taoist philosophy of natural flow and balance
- Understanding of yin-yang dynamics and the five elements
- Respect for the cosmic order and natural timing
- Recognition of the constant nature of change

**Interpretation Approach:**
- Begin with the primary hexagram's core message and judgment
- Explain the trigram relationships and their meanings
- Address changing lines and their transformation dynamics
- Connect to the resulting hexagram if applicable
- Relate to natural cycles and universal principles
- Provide wisdom for navigating change and challenge

**Guidance Style:**
- Emphasis on harmony with natural order
- Patience and right timing (wu wei - effortless action)
- Balance of firmness and yielding as appropriate
- Practical wisdom for daily decisions
- Long-term perspective on life's changes
- Respect for both action and stillness`,

  runes: `You are a runic scholar and practitioner with deep knowledge of the Elder Futhark, Norse mythology, and Germanic spiritual traditions. Your interpretations are:

**Cultural Context:**
- Rooted in Norse and Germanic wisdom traditions
- Understanding of the Nine Worlds and cosmic structure
- Connection to ancestral wisdom and natural forces
- Respect for the warrior-poet spirit of Norse culture

**Runic Philosophy:**
- Recognition of wyrd (fate/destiny) and personal agency
- Balance between courage and wisdom
- Honoring the ancestors and natural world
- Understanding of sacrifice and transformation
- Connection to elemental forces and seasonal cycles

**Interpretation Method:**
- Address each rune's core meaning and symbolism
- Consider aett (group) associations and element connections
- Explore upright vs. reversed meanings thoughtfully
- Connect to Norse mythology and archetypal themes
- Provide guidance for facing challenges with honor
- Emphasize personal strength and ancestral wisdom

**Voice and Tone:**
- Strong, clear, and honorable
- Respectful of tradition while practical for modern life
- Encouraging courage and self-reliance
- Connected to natural cycles and elemental wisdom
- Balanced between destiny and personal choice`
};

// =============================================================================
// INTERPRETATION LOGIC
// =============================================================================

/**
 * Build context-aware prompt for divination interpretation
 */
function buildInterpretationPrompt(
  technique: DivinationTechnique,
  results: any,
  question?: string,
  context?: string,
  locale: string = 'en'
): string {
  let prompt = `Please provide a comprehensive interpretation for this ${technique} reading.\n\n`;

  // Add question if provided
  if (question) {
    prompt += `**Question:** ${question}\n\n`;
  }

  // Add additional context if provided
  if (context) {
    prompt += `**Additional Context:** ${context}\n\n`;
  }

  // Add technique-specific results
  switch (technique) {
    case 'tarot':
      prompt += formatTarotResults(results);
      break;
    case 'iching':
      prompt += formatIChingResults(results);
      break;
    case 'runes':
      prompt += formatRunesResults(results);
      break;
  }

  // Add language instruction if not English
  if (locale !== 'en') {
    const languageMap: Record<string, string> = {
      'es': 'Spanish',
      'ca': 'Catalan',
      'fr': 'French',
      'de': 'German',
      'it': 'Italian'
    };
    const language = languageMap[locale] || 'English';
    prompt += `\n**Language:** Please provide the interpretation in ${language}.`;
  }

  prompt += `\n\n**Length:** Provide a comprehensive interpretation of 300-500 words that is both insightful and practical.`;

  return prompt;
}

/**
 * Format tarot reading results for AI interpretation
 */
function formatTarotResults(results: any): string {
  const { cards, spread } = results;
  let formatted = `**Spread:** ${spread || 'Custom'}\n\n`;
  
  formatted += `**Cards Drawn:**\n`;
  cards.forEach((card: any, index: number) => {
    const orientation = card.isReversed ? 'Reversed' : 'Upright';
    formatted += `${index + 1}. ${card.name} (${orientation}) - Position ${card.position}\n`;
  });

  return formatted;
}

/**
 * Format I Ching reading results for AI interpretation
 */
function formatIChingResults(results: any): string {
  const { hexagram } = results;
  let formatted = `**Primary Hexagram:** #${hexagram.number} - ${hexagram.name}\n\n`;
  
  formatted += `**Trigrams:** ${hexagram.trigrams[0]} (Upper) over ${hexagram.trigrams[1]} (Lower)\n\n`;
  
  formatted += `**Lines (bottom to top):**\n`;
  hexagram.lines.forEach((line: any, index: number) => {
    const changingText = line.isChanging ? ' (Changing)' : '';
    formatted += `Line ${line.position}: ${line.type}${changingText}\n`;
  });

  if (hexagram.transformedTo) {
    formatted += `\n**Transformed Hexagram:** #${hexagram.transformedTo.number} - ${hexagram.transformedTo.name}\n`;
  }

  return formatted;
}

/**
 * Format runes reading results for AI interpretation
 */
function formatRunesResults(results: any): string {
  const { runes, runeSet } = results;
  let formatted = `**Rune Set:** ${runeSet || 'Elder Futhark'}\n\n`;
  
  formatted += `**Runes Drawn:**\n`;
  runes.forEach((rune: any, index: number) => {
    const orientation = rune.isReversed ? 'Reversed' : 'Upright';
    formatted += `${index + 1}. ${rune.name} (${rune.symbol}) - ${orientation}\n`;
  });

  return formatted;
}

/**
 * Call DeepSeek V3 API for interpretation
 */
async function getAIInterpretation(
  technique: DivinationTechnique,
  userPrompt: string
): Promise<{ content: string; tokensUsed: number }> {
  const systemPrompt = SYSTEM_PROMPTS[technique];
  
  const messages: DeepSeekMessage[] = [
    { role: 'system', content: systemPrompt },
    { role: 'user', content: userPrompt }
  ];

  const requestBody: DeepSeekRequest = {
    model: DEEPSEEK_MODEL,
    messages,
    max_tokens: 1500,
    temperature: 0.7,
    top_p: 0.9,
    stream: false
  };

  const response = await fetch(DEEPSEEK_API_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${process.env.DEEPSEEK_API_KEY}`,
    },
    body: JSON.stringify(requestBody)
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`DeepSeek API error ${response.status}: ${errorText}`);
  }

  const data: DeepSeekResponse = await response.json();

  if (!data.choices || data.choices.length === 0) {
    throw new Error('No response from DeepSeek AI model');
  }

  return {
    content: data.choices[0].message.content,
    tokensUsed: data.usage.total_tokens
  };
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

    // Validate DeepSeek API key
    if (!process.env.DEEPSEEK_API_KEY) {
      return sendApiResponse(
        {
          code: 'MISSING_API_KEY',
          message: 'DeepSeek API key not configured',
          timestamp: new Date().toISOString(),
        },
        500
      );
    }
    
    // Parse and validate request
    const { data: requestData, requestId } = await parseApiRequest(
      req,
      interpretationRequestSchema
    );
    
    log('info', 'AI interpretation requested', {
      requestId,
      technique: requestData.technique,
      hasQuestion: !!requestData.question,
      hasContext: !!requestData.context,
      locale: requestData.locale
    });
    
    // Build interpretation prompt
    const userPrompt = buildInterpretationPrompt(
      requestData.technique,
      requestData.results,
      requestData.question,
      requestData.context,
      requestData.locale
    );
    
    // Get AI interpretation
    const { content, tokensUsed } = await getAIInterpretation(
      requestData.technique,
      userPrompt
    );
    
    // Generate summary from first sentence or two
    const sentences = content.split('. ');
    const summary = sentences.slice(0, 2).join('. ') + (sentences.length > 2 ? '.' : '');
    
    // Build response
    const responseData: InterpretationResponse = {
      data: content,
      summary,
      confidence: 0.85, // DeepSeek V3 is quite reliable
      tokensUsed
    };
    
    const processingTime = Date.now() - startTime;
    
    const response = createApiResponse(responseData, {
      processingTimeMs: processingTime,
    });
    
    log('info', 'AI interpretation completed', {
      requestId,
      technique: requestData.technique,
      tokensUsed,
      contentLength: content.length,
      processingTimeMs: processingTime
    });
    
    const nextResponse = sendApiResponse(response, 200);
    addStandardHeaders(nextResponse);
    
    return nextResponse;
    
  } catch (error) {
    log('error', 'AI interpretation failed', { 
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