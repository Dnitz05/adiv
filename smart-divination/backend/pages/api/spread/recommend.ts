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
    `• ${spread.nameCA} il·lumina perfectament ${categoryCa} gràcies a la seva estructura única: les posicions inicials revelen els fonaments i l'energia actual, mentre que les finals mostren cap on flueix naturalment la situació. Aquesta distribució t'ajuda a veure tant les arrels com els fruits del que estàs vivint.\n\n• Per interpretar-la amb profunditat, centra't primer en les cartes centrals (el cor de la lectura) per entendre què és essencial ara mateix, i després connecta-les amb les laterals per veure com les influències externes i internes interactuen. La tirada et revelarà no només què passa, sinó per què passa.`,

    `• Aquesta tirada capta amb precisió ${categoryCa} perquè cada posició està dissenyada per desvelar una capa diferent: des dels teus recursos ocults fins als obstacles que encara no veus clarament. La seva arquitectura et permet veure el problema des de múltiples angles, revelant patrons que normalment queden a l'ombra.\n\n• Quan llegeixis les cartes, presta especial atenció als contrastos entre posicions oposades: què enfronta, què impulsa, què frena. És en aquests diàlegs interns on trobaràs les claus més potents. Les posicions finals et donaran no prediccions, sinó tendències naturals si continues pel camí actual.`,

    `• ${spread.nameCA} s'adapta perfectament a ${categoryCa} perquè mapea tant el terreny emocional com el pràctic: veuràs què sent el teu cor i què et demana la realitat, i com ambdós camins poden trobar-se o xocar. Aquest equilibri entre intuïció i acció és el que fa aquesta tirada tan reveladora i útil.\n\n• Per treure'n el màxim profit, llegeix primer cada carta individualment, sentint-ne el missatge, i després busca els fils que les connecten: quines cartes es reforcen mútuament, quines es contradiuen. Aquestes tensions i harmonies et mostraran el mapa complet del que estàs vivint i cap on pots dirigir-te.`,

    `• La força d'${spread.nameCA} per ${categoryCa} rau en com distribueix les cartes en el temps i l'espai: passant del que fou al que és, i del que és al que pot ser. Aquesta progressió temporal et permet no només entendre d'on ve la situació, sinó també veure'n les branques de futur que s'obren davant teu.\n\n• Interpreta les posicions temporals (passat, present, futur) com un relat continu: el passat et dóna context, el present et mostra l'energia viva del moment, i el futur et suggereix camins probables. Però recorda: el futur de les cartes no és destí fix, sinó tendència que pots modelar amb consciència i acció.`,

    `• ${spread.nameCA} és ideal per ${categoryCa} perquè no només respon preguntes superficials, sinó que et guia cap a les preguntes més profundes: què necessita la meva ànima ara? Què demana aquesta situació de mi? La disposició de les cartes et porta des de la pregunta inicial fins al cor del que realment està passant.\n\n• Quan interpretis, no busquis respostes úniques o absolutes. Deixa que les cartes et parlin en imatges, sensacions, intuïcions. Les posicions centrals contenen el nucli de la resposta, però són les laterals les que et mostren el context complet i les opcions reals que tens al davant.`,
  ];

  const templatesES = [
    `• ${spread.nameES} ilumina perfectamente ${categoryEs} gracias a su estructura única: las posiciones iniciales revelan los cimientos y la energía actual, mientras que las finales muestran hacia dónde fluye naturalmente la situación. Esta distribución te ayuda a ver tanto las raíces como los frutos de lo que estás viviendo.\n\n• Para interpretarla con profundidad, céntrate primero en las cartas centrales (el corazón de la lectura) para entender qué es esencial ahora mismo, y después conéctalas con las laterales para ver cómo las influencias externas e internas interactúan. La tirada te revelará no solo qué pasa, sino por qué pasa.`,

    `• Esta tirada capta con precisión ${categoryEs} porque cada posición está diseñada para desvelar una capa diferente: desde tus recursos ocultos hasta los obstáculos que aún no ves claramente. Su arquitectura te permite ver el problema desde múltiples ángulos, revelando patrones que normalmente quedan en la sombra.\n\n• Cuando leas las cartas, presta especial atención a los contrastes entre posiciones opuestas: qué enfrenta, qué impulsa, qué frena. Es en esos diálogos internos donde encontrarás las claves más potentes. Las posiciones finales te darán no predicciones, sino tendencias naturales si continúas por el camino actual.`,

    `• ${spread.nameES} se adapta perfectamente a ${categoryEs} porque mapea tanto el terreno emocional como el práctico: verás qué siente tu corazón y qué te pide la realidad, y cómo ambos caminos pueden encontrarse o chocar. Este equilibrio entre intuición y acción es lo que hace esta tirada tan reveladora y útil.\n\n• Para sacarle el máximo provecho, lee primero cada carta individualmente, sintiendo su mensaje, y después busca los hilos que las conectan: qué cartas se refuerzan mutuamente, cuáles se contradicen. Estas tensiones y armonías te mostrarán el mapa completo de lo que estás viviendo y hacia dónde puedes dirigirte.`,

    `• La fuerza de ${spread.nameES} para ${categoryEs} radica en cómo distribuye las cartas en el tiempo y el espacio: pasando de lo que fue a lo que es, y de lo que es a lo que puede ser. Esta progresión temporal te permite no solo entender de dónde viene la situación, sino también ver las ramas de futuro que se abren ante ti.\n\n• Interpreta las posiciones temporales (pasado, presente, futuro) como un relato continuo: el pasado te da contexto, el presente te muestra la energía viva del momento, y el futuro te sugiere caminos probables. Pero recuerda: el futuro de las cartas no es destino fijo, sino tendencia que puedes moldear con consciencia y acción.`,

    `• ${spread.nameES} es ideal para ${categoryEs} porque no solo responde preguntas superficiales, sino que te guía hacia las preguntas más profundas: ¿qué necesita mi alma ahora? ¿Qué pide esta situación de mí? La disposición de las cartas te lleva desde la pregunta inicial hasta el corazón de lo que realmente está pasando.\n\n• Cuando interpretes, no busques respuestas únicas o absolutas. Deja que las cartas te hablen en imágenes, sensaciones, intuiciones. Las posiciones centrales contienen el núcleo de la respuesta, pero son las laterales las que te muestran el contexto completo y las opciones reales que tienes delante.`,
  ];

  const templatesEN = [
    `• ${spread.name} perfectly illuminates ${categoryEn} thanks to its unique structure: the initial positions reveal the foundations and current energy, while the final ones show where the situation naturally flows. This distribution helps you see both the roots and the fruits of what you're living.\n\n• To interpret it deeply, focus first on the central cards (the heart of the reading) to understand what's essential right now, then connect them with the lateral ones to see how external and internal influences interact. The spread will reveal not only what's happening, but why it's happening.`,

    `• This spread precisely captures ${categoryEn} because each position is designed to unveil a different layer: from your hidden resources to obstacles you don't yet see clearly. Its architecture lets you view the problem from multiple angles, revealing patterns that normally remain in shadow.\n\n• When reading the cards, pay special attention to contrasts between opposing positions: what confronts, what drives, what restrains. It's in these internal dialogues where you'll find the most powerful keys. The final positions will give you not predictions, but natural tendencies if you continue on your current path.`,

    `• ${spread.name} adapts perfectly to ${categoryEn} because it maps both the emotional and practical terrain: you'll see what your heart feels and what reality asks of you, and how both paths can meet or clash. This balance between intuition and action is what makes this spread so revealing and useful.\n\n• To get the most from it, first read each card individually, feeling its message, then look for the threads connecting them: which cards reinforce each other, which contradict. These tensions and harmonies will show you the complete map of what you're living and where you can head.`,

    `• The strength of ${spread.name} for ${categoryEn} lies in how it distributes cards through time and space: moving from what was to what is, and from what is to what can be. This temporal progression lets you not only understand where the situation comes from, but also see the future branches opening before you.\n\n• Interpret the temporal positions (past, present, future) as a continuous narrative: the past gives you context, the present shows you the living energy of the moment, and the future suggests probable paths. But remember: the cards' future isn't fixed destiny, but a tendency you can shape with awareness and action.`,

    `• ${spread.name} is ideal for ${categoryEn} because it doesn't just answer surface questions, but guides you toward deeper ones: what does my soul need now? What does this situation ask of me? The card layout takes you from the initial question to the heart of what's really happening.\n\n• When interpreting, don't seek single or absolute answers. Let the cards speak to you in images, sensations, intuitions. The central positions contain the core of the answer, but the lateral ones show you the complete context and the real options you have ahead.`,
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
