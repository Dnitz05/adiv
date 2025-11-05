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
  createApiResponse,
  createRequestId,
  handleApiError,
  log,
  parseApiRequest,
} from '../../../lib/utils/api';
import { isUsingGemini } from '../../../lib/services/ai-provider';
import { interpretCardsWithGemini } from '../../../lib/services/gemini-ai';

const METRICS_PATH = '/api/chat/general';
const ALLOW_HEADER_VALUE = 'OPTIONS, POST';

// Use DeepSeek Chat for general conversation
const DEFAULT_MODEL = process.env.DEEPSEEK_MODEL?.trim() ?? 'deepseek-chat';
const DEEPSEEK_URL = process.env.DEEPSEEK_API_URL ?? 'https://api.deepseek.com/v1/chat/completions';
const DEEPSEEK_API_KEY = process.env.DEEPSEEK_API_KEY;

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

  applyCorsHeaders(res, ALLOW_HEADER_VALUE);
  applyStandardResponseHeaders(res);

  if (req.method === 'OPTIONS') {
    return handleCorsPreflight(res);
  }

  if (req.method !== 'POST') {
    return sendJsonError(res, 405, 'METHOD_NOT_ALLOWED', 'Method not allowed', {
      allowedMethods: ['POST'],
      requestId,
    });
  }

  try {
    const { data: body, auth } = await parseApiRequest<ChatRequestBody>(
      req,
      chatRequestSchema,
      requestId,
    );

    log('info', `Chat request from user ${body.userId}`, {
      requestId,
      locale: body.locale,
      messageLength: body.message.length,
      hasHistory: !!body.conversationHistory,
    });

    // Check if using Gemini (for consistency)
    if (isUsingGemini()) {
      const geminiResponse = await handleGeminiChat(body, requestId);
      return res.status(200).json(
        createApiResponse({
          reply: geminiResponse,
        }, requestId)
      );
    }

    // Use DeepSeek for general chat
    const deepseekResponse = await handleDeepSeekChat(body, requestId);

    return res.status(200).json(
      createApiResponse({
        reply: deepseekResponse,
      }, requestId)
    );
  } catch (error) {
    return handleApiError(error, res, METRICS_PATH, requestId);
  }
}

/**
 * Handle chat with Gemini AI
 */
async function handleGeminiChat(
  body: ChatRequestBody,
  requestId: string,
): Promise<string> {
  const systemPrompt = buildSystemPrompt(body.locale);
  const userPrompt = body.message;

  try {
    const response = await interpretCardsWithGemini({
      systemPrompt,
      userPrompt,
      temperature: 0.8, // More creative for general chat
    });

    return response.interpretation || 'I apologize, but I could not generate a response at this time.';
  } catch (error) {
    log('error', 'Gemini chat failed', { requestId, error });
    throw new Error('Failed to get response from Gemini');
  }
}

/**
 * Handle chat with DeepSeek AI
 */
async function handleDeepSeekChat(
  body: ChatRequestBody,
  requestId: string,
): Promise<string> {
  if (!DEEPSEEK_API_KEY) {
    throw new Error('DeepSeek API key not configured');
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

    return reply.trim();
  } catch (error) {
    log('error', 'DeepSeek chat failed', { requestId, error });
    throw new Error('Failed to get response from DeepSeek');
  }
}

/**
 * Build system prompt based on locale
 */
function buildSystemPrompt(locale: string): string {
  const prompts: Record<string, string> = {
    ca: `Ets un assistent expert en tarot i espiritualitat. Respons amb saviesa, compassió i profunditat espiritual.

Característiques:
- Ets amable, empàtic i respectuós
- Tens coneixements profunds de tarot, astrologia i espiritualitat
- Proporciones guia pràctica i reflexió espiritual
- Respectes totes les creences i tradicions
- Respons de forma clara i accessible
- Mai diagnostiques problemes mèdics o legals

Quan et preguntin sobre tarot, explica els significats de les cartes, els spreads i les interpretacions. Quan et preguntin sobre temes espirituals en general, proporciona perspectives reflexives i útils.`,

    es: `Eres un asistente experto en tarot y espiritualidad. Respondes con sabiduría, compasión y profundidad espiritual.

Características:
- Eres amable, empático y respetuoso
- Tienes conocimientos profundos de tarot, astrología y espiritualidad
- Proporcionas guía práctica y reflexión espiritual
- Respetas todas las creencias y tradiciones
- Respondes de forma clara y accesible
- Nunca diagnosticas problemas médicos o legales

Cuando te pregunten sobre tarot, explica los significados de las cartas, los spreads y las interpretaciones. Cuando te pregunten sobre temas espirituales en general, proporciona perspectivas reflexivas y útiles.`,

    en: `You are an expert tarot and spirituality assistant. You respond with wisdom, compassion, and spiritual depth.

Characteristics:
- You are kind, empathetic, and respectful
- You have deep knowledge of tarot, astrology, and spirituality
- You provide practical guidance and spiritual reflection
- You respect all beliefs and traditions
- You respond clearly and accessibly
- You never diagnose medical or legal issues

When asked about tarot, explain card meanings, spreads, and interpretations. When asked about general spiritual topics, provide thoughtful and helpful perspectives.`,
  };

  return prompts[locale] || prompts.en;
}
