/**
 * API Types - Canonical Backend Type System
 */

// Core API
export interface ApiRequest {
  timestamp: string;
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

// Divination
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
