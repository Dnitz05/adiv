/**
 * API Types - Ultra-Professional Backend Type System
 * 
 * Comprehensive type definitions for all API endpoints, ensuring
 * type safety across the entire Vercel + Supabase stack.
 */

// =============================================================================
// CORE API TYPES
// =============================================================================

export interface ApiRequest {
  /** ISO8601 timestamp when request was created */
  timestamp: string;
  /** Unique request identifier for tracing */
  requestId?: string;
  /** User identifier (anonymous or authenticated) */
  userId?: string;
  /** User's preferred locale */
  locale?: string;
}

export interface ApiResponse<T = any> {
  /** Request processing was successful */
  success: boolean;
  /** Response data payload */
  data?: T;
  /** Error information if success = false */
  error?: ApiError;
  /** Response metadata */
  meta?: ResponseMetadata;
}

export interface ApiError {
  /** Error code for programmatic handling */
  code: string;
  /** Human-readable error message */
  message: string;
  /** Additional error details */
  details?: Record<string, any>;
  /** Error timestamp */
  timestamp: string;
  /** Request ID that caused the error */
  requestId?: string;
}

export interface ResponseMetadata {
  /** Server processing time in milliseconds */
  processingTimeMs: number;
  /** Timestamp when response was generated */
  timestamp: string;
  /** API version used */
  version: string;
  /** Rate limiting information */
  rateLimit?: RateLimitInfo;
  /** Cache information */
  cache?: CacheInfo;
}

export interface RateLimitInfo {
  /** Maximum requests allowed */
  limit: number;
  /** Requests remaining in current window */
  remaining: number;
  /** When the rate limit resets (Unix timestamp) */
  reset: number;
  /** Rate limit window in seconds */
  window: number;
}

export interface CacheInfo {
  /** Whether response was served from cache */
  hit: boolean;
  /** Cache TTL in seconds */
  ttl: number;
  /** Cache key used */
  key: string;
}

// =============================================================================
// DIVINATION TECHNIQUE TYPES
// =============================================================================

export type DivinationTechnique = 'tarot' | 'iching' | 'runes';

export interface DivinationRequest extends ApiRequest {
  /** Divination technique to use */
  technique: DivinationTechnique;
  /** Optional seed for reproducible results */
  seed?: string;
  /** User's question or topic */
  question?: string;
}

export interface DivinationResponse<T = any> extends ApiResponse<T> {
  /** Cryptographic seed used for generation */
  seed: string;
  /** Random.org signature for verification (if available) */
  signature?: string;
  /** Method used for randomness generation */
  method: 'random_org' | 'crypto_secure' | 'seeded';
}

// =============================================================================
// TAROT TYPES
// =============================================================================

export interface DrawCardsRequest extends DivinationRequest {
  technique: 'tarot';
  /** Number of cards to draw (1-10) */
  count: number;
  /** Spread type for positioned readings */
  spread?: string;
  /** Whether reversed cards are allowed */
  allowReversed?: boolean;
}

export interface TarotCard {
  /** Unique card ID (0-77 for standard deck) */
  id: number;
  /** Card name in English */
  name: string;
  /** Card suit */
  suit: string;
  /** Card number within suit (null for Major Arcana) */
  number: number | null;
  /** Whether card is reversed */
  isReversed: boolean;
  /** Position in the spread */
  position: number;
}

export interface DrawCardsResponse extends DivinationResponse<TarotCard[]> {
  data: TarotCard[];
  /** Spread type used */
  spread: string;
}

// =============================================================================
// I CHING TYPES
// =============================================================================

export interface TossCoinsRequest extends DivinationRequest {
  technique: 'iching';
  /** Divination method */
  method?: 'coins' | 'yarrow';
}

export interface HexagramLine {
  /** Line position (1-6, bottom to top) */
  position: number;
  /** Line type */
  type: 'yin' | 'yang';
  /** Whether this line is changing */
  isChanging: boolean;
  /** Numeric value (6,7,8,9) */
  value: number;
}

export interface Hexagram {
  /** Hexagram number (1-64) */
  number: number;
  /** Hexagram name */
  name: string;
  /** Six lines from bottom to top */
  lines: HexagramLine[];
  /** Upper and lower trigrams */
  trigrams: [string, string];
  /** Transformed hexagram if changing lines exist */
  transformedTo?: Hexagram;
}

export interface TossCoinsResponse extends DivinationResponse<Hexagram> {
  data: Hexagram;
}

// =============================================================================
// RUNES TYPES
// =============================================================================

export interface DrawRunesRequest extends DivinationRequest {
  technique: 'runes';
  /** Number of runes to draw (1-5) */
  count: number;
  /** Whether reversed runes are allowed */
  allowReversed?: boolean;
  /** Rune set to use */
  runeSet?: 'elder_futhark';
}

export interface Rune {
  /** Unique rune ID (0-23 for Elder Futhark) */
  id: number;
  /** Rune name */
  name: string;
  /** Unicode rune symbol */
  symbol: string;
  /** Whether rune is reversed */
  isReversed: boolean;
  /** Position in the spread */
  position: number;
  /** Brief meaning/keyword */
  meaning: string;
}

export interface DrawRunesResponse extends DivinationResponse<Rune[]> {
  data: Rune[];
}

// =============================================================================
// AI INTERPRETATION TYPES
// =============================================================================

export interface InterpretationRequest extends ApiRequest {
  /** Divination technique used */
  technique: DivinationTechnique;
  /** Raw divination results */
  results: Record<string, any>;
  /** User's question or topic */
  question?: string;
  /** Additional context */
  context?: string;
  /** Response locale */
  locale: string;
}

export interface InterpretationResponse extends ApiResponse<string> {
  /** AI-generated interpretation */
  data: string;
  /** Brief summary */
  summary?: string;
  /** AI confidence score (0-1) */
  confidence?: number;
  /** Suggested follow-up questions */
  followUpQuestions?: string[];
  /** Tokens used for billing */
  tokensUsed?: number;
}

// =============================================================================
// AUTHENTICATION & USER TYPES
// =============================================================================

export interface AuthRequest extends ApiRequest {
  /** Authentication provider */
  provider?: 'anonymous' | 'email' | 'google' | 'apple';
  /** Provider-specific data */
  credentials?: Record<string, any>;
}

export interface User {
  /** Unique user identifier */
  id: string;
  /** User email (if registered) */
  email?: string;
  /** Display name */
  name?: string;
  /** User tier */
  tier: 'free' | 'premium' | 'premium_annual';
  /** Account creation date */
  createdAt: string;
  /** Last activity date */
  lastActivity: string;
  /** User preferences */
  preferences: UserPreferences;
}

export interface UserPreferences {
  /** Preferred locale */
  locale: string;
  /** Preferred divination technique */
  defaultTechnique?: DivinationTechnique;
  /** Theme preference */
  theme: 'light' | 'dark' | 'auto';
  /** Notification settings */
  notifications: NotificationSettings;
}

export interface NotificationSettings {
  /** Email notifications enabled */
  email: boolean;
  /** Push notifications enabled */
  push: boolean;
  /** Marketing emails enabled */
  marketing: boolean;
}

// =============================================================================
// SESSION & HISTORY TYPES
// =============================================================================

export interface DivinationSession {
  /** Unique session identifier */
  id: string;
  /** User identifier */
  userId: string;
  /** Divination technique used */
  technique: DivinationTechnique;
  /** Session locale */
  locale: string;
  /** Session creation date */
  createdAt: string;
  /** Last activity date */
  lastActivity: string;
  /** User's question or topic */
  question?: string;
  /** Raw divination results */
  results?: Record<string, any>;
  /** AI interpretation */
  interpretation?: string;
  /** Session summary */
  summary?: string;
  /** Session metadata */
  metadata: SessionMetadata;
}

export interface SessionMetadata {
  /** Seed used for reproducibility */
  seed: string;
  /** Randomness method used */
  method: string;
  /** Random.org signature (if available) */
  signature?: string;
  /** Session duration in seconds */
  duration?: number;
  /** User satisfaction rating */
  rating?: number;
}

// =============================================================================
// HEALTH & MONITORING TYPES
// =============================================================================

export interface HealthResponse extends ApiResponse<HealthStatus> {
  data: HealthStatus;
}

export interface HealthStatus {
  /** Overall system status */
  status: 'healthy' | 'degraded' | 'unhealthy';
  /** Individual service statuses */
  services: ServiceStatus[];
  /** System metrics */
  metrics: SystemMetrics;
  /** Uptime information */
  uptime: UptimeInfo;
}

export interface ServiceStatus {
  /** Service name */
  name: string;
  /** Service status */
  status: 'healthy' | 'degraded' | 'unhealthy';
  /** Response time in milliseconds */
  responseTime?: number;
  /** Last check timestamp */
  lastCheck: string;
  /** Error message if unhealthy */
  error?: string;
}

export interface SystemMetrics {
  /** API requests per minute */
  requestsPerMinute: number;
  /** Average response time in milliseconds */
  averageResponseTime: number;
  /** Error rate percentage */
  errorRate: number;
  /** Memory usage in MB */
  memoryUsage: number;
}

export interface UptimeInfo {
  /** Service start time */
  startTime: string;
  /** Uptime in seconds */
  uptimeSeconds: number;
  /** Uptime percentage (last 30 days) */
  uptimePercentage: number;
}

// =============================================================================
// UTILITY TYPES
// =============================================================================

/** HTTP methods supported by the API */
export type HttpMethod = 'GET' | 'POST' | 'PUT' | 'DELETE' | 'OPTIONS';

/** Standard HTTP status codes */
export type HttpStatusCode = 
  | 200 // OK
  | 201 // Created  
  | 400 // Bad Request
  | 401 // Unauthorized
  | 403 // Forbidden
  | 404 // Not Found
  | 409 // Conflict
  | 429 // Too Many Requests
  | 500 // Internal Server Error
  | 502 // Bad Gateway
  | 503 // Service Unavailable;

/** API endpoint paths */
export type ApiEndpoint = 
  | '/api/health'
  | '/api/draw/cards'
  | '/api/draw/coins'
  | '/api/draw/runes'
  | '/api/interpret'
  | '/api/auth/login'
  | '/api/auth/logout'
  | '/api/user/profile'
  | '/api/sessions'
  | '/api/sessions/:id';

/** Environment types */
export type Environment = 'development' | 'staging' | 'production';

/** Log levels */
export type LogLevel = 'debug' | 'info' | 'warn' | 'error' | 'fatal';

// =============================================================================
// TYPE GUARDS
// =============================================================================

export function isApiRequest(obj: any): obj is ApiRequest {
  return obj && typeof obj.timestamp === 'string';
}

export function isApiResponse<T>(obj: any): obj is ApiResponse<T> {
  return obj && typeof obj.success === 'boolean';
}

export function isApiError(obj: any): obj is ApiError {
  return obj && typeof obj.code === 'string' && typeof obj.message === 'string';
}

export function isDivinationTechnique(value: any): value is DivinationTechnique {
  return ['tarot', 'iching', 'runes'].includes(value);
}

// =============================================================================
// TYPE UTILITIES
// =============================================================================

/** Make all properties optional recursively */
export type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P];
};

/** Make specific properties required */
export type RequireFields<T, K extends keyof T> = T & Required<Pick<T, K>>;

/** Extract response data type from API response */
export type ExtractData<T> = T extends ApiResponse<infer U> ? U : never;

/** Create API response type from data type */
export type CreateApiResponse<T> = ApiResponse<T>;