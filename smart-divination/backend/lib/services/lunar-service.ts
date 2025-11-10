import * as Astronomy from 'astronomy-engine';
import type { PostgrestError } from '@supabase/supabase-js';
import { log } from '../utils/api';
import { getSupabaseServiceClient, hasServiceCredentials } from '../utils/supabase';
import type {
  LunarDayData,
  LunarDayWithSessions,
  LunarGuidance,
  LunarPhaseId,
  LunarPhaseInfo,
  LunarRangeItem,
  LunarSessionSummary,
  LunarZodiacInfo,
} from '../types/lunar';
import type { DivinationTechnique } from '../types/api';

const SYNODIC_MONTH_DAYS = 29.53058867;

interface LunarCacheRow {
  date: string;
  phase: LunarPhaseId;
  illumination: number;
  age: number;
  zodiac_sign: string;
  guidance: string | null;
  data: Record<string, any> | null;
  updated_at: string;
}

interface LunarSessionRow {
  id: string;
  user_id: string;
  technique: DivinationTechnique;
  locale: string;
  created_at: string;
  question: string | null;
  summary: string | null;
  interpretation: string | null;
  results: Record<string, any> | null;
  metadata: Record<string, any> | null;
}

interface GetLunarDayOptions {
  date?: string | Date;
  locale?: string;
  requestId?: string;
  userId?: string;
  includeSessions?: boolean;
  preloadedSessions?: LunarSessionSummary[];
  cachedRows?: Map<string, LunarCacheRow>;
}

interface GetLunarRangeOptions {
  from: string | Date;
  to: string | Date;
  locale?: string;
  requestId?: string;
  userId?: string;
}

interface GuidanceRecord {
  [locale: string]: LunarGuidance;
}

const PHASE_DEFINITIONS: LunarPhaseInfo[] = [
  {
    id: 'new_moon',
    emoji: '\u{1F311}',
    angleStart: 337.5,
    angleEnd: 22.5,
    names: {
      en: 'New Moon',
      es: 'Luna nueva',
      ca: 'Lluna nova',
    },
    focus: {
      en: 'Plant seeds and whisper intentions for the cycle ahead.',
      es: 'Siembra semillas e intenciones para el c\u00edrculo que comienza.',
      ca: 'Planta les llavors i marca intencions pel nou cicle.',
    },
  },
  {
    id: 'waxing_crescent',
    emoji: '\u{1F312}',
    angleStart: 22.5,
    angleEnd: 67.5,
    names: {
      en: 'Waxing Crescent',
      es: 'Creciente',
      ca: 'Creixent',
    },
    focus: {
      en: 'Nurture ideas with gentle action and playful curiosity.',
      es: 'Nutre tus ideas con acci\u00f3n suave y curiosidad.',
      ca: 'Cuida les idees amb acci\u00f3 suau i curiositat.',
    },
  },
  {
    id: 'first_quarter',
    emoji: '\u{1F313}',
    angleStart: 67.5,
    angleEnd: 112.5,
    names: {
      en: 'First Quarter',
      es: 'Cuarto creciente',
      ca: 'Quart creixent',
    },
    focus: {
      en: 'Take decisive steps; align effort with your intention.',
      es: 'Da pasos firmes; alinea el esfuerzo con la intenci\u00f3n.',
      ca: 'Fes passes decidides; armonitza esfor\u00e7 i intenci\u00f3.',
    },
  },
  {
    id: 'waxing_gibbous',
    emoji: '\u{1F314}',
    angleStart: 112.5,
    angleEnd: 157.5,
    names: {
      en: 'Waxing Gibbous',
      es: 'Gibosa creciente',
      ca: 'Gibosa creixent',
    },
    focus: {
      en: 'Refine the plan, polish details, and stay devoted to growth.',
      es: 'Refina el plan, pule detalles y mant\u00e9n la devoci\u00f3n al crecimiento.',
      ca: 'Refina el pla, polint detalls amb devoci\u00f3 per al creixement.',
    },
  },
  {
    id: 'full_moon',
    emoji: '\u{1F315}',
    angleStart: 157.5,
    angleEnd: 202.5,
    names: {
      en: 'Full Moon',
      es: 'Luna llena',
      ca: 'Lluna plena',
    },
    focus: {
      en: 'Illuminate truths, celebrate progress, and express gratitude.',
      es: 'Ilumina verdades, celebra avances y expresa gratitud.',
      ca: 'Il\u00b7lumina veritats, celebra l\u2019avanc i agraeix.',
    },
  },
  {
    id: 'waning_gibbous',
    emoji: '\u{1F316}',
    angleStart: 202.5,
    angleEnd: 247.5,
    names: {
      en: 'Waning Gibbous',
      es: 'Gibosa menguante',
      ca: 'Gibosa minvant',
    },
    focus: {
      en: 'Share wisdom, offer support, and soften what feels rigid.',
      es: 'Comparte sabidur\u00eda, apoya y suaviza lo que est\u00e1 tenso.',
      ca: 'Comparteix saviesa, dona suport i suavitza el que se sent tens.',
    },
  },
  {
    id: 'last_quarter',
    emoji: '\u{1F317}',
    angleStart: 247.5,
    angleEnd: 292.5,
    names: {
      en: 'Last Quarter',
      es: 'Cuarto menguante',
      ca: 'Quart minvant',
    },
    focus: {
      en: 'Release what is complete and restructure your commitments.',
      es: 'Suelta lo que ya concluy\u00f3 y reestructura compromisos.',
      ca: 'Allibera el que ja ha complert i reestructura compromisos.',
    },
  },
  {
    id: 'waning_crescent',
    emoji: '\u{1F318}',
    angleStart: 292.5,
    angleEnd: 337.5,
    names: {
      en: 'Waning Crescent',
      es: 'Creciente menguante',
      ca: 'Creixent minvant',
    },
    focus: {
      en: 'Rest, dream, and listen for the whispers of the next cycle.',
      es: 'Descansa, sue\u00f1a y escucha los susurros del siguiente ciclo.',
      ca: 'Descansa, somia i escolta els xiuxiueigs del proper cicle.',
    },
  },
];

const ZODIAC_SIGNS: LunarZodiacInfo[] = [
  {
    id: 'aries',
    symbol: '\u2648',
    element: 'fire',
    names: { en: 'Aries', es: 'Aries', ca: '\u00c0ries' },
  },
  {
    id: 'taurus',
    symbol: '\u2649',
    element: 'earth',
    names: { en: 'Taurus', es: 'Tauro', ca: 'Taure' },
  },
  {
    id: 'gemini',
    symbol: '\u264a',
    element: 'air',
    names: { en: 'Gemini', es: 'G\u00e9minis', ca: 'Bessons' },
  },
  {
    id: 'cancer',
    symbol: '\u264b',
    element: 'water',
    names: { en: 'Cancer', es: 'C\u00e1ncer', ca: 'Cranc' },
  },
  {
    id: 'leo',
    symbol: '\u264c',
    element: 'fire',
    names: { en: 'Leo', es: 'Leo', ca: 'Lle\u00f3' },
  },
  {
    id: 'virgo',
    symbol: '\u264d',
    element: 'earth',
    names: { en: 'Virgo', es: 'Virgo', ca: 'Verge' },
  },
  {
    id: 'libra',
    symbol: '\u264e',
    element: 'air',
    names: { en: 'Libra', es: 'Libra', ca: 'Balan\u00e7a' },
  },
  {
    id: 'scorpio',
    symbol: '\u264f',
    element: 'water',
    names: { en: 'Scorpio', es: 'Escorpio', ca: 'Escorp\u00ed' },
  },
  {
    id: 'sagittarius',
    symbol: '\u2650',
    element: 'fire',
    names: { en: 'Sagittarius', es: 'Sagitario', ca: 'Sagitari' },
  },
  {
    id: 'capricorn',
    symbol: '\u2651',
    element: 'earth',
    names: { en: 'Capricorn', es: 'Capricornio', ca: 'Capricorn' },
  },
  {
    id: 'aquarius',
    symbol: '\u2652',
    element: 'air',
    names: { en: 'Aquarius', es: 'Acuario', ca: 'Aquari' },
  },
  {
    id: 'pisces',
    symbol: '\u2653',
    element: 'water',
    names: { en: 'Pisces', es: 'Piscis', ca: 'Peixos' },
  },
];

const RECOMMENDED_SPREADS: Record<LunarPhaseId, string[]> = {
  new_moon: ['single', 'three_card'],
  waxing_crescent: ['two_card', 'three_card'],
  first_quarter: ['five_card_cross', 'horseshoe'],
  waxing_gibbous: ['pyramid', 'star'],
  full_moon: ['celtic_cross', 'astrological'],
  waning_gibbous: ['relationship', 'horseshoe'],
  last_quarter: ['five_card_cross', 'year_ahead'],
  waning_crescent: ['single', 'two_card'],
};

const FALLBACK_GUIDANCE: Record<LunarPhaseId, Record<string, string>> = {
  new_moon: {
    en: 'The night is blank parchment. Whisper the intentions you dare to grow and allow stillness to protect the seed.',
    es: 'La noche es un pergamino en blanco. Susurra las intenciones que deseas cultivar y permite que el silencio resguarde la semilla.',
    ca: 'La nit \u00e9s un pergam\u00ed en blanc. Xiuxiueja les intencions que vols fer germinar i deixa que la quietud protegeixi la llavor.',
  },
  waxing_crescent: {
    en: 'Delicate shoots emerge; nurture them with gentle action and repeat your dreams aloud.',
    es: 'Brotan tallos delicados; alim\u00e9ntalos con acci\u00f3n suave y repite en veu alta tus somnis.',
    ca: 'Sorgeixen brots delicats; nodreix-los amb accions suaus i repeteix en veu alta els teus somnis.',
  },
  first_quarter: {
    en: 'The moon draws a line of courage. Make the choice you have postponed and trust your own momentum.',
    es: 'La luna traza una l\u00ednea de coraje. Toma la decisi\u00f3n que havies ajornat i confia en l\u2019impuls propi.',
    ca: 'La lluna dibuixa una l\ednia de coratge. Pren la decisi\u00f3 que ajornaves i confia en el teu impuls.',
  },
  waxing_gibbous: {
    en: 'Polish your craft; refine, adjust, and infuse love into every detail that sustains your vision.',
    es: 'Pulsa tu art; refina, ajusta y infunde amor en cada detall que sost\u00e9 tu visi\u00f3.',
    ca: 'Pol el teu art; refina, ajusta i infon amor en cada detall que sost\u00e9 la visi\u00f3.',
  },
  full_moon: {
    en: 'The moon is a lantern revealing truth. Celebrate what bloomed and let gratitude echo beneath the stars.',
    es: 'La luna es un farol que revela la veritat. Celebra lo que ha florecido i deixa que la gratitud ressoni sota els estels.',
    ca: 'La lluna \u00e9s un fanal que revela la veritat. Celebra all\f2 que ha florit i deixa que la gratitud ressoni sota els estels.',
  },
  waning_gibbous: {
    en: 'Share your wisdom like gentle rain; offer guidance and allow compassion to soften rigid edges.',
    es: 'Comparte tu saviesa como lluvia suave; ofrece guia i deixa que la compassio suavitzï els cantells r\u00edgids.',
    ca: 'Comparteix la saviesa com pluja suau; ofereix guia i deixa que la compassio estovi els cantells \u00e0spres.',
  },
  last_quarter: {
    en: 'Declutter the spirit. Release what is complete and redesign your commitments with clarity.',
    es: 'Despeja l\u2019esperit. Suelta lo que ya concluy\u00f3 i redissenya compromisos amb claredat.',
    ca: 'Despr\u00e9n-te all\f2 que ja s\ha completat i redissenya compromisos amb claredat.',
  },
  waning_crescent: {
    en: 'Curl inward, rest, and dream. The next cycle is weaving itself in your quiet imagination.',
    es: 'Rec\u00f3gete, descansa y somia. El siguiente ciclo s\u2019est\u00e0 teixint a la teva imaginacio silenciosa.',
    ca: 'Recull-te, descansa i somia; el proper cicle es teixeix dins la teva imaginaci\u00f3 silenciosa.',
  },
};

const LUNAR_GUIDANCE_SYSTEM_PROMPT = `You are a poetic astrologer crafting lunar guidance.
Your tone is empathetic, mystical, and rooted in nature imagery.
Write 3-4 sentences without bullet points.
Reference the lunar phase's focus and the moon's zodiac sign.
Encourage a tarot ritual aligned with the phase.
Language must match the user's locale.`;

function normalizeLocale(locale?: string): 'en' | 'es' | 'ca' {
  if (!locale) return 'en';
  const lower = locale.toLowerCase();
  if (lower.startsWith('es')) return 'es';
  if (lower.startsWith('ca')) return 'ca';
  return 'en';
}

function toDateKey(date: Date): string {
  return date.toISOString().split('T')[0];
}

function clampAngle(angle: number): number {
  const normalized = angle % 360;
  return normalized < 0 ? normalized + 360 : normalized;
}

function selectPhase(angle: number): LunarPhaseInfo {
  const normalized = clampAngle(angle);
  for (const phase of PHASE_DEFINITIONS) {
    if (phase.angleStart > phase.angleEnd) {
      if (normalized >= phase.angleStart || normalized < phase.angleEnd) {
        return phase;
      }
    } else if (normalized >= phase.angleStart && normalized < phase.angleEnd) {
      return phase;
    }
  }
  return PHASE_DEFINITIONS[0];
}

function selectZodiac(longitude: number): LunarZodiacInfo {
  const normalized = clampAngle(longitude);
  const index = Math.floor(normalized / 30) % 12;
  return ZODIAC_SIGNS[index];
}

function formatNumber(value: number, fractionDigits = 2): number {
  return Number.parseFloat(value.toFixed(fractionDigits));
}

function mapSessionRow(row: LunarSessionRow): LunarSessionSummary {
  const spreadId =
    row.results && typeof row.results === 'object' && row.results.spread
      ? (row.results.spread as string)
      : row.metadata && typeof row.metadata === 'object' && row.metadata.spread
        ? (row.metadata.spread as string)
        : null;

  return {
    id: row.id,
    createdAt: row.created_at,
    technique: row.technique,
    locale: row.locale,
    question: row.question,
    spreadId,
    summary: row.summary ?? undefined,
    interpretation: row.interpretation ?? undefined,
    metadata: row.metadata ?? undefined,
  };
}

function fallbackGuidance(phaseId: LunarPhaseId, locale: 'en' | 'es' | 'ca'): LunarGuidance {
  const text = FALLBACK_GUIDANCE[phaseId][locale] ?? FALLBACK_GUIDANCE[phaseId].en;
  return {
    locale,
    text,
    source: 'fallback',
    generatedAt: new Date().toISOString(),
  };
}

function sanitizeGuidanceText(text: string): string {
  return text
    .replace(/^["\s]+|["\s]+$/g, '\u{1F314}')
    .replace(/\s+/g, ' ')
    .trim();
}

async function maybeGenerateGuidance(
  phase: LunarPhaseInfo,
  zodiac: LunarZodiacInfo,
  locale: 'en' | 'es' | 'ca',
  requestId?: string
): Promise<LunarGuidance> {
  const hasGeminiKey = Boolean(process.env.GEMINI_API_KEY?.trim());
  if (!hasGeminiKey) {
    return fallbackGuidance(phase.id, locale);
  }

  try {
    const { callGemini } = await import('./gemini-ai');
    const response = await callGemini({
      systemPrompt: LUNAR_GUIDANCE_SYSTEM_PROMPT,
      userPrompt: `Locale: ${locale}\nPhase: ${phase.names.en} (${phase.id})\nFocus: ${phase.focus[locale]}\nZodiac sign: ${zodiac.names[locale]} (${zodiac.id})\nTarot spread suggestions: ${RECOMMENDED_SPREADS[phase.id].join(', ')}`,
      temperature: 0.8,
      maxTokens: 320,
      requestId,
    });

    const text = sanitizeGuidanceText(response.content ?? '\u{1F314}');
    if (text.length > 20) {
      return {
        locale,
        text,
        source: 'gemini',
        generatedAt: new Date().toISOString(),
      };
    }
  } catch (error) {
    log('warn', 'Gemini lunar guidance generation failed', {
      requestId,
      error: error instanceof Error ? error.message : String(error),
    });
  }

  return fallbackGuidance(phase.id, locale);
}

async function getCacheRow(dateKey: string, requestId?: string): Promise<LunarCacheRow | null> {
  if (!hasServiceCredentials()) {
    return null;
  }

  const client = getSupabaseServiceClient();
  const { data, error } = await client
    .from('lunar_daily_cache')
    .select('*')
    .eq('date', dateKey)
    .maybeSingle<LunarCacheRow>();

  if (error) {
    const code = (error as PostgrestError).code;
    if (code !== 'PGRST116') {
      log('warn', 'Failed to load lunar cache row', {
        requestId,
        dateKey,
        error: error.message,
      });
    }
    return null;
  }

  return data ?? null;
}

async function getCacheRows(
  from: string,
  to: string,
  requestId?: string
): Promise<Map<string, LunarCacheRow>> {
  const map = new Map<string, LunarCacheRow>();
  if (!hasServiceCredentials()) {
    return map;
  }

  const client = getSupabaseServiceClient();
  const { data, error } = await client
    .from('lunar_daily_cache')
    .select('*')
    .gte('date', from)
    .lte('date', to)
    .order('date', { ascending: true });

  if (error) {
    log('warn', 'Failed to load lunar cache range', {
      requestId,
      from,
      to,
      error: error.message,
    });
    return map;
  }

  for (const row of (data ?? []) as LunarCacheRow[]) {
    map.set(row.date, row);
  }
  return map;
}

async function upsertCacheRow(
  row: LunarCacheRow,
  localeGuidance: GuidanceRecord,
  requestId?: string
): Promise<void> {
  if (!hasServiceCredentials()) {
    return;
  }

  const client = getSupabaseServiceClient();
  const data = {
    date: row.date,
    phase: row.phase,
    illumination: row.illumination,
    age: row.age,
    zodiac_sign: row.zodiac_sign,
    guidance: row.guidance,
    data: {
      ...(row.data ?? {}),
      guidance: localeGuidance,
    },
    updated_at: new Date().toISOString(),
  };

  const { error } = await client.from('lunar_daily_cache').upsert(data, { onConflict: 'date' });

  if (error) {
    log('warn', 'Failed to upsert lunar cache row', {
      requestId,
      date: row.date,
      error: error.message,
    });
  }
}

function buildAstronomySnapshot(date: Date) {
  const phaseAngle = clampAngle(Astronomy.MoonPhase(date));
  const illuminationInfo = Astronomy.Illumination(Astronomy.Body.Moon, date);
  const moonPosition = Astronomy.EclipticGeoMoon(date);

  const illumination = illuminationInfo.phase_fraction * 100;
  const age = (phaseAngle / 360) * SYNODIC_MONTH_DAYS;

  return {
    phaseAngle,
    illumination: formatNumber(illumination),
    age: formatNumber(age),
    longitude: clampAngle(moonPosition.lon),
  };
}

function buildDayData(
  dateKey: string,
  phase: LunarPhaseInfo,
  zodiac: LunarZodiacInfo,
  phaseAngle: number,
  illumination: number,
  age: number,
  locale: 'en' | 'es' | 'ca',
  guidance: LunarGuidance | null
): LunarDayData {
  return {
    date: dateKey,
    phaseId: phase.id,
    phaseName: phase.names[locale] ?? phase.names.en,
    phaseEmoji: phase.emoji,
    phaseAngle: formatNumber(phaseAngle, 2),
    illumination: formatNumber(illumination, 2),
    age: formatNumber(age, 2),
    zodiac: {
      id: zodiac.id,
      name: zodiac.names[locale] ?? zodiac.names.en,
      symbol: zodiac.symbol,
      element: zodiac.element,
    },
    guidance: guidance ?? undefined,
    recommendedSpreads: RECOMMENDED_SPREADS[phase.id],
  };
}

function extractGuidanceFromRow(
  row: LunarCacheRow,
  locale: 'en' | 'es' | 'ca'
): { guidance: LunarGuidance | null; guidanceMap: GuidanceRecord } {
  const record: GuidanceRecord = row.data && row.data.guidance ? { ...row.data.guidance } : {};
  const guidance =
    record[locale] ??
    (row.guidance
      ? {
          locale,
          text: row.guidance,
          source: 'fallback' as const,
          generatedAt: row.updated_at,
        }
      : null);
  return { guidance, guidanceMap: record };
}

async function ensureGuidanceForLocale(
  guidanceMap: GuidanceRecord,
  locale: 'en' | 'es' | 'ca',
  phase: LunarPhaseInfo,
  zodiac: LunarZodiacInfo,
  requestId?: string
): Promise<{ guidance: LunarGuidance; map: GuidanceRecord }> {
  if (guidanceMap[locale]) {
    return { guidance: guidanceMap[locale], map: guidanceMap };
  }
  const guidance = await maybeGenerateGuidance(phase, zodiac, locale, requestId);
  return {
    guidance,
    map: { ...guidanceMap, [locale]: guidance },
  };
}

async function loadSessionsForDate(
  userId: string,
  date: Date,
  locale: 'en' | 'es' | 'ca',
  requestId?: string
): Promise<LunarSessionSummary[]> {
  if (!hasServiceCredentials()) {
    return [];
  }

  // Skip database operations for anonymous users (prefixed with "anon_")
  if (userId.startsWith('anon_')) {
    return [];
  }

  const start = new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()));
  const end = new Date(start);
  end.setUTCDate(end.getUTCDate() + 1);

  const client = getSupabaseServiceClient();
  const { data, error} = await client
    .from('sessions')
    .select(
      'id,user_id,technique,locale,created_at,question,summary,interpretation,results,metadata'
    )
    .eq('user_id', userId)
    .eq('is_deleted', false)
    .gte('created_at', start.toISOString())
    .lt('created_at', end.toISOString())
    .order('created_at', { ascending: true });

  if (error) {
    log('warn', 'Failed to load sessions for lunar day', {
      requestId,
      userId,
      date: start.toISOString(),
      error: error.message,
    });
    return [];
  }

  return (data ?? []).map((row) => mapSessionRow(row as LunarSessionRow));
}

async function loadSessionsMap(
  userId: string,
  from: Date,
  to: Date,
  requestId?: string
): Promise<Map<string, LunarSessionSummary[]>> {
  const map = new Map<string, LunarSessionSummary[]>();
  if (!hasServiceCredentials()) {
    return map;
  }

  // Skip database operations for anonymous users (prefixed with "anon_")
  if (userId.startsWith('anon_')) {
    return map;
  }

  const start = new Date(Date.UTC(from.getUTCFullYear(), from.getUTCMonth(), from.getUTCDate()));
  const end = new Date(Date.UTC(to.getUTCFullYear(), to.getUTCMonth(), to.getUTCDate()));
  end.setUTCDate(end.getUTCDate() + 1);

  const client = getSupabaseServiceClient();
  const { data, error } = await client
    .from('sessions')
    .select(
      'id,user_id,technique,locale,created_at,question,summary,interpretation,results,metadata'
    )
    .eq('user_id', userId)
    .eq('is_deleted', false)
    .gte('created_at', start.toISOString())
    .lt('created_at', end.toISOString())
    .order('created_at', { ascending: true });

  if (error) {
    log('warn', 'Failed to load sessions for lunar range', {
      requestId,
      userId,
      from: start.toISOString(),
      to: end.toISOString(),
      error: error.message,
    });
    return map;
  }

  for (const row of (data ?? []) as LunarSessionRow[]) {
    const session = mapSessionRow(row);
    const dateKey = session.createdAt.split('T')[0];
    if (!map.has(dateKey)) {
      map.set(dateKey, []);
    }
    map.get(dateKey)!.push(session);
  }

  return map;
}

function buildLunarCacheRow(
  dateKey: string,
  phase: LunarPhaseInfo,
  zodiac: LunarZodiacInfo,
  illumination: number,
  age: number,
  guidance: LunarGuidance | null,
  phaseAngle: number,
  longitude: number,
  existing?: LunarCacheRow
): LunarCacheRow {
  const data = {
    ...(existing?.data ?? {}),
    phaseAngle,
    longitude,
  } as Record<string, any>;

  if (existing?.data?.guidance) {
    data.guidance = existing.data.guidance;
  }

  return {
    date: dateKey,
    phase: phase.id,
    illumination: formatNumber(illumination, 2),
    age: formatNumber(age, 2),
    zodiac_sign: zodiac.id,
    guidance: guidance?.text ?? existing?.guidance ?? null,
    data,
    updated_at: new Date().toISOString(),
  };
}

export async function getLunarDay(options: GetLunarDayOptions = {}): Promise<LunarDayWithSessions> {
  const locale = normalizeLocale(options.locale);
  const date = options.date ? new Date(options.date) : new Date();
  const dateKey = toDateKey(date);
  const requestId = options.requestId;

  let cacheRow = options.cachedRows?.get(dateKey) ?? null;
  if (!cacheRow) {
    cacheRow = await getCacheRow(dateKey, requestId);
    if (cacheRow && options.cachedRows) {
      options.cachedRows.set(dateKey, cacheRow);
    }
  }

  const snapshot = buildAstronomySnapshot(date);
  const phase = selectPhase(snapshot.phaseAngle);
  const zodiac = selectZodiac(snapshot.longitude);

  let guidanceRecord: GuidanceRecord = {};
  let guidance: LunarGuidance | null = null;
  if (cacheRow) {
    const extracted = extractGuidanceFromRow(cacheRow, locale);
    guidance = extracted.guidance;
    guidanceRecord = extracted.guidanceMap;
  }

  if (!guidance) {
    const ensured = await ensureGuidanceForLocale(guidanceRecord, locale, phase, zodiac, requestId);
    guidance = ensured.guidance;
    guidanceRecord = ensured.map;
  }

  const dayData = buildDayData(
    dateKey,
    phase,
    zodiac,
    snapshot.phaseAngle,
    snapshot.illumination,
    snapshot.age,
    locale,
    guidance
  );

  const cachePayload = buildLunarCacheRow(
    dateKey,
    phase,
    zodiac,
    snapshot.illumination,
    snapshot.age,
    guidance,
    snapshot.phaseAngle,
    snapshot.longitude,
    cacheRow ?? undefined
  );

  if (!options.cachedRows) {
    await upsertCacheRow(cachePayload, guidanceRecord, requestId);
  } else {
    options.cachedRows.set(dateKey, cachePayload);
    await upsertCacheRow(cachePayload, guidanceRecord, requestId);
  }

  let sessions: LunarSessionSummary[] = [];
  if (options.includeSessions && options.userId) {
    sessions =
      options.preloadedSessions ??
      (await loadSessionsForDate(options.userId, date, locale, requestId));
  }

  return {
    ...dayData,
    sessions,
    sessionCount: sessions.length,
  };
}

export async function getLunarRange(options: GetLunarRangeOptions): Promise<LunarRangeItem[]> {
  const locale = normalizeLocale(options.locale);
  const fromDate = new Date(options.from);
  const toDate = new Date(options.to);
  if (Number.isNaN(fromDate.valueOf()) || Number.isNaN(toDate.valueOf())) {
    throw new Error('Invalid date range provided to getLunarRange');
  }

  const requestId = options.requestId;
  const start = new Date(
    Date.UTC(fromDate.getUTCFullYear(), fromDate.getUTCMonth(), fromDate.getUTCDate())
  );
  const end = new Date(
    Date.UTC(toDate.getUTCFullYear(), toDate.getUTCMonth(), toDate.getUTCDate())
  );

  if (end < start) {
    throw new Error('Range end date must be on or after the start date');
  }

  const rangeRows = await getCacheRows(toDateKey(start), toDateKey(end), requestId);
  const sessionMap = options.userId
    ? await loadSessionsMap(options.userId, start, end, requestId)
    : new Map<string, LunarSessionSummary[]>();

  const results: LunarRangeItem[] = [];
  const current = new Date(start);

  while (current <= end) {
    const dateKey = toDateKey(current);
    const day = await getLunarDay({
      date: current,
      locale,
      requestId,
      cachedRows: rangeRows,
      includeSessions: false,
    });

    const sessionCount = sessionMap.get(dateKey)?.length ?? 0;

    results.push({
      ...day,
      sessionCount,
    });

    current.setUTCDate(current.getUTCDate() + 1);
  }

  return results;
}

export async function buildLunarMetadata(
  dateIso: string,
  locale?: string,
  requestId?: string
): Promise<Record<string, any> | null> {
  const context = await getLunarDay({
    date: dateIso,
    locale,
    requestId,
    includeSessions: false,
  });

  if (!context) {
    return null;
  }

  const guidance = context.guidance;

  return {
    lunar: {
      date: context.date,
      phaseId: context.phaseId,
      phaseName: context.phaseName,
      phaseEmoji: context.phaseEmoji,
      illumination: context.illumination,
      phaseAngle: context.phaseAngle,
      age: context.age,
      zodiac: context.zodiac,
      recommendedSpreads: context.recommendedSpreads,
      guidance: guidance?.text ?? null,
      guidanceLocale: guidance?.locale ?? null,
      guidanceSource: guidance?.source ?? null,
      guidanceGeneratedAt: guidance?.generatedAt ?? null,
    },
  };
}
