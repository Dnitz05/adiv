import { randomUUID } from 'crypto';
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
import { isUsingGemini } from '../../../lib/services/ai-provider';
import { callGemini } from '../../../lib/services/gemini-ai';
import { generateTarotCards, decodeTarotCard } from '../../../lib/utils/randomness';
import { CARD_NAMES, type CardName } from '../../../lib/data/card-names';
import { SPREADS, type SpreadDefinition, type SpreadPosition } from '../../../lib/data/spreads';
import type { ChatResponseMessage, ChatTextMessage, ChatSpreadMessage, ChatCtaMessage, ChatResponseData, ChatSpreadCard } from '../../../lib/types/api';

// Use DeepSeek Chat for general conversation
const DEFAULT_MODEL = process.env.DEEPSEEK_MODEL?.trim() ?? 'deepseek-chat';
const DEEPSEEK_URL = process.env.DEEPSEEK_API_URL ?? 'https://api.deepseek.com/v1/chat/completions';
const DEEPSEEK_API_KEY = process.env.DEEPSEEK_API_KEY;
const GEMINI_API_KEY = process.env.GEMINI_API_KEY?.trim();

const SUPPORTED_CHAT_LOCALES = new Set(['en', 'es', 'ca']);

const CHAT_SPREAD_OPTIONS = [
  {
    id: 'single',
    cardCount: 1,
    names: { en: 'Single Card', es: 'Single Card', ca: 'Single Card' },
    summary: {
      en: 'One card for quick clarity or daily focus.',
      es: 'Una carta para claridad rapida o enfoque diario.',
      ca: 'Una carta per claredat rapida o focus diari.',
    },
  },
  {
    id: 'two_card',
    cardCount: 2,
    names: { en: 'Two Card', es: 'Two Card', ca: 'Two Card' },
    summary: {
      en: 'Dual energies for choices, contrasts, or relationships.',
      es: 'Energias duales para decisiones, contrastes o relaciones.',
      ca: 'Energies duals per decisions, contrastos o relacions.',
    },
  },
  {
    id: 'three_card',
    cardCount: 3,
    names: { en: 'Past-Present-Future', es: 'Past-Present-Future', ca: 'Passat-Present-Futur' },
    summary: {
      en: 'Three-step narrative looking at past, present, and emerging path.',
      es: 'Narrativa de tres pasos sobre pasado, presente y camino emergente.',
      ca: 'Narrativa de tres passos sobre passat, present i cami emergent.',
    },
  },
  {
    id: 'five_card_cross',
    cardCount: 5,
    names: { en: 'Cross Insight', es: 'Cross Insight', ca: 'Cross Insight' },
    summary: {
      en: 'Cross layout to explore influences, blocks, and guidance.',
      es: 'Disposicion en cruz para explorar influencias, bloqueos y guia.',
      ca: 'Disposicio en creu per explorar influencies, bloquejos i guia.',
    },
  },
  {
    id: 'pyramid',
    cardCount: 6,
    names: { en: 'Pyramid', es: 'Pyramid', ca: 'Pyramid' },
    summary: {
      en: 'Holistic six-card pyramid (mind, heart, action, support).',
      es: 'Piramide de seis cartas para vision holistica (mente, corazon, accion).',
      ca: 'Piramide de sis cartes per visio holistica (ment, cor, accio).',
    },
  },
  {
    id: 'horseshoe',
    cardCount: 7,
    names: { en: 'Horseshoe', es: 'Horseshoe', ca: 'Horseshoe' },
    summary: {
      en: 'Seven-card arc for obstacles, allies, and outcomes.',
      es: 'Arco de siete cartas para obstaculos, aliados y desenlaces.',
      ca: 'Arc de set cartes per obstacles, aliats i desenllacos.',
    },
  },
] as const;

const CHAT_SPREAD_ID_SET = new Set(CHAT_SPREAD_OPTIONS.map((option) => option.id));
const DEFAULT_CHAT_SPREAD_ID = 'three_card';

const geminiStructuredResponseSchema = z.object({
  messages: z
    .array(
      z.object({
        type: z.literal('text'),
        text: z.string().min(1),
      })
    )
    .min(1),
  intent: z
    .object({
      shouldDrawSpread: z.boolean().optional(),
      spreadId: z.string().min(1).max(64).optional(),
      ctaLabel: z.string().min(1).max(80).optional(),
    })
    .optional(),
});

type GeminiStructuredResponse = z.infer<typeof geminiStructuredResponseSchema>;

const chatRequestSchema = baseRequestSchema.extend({
  message: z.string().min(1, 'Message is required'),
  userId: z.string().min(1, 'User ID is required'),
  locale: z.string().optional().default('en'),
  conversationHistory: z.array(
    z.object({
      role: z.enum(['user', 'assistant']),
      content: z.string(),
    })
  ).optional(),
});

type ChatRequestBody = z.infer<typeof chatRequestSchema>;

/**
 * General chat endpoint for conversational AI
 *
 * POST /api/chat/general
 * Body: { message: string, userId: string, locale?: string, conversationHistory?: Array }
 *
 * Response: { success: true, data: { reply: string } }
 */
export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse,
) {
  const requestId = createRequestId();

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
    const { data: body } = await parseApiRequest<ChatRequestBody>(
      req,
      chatRequestSchema,
    );

    log('info', `Chat request from user ${body.userId}`, {
      requestId,
      locale: body.locale,
      messageLength: body.message.length,
      hasHistory: !!body.conversationHistory,
    });

    const useGemini = isUsingGemini();

    log('info', 'Selected chat provider', {
      requestId,
      provider: useGemini ? 'gemini' : 'deepseek',
    });

    const messages = useGemini
      ? await handleGeminiChat(body, requestId)
      : await handleDeepSeekChat(body, requestId);

    return res.status(200).json(
      createApiResponse<ChatResponseData>(
        {
          messages,
        },
        undefined,
        requestId,
      )
    );
  } catch (error) {
    return handleApiError(res, error, requestId);
  }
}

/**
 * Handle chat with Gemini AI
 */
async function handleGeminiChat(
  body: ChatRequestBody,
  requestId: string,
): Promise<ChatResponseMessage[]> {
  if (!GEMINI_API_KEY) {
    throw createApiError(
      'GEMINI_UNAVAILABLE',
      'Gemini API key not configured',
      503,
      { provider: 'gemini' },
      requestId,
    );
  }

  const locale = normaliseLocale(body.locale);
  const systemPrompt = buildSystemPrompt(locale);
  const userPrompt = buildGeminiPrompt(body);

  try {
    const response = await callGemini({
      systemPrompt,
      userPrompt,
      temperature: 0.7,
      maxTokens: 900,
      requestId,
    });

    const rawContent = response.content.trim();
    const structured = parseGeminiStructuredResponse(rawContent);

    log('info', 'Gemini chat response parsed', {
      requestId,
      rawContentLength: rawContent.length,
      rawContentPreview: rawContent.substring(0, 200),
      hasStructured: !!structured,
      shouldDrawSpread: structured?.intent?.shouldDrawSpread,
      spreadId: structured?.intent?.spreadId,
    });

    let messages: ChatResponseMessage[] = [];

    if (structured) {
      const textMessages = structured.messages
        .map((entry) => entry.text.trim())
        .filter((text) => text.length > 0);

      messages = textMessages.map((text) => createTextMessage(text));

      if (structured.intent?.shouldDrawSpread) {
        try {
          const preferredSpreadId =
            structured.intent.spreadId && CHAT_SPREAD_ID_SET.has(structured.intent.spreadId)
              ? structured.intent.spreadId
              : undefined;

          const spreadMessage = await createChatSpreadMessage({
            locale,
            preferredSpreadId,
            requestId,
          });

          messages.push(spreadMessage);

          const ctaLabel = structured.intent.ctaLabel?.trim() || getInterpretationCtaLabel(locale);
          messages.push(
            createInterpretationCtaMessage({
              spreadMessageId: spreadMessage.id,
              spreadId: spreadMessage.spreadId,
              label: ctaLabel,
            })
          );
        } catch (spreadError) {
          log('error', 'Failed to generate tarot spread for chat response', {
            requestId,
            error: spreadError instanceof Error ? spreadError.message : String(spreadError),
          });
        }
      }
    }

    if (!messages.length && rawContent.length > 0) {
      messages = [createTextMessage(rawContent)];
    }

    if (!messages.length) {
      const fallback =
        locale === 'es'
          ? 'Lo siento, no he podido generar una respuesta en este momento.'
          : locale === 'ca'
              ? 'Ho sento, no he pogut generar una resposta en aquest moment.'
              : 'I am sorry, I could not generate a response right now.';
      return [createTextMessage(fallback)];
    }

    return messages;
  } catch (error) {
    log('error', 'Gemini chat failed', { requestId, error });
    throw createApiError(
      'GEMINI_CHAT_FAILED',
      'Failed to get response from Gemini',
      503,
      {
        provider: 'gemini',
        cause: error instanceof Error ? error.message : String(error),
      },
      requestId,
    );
  }
}

/**
 * Handle chat with DeepSeek AI
 */
async function handleDeepSeekChat(
  body: ChatRequestBody,
  requestId: string,
): Promise<ChatResponseMessage[]> {
  const locale = normaliseLocale(body.locale);
  if (!DEEPSEEK_API_KEY) {
    throw createApiError(
      'DEEPSEEK_UNAVAILABLE',
      'DeepSeek API key not configured',
      503,
      { provider: 'deepseek' },
      requestId,
    );
  }

  const messages = [];

  // System message
  messages.push({
    role: 'system',
    content: buildSystemPrompt(body.locale),
  });

  // Add conversation history if provided
  if (body.conversationHistory && body.conversationHistory.length > 0) {
    messages.push(...body.conversationHistory);
  }

  // Add current user message
  messages.push({
    role: 'user',
    content: body.message,
  });

  try {
    const response = await fetch(DEEPSEEK_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${DEEPSEEK_API_KEY}`,
      },
      body: JSON.stringify({
        model: DEFAULT_MODEL,
        messages,
        temperature: 0.8,
        max_tokens: 1000,
        stream: false,
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      log('error', 'DeepSeek API error', { requestId, status: response.status, error: errorText });
      throw new Error(`DeepSeek API error: ${response.status}`);
    }

    const data = await response.json();
    const reply = data.choices?.[0]?.message?.content;

    if (!reply) {
      throw new Error('No response from DeepSeek');
    }

    const trimmed = reply.trim();
    if (!trimmed.length) {
      const fallback =
        locale === 'es'
          ? 'Lo siento, no he podido generar una respuesta en este momento.'
          : locale === 'ca'
              ? 'Ho sento, no he pogut generar una resposta en aquest moment.'
              : 'I am sorry, I could not generate a response right now.';
      return [createTextMessage(fallback)];
    }
    return [createTextMessage(trimmed)];
  } catch (error) {
    log('error', 'DeepSeek chat failed', { requestId, error });
    throw createApiError(
      'DEEPSEEK_CHAT_FAILED',
      'Failed to get response from DeepSeek',
      503,
      {
        provider: 'deepseek',
        cause: error instanceof Error ? error.message : String(error),
      },
      requestId,
    );
  }
}

function normaliseLocale(locale?: string): 'en' | 'es' | 'ca' {
  if (!locale) {
    return 'en';
  }
  const normalised = locale.toLowerCase();
  return SUPPORTED_CHAT_LOCALES.has(normalised) ? (normalised as 'en' | 'es' | 'ca') : 'en';
}

function createTextMessage(text: string): ChatTextMessage {
  return {
    id: randomUUID(),
    type: 'text',
    text: text.trim(),
  };
}

function getInterpretationCtaLabel(locale: 'en' | 'es' | 'ca'): string {
  switch (locale) {
    case 'es':
      return 'Interpretación';
    case 'ca':
      return 'Interpretació';
    default:
      return 'Interpretation';
  }
}

function createInterpretationCtaMessage(params: {
  spreadMessageId: string;
  spreadId: string;
  label: string;
}): ChatCtaMessage {
  return {
    id: randomUUID(),
    type: 'cta',
    label: params.label,
    payload: {
      action: 'interpret_spread',
      spreadMessageId: params.spreadMessageId,
      spreadId: params.spreadId,
    },
  };
}

function parseGeminiStructuredResponse(raw: string): GeminiStructuredResponse | null {
  const jsonSegment = extractJsonObject(raw);
  if (!jsonSegment) {
    return null;
  }
  try {
    const parsed = JSON.parse(jsonSegment);
    const result = geminiStructuredResponseSchema.safeParse(parsed);
    if (!result.success) {
      return null;
    }
    return result.data;
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
  for (let i = start; i < raw.length; i++) {
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

async function createChatSpreadMessage(options: {
  locale: 'en' | 'es' | 'ca';
  preferredSpreadId?: string;
  requestId: string;
}): Promise<ChatSpreadMessage> {
  const spreadDefinition = selectChatSpreadDefinition(options.preferredSpreadId);
  const sortedPositions = [...spreadDefinition.positions].sort((a, b) => a.number - b.number);

  const draw = await generateTarotCards({
    count: spreadDefinition.cardCount,
    allowReversed: true,
  });

  if (draw.values.length < spreadDefinition.cardCount) {
    throw new Error('Insufficient cards generated for spread');
  }

  const { rows, columns } = computeGridPreset(spreadDefinition.cardCount);

  const cards: ChatSpreadCard[] = [];

  for (let index = 0; index < spreadDefinition.cardCount; index += 1) {
    const encoded = draw.values[index];
    const { cardIndex, isReversed } = decodeTarotCard(encoded);
    const cardMetadata = findCardById(cardIndex);
    const positionDefinition = sortedPositions[index] ?? sortedPositions[sortedPositions.length - 1];
    const { row, column } = computeGridPosition(index, columns);
    const meaning = getPositionMeaning(positionDefinition, options.locale);

    cards.push({
      id: String(cardMetadata.id),
      name: localiseCardName(cardMetadata, options.locale),
      suit: cardMetadata.suit,
      number: cardMetadata.number,
      upright: !isReversed,
      position: positionDefinition?.number ?? index + 1,
      row,
      column,
      image: cardMetadata.image,
      meaning,
      meaningShort: meaning,
    });
  }

  log('info', 'Generated tarot spread for chat', {
    requestId: options.requestId,
    spreadId: spreadDefinition.id,
    cards: cards.map((card) => card.id),
  });

  return {
    id: randomUUID(),
    type: 'tarot_spread',
    spreadId: spreadDefinition.id,
    spreadName: localiseSpreadName(spreadDefinition, options.locale),
    spreadDescription: localiseSpreadDescription(spreadDefinition, options.locale),
    layout: {
      rows,
      columns,
    },
    cards,
  };
}

function selectChatSpreadDefinition(preferredSpreadId?: string): SpreadDefinition {
  const candidates = SPREADS.filter(
    (spread) => CHAT_SPREAD_ID_SET.has(spread.id) && spread.cardCount <= 9,
  );

  if (!candidates.length) {
    throw new Error('No chat-compatible spreads available');
  }

  if (preferredSpreadId) {
    const preferred = candidates.find((spread) => spread.id === preferredSpreadId);
    if (preferred) {
      return preferred;
    }
  }

  const fallback = candidates.find((spread) => spread.id === DEFAULT_CHAT_SPREAD_ID);
  return fallback ?? candidates[0];
}

function computeGridPreset(cardCount: number): { rows: number; columns: number } {
  const presets: Record<number, { rows: number; columns: number }> = {
    1: { rows: 1, columns: 1 },
    2: { rows: 1, columns: 2 },
    3: { rows: 1, columns: 3 },
    4: { rows: 2, columns: 2 },
    5: { rows: 2, columns: 3 },
    6: { rows: 2, columns: 3 },
    7: { rows: 3, columns: 3 },
    8: { rows: 3, columns: 3 },
    9: { rows: 3, columns: 3 },
  };
  return presets[cardCount] ?? { rows: 3, columns: 3 };
}

function computeGridPosition(index: number, columns: number): { row: number; column: number } {
  return {
    row: Math.floor(index / columns),
    column: index % columns,
  };
}

function findCardById(id: number): CardName {
  const card = CARD_NAMES.find((entry) => entry.id === id);
  if (!card) {
    throw new Error(`Unknown tarot card id ${id}`);
  }
  return card;
}

function localiseCardName(card: CardName, locale: 'en' | 'es' | 'ca'): string {
  if (locale === 'es') {
    return card.es;
  }
  if (locale === 'ca') {
    return card.ca;
  }
  return card.en;
}

function localiseSpreadName(spread: SpreadDefinition, locale: 'en' | 'es' | 'ca'): string {
  if (locale === 'es') {
    return spread.nameES;
  }
  if (locale === 'ca') {
    return spread.nameCA;
  }
  return spread.name;
}

function localiseSpreadDescription(spread: SpreadDefinition, locale: 'en' | 'es' | 'ca'): string {
  if (locale === 'es') {
    return spread.descriptionES;
  }
  if (locale === 'ca') {
    return spread.descriptionCA;
  }
  return spread.description;
}

function getPositionMeaning(position: SpreadPosition | undefined, locale: 'en' | 'es' | 'ca'): string | undefined {
  if (!position) {
    return undefined;
  }
  if (locale === 'es') {
    return position.meaningES ?? position.meaning;
  }
  if (locale === 'ca') {
    return position.meaningCA ?? position.meaning;
  }
  return position.meaning;
}

function buildGeminiPrompt(body: ChatRequestBody): string {
  const history = body.conversationHistory ?? [];
  const recentHistory = history.slice(-10);

  const transcript = recentHistory
    .map((entry) => `${entry.role === 'assistant' ? 'Assistant' : 'User'}: ${entry.content}`)
    .join('\n\n');

  const locale = normaliseLocale(body.locale);
  const spreadOptions = formatSpreadOptionsForPrompt(locale);
  const spreadIds = Array.from(CHAT_SPREAD_ID_SET).join(', ');

  const schemaDescription = `{
  "messages": [
    { "type": "text", "text": "<assistant reply in ${locale}>" }
  ],
  "intent": {
    "shouldDrawSpread": true | false,
    "spreadId": "<one of: ${spreadIds}>",
    "ctaLabel": "<optional custom button label in ${locale}>"
  }
}`;

  const languageInstructions = {
    ca: 'RESPOSTA EN CATALÀ - Els teus missatges de text han de ser EN CATALÀ',
    es: 'RESPUESTA EN ESPAÑOL - Tus mensajes de texto deben ser EN ESPAÑOL',
    en: 'RESPONSE IN ENGLISH - Your text messages must be IN ENGLISH',
  };

  const instructions = [
    `${languageInstructions[locale] || languageInstructions.en}`,
    '',
    `Respond with JSON ONLY that matches this schema:`,
    schemaDescription,
    '',
    'CRITICAL UNDERSTANDING:',
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
    'You are an AI assistant in a digital tarot app.',
    'You DO NOT need physical hands to draw cards.',
    'The SYSTEM draws cards automatically when you set shouldDrawSpread: true.',
    '',
    'NEVER say: "I cannot draw cards", "I don\'t have hands", "I\'m just an AI"',
    'INSTEAD: Set shouldDrawSpread: true and the app generates cards automatically.',
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
    '',
    'RULES for tarot spreads:',
    '1. User explicitly asks for cards (tirada/spread/draw/lectura):',
    '   → Set `"shouldDrawSpread": true`',
    '   → Pick best `"spreadId"` from catalogue',
    '   → System generates cards automatically',
    '   → Do NOT describe imaginary cards in text',
    '',
    '2. User asks question without requesting cards:',
    '   → You MAY set `"shouldDrawSpread": true` if helpful',
    '   → Or provide text guidance only',
    '',
    `3. Text messages: warm, mystical, under 3 paragraphs, IN ${locale.toUpperCase()}`,
    '',
    'Examples requiring shouldDrawSpread=true:',
    '- "Draw 3 cards about my career" → shouldDrawSpread: true',
    '- "Fes-me una tirada sobre l\'amor" → shouldDrawSpread: true',
    '- "Necesito una lectura de tarot" → shouldDrawSpread: true',
    '',
    'Spread catalogue:',
    spreadOptions,
    '',
    transcript ? `Conversation:\n${transcript}` : null,
    `User: ${body.message}`,
    '',
    `JSON (text in ${locale}):`,
  ].filter((part): part is string => part !== null);

  return instructions.join('\n\n');
}

function formatSpreadOptionsForPrompt(locale: 'en' | 'es' | 'ca'): string {
  return CHAT_SPREAD_OPTIONS.map((option) => {
    const name =
      locale === 'es'
        ? option.names.es
        : locale === 'ca'
            ? option.names.ca
            : option.names.en;
    const summary =
      locale === 'es'
        ? option.summary.es
        : locale === 'ca'
            ? option.summary.ca
            : option.summary.en;
    return `- ${option.id} (${option.cardCount} cards): ${name} — ${summary}`;
  }).join('\n');
}

/**
 * Build system prompt based on locale
 */
function buildSystemPrompt(locale: string): string {
  const prompts: Record<string, string> = {
    ca: `Ets un assistent expert en tarot i espiritualitat integrat en una aplicació digital. Respons SEMPRE EN CATALÀ amb saviesa, compassió i profunditat espiritual.

IMPORTANT - Com funciona el sistema de tirades:
- Quan un usuari et demana una tirada de cartes, TU NO tires cartes físiques
- Tu simplement indiques al sistema que generi una tirada (via JSON amb shouldDrawSpread: true)
- El SISTEMA automàticament generarà cartes aleatòries reals i les mostrarà visualment
- MAI diguis "no puc tirar cartes" o "no tinc mans" - el SISTEMA ho fa per tu automàticament

Característiques:
- Ets amable, empàtic i respectuós
- Tens coneixements profunds de tarot, astrologia i espiritualitat
- Proporciones guia pràctica i reflexió espiritual
- Respectes totes les creences i tradicions
- Respons SEMPRE EN CATALÀ de forma clara i accessible
- Mai diagnostiques problemes mèdics o legals

Quan et demanin tirades de tarot, activa shouldDrawSpread: true al JSON i el sistema generarà les cartes automàticament.`,

    es: `Eres un asistente experto en tarot y espiritualidad integrado en una aplicación digital. Respondes SIEMPRE EN ESPAÑOL con sabiduría, compasión y profundidad espiritual.

IMPORTANTE - Cómo funciona el sistema de tiradas:
- Cuando un usuario te pide una tirada de cartas, TÚ NO tiras cartas físicas
- Tú simplemente indicas al sistema que genere una tirada (vía JSON con shouldDrawSpread: true)
- El SISTEMA automáticamente generará cartas aleatorias reales y las mostrará visualmente
- NUNCA digas "no puedo tirar cartas" o "no tengo manos" - el SISTEMA lo hace por ti automáticamente

Características:
- Eres amable, empático y respetuoso
- Tienes conocimientos profundos de tarot, astrología y espiritualidad
- Proporcionas guía práctica y reflexión espiritual
- Respetas todas las creencias y tradiciones
- Respondes SIEMPRE EN ESPAÑOL de forma clara y accesible
- Nunca diagnosticas problemas médicos o legales

Cuando te pidan tiradas de tarot, activa shouldDrawSpread: true en el JSON y el sistema generará las cartas automáticamente.`,

    en: `You are an expert tarot and spirituality assistant integrated into a digital app. You ALWAYS respond IN ENGLISH with wisdom, compassion, and spiritual depth.

IMPORTANT - How the card drawing system works:
- When a user asks for a card spread, YOU DO NOT draw physical cards
- You simply tell the system to generate a spread (via JSON with shouldDrawSpread: true)
- The SYSTEM will automatically generate real random cards and display them visually
- NEVER say "I cannot draw cards" or "I don't have hands" - the SYSTEM does it for you automatically

Characteristics:
- You are kind, empathetic, and respectful
- You have deep knowledge of tarot, astrology, and spirituality
- You provide practical guidance and spiritual reflection
- You respect all beliefs and traditions
- You respond ALWAYS IN ENGLISH clearly and accessibly
- You never diagnose medical or legal issues

When asked for tarot spreads, set shouldDrawSpread: true in the JSON and the system will generate the cards automatically.`,
  };

  return prompts[locale] || prompts.en;
}
