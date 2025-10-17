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
 * Phase 1: Simple keyword-based spread recommendation
 * TODO Phase 2: Integrate with AI (GPT-4) for smarter recommendations
 */
async function recommendSpread(
  question: string,
  locale: string,
  preferredComplexity?: string,
  preferredCategory?: string
): Promise<SpreadRecommendation> {
  // Extract keywords from the question
  const keywords = extractKeywords(question);

  log('info', 'Extracted keywords from question', {
    question: question.substring(0, 100),
    keywords,
  });

  // Detect category based on keywords
  const detectedCategory = detectCategory(keywords);
  const detectedComplexity = detectComplexity(question, keywords);

  // Use preferred values if provided, otherwise use detected values
  const targetCategory = preferredCategory || detectedCategory;
  const targetComplexity = preferredComplexity || detectedComplexity;

  // Find the best spread
  const bestSpread = findBestSpread(keywords, targetCategory, targetComplexity);

  // Calculate confidence score
  const confidenceScore = calculateConfidenceScore(
    keywords,
    bestSpread,
    targetCategory,
    targetComplexity
  );

  // Get alternative spreads
  const alternatives = getAlternativeSpreads(bestSpread, keywords, targetCategory);

  // Generate reasoning
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
  locale: string = 'ca'
): { en: string; ca: string; es: string } {
  const keywordPhrase = keywords.length > 0 ? keywords.join(', ') : 'general inquiry';

  // Generate reasoning based on detected patterns
  const reasons = {
    ca: `He seleccionat la tirada "${spread.nameCA}" perquè és ideal per ${
      category === 'love'
        ? "qüestions d'amor i relacions"
        : category === 'decision'
          ? 'prendre decisions importants'
          : category === 'career'
            ? 'temes de carrera i treball'
            : 'obtenir una visió general de la situació'
    }. Amb ${spread.cardCount} cartes, aquesta tirada ${
      spread.complexity === 'simple'
        ? 'ofereix respostes ràpides i clares'
        : spread.complexity === 'medium'
          ? 'proporciona un equilibri entre profunditat i claredat'
          : 'ofereix una anàlisi profunda i detallada'
    }. Factors clau detectats: ${keywordPhrase}.`,

    es: `He seleccionado la tirada "${spread.nameES}" porque es ideal para ${
      category === 'love'
        ? 'cuestiones de amor y relaciones'
        : category === 'decision'
          ? 'tomar decisiones importantes'
          : category === 'career'
            ? 'temas de carrera y trabajo'
            : 'obtener una visión general de la situación'
    }. Con ${spread.cardCount} cartas, esta tirada ${
      spread.complexity === 'simple'
        ? 'ofrece respuestas rápidas y claras'
        : spread.complexity === 'medium'
          ? 'proporciona un equilibrio entre profundidad y claridad'
          : 'ofrece un análisis profundo y detallado'
    }. Factores clave detectados: ${keywordPhrase}.`,

    en: `I've selected the "${spread.name}" spread because it's ideal for ${
      category === 'love'
        ? 'love and relationship questions'
        : category === 'decision'
          ? 'making important decisions'
          : category === 'career'
            ? 'career and work matters'
            : 'getting a general overview of the situation'
    }. With ${spread.cardCount} cards, this spread ${
      spread.complexity === 'simple'
        ? 'offers quick and clear answers'
        : spread.complexity === 'medium'
          ? 'provides a balance between depth and clarity'
          : 'offers deep and detailed analysis'
    }. Key factors detected: ${keywordPhrase}.`,
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
