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
import type { ChatResponseData, ChatResponseMessage, ChatTextMessage } from '../../../lib/types/api';
import { generateInterpretation } from '../../../lib/services/ai-provider';
import { CARD_NAMES, type CardName } from '../../../lib/data/card-names';
import { SPREADS, type SpreadDefinition } from '../../../lib/data/spreads';

const SUPPORTED_LOCALES = new Set(['en', 'es', 'ca']);

const interpretationRequestSchema = baseRequestSchema.extend({
  spreadMessageId: z.string().min(1, 'spreadMessageId is required'),
  spreadId: z.string().min(1, 'spreadId is required'),
  spreadName: z.string().optional(),
  cards: z.array(
    z.object({
      id: z.string().min(1),
      upright: z.boolean(),
      position: z.number().int().min(1).max(9),
      meaning: z.string().optional(),
    })
  ).min(1).max(9),
  question: z.string().optional(),
});

type InterpretationRequestBody = z.infer<typeof interpretationRequestSchema>;

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
    const { data: body } = await parseApiRequest<InterpretationRequestBody>(
      req,
      interpretationRequestSchema,
    );

    const locale = normaliseLocale(body.locale);
    const spreadDefinition = findSpreadDefinition(body.spreadId, requestId);
    const spreadName = body.spreadName?.trim() || localiseSpreadName(spreadDefinition, locale);

    const cardsForInterpretation = body.cards.map((card, index) => {
      const cardMetadata = findCardById(Number(card.id), requestId);
      const positionLabel =
        card.meaning?.trim() && card.meaning.trim().length > 0
          ? card.meaning.trim()
          : `Position ${card.position}`;

      return {
        name: cardMetadata.en,
        upright: card.upright,
        position: positionLabel,
      };
    });

    log('info', 'Generating chat interpretation', {
      requestId,
      spreadId: body.spreadId,
      cardCount: cardsForInterpretation.length,
    });

    const interpretation = await generateInterpretation(
      body.question ?? '',
      cardsForInterpretation,
      spreadName,
      locale,
      requestId,
      body.spreadId,
    );

    const trimmedInterpretation = interpretation.trim();
    const reply = trimmedInterpretation.length > 0
      ? trimmedInterpretation
      : locale === 'es'
          ? 'No he podido generar una interpretacion en este momento.'
          : locale === 'ca'
              ? 'No he pogut generar una interpretacio en aquest moment.'
              : 'I could not produce an interpretation right now.';

    const messages: ChatResponseMessage[] = [createTextMessage(reply)];

    return res.status(200).json(
      createApiResponse<ChatResponseData>(
        { messages },
        undefined,
        requestId,
      ),
    );
  } catch (error) {
    return handleApiError(res, error, requestId);
  }
}

function normaliseLocale(locale?: string): 'en' | 'es' | 'ca' {
  if (!locale) {
    return 'en';
  }
  const normalized = locale.toLowerCase();
  return SUPPORTED_LOCALES.has(normalized) ? (normalized as 'en' | 'es' | 'ca') : 'en';
}

function createTextMessage(text: string): ChatTextMessage {
  return {
    id: randomUUID(),
    type: 'text',
    text: text.trim(),
  };
}

function findCardById(id: number, requestId: string): CardName {
  const card = CARD_NAMES.find((entry) => entry.id === id);
  if (!card) {
    throw createApiError(
      'INVALID_CARD',
      `Unknown tarot card id: ${id}`,
      400,
      undefined,
      requestId,
    );
  }
  return card;
}

function findSpreadDefinition(spreadId: string, requestId: string): SpreadDefinition {
  const spread = SPREADS.find((entry) => entry.id === spreadId);
  if (!spread) {
    throw createApiError(
      'UNKNOWN_SPREAD',
      `Unknown spread id: ${spreadId}`,
      400,
      undefined,
      requestId,
    );
  }
  return spread;
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
