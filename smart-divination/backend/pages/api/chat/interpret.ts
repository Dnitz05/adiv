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
import { extractKeywords } from '../../../lib/utils/text';

const METRICS_PATH = '/api/chat/interpret';
const ALLOW_HEADER_VALUE = 'OPTIONS, POST';
// Use DeepSeek Chat with aggressive speed optimizations
// Note: deepseek-reasoner (R1) causes timeouts in production, so we force deepseek-chat
const envModel = process.env.DEEPSEEK_MODEL?.trim();
const DEFAULT_MODEL =
  envModel === 'deepseek-reasoner' ? 'deepseek-chat' : (envModel ?? 'deepseek-chat');
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
  debug?: {
    envApiKeyPresent: boolean;
    resolvedModel: string;
  };
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
  const questionText = question?.trim() ?? 'No specific question.';
  const spread = typeof results.spread === 'string' ? results.spread : 'unknown';
  const promptLines = [
    'JSON: {"interpretation": "markdown", "summary": "title <120 chars", "keywords": ["key1", "key2"]}',
    '',
    'Brief tarot insight (250-350 words):',
    'Write a flowing, narrative interpretation with clear structure.',
    'Start with a brief opening, describe each card naturally with **🃏 Card Name** in bold,',
    'then add two final sections with these exact titles:',
    '',
    '**Conclusión**: Synthesize the overall meaning (2-3 sentences)',
    '**Consejo**: Provide practical, actionable guidance (2-3 sentences)',
    '',
    'Style: mystical + practical.',
    `Lang: ${locale}`,
    `Q: ${questionText}`,
    `Spread: ${spread}`,
    '',
    formatResultsForPrompt(results, technique),
  ];
  return promptLines.join('\n');
}

async function generateInterpretationFromDeepSeek(
  params: DeepSeekParams
): Promise<GeneratedInterpretation | null> {
  // WORKAROUND: Vercel env vars contain trailing \n that corrupt values
  // See: docs/vercel-env-vars-issue-report.md
  const envApiKey = process.env.DEEPSEEK_API_KEY?.trim() || null;
  const apiKey = envApiKey;
  log('info', 'DeepSeek API key check', {
    sessionId: params.sessionId,
    hasApiKey: !!apiKey,
    keyLength: apiKey?.length ?? 0,
    rawLength: process.env.DEEPSEEK_API_KEY?.length ?? 0,
  });
  if (!apiKey) {
    log('warn', 'DeepSeek API key missing; skipping interpretation generation', {
      sessionId: params.sessionId,
    });
    return null;
  }

  const resolvedModel = params.model?.trim() ?? envModel ?? DEFAULT_MODEL;

  log('info', 'Calling DeepSeek API', {
    sessionId: params.sessionId,
    url: DEEPSEEK_URL,
    model: resolvedModel,
  });

  const requestBody = {
    model: resolvedModel,
    temperature: params.temperature ?? 0.8, // Higher temp = faster generation
    max_tokens: 1000, // Sufficient for complete interpretations
    messages: [
      {
        role: 'system',
        content: `You are a wise divination guide. Respond ONLY with strict JSON: {"interpretation":"markdown text","summary":"title","keywords":[]}. Use markdown: **bold** for section titles, *italic* for emphasis. Be concise but profound. IMPORTANT: Respond in the SAME LANGUAGE as the user's question. If the question language cannot be determined, respond in the locale language: ${params.locale}.`,
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
  const message = payload?.choices?.[0]?.message;

  // For deepseek-chat, content should be present
  // For deepseek-reasoner (R1), content contains the final answer
  // reasoning_content contains the Chain of Thought (internal reasoning)
  const content: unknown = message?.content;

  if (typeof content !== 'string' || content.trim().length === 0) {
    log('error', 'DeepSeek response has empty content', {
      sessionId: params.sessionId,
      hasMessage: !!message,
      hasContent: !!message?.content,
      hasReasoningContent: !!message?.reasoning_content,
      model: params.model ?? DEFAULT_MODEL,
    });
    throw new Error('DeepSeek response was empty.');
  }

  // Log if we received reasoning_content (for debugging)
  if (message?.reasoning_content) {
    log('info', 'DeepSeek R1 reasoning received', {
      sessionId: params.sessionId,
      reasoningLength: (message.reasoning_content as string).length,
    });
  }

  log('info', 'DeepSeek raw content', {
    sessionId: params.sessionId,
    contentLength: content.length,
    contentPreview: content.substring(0, 200),
  });

  // Clean up markdown code blocks if present
  let cleanedContent = content.trim();
  if (cleanedContent.startsWith('```json')) {
    cleanedContent = cleanedContent.substring('```json'.length);
  } else if (cleanedContent.startsWith('```')) {
    cleanedContent = cleanedContent.substring('```'.length);
  }
  if (cleanedContent.endsWith('```')) {
    cleanedContent = cleanedContent.substring(0, cleanedContent.length - '```'.length);
  }
  cleanedContent = cleanedContent.trim();

  log('info', 'Cleaned content', {
    sessionId: params.sessionId,
    cleanedLength: cleanedContent.length,
    cleanedPreview: cleanedContent.substring(0, 200),
  });

  try {
    const parsed = JSON.parse(cleanedContent) as Record<string, unknown>;
    const interpretationValue = parsed['interpretation'];
    const summaryValue = parsed['summary'];
    const keywordsValue = parsed['keywords'];

    log('info', 'Parsed DeepSeek response', {
      sessionId: params.sessionId,
      interpretationType: typeof interpretationValue,
      interpretationPreview:
        typeof interpretationValue === 'string'
          ? interpretationValue.substring(0, 100)
          : 'not a string',
    });

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

    return {
      interpretation,
      summary,
      keywords,
      debug: { envApiKeyPresent: Boolean(envApiKey), resolvedModel },
    };
  } catch {
    return {
      interpretation: cleanedContent,
      keywords: [],
      debug: { envApiKeyPresent: Boolean(envApiKey), resolvedModel },
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

  // Use userId from request (supports both authenticated and anonymous users)
  const authenticatedUserId = input.userId ?? authContext?.userId;

  if (!authenticatedUserId) {
    handleApiError(
      res,
      createApiError('UNAUTHENTICATED', 'User ID required', 401, { statusCode: 401 }, requestId),
      requestId,
      401
    );
    recordApiMetric(METRICS_PATH, 401, Date.now() - startedAt);
    return;
  }
  const locale = input.locale ?? 'en';
  const technique = input.technique;
  const results = input.results ?? {};
  const question = input.question?.trim();

  const debugHeader = req.headers['x-debug'];
  const debugMode = Array.isArray(debugHeader)
    ? debugHeader.some((value) => value === '1' || value === 'true')
    : debugHeader === '1' || debugHeader === 'true';

  let interpretation = input.interpretation?.trim();
  let summary = input.summary?.trim();
  const keywordSet = new Set<string>(extractKeywords(question, 12));
  let generatedByModel = false;
  let deepSeekDebug: GeneratedInterpretation['debug'] | undefined;
  let generationError: string | undefined;

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
        deepSeekDebug = generated.debug;
      }
    } catch (error) {
      generationError = error instanceof Error ? error.message : String(error);
      log('warn', 'DeepSeek interpretation failed', {
        requestId,
        sessionId: input.sessionId,
        error: generationError,
      });
    }
  }

  if (!interpretation || interpretation.length === 0) {
    interpretation = 'Interpretation unavailable at this time.';
  }

  extractKeywords(interpretation, 12).forEach((keyword) => keywordSet.add(keyword));
  const keywords = Array.from(keywordSet).slice(0, 12);

  if (!summary || summary.length === 0) {
    summary = deriveSummary(interpretation);
  }

  const supabaseAvailable = Boolean(
    process.env.SUPABASE_URL && process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  // Skip session validation for anonymous users (they don't have database sessions)
  const isAnonymous = authenticatedUserId?.startsWith('anon_') ?? false;

  if (input.sessionId && supabaseAvailable && !isAnonymous) {
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

  // Skip database storage for anonymous users
  if (supabaseAvailable && !isAnonymous) {
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
  } else if (isAnonymous) {
    log('info', 'Skipping interpretation persistence for anonymous user', {
      requestId,
      sessionId: input.sessionId,
      userId: authenticatedUserId,
    });
  } else {
    log('warn', 'Supabase credentials missing, skipping interpretation persistence', {
      requestId,
      sessionId: input.sessionId,
    });
  }

  const duration = Date.now() - startedAt;
  const envKey = process.env.DEEPSEEK_API_KEY;
  const trimmedEnvKey = envKey?.trim();
  const debugPayload = debugMode
    ? {
        debug: {
          generationError: generationError ?? null,
          envApiKeyPresent: deepSeekDebug?.envApiKeyPresent ?? Boolean(trimmedEnvKey),
          resolvedModel: deepSeekDebug?.resolvedModel ?? envModel ?? DEFAULT_MODEL,
          hasEnvApiKey: Boolean(trimmedEnvKey),
          envKeyPrefix: trimmedEnvKey ? trimmedEnvKey.slice(0, 8) : null,
          envKeyLength: envKey?.length ?? 0,
        },
      }
    : {};
  const response = createApiResponse(
    {
      sessionId: input.sessionId,
      interpretation,
      summary: summary ?? null,
      question: question ?? null,
      keywords,
      stored: artifactStored || messageStored,
      generated: generatedByModel,
      ...debugPayload,
    },
    { processingTimeMs: duration, requestId },
    requestId
  );

  res.status(200).json(response);
  recordApiMetric(METRICS_PATH, 200, duration);
}
