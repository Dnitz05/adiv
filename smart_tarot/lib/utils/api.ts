/**
 * API Utilities - Ultra-Professional Backend Utilities
 * 
 * Core utilities for request/response handling, validation, error management,
 * and performance optimization across the Vercel + Supabase stack.
 */

import { NextRequest, NextResponse } from 'next/server';
import { nanoid } from 'nanoid';
import { z } from 'zod';
import type {
  ApiRequest,
  ApiResponse,
  ApiError,
  ResponseMetadata,
  HttpStatusCode,
  LogLevel,
  DivinationTechnique,
} from '../types/api';

// =============================================================================
// REQUEST HANDLING
// =============================================================================

/**
 * Parse and validate API request
 */
export async function parseApiRequest<T extends ApiRequest>(
  req: NextRequest,
  schema?: z.ZodSchema<T>
): Promise<{ data: T; requestId: string }> {
  const requestId = req.headers.get('x-request-id') || nanoid();
  
  try {
    let body: any = {};
    
    // Parse request body based on content type
    const contentType = req.headers.get('content-type') || '';
    
    if (contentType.includes('application/json')) {
      const text = await req.text();
      body = text ? JSON.parse(text) : {};
    } else if (contentType.includes('application/x-www-form-urlencoded')) {
      const formData = await req.formData();
      body = Object.fromEntries(formData.entries());
    }
    
    // Merge with query parameters
    const url = new URL(req.url);
    const queryParams = Object.fromEntries(url.searchParams.entries());
    
    // Create base request object
    const baseRequest: ApiRequest = {
      timestamp: new Date().toISOString(),
      requestId,
      userId: req.headers.get('x-user-id') || undefined,
      locale: req.headers.get('x-locale') || 'en',
      ...queryParams,
      ...body,
    };
    
    // Validate if schema provided
    const data = schema ? schema.parse(baseRequest) : (baseRequest as T);
    
    return { data, requestId };
  } catch (error) {
    throw createApiError(
      'INVALID_REQUEST',
      'Failed to parse request',
      400,
      { originalError: error instanceof Error ? error.message : String(error) }
    );
  }
}

/**
 * Create standardized API response
 */
export function createApiResponse<T>(
  data?: T,
  meta?: Partial<ResponseMetadata>,
  requestId?: string
): ApiResponse<T> {
  const timestamp = new Date().toISOString();
  
  const metadata: ResponseMetadata = {
    processingTimeMs: 0, // Will be set by middleware
    timestamp,
    version: '1.0.0',
    ...meta,
  };
  
  return {
    success: true,
    data,
    meta: metadata,
  };
}

/**
 * Create standardized API error response
 */
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

/**
 * Send API response with proper status code
 */
export function sendApiResponse<T>(
  response: ApiResponse<T> | ApiError,
  statusCode: HttpStatusCode = 200
): NextResponse {
  const isError = 'code' in response;
  
  if (isError) {
    return NextResponse.json(
      {
        success: false,
        error: response,
      },
      { status: statusCode }
    );
  }
  
  return NextResponse.json(response, { status: statusCode });
}

// =============================================================================
// VALIDATION SCHEMAS
// =============================================================================

/** Base API request schema */
export const baseRequestSchema = z.object({
  timestamp: z.string().datetime(),
  requestId: z.string().optional(),
  userId: z.string().optional(),
  locale: z.enum(['en', 'es', 'ca']).default('en'),
});

/** Divination technique validation */
export const divinationTechniqueSchema = z.enum(['tarot', 'iching', 'runes']);

/** Draw cards request schema */
export const drawCardsRequestSchema = baseRequestSchema.extend({
  technique: z.literal('tarot'),
  count: z.number().int().min(1).max(10),
  spread: z.string().optional(),
  allowReversed: z.boolean().default(true),
  seed: z.string().min(8).optional(),
  question: z.string().optional(),
});

/** Toss coins request schema */
export const tossCoinsRequestSchema = baseRequestSchema.extend({
  technique: z.literal('iching'),
  method: z.enum(['coins', 'yarrow']).default('coins'),
  seed: z.string().min(8).optional(),
  question: z.string().optional(),
});

/** Draw runes request schema */
export const drawRunesRequestSchema = baseRequestSchema.extend({
  technique: z.literal('runes'),
  count: z.number().int().min(1).max(5),
  allowReversed: z.boolean().default(true),
  runeSet: z.enum(['elder_futhark']).default('elder_futhark'),
  seed: z.string().min(8).optional(),
  question: z.string().optional(),
});

/** Interpretation request schema */
export const interpretationRequestSchema = baseRequestSchema.extend({
  technique: divinationTechniqueSchema,
  results: z.record(z.any()),
  question: z.string().optional(),
  context: z.string().optional(),
});

// =============================================================================
// ERROR HANDLING
// =============================================================================

/**
 * Centralized error handler for API endpoints
 */
export function handleApiError(error: unknown, requestId?: string): NextResponse {
  let apiError: ApiError;
  let statusCode: HttpStatusCode = 500;
  
  if (error instanceof z.ZodError) {
    // Validation error
    apiError = createApiError(
      'VALIDATION_ERROR',
      'Request validation failed',
      400,
      { 
        issues: error.issues.map(issue => ({
          path: issue.path.join('.'),
          message: issue.message,
          code: issue.code,
        }))
      },
      requestId
    );
    statusCode = 400;
  } else if (error instanceof Error) {
    // Generic error
    const message = error.message;
    
    if (message.includes('rate limit')) {
      statusCode = 429;
      apiError = createApiError('RATE_LIMIT_EXCEEDED', message, statusCode, undefined, requestId);
    } else if (message.includes('unauthorized')) {
      statusCode = 401;
      apiError = createApiError('UNAUTHORIZED', message, statusCode, undefined, requestId);
    } else if (message.includes('forbidden')) {
      statusCode = 403;
      apiError = createApiError('FORBIDDEN', message, statusCode, undefined, requestId);
    } else if (message.includes('not found')) {
      statusCode = 404;
      apiError = createApiError('NOT_FOUND', message, statusCode, undefined, requestId);
    } else {
      apiError = createApiError('INTERNAL_ERROR', message, statusCode, undefined, requestId);
    }
  } else {
    // Unknown error
    apiError = createApiError(
      'UNKNOWN_ERROR',
      'An unexpected error occurred',
      500,
      { originalError: String(error) },
      requestId
    );
  }
  
  // Log error
  logError(apiError, statusCode);
  
  return sendApiResponse(apiError, statusCode);
}

// =============================================================================
// LOGGING
// =============================================================================

/**
 * Structured logging utility
 */
export function log(level: LogLevel, message: string, data?: Record<string, any>): void {
  const timestamp = new Date().toISOString();
  const logEntry = {
    timestamp,
    level,
    message,
    ...data,
  };
  
  // Use appropriate console method based on level
  switch (level) {
    case 'debug':
      console.debug(JSON.stringify(logEntry));
      break;
    case 'info':
      console.info(JSON.stringify(logEntry));
      break;
    case 'warn':
      console.warn(JSON.stringify(logEntry));
      break;
    case 'error':
    case 'fatal':
      console.error(JSON.stringify(logEntry));
      break;
  }
}

/**
 * Log API request
 */
export function logRequest(req: NextRequest, requestId: string): void {
  log('info', 'API Request', {
    requestId,
    method: req.method,
    url: req.url,
    userAgent: req.headers.get('user-agent'),
    ip: req.headers.get('x-forwarded-for') || req.ip,
    technique: req.headers.get('x-technique'),
  });
}

/**
 * Log API response
 */
export function logResponse(
  statusCode: number,
  processingTimeMs: number,
  requestId: string
): void {
  log('info', 'API Response', {
    requestId,
    statusCode,
    processingTimeMs,
  });
}

/**
 * Log error with context
 */
export function logError(error: ApiError, statusCode: number): void {
  log('error', 'API Error', {
    requestId: error.requestId,
    code: error.code,
    message: error.message,
    statusCode,
    details: error.details,
  });
}

// =============================================================================
// PERFORMANCE & CACHING
// =============================================================================

/**
 * Create cache key for request
 */
export function createCacheKey(
  technique: DivinationTechnique,
  params: Record<string, any>
): string {
  // Sort parameters for consistent keys
  const sortedParams = Object.keys(params)
    .sort()
    .reduce((obj, key) => {
      obj[key] = params[key];
      return obj;
    }, {} as Record<string, any>);
  
  const paramsString = JSON.stringify(sortedParams);
  return `${technique}:${Buffer.from(paramsString).toString('base64')}`;
}

/**
 * Performance monitoring middleware
 */
export function withPerformanceMonitoring<T extends (...args: any[]) => Promise<any>>(
  fn: T,
  operationName: string
): T {
  return (async (...args: any[]) => {
    const startTime = Date.now();
    
    try {
      const result = await fn(...args);
      const duration = Date.now() - startTime;
      
      log('info', 'Operation completed', {
        operation: operationName,
        duration,
        success: true,
      });
      
      return result;
    } catch (error) {
      const duration = Date.now() - startTime;
      
      log('error', 'Operation failed', {
        operation: operationName,
        duration,
        error: error instanceof Error ? error.message : String(error),
        success: false,
      });
      
      throw error;
    }
  }) as T;
}

// =============================================================================
// RATE LIMITING
// =============================================================================

interface RateLimitConfig {
  windowMs: number;
  maxRequests: number;
  skipSuccessfulRequests?: boolean;
  skipFailedRequests?: boolean;
}

const rateLimitStore = new Map<string, { requests: number; resetTime: number }>();

/**
 * Simple in-memory rate limiting
 */
export function checkRateLimit(
  identifier: string,
  config: RateLimitConfig
): { allowed: boolean; remaining: number; resetTime: number } {
  const now = Date.now();
  const key = identifier;
  
  // Clean up expired entries
  for (const [k, v] of rateLimitStore.entries()) {
    if (v.resetTime <= now) {
      rateLimitStore.delete(k);
    }
  }
  
  const current = rateLimitStore.get(key);
  
  if (!current || current.resetTime <= now) {
    // New window
    const resetTime = now + config.windowMs;
    rateLimitStore.set(key, { requests: 1, resetTime });
    return { 
      allowed: true, 
      remaining: config.maxRequests - 1, 
      resetTime 
    };
  }
  
  if (current.requests >= config.maxRequests) {
    // Rate limit exceeded
    return { 
      allowed: false, 
      remaining: 0, 
      resetTime: current.resetTime 
    };
  }
  
  // Increment counter
  current.requests++;
  return { 
    allowed: true, 
    remaining: config.maxRequests - current.requests, 
    resetTime: current.resetTime 
  };
}

// =============================================================================
// SECURITY
// =============================================================================

/**
 * Validate request origin
 */
export function validateOrigin(req: NextRequest): boolean {
  const origin = req.headers.get('origin');
  const host = req.headers.get('host');
  
  // Allow same-origin requests
  if (origin && host) {
    const originUrl = new URL(origin);
    return originUrl.host === host;
  }
  
  // Allow requests without origin (mobile apps)
  return !origin;
}

/**
 * Sanitize user input
 */
export function sanitizeInput(input: string): string {
  return input
    .trim()
    .replace(/[<>]/g, '') // Remove potential HTML
    .substring(0, 1000); // Limit length
}

/**
 * Generate secure random seed
 */
export function generateSecureSeed(length: number = 32): string {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let result = '';
  
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  
  return result;
}

// =============================================================================
// RESPONSE HELPERS
// =============================================================================

/**
 * Handle CORS preflight requests
 */
export function handleCors(req: NextRequest): NextResponse | null {
  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    return new NextResponse(null, {
      status: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 
          'Content-Type, Authorization, X-Requested-With, X-Request-ID, X-Technique, X-User-ID, X-Locale',
        'Access-Control-Max-Age': '86400',
      },
    });
  }
  
  return null;
}

/**
 * Add standard headers to response
 */
export function addStandardHeaders(response: NextResponse): void {
  response.headers.set('X-Content-Type-Options', 'nosniff');
  response.headers.set('X-Frame-Options', 'DENY');
  response.headers.set('X-XSS-Protection', '1; mode=block');
  response.headers.set('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
  response.headers.set('Referrer-Policy', 'strict-origin-when-cross-origin');
}

// =============================================================================
// TYPE UTILITIES
// =============================================================================

/**
 * Check if request is for a specific technique
 */
export function isTechniqueRequest(
  req: NextRequest, 
  technique: DivinationTechnique
): boolean {
  const pathTechnique = req.nextUrl.pathname.includes(`/${technique}`);
  const headerTechnique = req.headers.get('x-technique') === technique;
  
  return pathTechnique || headerTechnique;
}

/**
 * Extract technique from request
 */
export function extractTechnique(req: NextRequest): DivinationTechnique | null {
  // Try header first
  const headerTechnique = req.headers.get('x-technique');
  if (headerTechnique && ['tarot', 'iching', 'runes'].includes(headerTechnique)) {
    return headerTechnique as DivinationTechnique;
  }
  
  // Try URL path
  const path = req.nextUrl.pathname;
  if (path.includes('/tarot') || path.includes('/cards')) return 'tarot';
  if (path.includes('/iching') || path.includes('/coins')) return 'iching';
  if (path.includes('/runes')) return 'runes';
  
  return null;
}