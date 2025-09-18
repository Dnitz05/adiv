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

export function sendApiResponse<T>(
  response: ApiResponse<T> | ApiError,
  statusCode: HttpStatusCode = 200
): Response {
  const isError = (response as any).code !== undefined && (response as any).success === undefined;
  const body = isError
    ? { success: false, error: response }
    : response;
  return new Response(JSON.stringify(body), {
    status: statusCode,
    headers: { 'content-type': 'application/json' },
  });
}

export function addStandardHeaders(res: Response): void {
  res.headers.set('x-api-version', '1.0.0');
  res.headers.set('x-frame-options', 'DENY');
  res.headers.set('x-content-type-options', 'nosniff');
}

export function handleCors(req: { method?: string; headers?: any }): Response | null {
  const origin = '*';
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      status: 204,
      headers: {
        'Access-Control-Allow-Origin': origin,
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Requested-With, X-Request-ID, X-Technique, X-User-ID, X-Locale',
      },
    });
  }
  return null;
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

export async function parseApiRequest<T = any>(req: any): Promise<T> {
  const contentType = req?.headers?.get?.('content-type') ?? '';
  if (contentType.includes('application/json')) {
    const text = await req.text();
    return text ? JSON.parse(text) : ({} as T);
  }
  if (contentType.includes('application/x-www-form-urlencoded')) {
    const formData = await req.formData();
    return Object.fromEntries(formData.entries()) as any;
  }
  return {} as T;
}
