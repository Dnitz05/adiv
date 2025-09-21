// Minimal API utilities to decouple from legacy code during migration.
// Provides stable helpers used across endpoints.

export type HttpStatusCode = number;

export interface ResponseMetadata {
  processingTimeMs: number;
  timestamp: string;
  version: string;
  requestId?: string;
  rateLimit?: {
    limit: number;
    remaining: number;
    reset: number;
    window: number;
  };
  cache?: {
    hit: boolean;
    ttl: number;
    key: string;
  };
}

export interface ApiError {
  code: string;
  message: string;
  details?: Record<string, any>;
  timestamp: string;
  requestId?: string;
}

export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: ApiError;
  meta?: ResponseMetadata;
}

export function createApiResponse<T>(
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
      version: meta?.version ?? '1.0.0',
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

export function log(level: 'debug' | 'info' | 'warn' | 'error', message: string, ctx?: any): void {
  const line = JSON.stringify({
    level,
    message,
    timestamp: new Date().toISOString(),
    ...(ctx ? { ctx } : {}),
  });
  // eslint-disable-next-line no-console
  if (level === 'error') console.error(line);
  else if (level === 'warn') console.warn(line);
  else console.log(line);
}
