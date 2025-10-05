/**
 * API Types - Canonical Backend Type System
 */

export type JsonValue = string | number | boolean | null | JsonRecord | JsonValue[];

export interface JsonRecord {
  [key: string]: JsonValue | undefined;
}

export type HttpStatusCode =
  | 200
  | 201
  | 202
  | 204
  | 400
  | 401
  | 403
  | 404
  | 409
  | 429
  | 500
  | 502
  | 503;

export type LogLevel = 'debug' | 'info' | 'warn' | 'error' | 'fatal';

type ServiceHealthState = 'healthy' | 'degraded' | 'unhealthy';

export interface ServiceStatus {
  name: string;
  status: ServiceHealthState;
  responseTime?: number;
  lastCheck: string;
  error?: string;
}

export interface SystemMetrics {
  requestsPerMinute: number;
  averageResponseTime: number;
  errorRate: number;
  memoryUsage: number;
}

export interface UptimeInfo {
  startTime: string;
  uptimeSeconds: number;
  uptimePercentage: number;
}

export interface HealthStatus {
  status: ServiceHealthState;
  services: ServiceStatus[];
  metrics: SystemMetrics;
  uptime: UptimeInfo;
}

export interface DeepSeekMessage {
  role?: string;
  content?: string;
}

export interface DeepSeekChoice {
  index?: number;
  message?: DeepSeekMessage;
  finish_reason?: string;
}

export interface DeepSeekUsage {
  prompt_tokens?: number;
  completion_tokens?: number;
  total_tokens?: number;
}

export interface DeepSeekResponse {
  id?: string;
  choices: DeepSeekChoice[];
  usage?: DeepSeekUsage;
  [key: string]: unknown;
}
// Core API
export interface ApiRequest {
  timestamp?: string;
  requestId?: string;
  userId?: string;
  locale?: string;
}

export interface ApiError {
  code: string;
  message: string;
  details?: Record<string, any>;
  timestamp: string;
  requestId?: string;
}

export interface RateLimitInfo {
  limit: number;
  remaining: number;
  reset: number;
  window: number;
}

export interface CacheInfo {
  hit: boolean;
  ttl: number;
  key: string;
}

export interface ResponseMetadata {
  processingTimeMs: number;
  timestamp: string;
  version: string;
  requestId?: string;
  rateLimit?: RateLimitInfo;
  cache?: CacheInfo;
}

export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: ApiError;
  meta?: ResponseMetadata;
}

export type HealthResponse = ApiResponse<HealthStatus>;

export type DivinationTechnique = 'tarot' | 'iching' | 'runes';

export interface DivinationRequest extends ApiRequest {
  technique: DivinationTechnique;
  seed?: string;
  question?: string;
}

export interface DivinationResponse<T = any> extends ApiResponse<T> {
  seed: string;
  signature?: string;
  method: 'random_org' | 'crypto_secure' | 'seeded';
}

// Tarot
export interface DrawCardsRequest extends DivinationRequest {
  technique: 'tarot';
  count: number;
  spread?: string;
  allowReversed?: boolean;
}

export interface TarotCard {
  id: number;
  name: string;
  suit: string;
  number: number | null;
  isReversed: boolean;
  position: number;
}

export interface DrawCardsResponse extends DivinationResponse<TarotCard[]> {
  data: TarotCard[];
  spread: string;
}

// I Ching
export interface TossCoinsRequest extends DivinationRequest {
  technique: 'iching';
  method?: 'coins' | 'yarrow';
}

export interface HexagramLine {
  position: number;
  type: 'yin' | 'yang';
  isChanging: boolean;
  value: number;
}

export interface Hexagram {
  number: number;
  name: string;
  lines: HexagramLine[];
  trigrams: [string, string];
  transformedTo?: Hexagram;
}

export interface TossCoinsResponse extends DivinationResponse<Hexagram> {
  data: Hexagram;
}

// Runes
export interface DrawRunesRequest extends DivinationRequest {
  technique: 'runes';
  count: number;
  allowReversed?: boolean;
  runeSet?: 'elder_futhark';
}

export interface Rune {
  id: number;
  name: string;
  symbol: string;
  isReversed: boolean;
  position: number;
  meaning: string;
}

export interface DrawRunesResponse extends DivinationResponse<Rune[]> {
  data: Rune[];
}

// AI Interpretation
export interface InterpretationRequest extends ApiRequest {
  technique: DivinationTechnique;
  results: Record<string, any>;
  question?: string;
  context?: string;
  locale: string;
}

export interface InterpretationResponse extends ApiResponse<string> {
  data: string;
  summary?: string;
  confidence?: number;
  followUpQuestions?: string[];
  tokensUsed?: number;
}
// Sessions
export interface SessionMetadata {
  seed?: string;
  method?: string;
  signature?: string;
  duration?: number;
  rating?: number;
  history?: {
    artifacts: number;
    messages: number;
    updatedAt: string;
  };
}

export interface SessionArtifact {
  id: string;
  type: 'tarot_draw' | 'iching_cast' | 'rune_cast' | 'interpretation' | 'message_bundle' | 'note';
  source: 'user' | 'assistant' | 'system';
  createdAt: string;
  version: number;
  payload: Record<string, any>;
  metadata?: Record<string, any>;
}

export interface SessionMessage {
  id: string;
  sender: 'user' | 'assistant' | 'system';
  sequence: number;
  createdAt: string;
  content: string;
  metadata?: Record<string, any>;
}

export interface DivinationSession {
  id: string;
  userId: string;
  technique: DivinationTechnique;
  locale: string;
  createdAt: string;
  lastActivity: string;
  question: string | null;
  results?: Record<string, any>;
  interpretation?: string | null;
  summary?: string | null;
  metadata: SessionMetadata | Record<string, any> | null;
  artifacts?: SessionArtifact[];
  messages?: SessionMessage[];
  keywords?: string[];
}
export function isApiError(obj: unknown): obj is ApiError {
  return (
    typeof obj === 'object' &&
    obj !== null &&
    'code' in obj &&
    'message' in obj &&
    typeof (obj as any).code === 'string' &&
    typeof (obj as any).message === 'string'
  );
}
