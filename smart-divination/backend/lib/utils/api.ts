/**
 * API Utilities - Ultra-Professional Backend Utilities
 *
 * Provides consistent request parsing, error handling, logging and ancillary
 * helpers for the canonical Next.js (Node runtime) backend.
 */

import type { NextApiRequest, NextApiResponse } from 'next';
import { randomUUID } from 'crypto';
import { z, ZodError } from 'zod';
import type { User } from '@supabase/supabase-js';
import type {
  ApiRequest,
  ApiResponse,
  ApiError,
  ResponseMetadata,
  HttpStatusCode,
  DivinationTechnique,
} from '../types/api';
import { isApiError } from '../types/api';
import { log, logDebug, logError, logInfo, logWarn } from './logger';
import { ensureUserRecord, getSupabaseServiceClient, getUserTier } from './supabase';
import { resolveErrorDefinition, type KnownErrorCode } from './errors';

// Re-export logging functions
export { log, logDebug, logError, logInfo, logWarn };
export type { KnownErrorCode } from './errors';

export const API_VERSION = '1.0.0';

export interface AuthContext {
  userId: string;
  user: User;
  token: string;
  tier: 'free' | 'premium' | 'premium_annual';
}

interface ParseApiRequestOptions {
  requireUser?: boolean;
}

const AUTH_CONTEXT_KEY = '__smart_divination_auth__';

export function createRequestId(): string {
  try {
    return randomUUID().replace(/-/g, '');
  } catch {
    return `${Date.now()}_${Math.random().toString(36).slice(2, 10)}`;
  }
}

export async function parseApiRequest<T extends ApiRequest>(
  req: NextApiRequest,
  schema?: z.ZodSchema<any>,
  options: ParseApiRequestOptions = {}
): Promise<{ data: T; requestId: string; auth?: AuthContext }> {
  const requestId = normaliseHeader(req.headers['x-request-id']) || createRequestId();
  const auth = await resolveAuthContext(req, {
    requireUser: options.requireUser ?? false,
    requestId,
  });

  try {
    const body = normaliseBody(req.body);
    const queryParams = Object.fromEntries(
      Object.entries(req.query).map(([key, value]) => [key, normaliseQueryValue(value)])
    );

    const normalisedBody = normaliseLegacyKeys(body);
    const normalisedQuery = normaliseLegacyKeys(queryParams);

    const baseRequest: ApiRequest = {
      timestamp: new Date().toISOString(),
      requestId,
      userId: auth?.userId ?? normaliseHeader(req.headers['x-user-id']),
      locale: normaliseHeader(req.headers['x-locale']) || 'en',
      ...normalisedQuery,
      ...normalisedBody,
    };

    const data = schema ? (schema.parse(baseRequest) as T) : (baseRequest as T);

    if (options.requireUser && !data.userId) {
      throw createApiError(
        'UNAUTHENTICATED',
        'Authentication required',
        401,
        { statusCode: 401 },
        requestId
      );
    }

    return { data, requestId, auth };
  } catch (error) {
    if (isApiError(error)) {
      throw error;
    }
    throw createApiError(
      'INVALID_REQUEST',
      'Failed to parse request',
      400,
      { originalError: error instanceof Error ? error.message : String(error) },
      requestId
    );
  }
}

export async function resolveAuthContext(
  req: NextApiRequest,
  options: { requireUser: boolean; requestId: string }
): Promise<AuthContext | null> {
  const cached = getCachedAuthContext(req);
  if (cached !== undefined) {
    return cached;
  }

  const authHeader = normaliseHeader(req.headers['authorization']);
  const fallbackHeader = normaliseHeader(req.headers['x-supabase-auth']);
  const token = extractAuthToken(authHeader, fallbackHeader);

  if (!token) {
    if (options.requireUser) {
      throw createApiError(
        'UNAUTHENTICATED',
        'Authentication required',
        401,
        { statusCode: 401 },
        options.requestId
      );
    }
    cacheAuthContext(req, null);
    return null;
  }

  try {
    const client = getSupabaseServiceClient();
    const { data, error } = await client.auth.getUser(token);
    if (error || !data?.user) {
      logWarn('Supabase token validation failed', {
        error: error?.message ?? 'user_not_found',
        requestId: options.requestId,
      });
      throw createApiError(
        'UNAUTHENTICATED',
        'Authentication token is invalid',
        401,
        { statusCode: 401 },
        options.requestId
      );
    }

    await ensureUserRecord(data.user);
    const tier = (await getUserTier(data.user.id)) ?? 'free';

    const context: AuthContext = {
      userId: data.user.id,
      user: data.user,
      token,
      tier,
    };
    cacheAuthContext(req, context);
    return context;
  } catch (error) {
    if (isApiError(error)) {
      throw error;
    }
    logWarn('resolveAuthContext failed', {
      error: error instanceof Error ? error.message : String(error),
      requestId: options.requestId,
    });
    throw createApiError(
      'UNAUTHENTICATED',
      'Failed to validate authentication token',
      401,
      { statusCode: 401 },
      options.requestId
    );
  }
}

function extractAuthToken(
  authHeader?: string | null,
  fallbackHeader?: string | null
): string | null {
  const bearer = authHeader ? parseBearerToken(authHeader) : null;
  if (bearer) {
    return bearer;
  }
  if (fallbackHeader) {
    const trimmed = fallbackHeader.trim();
    return trimmed.length > 0 ? trimmed : null;
  }
  return null;
}

function parseBearerToken(value?: string | null): string | null {
  if (!value) {
    return null;
  }
  const match = /^Bearer\s+(.+)$/i.exec(value.trim());
  if (!match) {
    return null;
  }
  const token = match[1].trim();
  return token.length > 0 ? token : null;
}

function getCachedAuthContext(req: NextApiRequest): AuthContext | null | undefined {
  return (req as unknown as Record<string, unknown>)[AUTH_CONTEXT_KEY] as AuthContext | null | undefined;
}

function cacheAuthContext(req: NextApiRequest, context: AuthContext | null): void {
  (req as unknown as Record<string, unknown>)[AUTH_CONTEXT_KEY] = context;
}

export function createErrorFromCode(
  code: KnownErrorCode,
  options?: {
    message?: string;
    statusCode?: HttpStatusCode;
    details?: Record<string, any>;
    requestId?: string;
  }
): ApiError {
  return createApiError(code, options?.message, options?.statusCode, options?.details, options?.requestId);
}export function createApiResponse<T = any>(
  data?: T,
  meta?: Partial<ResponseMetadata>,
  requestId?: string
): ApiResponse<T> {
  const timestamp = new Date().toISOString();
  return {
    success: true,
    data,
    meta: {
      processingTimeMs: meta?.processingTimeMs ?? 0,
      timestamp,
      version: meta?.version ?? API_VERSION,
      requestId,
      rateLimit: meta?.rateLimit,
      cache: meta?.cache,
    },
  };
}

export function createApiError(
  code: string,
  message: string,
  statusCode: HttpStatusCode = 500,
  details?: Record<string, any>,
  requestId?: string
): ApiError {
  return {
    code,
    message,
    details,
    timestamp: new Date().toISOString(),
    requestId,
  };
}

export function sendApiResponse<T>(
  res: NextApiResponse,
  payload: ApiResponse<T>,
  statusCode: HttpStatusCode = 200
): void {
  res.status(statusCode).json(payload);
}

export function sendApiError(
  res: NextApiResponse,
  error: ApiError,
  statusCode: HttpStatusCode
): void {
  res.status(statusCode).json({ success: false, error });
}

export function handleApiError(
  res: NextApiResponse,
  error: unknown,
  requestId?: string,
  defaultStatus: HttpStatusCode = 500
): void {
  if (error instanceof ZodError) {
    const apiError = createApiError(
      'VALIDATION_ERROR',
      'Invalid request payload',
      400,
      { issues: error.issues },
      requestId
    );
    logError(apiError, 400);
    sendApiError(res, apiError, 400);
    return;
  }

  if (isApiError(error)) {
    const definition = resolveErrorDefinition(error.code);
    const status = clampStatusCode(definition?.status ?? defaultStatus);
    logError(error, status);
    sendApiError(res, error, status);
    return;
  }

  if (error instanceof Error) {
    const apiError = createApiError(
      'INTERNAL_ERROR',
      error.message,
      defaultStatus,
      undefined,
      requestId
    );
    const status = clampStatusCode(defaultStatus);
    logError(apiError, status);
    sendApiError(res, apiError, status);
    return;
  }

  const fallback = createApiError(
    'INTERNAL_ERROR',
    'Unexpected error occurred',
    defaultStatus,
    undefined,
    requestId
  );
  const status = clampStatusCode(defaultStatus);
  logError(fallback, status);
  sendApiError(res, fallback, status);
}



export function sanitizeInput(input: string): string {
  return input.trim().replace(/[<>]/g, '').slice(0, 1000);
}

export function generateSecureSeed(length = 32): string {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let result = '';
  for (let i = 0; i < length; i += 1) {
    result += characters.charAt(Math.floor(Math.random() * characters.length));
  }
  return result;
}

export function isTechniqueRequest(req: NextApiRequest, technique: DivinationTechnique): boolean {
  const path = req.url ?? '';
  const headerTechnique = normaliseHeader(req.headers['x-technique']);
  return path.includes(`/${technique}`) || headerTechnique === technique;
}

export function extractTechnique(req: NextApiRequest): DivinationTechnique | null {
  const headerTechnique = normaliseHeader(req.headers['x-technique']);
  if (headerTechnique && ['tarot', 'iching', 'runes'].includes(headerTechnique)) {
    return headerTechnique as DivinationTechnique;
  }

  const path = req.url ?? '';
  if (path.includes('/tarot') || path.includes('/cards')) return 'tarot';
  if (path.includes('/iching') || path.includes('/coins')) return 'iching';
  if (path.includes('/runes')) return 'runes';
  return null;
}

export const baseRequestSchema = z.object({
  timestamp: z.string().datetime(),
  requestId: z.string().optional(),
  userId: z.string().optional(),
  locale: z.string().min(2).default('en'),
});

export const divinationTechniqueSchema = z.enum(['tarot', 'iching', 'runes']);

export const drawCardsRequestSchema = baseRequestSchema.extend({
  technique: z.literal('tarot').default('tarot'),
  count: z.number().int().min(1).max(10),
  spread: z.string().optional(),
  allowReversed: z.boolean().default(true),
  seed: z.string().min(1).optional(),
  question: z.string().optional(),
});

export const tossCoinsRequestSchema = baseRequestSchema.extend({
  technique: z.literal('iching').default('iching'),
  method: z.enum(['coins', 'yarrow']).default('coins'),
  seed: z.string().min(1).optional(),
  question: z.string().optional(),
});

export const drawRunesRequestSchema = baseRequestSchema.extend({
  technique: z.literal('runes').default('runes'),
  count: z.number().int().min(1).max(5),
  allowReversed: z.boolean().default(true),
  runeSet: z.enum(['elder_futhark']).default('elder_futhark'),
  seed: z.string().min(1).optional(),
  question: z.string().optional(),
});

export const interpretationRequestSchema = baseRequestSchema.extend({
  technique: divinationTechniqueSchema,
  results: z.record(z.any()),
  question: z.string().optional(),
  context: z.string().optional(),
});

const ALLOWED_STATUSES: HttpStatusCode[] = [200, 201, 400, 401, 403, 404, 409, 429, 500, 502, 503];

function clampStatusCode(status: number): HttpStatusCode {
  return (ALLOWED_STATUSES.includes(status as HttpStatusCode) ? status : 500) as HttpStatusCode;
}

function normaliseLegacyKeys(source: Record<string, any>): Record<string, any> {
  if (!source || typeof source !== 'object' || Array.isArray(source)) {
    return source;
  }

  const result: Record<string, any> = { ...source };

  if ('allow_reversed' in result && !('allowReversed' in result)) {
    const coerced = coerceBoolean(result.allow_reversed);
    if (coerced !== undefined) {
      result.allowReversed = coerced;
    } else if (typeof result.allow_reversed === 'boolean') {
      result.allowReversed = result.allow_reversed;
    }
    delete result.allow_reversed;
  }

  if ('allowReversed' in result) {
    const coerced = coerceBoolean(result.allowReversed);
    if (coerced !== undefined) {
      result.allowReversed = coerced;
    }
  }

  return result;
}

function coerceBoolean(value: any): boolean | undefined {
  if (typeof value === 'boolean') {
    return value;
  }
  if (typeof value === 'string') {
    const normalised = value.trim().toLowerCase();
    if (['true', '1', 'yes', 'on'].includes(normalised)) {
      return true;
    }
    if (['false', '0', 'no', 'off'].includes(normalised)) {
      return false;
    }
  }
  return undefined;
}

function normaliseBody(body: any): Record<string, any> {
  if (!body) return {};

  if (typeof body === 'string') {
    return body.length ? JSON.parse(body) : {};
  }

  if (Buffer.isBuffer(body)) {
    return body.length ? JSON.parse(body.toString('utf-8')) : {};
  }

  if (typeof body === 'object') {
    return body as Record<string, any>;
  }

  return {};
}

function normaliseHeader(value: string | string[] | undefined): string | undefined {
  if (Array.isArray(value)) {
    return value[0];
  }
  if (typeof value === 'string') {
    return value;
  }
  return undefined;
}

function normaliseQueryValue(value: string | string[] | undefined): string | undefined {
  if (Array.isArray(value)) {
    return value[0];
  }
  if (typeof value === 'string') {
    return value;
  }
  return undefined;
}




