import type { DivinationTechnique } from './api';

export type LunarPhaseId =
  | 'new_moon'
  | 'waxing_crescent'
  | 'first_quarter'
  | 'waxing_gibbous'
  | 'full_moon'
  | 'waning_gibbous'
  | 'last_quarter'
  | 'waning_crescent';

export type LunarElement = 'fire' | 'earth' | 'air' | 'water';

export interface LunarZodiacInfo {
  id: string;
  symbol: string;
  element: LunarElement;
  names: Record<string, string>;
}

export interface LunarPhaseInfo {
  id: LunarPhaseId;
  emoji: string;
  angleStart: number;
  angleEnd: number;
  names: Record<string, string>;
  focus: Record<string, string>;
}

export interface LunarGuidance {
  locale: string;
  text: string;
  source: 'gemini' | 'fallback';
  generatedAt: string;
}

export interface LunarDayData {
  date: string; // ISO date (YYYY-MM-DD)
  phaseId: LunarPhaseId;
  phaseName: string;
  phaseEmoji: string;
  phaseAngle: number; // degrees (0-360)
  illumination: number; // percent (0-100)
  age: number; // days since new moon
  zodiac: {
    id: string;
    name: string;
    symbol: string;
    element: LunarElement;
  };
  guidance?: LunarGuidance | null;
  recommendedSpreads: string[];
}

export interface LunarSessionSummary {
  id: string;
  createdAt: string;
  technique: DivinationTechnique;
  locale: string;
  question: string | null;
  spreadId?: string | null;
  summary?: string | null;
  interpretation?: string | null;
  metadata?: Record<string, any> | null;
}

export interface LunarDayWithSessions extends LunarDayData {
  sessions: LunarSessionSummary[];
  sessionCount: number;
}

export interface LunarRangeItem extends LunarDayData {
  sessionCount: number;
}
