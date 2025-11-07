import type { NextApiRequest, NextApiResponse } from 'next';
import { z } from 'zod';

import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../../lib/utils/nextApi';
import {
  baseRequestSchema,
  createApiError,
  createApiResponse,
  createRequestId,
  handleApiError,
  log,
  parseApiRequest,
} from '../../../lib/utils/api';
import { callGemini } from '../../../lib/services/gemini-ai';
import { getLunarDay } from '../../../lib/services/lunar-service';
import type {
  LunarAdviceResponseData,
  LunarAdvicePayload,
  LunarAdviceTopic,
} from '../../../lib/types/api';
import type { LunarDayData } from '../../../lib/types/lunar';
import {
  hasServiceCredentials,
  insertLunarAdviceRecord,
} from '../../../lib/utils/supabase';
import {
  getPhaseKnowledge,
  getZodiacKnowledge,
} from '../../../lib/data/lunar-guidance-knowledge';

const SUPPORTED_LOCALES = new Set(['en', 'es', 'ca']);
const MAX_LOOKAHEAD_DAYS = 32;

const adviceRequestSchema = baseRequestSchema.extend({
  topic: z
    .enum(['intentions', 'projects', 'relationships', 'wellbeing', 'creativity'])
    .default('intentions'),
  intention: z.string().trim().max(160).optional(),
  date: z.string().optional(),
});

const geminiAdviceSchema = z.object({
  focus: z.string().min(1),
  today: z.array(z.string().min(1)).min(1).max(4),
  next: z.object({
    phaseId: z.string().min(1),
    date: z.string().min(1),
    name: z.string().min(1),
    advice: z.string().min(1),
  }),
});

type AdviceRequestBody = z.infer<typeof adviceRequestSchema>;
type GeminiAdvice = z.infer<typeof geminiAdviceSchema>;

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse,
) {
  const requestId = createRequestId();
  const startedAt = Date.now();

  applyCorsHeaders(res);
  applyStandardResponseHeaders(res);

  if (req.method === 'OPTIONS') {
    return handleCorsPreflight(req, res);
  }

  if (req.method !== 'POST') {
    return sendJsonError(res, 405, {
      code: 'METHOD_NOT_ALLOWED',
      message: 'Method not allowed',
      requestId,
      details: { allowedMethods: ['POST'] },
    });
  }

  try {
    const { data: body } = await parseApiRequest<AdviceRequestBody>(
      req,
      adviceRequestSchema,
    );

    const locale = normaliseLocale(body.locale);
    const targetDate = resolveTargetDate(body.date);
    const targetDateIso = toDateIso(targetDate);

    log('info', 'Generating lunar advice', {
      requestId,
      date: targetDateIso,
      topic: body.topic,
      locale,
    });

    const lunarContext = await getLunarDay({
      date: targetDateIso,
      locale,
      requestId,
      includeSessions: false,
    });

    const nextPhase = await findNextPhaseDay(targetDate, locale, requestId);

    const aiAdvice = await generateAdviceWithGemini({
      topic: body.topic,
      intention: body.intention,
      locale,
      current: lunarContext,
      nextPhase,
      requestId,
    });

    const responsePayload: LunarAdviceResponseData = {
      advice: aiAdvice,
      context: {
        date: lunarContext.date,
        phaseId: lunarContext.phaseId,
        phaseName: lunarContext.phaseName,
        phaseEmoji: lunarContext.phaseEmoji,
        illumination: lunarContext.illumination,
        zodiac: {
          id: lunarContext.zodiac.id,
          name: lunarContext.zodiac.name,
          element: lunarContext.zodiac.element,
          symbol: lunarContext.zodiac.symbol,
        },
      },
    };

    return res.status(200).json(
      createApiResponse<LunarAdviceResponseData>(
        responsePayload,
        { processingTimeMs: Date.now() - startedAt },
        requestId,
      ),
    );
  } catch (error) {
    return handleApiError(res, error, requestId);
  }
}

async function generateAdviceWithGemini(options: {
  topic: LunarAdviceTopic;
  intention?: string;
  locale: 'en' | 'es' | 'ca';
  current: LunarDayData;
  nextPhase: LunarDayData;
  requestId: string;
}): Promise<LunarAdvicePayload> {
  const { topic, intention, locale, current, nextPhase, requestId } = options;

  const systemPrompt = buildSystemPrompt(locale);
  const userPrompt = buildUserPrompt({
    topic,
    intention,
    locale,
    current,
    nextPhase,
  });

  try {
    const response = await callGemini({
      systemPrompt,
      userPrompt,
      temperature: 0.6,
      maxTokens: 700,
      requestId,
    });

    const rawContent = response.content.trim();
    const parsed = parseGeminiAdvice(rawContent);

    if (parsed) {
      const normalizedAdvice = normaliseAdvice(parsed, nextPhase, locale);
      log('info', 'Generated lunar advice via Gemini', {
        requestId,
        topic,
        tokens: rawContent.length,
      });
      return normalizedAdvice;
    }

    log('warn', 'Failed to parse Gemini lunar advice JSON, using fallback', {
      requestId,
      contentPreview: rawContent.slice(0, 120),
    });
  } catch (error) {
    log('error', 'Gemini lunar advice generation failed', {
      requestId,
      error: error instanceof Error ? error.message : String(error),
    });
  }

  return buildFallbackAdvice({
    locale,
    current,
    nextPhase,
    topic,
    intention,
  });
}

async function findNextPhaseDay(
  startDate: Date,
  locale: 'en' | 'es' | 'ca',
  requestId: string,
): Promise<LunarDayData> {
  const current = new Date(Date.UTC(
    startDate.getUTCFullYear(),
    startDate.getUTCMonth(),
    startDate.getUTCDate(),
  ));

  const todayData = await getLunarDay({
    date: current,
    locale,
    requestId,
    includeSessions: false,
  });

  for (let offset = 1; offset <= MAX_LOOKAHEAD_DAYS; offset += 1) {
    const candidate = new Date(current);
    candidate.setUTCDate(candidate.getUTCDate() + offset);
    const candidateData = await getLunarDay({
      date: candidate,
      locale,
      requestId,
      includeSessions: false,
    });

    if (candidateData.phaseId !== todayData.phaseId) {
      return candidateData;
    }
  }

  return todayData;
}

function buildSystemPrompt(locale: 'en' | 'es' | 'ca'): string {
  const base = {
    en: `You are Luna, a calm and mystical lunar coach. You blend traditional astrology and lunar wisdom to guide daily actions.`,
    es: `Eres Luna, una guía lunar suave y mística. Combinas astrología tradicional y sabiduría lunar para orientar acciones diarias.`,
    ca: `Ets Lluna, una guia lunar serena i mística. Combines astrologia tradicional i saviesa lunar per orientar accions diàries.`,
  };

  const authenticity = {
    en: `AUTHENTICITY POLICY:
- Base ALL advice on documented traditions: Hellenistic Astrology, Western Modern Astrology, Wicca/Witchcraft moon wisdom
- NEVER invent meanings or make unsupported claims
- Reference specific astrological traditions when relevant
- Traditional moon phase knowledge comes from Wicca and Western Astrology
- Zodiac interpretations based on Hellenistic and Western Modern schools`,
    es: `POLÍTICA DE AUTENTICIDAD:
- Basa TODO el consejo en tradiciones documentadas: Astrología Helenística, Astrología Occidental Moderna, sabiduría lunar Wicca/Brujería
- NUNCA inventes significados ni hagas afirmaciones sin fundamento
- Referencia tradiciones astrológicas específicas cuando sea relevante
- El conocimiento tradicional de fases lunares proviene de Wicca y Astrología Occidental
- Interpretaciones zodiacales basadas en escuelas Helenística y Occidental Moderna`,
    ca: `POLÍTICA D'AUTENTICITAT:
- Basa TOT el consell en tradicions documentades: Astrologia Hel·lenística, Astrologia Occidental Moderna, saviesa lunar Wicca/Bruixeria
- MAI inventis significats ni facis afirmacions sense fonament
- Referència tradicions astrològiques específiques quan sigui rellevant
- El coneixement tradicional de fases lunars prové de Wicca i Astrologia Occidental
- Interpretacions zodiacals basades en escoles Hel·lenística i Occidental Moderna`,
  };

  return `${base[locale]}

${authenticity[locale]}

Principles:
- Speak warmly, poetically, but keep guidance actionable
- Tie advice to the traditional meanings provided for the lunar phase and zodiac sign
- Use the "bestFor" and "avoid" guidance from traditional sources
- Keep sentences concise; avoid lists longer than 3 items
- NEVER give medical or legal recommendations`;
}

function buildUserPrompt(options: {
  topic: LunarAdviceTopic;
  intention?: string;
  locale: 'en' | 'es' | 'ca';
  current: LunarDayData;
  nextPhase: LunarDayData;
}): string {
  const { topic, intention, locale, current, nextPhase } = options;

  // Get traditional knowledge for current phase and zodiac
  const phaseKnowledge = getPhaseKnowledge(current.phaseId);
  const zodiacKnowledge = getZodiacKnowledge(current.zodiac.id);

  const phaseInfo = phaseKnowledge ? [
    `\nTRADITIONAL PHASE KNOWLEDGE (${current.phaseName}):`,
    `Meaning: ${phaseKnowledge.meaning[locale]}`,
    `Energy: ${phaseKnowledge.energy[locale]}`,
    `Best for: ${phaseKnowledge.bestFor[locale].join(', ')}`,
    phaseKnowledge.avoid[locale].length > 0
      ? `Avoid: ${phaseKnowledge.avoid[locale].join(', ')}`
      : null,
  ].filter(Boolean).join('\n') : '';

  const zodiacInfo = zodiacKnowledge ? [
    `\nTRADITIONAL ZODIAC KNOWLEDGE (Moon in ${current.zodiac.name}):`,
    `Emotional tone: ${zodiacKnowledge.emotionalTone[locale]}`,
    `Focus areas: ${zodiacKnowledge.focusAreas[locale].join(', ')}`,
    `Element: ${zodiacKnowledge.element}`,
  ].join('\n') : '';

  const nextPhaseKnowledge = getPhaseKnowledge(nextPhase.phaseId);
  const nextPhaseInfo = nextPhaseKnowledge ? [
    `\nNEXT PHASE PREPARATION (${nextPhase.phaseName}):`,
    `Meaning: ${nextPhaseKnowledge.meaning[locale]}`,
    `Energy: ${nextPhaseKnowledge.energy[locale]}`,
  ].join('\n') : '';

  const schemaDescription = `{
  "focus": "One evocative sentence describing the day's lunar focus based on traditional knowledge",
  "today": ["Actionable suggestion 1", "Actionable suggestion 2", "Optional third suggestion"],
  "next": {
    "phaseId": "lunar phase ID e.g. new_moon",
    "date": "ISO date YYYY-MM-DD",
    "name": "Localized phase name",
    "advice": "Short preparation tip for that phase based on traditional meaning"
  }
}`;

  return [
    `Locale: ${locale}`,
    `Date: ${current.date}`,
    `Topic: ${topic}`,
    intention ? `User intention: ${intention}` : null,
    '',
    `CURRENT LUNAR CONTEXT:`,
    `Phase: ${current.phaseName} (${current.phaseId}) ${current.phaseEmoji}`,
    `Illumination: ${current.illumination.toFixed(1)}%`,
    `Zodiac: ${current.zodiac.name} (${current.zodiac.element}) ${current.zodiac.symbol}`,
    phaseInfo,
    zodiacInfo,
    nextPhaseInfo,
    '',
    `TASK: Generate personalized lunar guidance for the topic "${topic}" based on the traditional knowledge provided above.`,
    `The advice should integrate both the phase energy and zodiac influence.`,
    '',
    'Respond ONLY with valid JSON matching this schema:',
    schemaDescription,
  ]
    .filter(Boolean)
    .join('\n');
}

function parseGeminiAdvice(raw: string): GeminiAdvice | null {
  const jsonString = extractJsonObject(raw);
  if (!jsonString) {
    return null;
  }
  try {
    const parsed = JSON.parse(jsonString);
    const result = geminiAdviceSchema.safeParse(parsed);
    return result.success ? result.data : null;
  } catch {
    return null;
  }
}

function extractJsonObject(raw: string): string | null {
  const start = raw.indexOf('{');
  if (start === -1) {
    return null;
  }

  let depth = 0;
  for (let i = start; i < raw.length; i += 1) {
    const char = raw[i];
    if (char === '{') {
      depth += 1;
    } else if (char === '}') {
      depth -= 1;
      if (depth === 0) {
        return raw.slice(start, i + 1);
      }
    }
  }

  return null;
}

function normaliseAdvice(
  raw: GeminiAdvice,
  nextPhase: LunarDayData,
  locale: 'en' | 'es' | 'ca',
): LunarAdvicePayload {
  const nextPhaseId = normalisePhaseId(raw.next.phaseId, nextPhase.phaseId);

  return {
    focus: raw.focus.trim(),
    today: raw.today.map((item) => item.trim()).filter(Boolean),
    next: {
      phaseId: nextPhaseId as any,
      date: raw.next.date || nextPhase.date,
      name: raw.next.name.trim().length > 0 ? raw.next.name.trim() : nextPhase.phaseName,
      advice: raw.next.advice.trim(),
    },
  };
}

function normalisePhaseId(candidate: string, fallback: string): string {
  const allowed = new Set([
    'new_moon',
    'waxing_crescent',
    'first_quarter',
    'waxing_gibbous',
    'full_moon',
    'waning_gibbous',
    'last_quarter',
    'waning_crescent',
  ]);

  const normalised = candidate.trim().toLowerCase();
  return allowed.has(normalised) ? normalised : fallback;
}

function buildFallbackAdvice(options: {
  locale: 'en' | 'es' | 'ca';
  current: LunarDayData;
  nextPhase: LunarDayData;
  topic: LunarAdviceTopic;
  intention?: string;
}): LunarAdvicePayload {
  const { locale, current, nextPhase, intention } = options;

  // Get traditional knowledge
  const phaseKnowledge = getPhaseKnowledge(current.phaseId);
  const nextPhaseKnowledge = getPhaseKnowledge(nextPhase.phaseId);

  // Build focus based on traditional meaning
  let focus: string;
  if (phaseKnowledge) {
    const energyWord = phaseKnowledge.energy[locale].split(',')[0].toLowerCase();
    focus = locale === 'en'
      ? `Today's ${current.phaseName} brings ${energyWord} energy in ${current.zodiac.name}.`
      : locale === 'es'
      ? `La ${current.phaseName} de hoy trae energía ${energyWord} en ${current.zodiac.name}.`
      : `La ${current.phaseName} d'avui porta energia ${energyWord} a ${current.zodiac.name}.`;
  } else {
    focus = locale === 'en'
      ? `The ${current.phaseName} guides your path today.`
      : locale === 'es'
      ? `La ${current.phaseName} guía tu camino hoy.`
      : `La ${current.phaseName} guia el teu camí avui.`;
  }

  // Build suggestions based on traditional "bestFor"
  const todaySuggestions: string[] = [];
  if (phaseKnowledge && phaseKnowledge.bestFor[locale].length >= 2) {
    todaySuggestions.push(
      phaseKnowledge.bestFor[locale][0],
      phaseKnowledge.bestFor[locale][1]
    );
  } else {
    // Generic fallback
    todaySuggestions.push(
      locale === 'en' ? 'Honor this lunar moment with mindful action.'
        : locale === 'es' ? 'Honra este momento lunar con acción consciente.'
        : 'Honra aquest moment lunar amb acció conscient.',
      locale === 'en' ? 'Trust the moon\'s natural rhythm.'
        : locale === 'es' ? 'Confía en el ritmo natural de la luna.'
        : 'Confia en el ritme natural de la lluna.'
    );
  }

  // Add intention if provided
  if (intention && todaySuggestions.length < 3) {
    const whisper = {
      en: `Hold your intention: "${intention}".`,
      es: `Mantén tu intención: "${intention}".`,
      ca: `Mantingues la teva intenció: "${intention}".`,
    }[locale];
    todaySuggestions.push(whisper);
  }

  // Build next phase advice based on traditional meaning
  let nextAdvice: string;
  if (nextPhaseKnowledge) {
    const nextMeaning = nextPhaseKnowledge.meaning[locale].split('.')[0];
    nextAdvice = locale === 'en'
      ? `As ${nextPhase.phaseName} approaches: ${nextMeaning.toLowerCase()}.`
      : locale === 'es'
      ? `Cuando se acerque ${nextPhase.phaseName}: ${nextMeaning.toLowerCase()}.`
      : `Quan s'acosti ${nextPhase.phaseName}: ${nextMeaning.toLowerCase()}.`;
  } else {
    nextAdvice = locale === 'en'
      ? `Prepare for the ${nextPhase.phaseName} with reflection.`
      : locale === 'es'
      ? `Prepárate para ${nextPhase.phaseName} con reflexión.`
      : `Prepara't per ${nextPhase.phaseName} amb reflexió.`;
  }

  return {
    focus,
    today: todaySuggestions,
    next: {
      phaseId: nextPhase.phaseId,
      date: nextPhase.date,
      name: nextPhase.phaseName,
      advice: nextAdvice,
    },
  };
}

function isAnonymousUserId(userId: string): boolean {
  return userId.startsWith('anon_');
}


function normaliseLocale(locale?: string): 'en' | 'es' | 'ca' {
  if (!locale) {
    return 'en';
  }
  const normalized = locale.toLowerCase();
  return SUPPORTED_LOCALES.has(normalized) ? (normalized as 'en' | 'es' | 'ca') : 'en';
}

function resolveTargetDate(dateInput?: string): Date {
  if (!dateInput || !dateInput.trim()) {
    return new Date();
  }
  const parsed = new Date(dateInput);
  if (Number.isNaN(parsed.valueOf())) {
    throw createApiError('INVALID_DATE', 'Invalid date supplied for lunar advice', 400);
  }
  return parsed;
}

function toDateIso(date: Date): string {
  return new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()))
    .toISOString()
    .slice(0, 10);
}
