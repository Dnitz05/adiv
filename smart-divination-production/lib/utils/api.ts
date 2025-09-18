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
export async function parseApiRequest(
  req: NextRequest,
  schema?: z.ZodTypeAny
): Promise<{ data: any; requestId: string }> {
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
      body = {};
      formData.forEach((value, key) => {
        body[key] = value;
      });
    }
    
    // Merge with query parameters
    const url = new URL(req.url);
    const queryParams = Object.fromEntries(url.searchParams.entries());
    
    // Create base request object (allow additional fields from body/query)
    const baseRequest: any = {
      timestamp: new Date().toISOString(),
      requestId,
      userId: req.headers['x-user-id'] || undefined,
      locale: req.headers['x-locale'] || 'en',
      ...queryParams,
      ...body,
    };
    
    // Validate if schema provided
    const data = schema ? schema.parse(baseRequest) : baseRequest;
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
    // Unknown error - better error serialization
    const errorDetails: any = { originalError: 'Unknown error' };
    
    if (error && typeof error === 'object') {
      try {
        errorDetails.originalError = JSON.stringify(error);
      } catch {
        errorDetails.originalError = error.toString();
      }
      
      if ('message' in error) {
        errorDetails.errorMessage = (error as any).message;
      }
      if ('stack' in error) {
        errorDetails.errorStack = (error as any).stack;
      }
    } else {
      errorDetails.originalError = String(error);
    }
    
    apiError = createApiError(
      'UNKNOWN_ERROR',
      'An unexpected error occurred',
      500,
      errorDetails,
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
  
  // Safe JSON stringify to avoid circular reference errors
  let logString: string;
  try {
    logString = JSON.stringify(logEntry, (key, value) => {
      // Handle circular references and complex objects
      if (value instanceof Error) {
        return {
          name: value.name,
          message: value.message,
          stack: value.stack
        };
      }
      return value;
    });
  } catch (error) {
    // Fallback for complex objects that can't be stringified
    logString = JSON.stringify({
      timestamp: new Date().toISOString(),
      level,
      message,
      error: 'Failed to stringify log data'
    });
  }
  
  // Use appropriate console method based on level
  switch (level) {
    case 'debug':
      console.debug(logString);
      break;
    case 'info':
      console.info(logString);
      break;
    case 'warn':
      console.warn(logString);
      break;
    case 'error':
    case 'fatal':
      console.error(logString);
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
    userAgent: req.headers['user-agent'],
    ip: req.headers['x-forwarded-for'] || req.headers['x-real-ip'] || 'unknown',
    technique: req.headers['x-technique'],
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

// In-memory fallback for development/edge cases
const rateLimitStore = new Map<string, { requests: number; resetTime: number }>();

/**
 * Serverless-persistent rate limiting with Supabase backend
 */
export async function checkRateLimitPersistent(
  identifier: string,
  config: RateLimitConfig
): Promise<{ allowed: boolean; remaining: number; resetTime: number }> {
  const now = Date.now();
  const windowStart = Math.floor(now / config.windowMs) * config.windowMs;
  const resetTime = windowStart + config.windowMs;
  const key = `rate_limit:${identifier}:${windowStart}`;
  
  try {
    // Try to use persistent storage (Supabase)
    const { getSupabaseServiceClient } = await import('./supabase');
    const supabase = getSupabaseServiceClient();
    
    // Create/get rate limit record
    const { data: existing, error: selectError } = await supabase
      .from('rate_limits')
      .select('requests')
      .eq('key', key)
      .single();
    
    if (selectError && selectError.code !== 'PGRST116') {
      // Database error, fallback to in-memory
      return checkRateLimitInMemory(identifier, config);
    }
    
    const currentRequests = existing?.requests || 0;
    
    if (currentRequests >= config.maxRequests) {
      return {
        allowed: false,
        remaining: 0,
        resetTime
      };
    }
    
    // Increment counter
    const newRequests = currentRequests + 1;
    
    if (existing) {
      // Update existing record
      await supabase
        .from('rate_limits')
        .update({ 
          requests: newRequests,
          updated_at: new Date().toISOString()
        })
        .eq('key', key);
    } else {
      // Create new record
      await supabase
        .from('rate_limits')
        .insert({
          key,
          identifier,
          requests: newRequests,
          window_start: new Date(windowStart).toISOString(),
          expires_at: new Date(resetTime + 86400000).toISOString() // Keep for 24h for cleanup
        });
    }
    
    return {
      allowed: true,
      remaining: config.maxRequests - newRequests,
      resetTime
    };
    
  } catch (error) {
    log('warn', 'Rate limiting falling back to in-memory', {
      error: error instanceof Error ? error.message : String(error)
    });
    // Fallback to in-memory if database fails
    return checkRateLimitInMemory(identifier, config);
  }
}

/**
 * In-memory rate limiting fallback
 */
function checkRateLimitInMemory(
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

/**
 * Legacy synchronous rate limiting (deprecated)
 * @deprecated Use checkRateLimitPersistent instead
 */
export function checkRateLimit(
  identifier: string,
  config: RateLimitConfig
): { allowed: boolean; remaining: number; resetTime: number } {
  return checkRateLimitInMemory(identifier, config);
}

// =============================================================================
// SECURITY
// =============================================================================

/**
 * Validate request origin
 */
export function validateOrigin(req: NextRequest): boolean {
  const origin = req.headers['origin'];
  const host = req.headers['host'];
  
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
 * Generate cryptographically secure random seed
 */
export function generateSecureSeed(length: number = 32): string {
  // Use Node.js crypto.randomBytes for cryptographically secure randomness
  const crypto = require('crypto');
  return crypto.randomBytes(Math.ceil(length * 0.75)).toString('base64url').slice(0, length);
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
  const headerTechnique = req.headers['x-technique'] === technique;
  
  return pathTechnique || headerTechnique;
}

/**
 * Extract technique from request
 */
export function extractTechnique(req: NextRequest): DivinationTechnique | null {
  // Try header first
  const headerTechnique = req.headers['x-technique'];
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
