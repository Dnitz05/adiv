import type { NextApiRequest, NextApiResponse } from 'next';
import { z } from 'zod';

import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
} from '../../../lib/utils/nextApi';
import {
  baseRequestSchema,
  createApiResponse,
  createRequestId,
  handleApiError,
  log,
  parseApiRequest,
} from '../../../lib/utils/api';
import { recordApiMetric } from '../../../lib/utils/metrics';
import { extractKeywords } from '../../../lib/utils/text';
import { findBestSpread, SPREADS, type SpreadDefinition } from '../../../lib/data/spreads';

const METRICS_PATH = '/api/spread/recommend';
const CORS_CONFIG = { methods: 'OPTIONS, POST' };

/**
 * Request schema for spread recommendation
 */
const spreadRecommendationRequestSchema = baseRequestSchema.extend({
  question: z.string().min(1, 'question is required'),
  locale: z.string().min(2).optional().default('ca'),
  // Optional hints from the user
  preferredComplexity: z.enum(['simple', 'medium', 'complex', 'extended']).optional(),
  preferredCategory: z
    .enum(['general', 'love', 'career', 'decision', 'spiritual', 'monthly', 'yearly'])
    .optional(),
});

type SpreadRecommendationRequestBody = z.infer<typeof spreadRecommendationRequestSchema>;

/**
 * Response structure for spread recommendation
 */
interface SpreadRecommendation {
  spread: SpreadDefinition;
  reasoning: string;
  reasoningCA?: string;
  reasoningES?: string;
  confidenceScore: number;
  keyFactors: string[];
  detectedCategory?: string;
  detectedComplexity?: string;
  alternatives?: SpreadDefinition[];
}

/**
 * Phase 2: AI-powered spread recommendation with DeepSeek
 * Falls back to keyword-based if AI fails
 */
async function recommendSpread(
  question: string,
  locale: string,
  preferredComplexity?: string,
  preferredCategory?: string
): Promise<SpreadRecommendation> {
  // Try AI-powered selection first
  const useAI = process.env.DEEPSEEK_API_KEY?.trim();

  if (useAI) {
    try {
      const { selectSpreadWithAI } = await import('../../../lib/services/ai-spread-selector');
      const aiSelection = await selectSpreadWithAI(question, locale);
      const spread = SPREADS.find((s) => s.id === aiSelection.spreadId);

      if (spread) {
        const alternatives = getAlternativeSpreads(spread, [], spread.category);
        const keywords = extractKeywords(question);

        return {
          spread,
          reasoning: aiSelection.reason,
          reasoningCA: aiSelection.reason,
          reasoningES: aiSelection.reason,
          confidenceScore: aiSelection.confidence,
          keyFactors: keywords,
          detectedCategory: spread.category,
          detectedComplexity: spread.complexity,
          alternatives,
        };
      }
    } catch (error) {
      log('warn', 'AI spread selection failed, falling back to keyword-based', {
        error: error instanceof Error ? error.message : 'Unknown error',
      });
    }
  }

  // Fallback: keyword-based selection
  const keywords = extractKeywords(question);

  log('info', 'Using keyword-based spread selection', {
    question: question.substring(0, 100),
    keywords,
  });

  const detectedCategory = detectCategory(keywords);
  const detectedComplexity = detectComplexity(question, keywords);
  const targetCategory = preferredCategory || detectedCategory;
  const targetComplexity = preferredComplexity || detectedComplexity;
  const bestSpread = findBestSpread(keywords, targetCategory, targetComplexity);
  const confidenceScore = calculateConfidenceScore(
    keywords,
    bestSpread,
    targetCategory,
    targetComplexity
  );
  const alternatives = getAlternativeSpreads(bestSpread, keywords, targetCategory);
  const reasoning = generateReasoning(question, bestSpread, keywords, detectedCategory, locale);

  return {
    spread: bestSpread,
    reasoning: reasoning.en,
    reasoningCA: reasoning.ca,
    reasoningES: reasoning.es,
    confidenceScore,
    keyFactors: keywords,
    detectedCategory,
    detectedComplexity,
    alternatives,
  };
}

/**
 * Detect category from keywords
 */
function detectCategory(keywords: string[]): string {
  const categoryKeywords: Record<string, string[]> = {
    love: ['amor', 'love', 'relació', 'relación', 'relationship', 'parella', 'pareja', 'partner'],
    career: ['carrera', 'career', 'treball', 'trabajo', 'work', 'feina', 'job', 'professió'],
    decision: ['decisió', 'decisión', 'decision', 'triar', 'elegir', 'choose', 'opció', 'opción'],
    spiritual: [
      'espiritual',
      'spiritual',
      'ànima',
      'alma',
      'soul',
      'creixement',
      'crecimiento',
      'growth',
    ],
  };

  for (const [category, terms] of Object.entries(categoryKeywords)) {
    if (keywords.some((kw) => terms.some((term) => kw.includes(term) || term.includes(kw)))) {
      return category;
    }
  }

  return 'general';
}

/**
 * Detect complexity from question length and keywords
 */
function detectComplexity(question: string, keywords: string[]): string {
  // Simple heuristic based on question length and keyword count
  const wordCount = question.split(/\s+/).length;

  if (wordCount < 10 && keywords.length <= 2) {
    return 'simple';
  } else if (wordCount > 30 || keywords.length > 4) {
    return 'complex';
  }

  return 'medium';
}

/**
 * Calculate confidence score based on matches
 */
function calculateConfidenceScore(
  keywords: string[],
  spread: SpreadDefinition,
  category?: string,
  complexity?: string
): number {
  let score = 0.5; // Base confidence

  // Boost if category matches
  if (category && spread.category === category) {
    score += 0.2;
  }

  // Boost if complexity matches
  if (complexity && spread.complexity === complexity) {
    score += 0.15;
  }

  // Boost based on keyword matches
  const matchCount = keywords.filter((kw) =>
    spread.suitableFor.some((tag) => tag.includes(kw) || kw.includes(tag))
  ).length;

  if (matchCount > 0) {
    score += (matchCount / keywords.length) * 0.15;
  }

  return Math.min(1.0, score);
}

/**
 * Get alternative spreads
 */
function getAlternativeSpreads(
  primarySpread: SpreadDefinition,
  keywords: string[],
  category?: string
): SpreadDefinition[] {
  return SPREADS.filter((s) => s.id !== primarySpread.id)
    .filter((s) => !category || s.category === category || s.category === 'general')
    .slice(0, 2);
}

/**
 * Generate reasoning in multiple languages
 */
function generateReasoning(
  question: string,
  spread: SpreadDefinition,
  keywords: string[],
  category?: string,
  _locale: string = 'ca'
): { en: string; ca: string; es: string } {
  const categoryCa =
    category === 'love'
      ? "els temes d'amor i de vincle afectiu"
      : category === 'decision'
        ? 'els moments en què cal prendre decisions importants'
        : category === 'career'
          ? 'les inquietuds professionals i de projecte vital'
          : "la necessitat d'obtenir una mirada global de la situació";
  const categoryEs =
    category === 'love'
      ? 'los temas de amor y vínculo afectivo'
      : category === 'decision'
        ? 'los momentos en los que toca tomar decisiones importantes'
        : category === 'career'
          ? 'las inquietudes profesionales y de propósito vital'
          : 'la necesidad de obtener una mirada amplia de la situación';
  const categoryEn =
    category === 'love'
      ? 'matters of the heart and relationship dynamics'
      : category === 'decision'
        ? 'those crossroads where an important decision is required'
        : category === 'career'
          ? 'career questions and the direction of your work life'
          : 'the need for a compassionate overview of the situation';

  const complexityCa =
    spread.complexity === 'simple'
      ? 'amb un ritme àgil i clar'
      : spread.complexity === 'medium'
        ? 'amb prou profunditat sense perdre claredat'
        : 'amb la profunditat que cal per revisar totes les capes';
  const complexityEs =
    spread.complexity === 'simple'
      ? 'con un ritmo ágil y claro'
      : spread.complexity === 'medium'
        ? 'con la profundidad justa sin perder claridad'
        : 'con la profundidad necesaria para revisar cada capa';
  const complexityEn =
    spread.complexity === 'simple'
      ? 'with a quick, clear rhythm'
      : spread.complexity === 'medium'
        ? 'with enough depth while staying clear'
        : 'with the depth needed to explore every layer';

  const keywordSummaryCa = keywords.length > 0 ? keywords.join(', ') : 'el que sents ara mateix';
  const keywordSummaryEs = keywords.length > 0 ? keywords.join(', ') : 'lo que sientes ahora mismo';
  const keywordSummaryEn =
    keywords.length > 0 ? keywords.join(', ') : 'what is moving inside you right now';

  const reasons = {
    ca: `He escollit la tirada "${spread.nameCA}" perquè acompanya molt bé ${categoryCa}. ${spread.cardCount === 1 ? 'Aquesta carta' : `Les ${spread.cardCount} cartes`} treballen ${complexityCa} per oferir-te una lectura coherent i amable. Els matisos que expresses (${keywordSummaryCa}) es miraran amb sensibilitat perquè puguis sentir amb serenor els propers passos.`,

    es: `He elegido la tirada "${spread.nameES}" porque abraza con cuidado ${categoryEs}. ${spread.cardCount === 1 ? 'Esta carta' : `Las ${spread.cardCount} cartas`} trabajan ${complexityEs} para darte una mirada didáctica y cercana. Los matices que compartes (${keywordSummaryEs}) se abordarán con delicadeza para que encuentres claridad y calma.`,

    en: `I've chosen the "${spread.name}" spread because it gently supports ${categoryEn}. ${spread.cardCount === 1 ? 'This card' : `The ${spread.cardCount} cards`} work ${complexityEn} to offer a thoughtful, down-to-earth reading. The feelings woven through your question (${keywordSummaryEn}) will be explored with care so you can sense the next step with confidence.`,
  };

  return reasons;
}

/**
 * Main handler
 */
export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const requestId = createRequestId();
  const startTime = Date.now();

  try {
    // Handle CORS preflight
    if (handleCorsPreflight(req, res, CORS_CONFIG)) {
      return;
    }

    // Apply headers
    applyCorsHeaders(res, CORS_CONFIG);
    applyStandardResponseHeaders(res);

    // Only allow POST
    if (req.method !== 'POST') {
      res.status(405).json(
        createApiResponse({
          requestId,
          error: { type: 'method_not_allowed', message: 'Method not allowed' },
        })
      );
      return;
    }

    // Parse and validate request
    const parsed = await parseApiRequest<SpreadRecommendationRequestBody>(
      req,
      spreadRecommendationRequestSchema,
      {
        requireUser: false,
      }
    );
    const { data: body, auth: authContext } = parsed;

    log('info', 'Processing spread recommendation request', {
      requestId,
      userId: authContext?.userId,
      questionLength: body.question.length,
      locale: body.locale,
    });

    // Get recommendation
    const recommendation = await recommendSpread(
      body.question,
      body.locale,
      body.preferredComplexity,
      body.preferredCategory
    );

    // Record metrics
    const duration = Date.now() - startTime;
    recordApiMetric(METRICS_PATH, 200, duration);

    log('info', 'Spread recommendation completed', {
      requestId,
      spreadId: recommendation.spread.id,
      confidence: recommendation.confidenceScore,
      duration,
    });

    // Send response
    res.status(200).json(
      createApiResponse({
        requestId,
        data: recommendation,
      })
    );
  } catch (error) {
    const duration = Date.now() - startTime;
    recordApiMetric(METRICS_PATH, 500, duration);

    handleApiError(res, error, requestId);
  }
}
