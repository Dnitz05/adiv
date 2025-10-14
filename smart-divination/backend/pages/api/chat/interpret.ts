import type { NextApiRequest, NextApiResponse } from 'next';
import { z } from 'zod';
import type { DeepSeekResponse, JsonRecord } from '../../../lib/types/api';

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
  divinationTechniqueSchema,
  handleApiError,
  log,
  parseApiRequest,
  createApiError,
  type AuthContext,
} from '../../../lib/utils/api';
import {
  createSessionArtifact,
  createSessionMessage,
  getSession,
} from '../../../lib/utils/supabase';
import { recordApiMetric } from '../../../lib/utils/metrics';

const METRICS_PATH = '/api/chat/interpret';
const ALLOW_HEADER_VALUE = 'OPTIONS, POST';
const DEFAULT_MODEL = process.env.DEEPSEEK_MODEL ?? 'deepseek-chat';
const DEEPSEEK_URL = process.env.DEEPSEEK_API_URL ?? 'https://api.deepseek.com/v1/chat/completions';

const interpretationRequestSchema = baseRequestSchema.extend({
  sessionId: z.string().min(1, 'sessionId is required'),
  results: z.record(z.any(), { required_error: 'results are required' }),
  interpretation: z.string().min(1).optional(),
  summary: z.string().optional(),
  question: z.string().optional(),
  model: z.string().optional(),
  temperature: z.number().min(0).max(2).optional(),
  technique: divinationTechniqueSchema.default('tarot'),
  locale: z.string().min(2).optional(),
});

type InterpretationRequestBody = z.infer<typeof interpretationRequestSchema>;

type GeneratedInterpretation = {
  interpretation: string;
  summary?: string;
  keywords: string[];
};

type TarotResultCard = {
  name?: string;
  suit?: string;
  position?: number;
  upright?: boolean;
};

type DeepSeekParams = {
  sessionId: string;
  results: JsonRecord;
  question?: string | null;
  technique: string;
  locale: string;
  model?: string;
  temperature?: number;
};

function extractKeywords(source?: string | null): string[] {
  if (!source) {
    return [];
  }
  const words = source
    .toLowerCase()
    .replace(/[^a-z0-9\s]/g, ' ')
    .split(/\s+/)
    .filter((word) => word.length >= 4);
  const unique = Array.from(new Set(words));
  return unique.slice(0, 12);
}

function cleanMetadata(source: Record<string, unknown>): Record<string, unknown> {
  const result: Record<string, unknown> = {};
  for (const [key, value] of Object.entries(source)) {
    if (value !== undefined && value !== null) {
      result[key] = value;
    }
  }
  return result;
}

function deriveSummary(text: string): string {
  const cleaned = text.replace(/\s+/g, ' ').trim();
  if (cleaned.length <= 140) {
    return cleaned;
  }
  const sentenceMatch = cleaned.match(/[^.!?]+[.!?]/);
  if (sentenceMatch && sentenceMatch[0].length >= 40) {
    return sentenceMatch[0].trim();
  }
  return `${cleaned.slice(0, 137).trim()}...`;
}

function formatResultsForPrompt(results: JsonRecord, technique: string): string {
  if (technique === 'tarot') {
    const cards = Array.isArray(results.cards) ? (results.cards as TarotResultCard[]) : [];
    if (!cards.length) {
      return 'No cards provided.';
    }
    return cards
      .map((card: TarotResultCard, index: number) => {
        const name = typeof card?.name === 'string' ? card.name : 'Unknown card';
        const suit = typeof card?.suit === 'string' ? card.suit : '';
        const position = typeof card?.position === 'number' ? card.position : index + 1;
        const orientation = card?.upright === false ? 'reversed' : 'upright';
        const suitPart = suit ? ` (${suit})` : '';
        return `${index + 1}. ${name}${suitPart} - ${orientation} at position ${position}`;
      })
      .join('\n');
  }

  return JSON.stringify(results);
}

function buildInterpretationPrompt(params: {
  technique: string;
  locale: string;
  question?: string | null;
  results: JsonRecord;
}): string {
  const { technique, locale, question, results } = params;
  const questionText = question?.trim() ?? 'No specific question was provided.';
  const spread = typeof results.spread === 'string' ? results.spread : 'unknown';
  const method = typeof results.method === 'string' ? results.method : 'unspecified';
  const promptLines = [
    'You are an empathetic divination guide. Provide ethical, supportive insight.',
    'Respond strictly as JSON with keys "interpretation" (string), "summary" (<=120 characters), and "keywords" (array of <=8 lowercase phrases).',
    'Avoid deterministic or harmful language. Suggest balanced, actionable guidance.',
    '',
    `Technique: ${technique}`,
    `Locale: ${locale}`,
    `Spread: ${spread}`,
    `Method: ${method}`,
    `Question: ${questionText}`,
    'Cards:',
    formatResultsForPrompt(results, technique),
  ];
  return promptLines.join('\n');
}

async function generateInterpretationFromDeepSeek(
  params: DeepSeekParams
): Promise<GeneratedInterpretation | null> {
  const apiKey = process.env.DEEPSEEK_API_KEY;
  log('info', 'DeepSeek API key check', {
    sessionId: params.sessionId,
    hasApiKey: !!apiKey,
    keyLength: apiKey?.length || 0,
  });
  if (!apiKey) {
    log('warn', 'DeepSeek API key missing; skipping interpretation generation', {
      sessionId: params.sessionId,
    });
    return null;
  }

  const requestBody = {
    model: params.model ?? DEFAULT_MODEL,
    temperature: params.temperature ?? 0.7,
    max_tokens: 600,
    messages: [
      {
        role: 'system',
        content:
          'You are an empathetic divination assistant. Respond ONLY with strict JSON. Do not include explanations or extra text.',
      },
      {
        role: 'user',
        content: buildInterpretationPrompt({
          technique: params.technique,
          locale: params.locale,
          question: params.question,
          results: params.results,
        }),
      },
    ],
  };

  log('info', 'Calling DeepSeek API', {
    sessionId: params.sessionId,
    url: DEEPSEEK_URL,
    model: params.model ?? DEFAULT_MODEL,
  });

  const response = await fetch(DEEPSEEK_URL, {
    method: 'POST',
    headers: {
      'content-type': 'application/json',
      authorization: `Bearer ${apiKey}`,
    },
    body: JSON.stringify(requestBody),
  });

  log('info', 'DeepSeek API response', {
    sessionId: params.sessionId,
    status: response.status,
    ok: response.ok,
  });

  if (!response.ok) {
    const errorText = await response.text().catch(() => '');
    log('error', 'DeepSeek request failed', {
      sessionId: params.sessionId,
      status: response.status,
      errorText,
    });
    throw new Error(`DeepSeek request failed (${response.status}): ${errorText}`);
  }

  const payload = (await response.json()) as DeepSeekResponse;
  const content: unknown = payload?.choices?.[0]?.message?.content;
  if (typeof content !== 'string' || content.trim().length === 0) {
    throw new Error('DeepSeek response was empty.');
  }

  try {
    const parsed = JSON.parse(content) as Record<string, unknown>;
    const interpretationValue = parsed['interpretation'];
    const summaryValue = parsed['summary'];
    const keywordsValue = parsed['keywords'];

    const interpretation =
      typeof interpretationValue === 'string' ? interpretationValue : content.trim();
    const summary = typeof summaryValue === 'string' ? summaryValue : undefined;
    const keywords = Array.isArray(keywordsValue)
      ? (keywordsValue as unknown[])
          .filter((value): value is string => typeof value === 'string')
          .map((value) => value.trim())
          .filter((value) => value.length >= 2)
          .slice(0, 12)
      : [];

    return { interpretation, summary, keywords };
  } catch {
    return {
      interpretation: content.trim(),
      keywords: [],
    };
  }
}

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const startedAt = Date.now();
  const requestId = createRequestId();

  const corsConfig = { methods: 'POST,OPTIONS' } as const;
  applyCorsHeaders(res, corsConfig);
  applyStandardResponseHeaders(res);

  if (handleCorsPreflight(req, res, corsConfig)) {
    recordApiMetric(METRICS_PATH, 204, Date.now() - startedAt);
    return;
  }

  if (req.method !== 'POST') {
    res.setHeader('Allow', ALLOW_HEADER_VALUE);
    sendJsonError(res, 405, {
      code: 'METHOD_NOT_ALLOWED',
      message: 'Only POST method is allowed for chat/interpret',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);
    return;
  }

  let parsed: { data: InterpretationRequestBody; requestId: string; auth?: AuthContext };
  try {
    parsed = await parseApiRequest<InterpretationRequestBody>(req, interpretationRequestSchema, {
      requireUser: false,
    });
  } catch (error) {
    handleApiError(res, error, requestId, 400);
    recordApiMetric(METRICS_PATH, res.statusCode || 400, Date.now() - startedAt);
    return;
  }

  const { data: input, auth } = parsed;
  const authContext = auth;
  if (!authContext) {
    handleApiError(
      res,
      createApiError(
        'UNAUTHENTICATED',
        'Authentication required',
        401,
        { statusCode: 401 },
        requestId
      ),
      requestId,
      401
    );
    recordApiMetric(METRICS_PATH, 401, Date.now() - startedAt);
    return;
  }

  const authenticatedUserId = authContext.userId;
  const locale = input.locale ?? 'en';
  const technique = input.technique;
  const results = input.results ?? {};
  const question = input.question?.trim();

  let interpretation = input.interpretation?.trim();
  let summary = input.summary?.trim();
  const keywordSet = new Set<string>(extractKeywords(question));
  let generatedByModel = false;

  if (!interpretation || interpretation.length === 0) {
    try {
      const generated = await generateInterpretationFromDeepSeek({
        sessionId: input.sessionId,
        results,
        question,
        technique,
        locale,
        model: input.model,
        temperature: input.temperature,
      });
      if (generated) {
        interpretation = generated.interpretation.trim();
        if (generated.summary && generated.summary.trim().length > 0) {
          summary = generated.summary.trim();
        }
        generated.keywords.forEach((keyword) => keywordSet.add(keyword.toLowerCase()));
        generatedByModel = true;
      }
    } catch (error) {
      log('warn', 'DeepSeek interpretation failed', {
        requestId,
        sessionId: input.sessionId,
        error: error instanceof Error ? error.message : String(error),
      });
    }
  }

  if (!interpretation || interpretation.length === 0) {
    interpretation = 'Interpretation unavailable at this time.';
  }

  extractKeywords(interpretation).forEach((keyword) => keywordSet.add(keyword));
  const keywords = Array.from(keywordSet).slice(0, 12);

  if (!summary || summary.length === 0) {
    summary = deriveSummary(interpretation);
  }

  const supabaseAvailable = Boolean(
    process.env.SUPABASE_URL && process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  if (input.sessionId && supabaseAvailable) {
    try {
      const existingSession = await getSession(input.sessionId);
      if (!existingSession) {
        sendJsonError(res, 404, {
          code: 'SESSION_NOT_FOUND',
          message: 'Session not found or no longer available.',
          requestId,
        });
        recordApiMetric(METRICS_PATH, 404, Date.now() - startedAt);
        return;
      }
      if (existingSession.userId !== authenticatedUserId) {
        sendJsonError(res, 403, {
          code: 'FORBIDDEN',
          message: 'You are not allowed to update this session.',
          requestId,
        });
        recordApiMetric(METRICS_PATH, 403, Date.now() - startedAt);
        return;
      }
    } catch (error) {
      handleApiError(res, error, requestId, 500);
      recordApiMetric(METRICS_PATH, res.statusCode || 500, Date.now() - startedAt);
      return;
    }
  }

  let artifactStored = false;
  let messageStored = false;

  if (supabaseAvailable) {
    try {
      await createSessionArtifact({
        sessionId: input.sessionId,
        type: 'interpretation',
        source: 'assistant',
        payload: cleanMetadata({
          interpretation,
          summary,
          question,
          model: input.model ?? (generatedByModel ? DEFAULT_MODEL : undefined),
          technique,
          locale,
          generatedAt: new Date().toISOString(),
          keywords,
        }),
      });
      artifactStored = true;
    } catch (artifactError) {
      log('warn', 'Failed to persist interpretation artifact', {
        requestId,
        sessionId: input.sessionId,
        error: artifactError instanceof Error ? artifactError.message : String(artifactError),
      });
    }

    try {
      const metadata = cleanMetadata({
        technique,
        locale,
        model: input.model ?? (generatedByModel ? DEFAULT_MODEL : undefined),
        summary,
        question,
        keywords,
      });
      await createSessionMessage({
        sessionId: input.sessionId,
        sender: 'assistant',
        content: interpretation,
        metadata,
      });
      messageStored = true;
    } catch (messageError) {
      log('warn', 'Failed to persist interpretation message', {
        requestId,
        sessionId: input.sessionId,
        error: messageError instanceof Error ? messageError.message : String(messageError),
      });
    }
  } else {
    log('warn', 'Supabase credentials missing, skipping interpretation persistence', {
      requestId,
      sessionId: input.sessionId,
    });
  }

  const duration = Date.now() - startedAt;
  const response = createApiResponse(
    {
      sessionId: input.sessionId,
      interpretation,
      summary: summary ?? null,
      question: question ?? null,
      keywords,
      stored: artifactStored || messageStored,
      generated: generatedByModel,
    },
    { processingTimeMs: duration, requestId },
    requestId
  );

  res.status(200).json(response);
  recordApiMetric(METRICS_PATH, 200, duration);
}
