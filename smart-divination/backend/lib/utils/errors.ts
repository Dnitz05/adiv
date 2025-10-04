import type { HttpStatusCode } from '../types/api';

type HttpStatusMeta = HttpStatusCode | 400 | 401 | 403 | 404 | 409 | 429 | 500 | 502 | 503 | 200 | 201;

export type ErrorSeverity = 'info' | 'warn' | 'error';

type ErrorDefinitionShape = {
  code: string;
  status: HttpStatusMeta;
  defaultMessage: string;
  severity: ErrorSeverity;
  defaultDetails?: Record<string, unknown>;
};

const ERROR_DEFINITION_MAP = {
  UNAUTHENTICATED: {
    code: 'UNAUTHENTICATED',
    status: 401,
    defaultMessage: 'Authentication required.',
    severity: 'warn',
  },
  INVALID_REQUEST: {
    code: 'INVALID_REQUEST',
    status: 400,
    defaultMessage: 'Request payload is invalid.',
    severity: 'warn',
  },
  VALIDATION_ERROR: {
    code: 'VALIDATION_ERROR',
    status: 400,
    defaultMessage: 'Invalid request payload.',
    severity: 'warn',
  },
  INTERNAL_ERROR: {
    code: 'INTERNAL_ERROR',
    status: 500,
    defaultMessage: 'Unexpected server error.',
    severity: 'error',
  },
  SMART_ERR_SUPABASE_MISSING: {
    code: 'SMART_ERR_SUPABASE_MISSING',
    status: 503,
    defaultMessage: 'Supabase credentials are not configured.',
    severity: 'warn',
    defaultDetails: { service: 'supabase' },
  },
  SMART_ERR_DEEPSEEK_MISSING: {
    code: 'SMART_ERR_DEEPSEEK_MISSING',
    status: 503,
    defaultMessage: 'DeepSeek API key is not configured.',
    severity: 'warn',
    defaultDetails: { service: 'deepseek' },
  },
  SMART_ERR_RANDOM_ORG_MISSING: {
    code: 'SMART_ERR_RANDOM_ORG_MISSING',
    status: 503,
    defaultMessage: 'Random.org API key is not configured.',
    severity: 'warn',
    defaultDetails: { service: 'random_org' },
  },
  SMART_ERR_FEATURE_DISABLED: {
    code: 'SMART_ERR_FEATURE_DISABLED',
    status: 503,
    defaultMessage: 'Requested feature is currently disabled.',
    severity: 'info',
  },
  SMART_ERR_FORBIDDEN: {
    code: 'SMART_ERR_FORBIDDEN',
    status: 403,
    defaultMessage: 'You are not allowed to perform this action.',
    severity: 'warn',
  },
  SMART_ERR_NOT_FOUND: {
    code: 'SMART_ERR_NOT_FOUND',
    status: 404,
    defaultMessage: 'Requested resource could not be found.',
    severity: 'warn',
  },
  SMART_ERR_RATE_LIMITED: {
    code: 'SMART_ERR_RATE_LIMITED',
    status: 429,
    defaultMessage: 'Too many requests. Please try again later.',
    severity: 'warn',
  },
} as const satisfies Record<string, ErrorDefinitionShape>;

export const ERROR_DEFINITIONS = ERROR_DEFINITION_MAP;

export type KnownErrorCode = keyof typeof ERROR_DEFINITIONS;

export type ErrorDefinition = (typeof ERROR_DEFINITIONS)[KnownErrorCode] & { code: KnownErrorCode };

export function resolveErrorDefinition(code: string): ErrorDefinition | undefined {
  return ERROR_DEFINITIONS[code as KnownErrorCode];
}
