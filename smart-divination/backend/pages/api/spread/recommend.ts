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
import { isUsingGemini } from '../../../lib/services/ai-provider';
import { selectSpreadWithGemini } from '../../../lib/services/gemini-ai';

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
  interpretationGuide?: string;
  interpretationGuideCA?: string;
  interpretationGuideES?: string;
  confidenceScore: number;
  keyFactors: string[];
  detectedCategory?: string;
  detectedComplexity?: string;
  alternatives?: SpreadDefinition[];
}

/**
 * Phase 2: AI-powered spread recommendation with Gemini or DeepSeek
 * Falls back to keyword-based if AI fails
 */
async function recommendSpread(
  question: string,
  locale: string,
  preferredComplexity?: string,
  preferredCategory?: string,
  requestId?: string
): Promise<SpreadRecommendation> {
  // Try AI-powered selection first
  const useAI = isUsingGemini()
    ? process.env.GEMINI_API_KEY?.trim()
    : process.env.DEEPSEEK_API_KEY?.trim();

  if (useAI) {
    try {
      let aiSelection;

      if (isUsingGemini()) {
        // Use Gemini for spread selection
        log('info', 'Using Gemini for spread selection', { requestId });
        aiSelection = await selectSpreadWithGemini(question, SPREADS, locale, requestId);
      } else {
        // Use DeepSeek for spread selection
        const { selectSpreadWithAI } = await import('../../../lib/services/ai-spread-selector');
        aiSelection = await selectSpreadWithAI(question, locale, requestId);
      }

      const spread = SPREADS.find((s) => s.id === aiSelection.spreadId);

      if (spread) {
        const alternatives = getAlternativeSpreads(spread, [], spread.category);
        const keywords = extractKeywords(question);

        return {
          spread,
          reasoning: aiSelection.reason,
          reasoningCA: aiSelection.reason,
          reasoningES: aiSelection.reason,
          interpretationGuide: aiSelection.interpretationGuide,
          interpretationGuideCA: aiSelection.interpretationGuide,
          interpretationGuideES: aiSelection.interpretationGuide,
          confidenceScore: 0.9,
          keyFactors: keywords,
          detectedCategory: spread.category,
          detectedComplexity: spread.complexity,
          alternatives,
        };
      }
    } catch (error) {
      log('warn', 'AI spread selection failed, falling back to keyword-based', {
        requestId,
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

  // Generate interpretation guide with variety
  const guideIndex = Math.floor(Math.random() * 3);

  const guidesCA = [
    `Per interpretar aquesta tirada, observa com cada carta es relaciona amb la seva posició al diagrama. Comença per les primeres posicions i avança cap a les finals, deixant que el significat de cada carta es vagi construint sobre l'anterior. Presta atenció als colors i símbols de les cartes, ja que et donaran pistes sobre l'energia de cada aspecte.`,
    `Llegeix aquesta tirada com si fossis una història. Cada carta és un capítol que s'obre davant teu. Deixa que les imatges parlin al teu intuït abans de buscar significats. Els colors càlids sovint parlen de passió i acció, mentre que els freds suggereixen reflexió i calma. Deixa't guiar per allò que ressona amb tu.`,
    `En aquesta tirada, cada carta és una finestra a un aspecte de la teva situació. Respira profundament abans de començar i fixa't primer en la impressió general. Després, explora cada posició amb curiositat, preguntant-te què et crida l'atenció de cada carta. La veritat sovint apareix en els detalls inesperats.`,
  ];

  const guidesES = [
    `Para interpretar esta tirada, observa cómo cada carta se relaciona con su posición en el diagrama. Empieza por las primeras posiciones y avanza hacia las finales, dejando que el significado de cada carta se construya sobre el anterior. Presta atención a los colores y símbolos de las cartas, ya que te darán pistas sobre la energía de cada aspecto.`,
    `Lee esta tirada como si fuera una historia. Cada carta es un capítulo que se abre ante ti. Deja que las imágenes hablen a tu intuición antes de buscar significados. Los colores cálidos a menudo hablan de pasión y acción, mientras que los fríos sugieren reflexión y calma. Déjate guiar por lo que resuena contigo.`,
    `En esta tirada, cada carta es una ventana a un aspecto de tu situación. Respira profundamente antes de empezar y fíjate primero en la impresión general. Después, explora cada posición con curiosidad, preguntándote qué te llama la atención de cada carta. La verdad a menudo aparece en los detalles inesperados.`,
  ];

  const guidesEN = [
    `To interpret this spread, observe how each card relates to its position in the diagram. Start with the first positions and move toward the final ones, letting the meaning of each card build upon the previous. Pay attention to the colors and symbols of the cards, as they will give you clues about the energy of each aspect.`,
    `Read this spread like a story unfolding. Each card is a chapter opening before you. Let the images speak to your intuition before seeking meanings. Warm colors often speak of passion and action, while cool ones suggest reflection and calm. Allow yourself to be guided by what resonates with you.`,
    `In this spread, each card is a window into an aspect of your situation. Take a deep breath before beginning and notice the overall impression first. Then explore each position with curiosity, asking yourself what catches your attention in each card. Truth often appears in unexpected details.`,
  ];

  const interpretationGuideTemplates = {
    ca: guidesCA[guideIndex],
    es: guidesES[guideIndex],
    en: guidesEN[guideIndex],
  };

  const interpretationGuide =
    locale === 'ca'
      ? interpretationGuideTemplates.ca
      : locale === 'es'
        ? interpretationGuideTemplates.es
        : interpretationGuideTemplates.en;

  return {
    spread: bestSpread,
    reasoning: reasoning.en,
    reasoningCA: reasoning.ca,
    reasoningES: reasoning.es,
    interpretationGuide,
    interpretationGuideCA: interpretationGuideTemplates.ca,
    interpretationGuideES: interpretationGuideTemplates.es,
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
          : 'explorar el que et preocupa ara mateix';
  const categoryEs =
    category === 'love'
      ? 'los temas de amor y vínculo afectivo'
      : category === 'decision'
        ? 'los momentos en los que toca tomar decisiones importantes'
        : category === 'career'
          ? 'las inquietudes profesionales y de propósito vital'
          : 'explorar lo que te preocupa ahora mismo';
  const categoryEn =
    category === 'love'
      ? 'matters of the heart and relationship dynamics'
      : category === 'decision'
        ? 'those crossroads where an important decision is required'
        : category === 'career'
          ? 'career questions and the direction of your work life'
          : 'exploring what concerns you right now';

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

  // Multiple templates for variety
  const templateIndex = Math.floor(Math.random() * 5);

  const templatesCA = [
    `He triat ${spread.nameCA} per ${categoryCa}:\n\n• Les cartes mostraran on et trobes ara i cap on vas\n• Cada posició revelarà què necessites saber per avançar`,
    `${spread.nameCA} encaixa perfectament amb la teva pregunta:\n\n• Veuràs la influència del passat i com està modelant el present\n• Les cartes finals t'indicaran possibles desenllaços i consells`,
    `Aquesta tirada és ideal per ${categoryCa}:\n\n• T'ajudarà a veure què bloqueja i què impulsa la situació\n• Descobriràs recursos interns que encara no has activat`,
    `${spread.nameCA} et mostrarà el camí per ${categoryCa}:\n\n• Les primeres cartes parlaran de tu i la teva energia actual\n• Les últimes et revelaran l'evolució natural d'aquesta situació`,
    `Per a la teva pregunta, ${spread.nameCA} és el millor:\n\n• Veuràs com interactuen els diferents aspectes de la teva vida\n• Les cartes t'oferiran una lectura clara de l'energia present`,
  ];

  const templatesES = [
    `He elegido ${spread.nameES} para ${categoryEs}:\n\n• Las cartas mostrarán dónde estás ahora y hacia dónde vas\n• Cada posición revelará qué necesitas saber para avanzar`,
    `${spread.nameES} encaja perfectamente con tu pregunta:\n\n• Verás la influencia del pasado y cómo está moldeando el presente\n• Las cartas finales te indicarán posibles desenlaces y consejos`,
    `Esta tirada es ideal para ${categoryEs}:\n\n• Te ayudará a ver qué bloquea y qué impulsa la situación\n• Descubrirás recursos internos que aún no has activado`,
    `${spread.nameES} te mostrará el camino para ${categoryEs}:\n\n• Las primeras cartas hablarán de ti y tu energía actual\n• Las últimas te revelarán la evolución natural de esta situación`,
    `Para tu pregunta, ${spread.nameES} es lo mejor:\n\n• Verás cómo interactúan los diferentes aspectos de tu vida\n• Las cartas te ofrecerán una lectura clara de la energía presente`,
  ];

  const templatesEN = [
    `I chose ${spread.name} for ${categoryEn}:\n\n• The cards will show where you are now and where you're heading\n• Each position will reveal what you need to know to move forward`,
    `${spread.name} fits perfectly with your question:\n\n• You'll see the influence of the past and how it's shaping the present\n• The final cards will indicate possible outcomes and advice`,
    `This spread is ideal for ${categoryEn}:\n\n• It will help you see what's blocking and what's driving the situation\n• You'll discover internal resources you haven't activated yet`,
    `${spread.name} will show you the path for ${categoryEn}:\n\n• The first cards will speak about you and your current energy\n• The last ones will reveal the natural evolution of this situation`,
    `For your question, ${spread.name} is the best:\n\n• You'll see how different aspects of your life interact\n• The cards will offer you a clear reading of the present energy`,
  ];

  const reasons = {
    ca: templatesCA[templateIndex],
    es: templatesES[templateIndex],
    en: templatesEN[templateIndex],
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
      body.preferredCategory,
      requestId
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
