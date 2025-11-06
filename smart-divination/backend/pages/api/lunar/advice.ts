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
    en: `You are Luna, a calm and mystical lunar coach. You blend astronomy and intuition to guide daily actions.`,
    es: `Eres Luna, una guía lunar suave y mística. Combinas astronomía e intuición para orientar acciones diarias.`,
    ca: `Ets Lluna, una guia lunar serena i mística. Combines astronomia i intuïció per orientar accions diàries.`,
  };

  return `${base[locale]}

Principles:
- Speak warmly, poetically, but keep guidance actionable.
- Tie advice to the current lunar phase, zodiac sign, illumination, and topic provided.
- Keep sentences concise; avoid lists longer than 3 items.
- NEVER give medical or legal recommendations.`;
}

function buildUserPrompt(options: {
  topic: LunarAdviceTopic;
  intention?: string;
  locale: 'en' | 'es' | 'ca';
  current: LunarDayData;
  nextPhase: LunarDayData;
}): string {
  const { topic, intention, locale, current, nextPhase } = options;

  const schemaDescription = `{
  "focus": "One evocative sentence describing the day's lunar focus",
  "today": ["Actionable suggestion 1", "Actionable suggestion 2", "Optional third suggestion"],
  "next": {
    "phaseId": "lunar phase ID e.g. new_moon",
    "date": "ISO date YYYY-MM-DD",
    "name": "Localized phase name",
    "advice": "Short preparation tip for that phase"
  }
}`;

  return [
    `Locale: ${locale}`,
    `Date: ${current.date}`,
    `Topic: ${topic}`,
    intention ? `User intention: ${intention}` : null,
    `Current phase: ${current.phaseName} (${current.phaseId}) ${current.phaseEmoji}`,
    `Illumination: ${current.illumination.toFixed(1)}%`,
    `Zodiac: ${current.zodiac.name} (${current.zodiac.element})`,
    `Next distinct phase: ${nextPhase.phaseName} on ${nextPhase.date} (${nextPhase.phaseId})`,
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

  const phaseLabel = current.phaseName.toLowerCase();
  const zodiacLabel = current.zodiac.name.toLowerCase();

  const focusMap: Record<'en' | 'es' | 'ca', string> = {
    en: 'Let the ' + phaseLabel + ' guide your ' + zodiacLabel + ' heart.',
    es: 'Deja que la ' + phaseLabel + ' inspire tu corazon ' + zodiacLabel + '.',
    ca: 'Deixa que la ' + phaseLabel + ' inspiri el teu cor ' + zodiacLabel + '.',
  };

  const todayBase: Record<'en' | 'es' | 'ca', string[]> = {
    en: [
      'Take a mindful moment to honour your intention.',
      'Act in small, meaningful steps while the moon is ' + phaseLabel + '.',
    ],
    es: [
      'Reserva un momento consciente para honrar tu intencion.',
      'Da pasos pequenos y sentidos mientras la luna esta ' + phaseLabel + '.',
    ],
    ca: [
      'Reserva un instant conscient per honrar la teva intencio.',
      'Fes passos petits i sentits mentre la lluna es ' + phaseLabel + '.',
    ],
  };

  const nextAdviceMap: Record<'en' | 'es' | 'ca', string> = {
    en: 'Prepare for the ' + nextPhase.phaseName.toLowerCase() + ' by reflecting on progress so far.',
    es: 'Preparate para la ' + nextPhase.phaseName.toLowerCase() + ' revisando tus avances.',
    ca: 'Prepara la ' + nextPhase.phaseName.toLowerCase() + ' revisant els avancos fets.',
  };

  const todaySuggestions = [...todayBase[locale]];

  if (intention && todaySuggestions.length < 3) {
    const whisper = {
      en: 'Whisper your intention: "' + intention + '".',
      es: 'Susurra tu intencion: "' + intention + '".',
      ca: 'Murmura la teva intencio: "' + intention + '".',
    }[locale];
    todaySuggestions.push(whisper);
  }

  return {
    focus: focusMap[locale],
    today: todaySuggestions,
    next: {
      phaseId: nextPhase.phaseId,
      date: nextPhase.date,
      name: nextPhase.phaseName,
      advice: nextAdviceMap[locale],
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
