import type { NextApiRequest, NextApiResponse } from 'next';

export interface CorsConfig {
  origin?: string;
  methods?: string;
  headers?: string;
  credentials?: boolean;
}

const DEFAULT_CORS: Required<CorsConfig> = {
  origin: '*',
  methods: 'GET,POST,PUT,DELETE,PATCH,OPTIONS',
  headers:
    'content-type,authorization,x-request-id,x-technique,x-user-id,x-locale,x-api-version,x-csrf-token,x-requested-with,accept,accept-version,content-length,content-md5,date',
  credentials: true,
};

const STANDARD_HEADERS: Record<string, string> = {
  'x-api-version': '1.0.0',
  'x-frame-options': 'DENY',
  'x-content-type-options': 'nosniff',
};

export function applyCorsHeaders(res: NextApiResponse, config?: CorsConfig): void {
  const cfg = { ...DEFAULT_CORS, ...(config ?? {}) };
  res.setHeader('Access-Control-Allow-Origin', cfg.origin);
  res.setHeader('Access-Control-Allow-Methods', cfg.methods);
  res.setHeader('Access-Control-Allow-Headers', cfg.headers);
  res.setHeader('Access-Control-Allow-Credentials', String(cfg.credentials));
}

export function handleCorsPreflight(
  req: NextApiRequest,
  res: NextApiResponse,
  config?: CorsConfig
): boolean {
  applyCorsHeaders(res, config);
  if (req.method === 'OPTIONS') {
    res.status(204).end();
    return true;
  }
  return false;
}

export function applyStandardResponseHeaders(
  res: NextApiResponse,
  extraHeaders?: Record<string, string>
): void {
  Object.entries({ ...STANDARD_HEADERS, ...(extraHeaders ?? {}) }).forEach(([key, value]) => {
    res.setHeader(key, value);
  });
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

export function parseRequestBody(req: NextApiRequest): Record<string, unknown> {
  const { body } = req;
  if (!body) {
    return {};
  }
  if (typeof body === 'string') {
    if (!body.length) {
      return {};
    }
    const parsed: unknown = JSON.parse(body);
    return isRecord(parsed) ? parsed : {};
  }
  if (Buffer.isBuffer(body)) {
    const decoded = body.toString('utf-8');
    if (!decoded.length) {
      return {};
    }
    const parsed: unknown = JSON.parse(decoded);
    return isRecord(parsed) ? parsed : {};
  }
  return isRecord(body) ? body : {};
}

export function getHeader(req: NextApiRequest, name: string): string | undefined {
  const header = req.headers[name.toLowerCase()];
  if (Array.isArray(header)) {
    return header[0];
  }
  if (typeof header === 'string') {
    return header;
  }
  return undefined;
}

export function getLocaleFromHeader(req: NextApiRequest, fallback = 'en'): string {
  const header = getHeader(req, 'x-locale');
  if (header && header.trim().length > 0) {
    return header;
  }
  return fallback;
}

export interface JsonErrorPayload {
  code: string;
  message: string;
  timestamp?: string;
  requestId?: string;
  details?: unknown;
}

export function sendJsonError(
  res: NextApiResponse,
  status: number,
  error: JsonErrorPayload,
  extra?: Record<string, unknown>
): void {
  res.status(status).json({
    success: false,
    error: {
      ...error,
      timestamp: error.timestamp ?? new Date().toISOString(),
    },
    ...(extra ? { meta: extra } : {}),
  });
}
