/**
 * AI Interpretation Endpoint - Ultra-Professional Implementation
 *
 * Provides sophisticated AI-powered interpretations for all divination techniques
 * using DeepSeek V3 with specialized prompts and context-aware responses.
 */

import type { NextApiRequest, NextApiResponse } from 'next';
import { log } from '../../../lib/utils/api';
import type { DivinationTechnique, TarotCard, Hexagram, Rune } from '../../../lib/types/api';
import { fetchWithTimeout } from '../../../lib/utils/http';

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
- Balanced between destiny and personal choice`,
};

// =============================================================================
// INTERPRETATION LOGIC
// =============================================================================

/**
 * Build context-aware prompt for divination interpretation
 */
function buildInterpretationPrompt(
  technique: DivinationTechnique,
  results: unknown,
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
      prompt += formatTarotResults(results as { cards: TarotCard[]; spread?: string });
      break;
    case 'iching':
      prompt += formatIChingResults(results as { hexagram: Hexagram });
      break;
    case 'runes':
      prompt += formatRunesResults(results as { runes: Rune[]; runeSet?: string });
      break;
  }

  // Add language instruction if not English
  if (locale !== 'en') {
    const languageMap: Record<string, string> = {
      es: 'Spanish',
      ca: 'Catalan',
      fr: 'French',
      de: 'German',
      it: 'Italian',
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
function formatTarotResults(results: { cards: TarotCard[]; spread?: string }): string {
  const { cards, spread } = results;
  let formatted = `**Spread:** ${spread || 'Custom'}\n\n`;

  formatted += `**Cards Drawn:**\n`;
  cards.forEach((card: TarotCard, index: number) => {
    const orientation = card.isReversed ? 'Reversed' : 'Upright';
    formatted += `${index + 1}. ${card.name} (${orientation}) - Position ${card.position}\n`;
  });

  return formatted;
}

/**
 * Format I Ching reading results for AI interpretation
 */
function formatIChingResults(results: { hexagram: Hexagram }): string {
  const { hexagram } = results;
  let formatted = `**Primary Hexagram:** #${hexagram.number} - ${hexagram.name}\n\n`;

  formatted += `**Trigrams:** ${hexagram.trigrams[0]} (Upper) over ${hexagram.trigrams[1]} (Lower)\n\n`;

  formatted += `**Lines (bottom to top):**\n`;
  hexagram.lines.forEach((line) => {
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
function formatRunesResults(results: { runes: Rune[]; runeSet?: string }): string {
  const { runes, runeSet } = results;
  let formatted = `**Rune Set:** ${runeSet || 'Elder Futhark'}\n\n`;

  formatted += `**Runes Drawn:**\n`;
  runes.forEach((rune, index: number) => {
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
    { role: 'user', content: userPrompt },
  ];

  const requestBody: DeepSeekRequest = {
    model: DEEPSEEK_MODEL,
    messages,
    max_tokens: 1500,
    temperature: 0.7,
    top_p: 0.9,
    stream: false,
  };

  const response = await fetchWithTimeout(DEEPSEEK_API_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${process.env.DEEPSEEK_API_KEY}`,
    },
    body: JSON.stringify(requestBody),
    timeoutMs: 15000,
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
    tokensUsed: data.usage.total_tokens,
  };
}

// =============================================================================
// ENHANCED VALIDATION & HELPERS
// =============================================================================

/**
 * Comprehensive validation for interpretation requests
 */
function validateInterpretationRequest(requestData: Record<string, unknown>): string[] {
  const errors: string[] = [];

  // Validate technique
  const technique = requestData.technique;
  if (!technique) {
    errors.push('Technique is required');
  } else if (typeof technique !== 'string' || !['tarot', 'iching', 'runes'].includes(technique)) {
    errors.push(`Invalid technique: ${String(technique)}. Must be one of: tarot, iching, runes`);
  }

  // Validate results based on technique
  const results = requestData.results as Record<string, unknown> | undefined;
  if (!results || typeof results !== 'object') {
    errors.push('Results object is required');
  } else {
    switch (technique) {
      case 'tarot':
        {
          const cards = (results as { cards?: unknown[] }).cards;
          if (!Array.isArray(cards)) {
            errors.push('Tarot results must contain a cards array');
          } else if (cards.length === 0) {
            errors.push('At least one tarot card is required');
          }
        }
        break;

      case 'runes':
        {
          const runes = (results as { runes?: unknown[] }).runes;
          if (!Array.isArray(runes)) {
            errors.push('Runes results must contain a runes array');
          } else if (runes.length === 0) {
            errors.push('At least one rune is required');
          }
        }
        break;

      case 'iching':
        {
          const hx = (results as { hexagram?: { number?: unknown; lines?: unknown } }).hexagram;
          if (!hx || typeof hx !== 'object') {
            errors.push('I Ching results must contain a hexagram object');
          } else if (typeof hx.number !== 'number' || !Array.isArray(hx.lines)) {
            errors.push('I Ching hexagram must have number and lines');
          }
        }
        break;
    }
  }

  // Validate locale
  const supportedLocales = ['en', 'es', 'ca', 'fr', 'de', 'it'];
  const locale = requestData.locale;
  if (locale && typeof locale === 'string' && !supportedLocales.includes(locale)) {
    errors.push(`Unsupported locale: ${locale}. Supported: ${supportedLocales.join(', ')}`);
  }

  // Validate question length if provided
  if (typeof requestData.question === 'string' && requestData.question.length > 500) {
    errors.push('Question must be 500 characters or less');
  }

  // Validate context length if provided
  if (typeof requestData.context === 'string' && requestData.context.length > 1000) {
    errors.push('Context must be 1000 characters or less');
  }

  return errors;
}

/**
 * Generate relevant follow-up questions based on technique and original question
 */
function generateFollowUpQuestions(
  technique: DivinationTechnique,
  originalQuestion?: string
): string[] {
  const baseQuestions: Record<DivinationTechnique, string[]> = {
    tarot: [
      'What should I focus on in the near future?',
      'How can I overcome the challenges shown in this reading?',
      'What opportunities should I be aware of?',
      'What does this reading suggest about my personal growth?',
    ],
    iching: [
      'How can I better align with the natural flow of events?',
      'What actions would be most harmonious at this time?',
      'How should I prepare for the changes ahead?',
      'What wisdom can guide me through this situation?',
    ],
    runes: [
      'What ancestral wisdom can guide me forward?',
      'How can I honor the path shown by these runes?',
      'What strength do I need to cultivate?',
      'What challenges require my attention?',
    ],
  };

  const questions = [...baseQuestions[technique]];

  // Add context-specific questions if we have an original question
  if (originalQuestion && originalQuestion.toLowerCase().includes('love')) {
    questions.unshift('How can I nurture the relationships in my life?');
  } else if (originalQuestion && originalQuestion.toLowerCase().includes('career')) {
    questions.unshift('What professional opportunities align with my path?');
  } else if (originalQuestion && originalQuestion.toLowerCase().includes('health')) {
    questions.unshift('What aspects of my wellbeing deserve attention?');
  }

  // Return a maximum of 3 questions
  return questions.slice(0, 3);
}

// =============================================================================
// MAIN HANDLER
// =============================================================================

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const startTime = Date.now();
  const requestTimestamp = new Date().toISOString();

  try {
    // Set CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    res.setHeader(
      'Access-Control-Allow-Headers',
      'Content-Type, Authorization, X-Requested-With, X-Request-ID, X-Technique'
    );

    // Handle preflight
    if (req.method === 'OPTIONS') {
      res.status(200).end();
      return;
    }

    // Only allow POST requests
    if (req.method !== 'POST') {
      res.status(405).json({
        success: false,
        error: {
          code: 'METHOD_NOT_ALLOWED',
          message: 'Only POST method is allowed for interpretation requests',
          timestamp: requestTimestamp,
          details: { allowedMethods: ['POST'] },
        },
      });
      return;
    }

    // Validate DeepSeek API key
    if (!process.env.DEEPSEEK_API_KEY) {
      log('error', 'DeepSeek API key not configured', {
        endpoint: '/api/chat/interpret',
        timestamp: requestTimestamp,
      });

      res.status(500).json({
        success: false,
        error: {
          code: 'MISSING_API_KEY',
          message: 'AI interpretation service is temporarily unavailable',
          timestamp: requestTimestamp,
          details: { service: 'DeepSeek', status: 'not_configured' },
        },
      });
      return;
    }

    // Parse and validate request
    const requestData = req.body;
    const requestId = (req.headers['x-request-id'] as string) || `req_${Date.now()}`;

    // Enhanced validation
    const validationErrors = validateInterpretationRequest(requestData);
    if (validationErrors.length > 0) {
      log('warn', 'Invalid interpretation request', {
        requestId,
        errors: validationErrors,
        technique: requestData.technique,
      });

      res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Invalid interpretation request parameters',
          timestamp: requestTimestamp,
          details: {
            errors: validationErrors,
            receivedTechnique: requestData.technique,
          },
          requestId,
        },
      });
      return;
    }

    log('info', 'AI interpretation requested', {
      requestId,
      technique: requestData.technique,
      hasQuestion: !!requestData.question,
      hasContext: !!requestData.context,
      locale: requestData.locale,
      resultsKeys: Object.keys(requestData.results || {}),
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
    const { content, tokensUsed } = await getAIInterpretation(requestData.technique, userPrompt);

    // Generate summary from first sentence or two
    const sentences = content.split('. ');
    const summary = sentences.slice(0, 2).join('. ') + (sentences.length > 2 ? '.' : '');

    // Validate interpretation quality
    if (!content || content.trim().length < 50) {
      log('warn', 'Generated interpretation too short', {
        requestId,
        contentLength: content?.length || 0,
        tokensUsed,
      });

      res.status(422).json({
        success: false,
        error: {
          code: 'INTERPRETATION_ERROR',
          message: 'Generated interpretation is too short or empty',
          timestamp: requestTimestamp,
          details: {
            contentLength: content?.length || 0,
            minLength: 50,
          },
          requestId,
        },
      });
      return;
    }

    // Build response with enhanced data structure
    const interpretationData = {
      data: content,
      summary,
      confidence: Math.min(0.95, Math.max(0.6, 0.85)), // Clamp confidence
      followUpQuestions: generateFollowUpQuestions(requestData.technique, requestData.question),
      tokensUsed,
    };

    const processingTime = Date.now() - startTime;

    const response = {
      success: true,
      data: interpretationData,
      meta: {
        processingTimeMs: processingTime,
        timestamp: requestTimestamp,
        version: '1.0.0',
      },
    };

    log('info', 'AI interpretation completed', {
      requestId,
      technique: requestData.technique,
      tokensUsed,
      contentLength: content.length,
      processingTimeMs: processingTime,
    });

    res.status(200).json(response);
  } catch (error) {
    const processingTime = Date.now() - startTime;

    log('error', 'AI interpretation failed', {
      error: error instanceof Error ? error.message : String(error),
      processingTimeMs: processingTime,
      timestamp: requestTimestamp,
    });

    // Enhanced error handling with specific error types
    if (error instanceof Error) {
      if (error.message.includes('DeepSeek API error')) {
        res.status(503).json({
          success: false,
          error: {
            code: 'AI_SERVICE_ERROR',
            message: 'AI interpretation service is temporarily unavailable',
            timestamp: requestTimestamp,
            details: {
              service: 'DeepSeek',
              processingTimeMs: processingTime,
            },
          },
        });
        return;
      } else if (error.message.includes('timeout')) {
        res.status(408).json({
          success: false,
          error: {
            code: 'REQUEST_TIMEOUT',
            message: 'Interpretation request timed out',
            timestamp: requestTimestamp,
            details: {
              processingTimeMs: processingTime,
              timeout: '30s',
            },
          },
        });
        return;
      }
    }

    res.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'An unexpected error occurred during interpretation',
        timestamp: requestTimestamp,
        details: { processingTimeMs: processingTime },
      },
    });
  }
}

// =============================================================================
// EDGE FUNCTION CONFIGURATION
// =============================================================================

export const runtime = 'nodejs'; // Complex API - requires Node.js runtime for now
export const preferredRegion = 'auto';
