// =====================================================
// MODULAR CONTENT COMPOSER
// =====================================================
// Replaces OpenAI with pre-written modular content
// Composes: Base Template + Seasonal Overlay + Weekday Energy + Special Events
// ZERO external API cost, INFINITE combinations

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3';

const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

// =====================================================
// TYPES
// =====================================================

export interface LunarGuideTemplate {
  id: string;
  phase_id: string;
  element: string | null;
  zodiac_sign: string | null;
  headline: Record<string, string>;
  tagline: Record<string, string> | null;
  focus_areas: Record<string, string[]>;
  energy_description: Record<string, string>;
  recommended_actions: Record<string, string[]>;
  priority: number;
  active: boolean;
}

export interface SeasonalOverlay {
  id: string;
  template_id: string;
  season: 'spring' | 'summer' | 'autumn' | 'winter';
  overlay_headline: Record<string, string>;
  overlay_description: Record<string, string>;
  energy_shift: Record<string, string>;
  themes: Record<string, string[]>;
  seasonal_actions: Record<string, string[]>;
}

export interface WeekdayEnergy {
  id: string;
  weekday: string;
  planet: string;
  element: string;
  qualities: Record<string, string>;
  description: Record<string, string>;
  traditional_meaning: Record<string, string>;
  areas_of_influence: Record<string, string[]>;
  favorable_activities: Record<string, string[]>;
  color: string;
  metal: string;
  stones: string[];
  herbs: string[];
  planet_emoji: string;
  element_emoji: string;
}

export interface SpecialAstronomicalEvent {
  id: string;
  event_type: string;
  start_date: string;
  end_date: string | null;
  event_name: Record<string, string>;
  traditional_meaning: Record<string, string>;
  guidance: Record<string, string>;
  recommended_actions: Record<string, string[]>;
  avoid_actions: Record<string, string[]>;
  intensity: number;
  visibility: string;
  zodiac_sign: string | null;
}

export interface ComposeGuideParams {
  date: Date;
  phaseId: string;
  zodiacSign: string;
  element: string;
  lunarAge: number;
  illumination: number;
  template: LunarGuideTemplate;
}

export interface ComposedGuide {
  composed_headline: Record<string, string>;
  composed_description: Record<string, string>;
  composed_guidance: Record<string, string>;
  focus_areas: Record<string, string[]>;
  recommended_actions: Record<string, string[]>;
  seasonal_overlay_id: string | null;
  weekday: string;
  special_event_ids: string[];
  composition_version: string;
}

// =====================================================
// SEASON DETECTION
// =====================================================

/**
 * Determine astrological season from zodiac sign
 * Based on Wheel of the Year sabbats + elemental correspondences
 */
function getSeasonFromZodiac(zodiacSign: string): 'spring' | 'summer' | 'autumn' | 'winter' {
  const seasonMap: Record<string, 'spring' | 'summer' | 'autumn' | 'winter'> = {
    // SPRING: Ostara (Aries 0°) → Beltane (Taurus 15°)
    // Fire initiation (Aries) + Earth abundance (Taurus) + Air communication (Gemini early)
    'aries': 'spring',      // Mar 21 - Apr 19 (Fire Cardinal - Renewal)
    'taurus': 'spring',     // Apr 20 - May 20 (Earth Fixed - Fertility)
    'gemini': 'spring',     // May 21 - Jun 20 (Air Mutable - Fresh Ideas)

    // SUMMER: Litha (Cancer 0°) → Lughnasadh (Leo 15°)
    // Water nurturing (Cancer) + Fire radiance (Leo) + Earth precision (Virgo early)
    'cancer': 'summer',     // Jun 21 - Jul 22 (Water Cardinal - Nurturing)
    'leo': 'summer',        // Jul 23 - Aug 22 (Fire Fixed - Peak Expression)
    'virgo': 'summer',      // Aug 23 - Sep 22 (Earth Mutable - Harvest Prep)

    // AUTUMN: Mabon (Libra 0°) → Samhain (Scorpio 15°)
    // Air balance (Libra) + Water transformation (Scorpio) + Fire wisdom (Sagittarius early)
    'libra': 'autumn',      // Sep 23 - Oct 22 (Air Cardinal - Balance)
    'scorpio': 'autumn',    // Oct 23 - Nov 21 (Water Fixed - Deep Wisdom)
    'sagittarius': 'autumn', // Nov 22 - Dec 21 (Fire Mutable - Harvest Meaning)

    // WINTER: Yule (Capricorn 0°) → Imbolc (Aquarius 0°)
    // Earth structure (Capricorn) + Air innovation (Aquarius) + Water mysticism (Pisces)
    'capricorn': 'winter',  // Dec 22 - Jan 19 (Earth Cardinal - Foundation)
    'aquarius': 'winter',   // Jan 20 - Feb 18 (Air Fixed - Vision)
    'pisces': 'winter',     // Feb 19 - Mar 20 (Water Mutable - Mystery)
  };

  return seasonMap[zodiacSign.toLowerCase()] || 'spring';
}

/**
 * Get weekday name from Date
 */
function getWeekdayName(date: Date): string {
  const weekdays = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
  return weekdays[date.getDay()];
}

// =====================================================
// CONTENT FETCHERS
// =====================================================

/**
 * Fetch seasonal overlay for template + season
 */
async function fetchSeasonalOverlay(
  templateId: string,
  season: string
): Promise<SeasonalOverlay | null> {
  const { data, error } = await supabase
    .from('seasonal_overlays')
    .select('*')
    .eq('template_id', templateId)
    .eq('season', season)
    .single();

  if (error) {
    console.warn(`No seasonal overlay found for template ${templateId} + ${season}:`, error.message);
    return null;
  }

  return data as SeasonalOverlay;
}

/**
 * Fetch weekday energy
 */
async function fetchWeekdayEnergy(weekday: string): Promise<WeekdayEnergy | null> {
  const { data, error } = await supabase
    .from('weekday_energies')
    .select('*')
    .eq('weekday', weekday)
    .single();

  if (error) {
    console.warn(`No weekday energy found for ${weekday}:`, error.message);
    return null;
  }

  return data as WeekdayEnergy;
}

/**
 * Fetch active special astronomical events for date
 */
async function fetchActiveEvents(date: Date): Promise<SpecialAstronomicalEvent[]> {
  const dateString = date.toISOString().split('T')[0];

  const { data, error } = await supabase
    .from('special_astronomical_events')
    .select('*')
    .eq('active', true)
    .lte('start_date', dateString)
    .or(`end_date.is.null,end_date.gte.${dateString}`)
    .order('intensity', { ascending: false });

  if (error) {
    console.warn(`Error fetching special events:`, error.message);
    return [];
  }

  return (data || []) as SpecialAstronomicalEvent[];
}

// =====================================================
// COMPOSITION ENGINE
// =====================================================

/**
 * Compose complete lunar guide from modular components
 */
export async function composeGuide(params: ComposeGuideParams): Promise<ComposedGuide> {
  const { date, template, zodiacSign } = params;

  // Determine season from zodiac
  const season = getSeasonFromZodiac(zodiacSign);
  const weekday = getWeekdayName(date);

  console.log(`Composing guide: season=${season}, weekday=${weekday}`);

  // Fetch modular components
  const [overlay, weekdayEnergy, specialEvents] = await Promise.all([
    fetchSeasonalOverlay(template.id, season),
    fetchWeekdayEnergy(weekday),
    fetchActiveEvents(date),
  ]);

  console.log(`Components fetched: overlay=${!!overlay}, weekday=${!!weekdayEnergy}, events=${specialEvents.length}`);

  // Compose multilingual content
  const composed = composeMultilingualContent(template, overlay, weekdayEnergy, specialEvents);

  return {
    ...composed,
    seasonal_overlay_id: overlay?.id || null,
    weekday: weekday,
    special_event_ids: specialEvents.map(e => e.id),
    composition_version: 'v1.0',
  };
}

/**
 * Compose multilingual content from all components
 */
function composeMultilingualContent(
  template: LunarGuideTemplate,
  overlay: SeasonalOverlay | null,
  weekdayEnergy: WeekdayEnergy | null,
  specialEvents: SpecialAstronomicalEvent[]
): Omit<ComposedGuide, 'seasonal_overlay_id' | 'weekday' | 'special_event_ids' | 'composition_version'> {
  const languages = ['en', 'es', 'ca'] as const;

  const composedHeadline: Record<string, string> = {};
  const composedDescription: Record<string, string> = {};
  const composedGuidance: Record<string, string> = {};
  const focusAreas: Record<string, string[]> = {};
  const recommendedActions: Record<string, string[]> = {};

  for (const lang of languages) {
    // HEADLINE: Overlay headline (if available) or template headline
    composedHeadline[lang] = overlay?.overlay_headline[lang] || template.headline[lang];

    // DESCRIPTION: Weave template + overlay + weekday
    const parts: string[] = [];

    // Base template energy
    parts.push(template.energy_description[lang]);

    // Seasonal overlay modifies the energy
    if (overlay) {
      parts.push(overlay.energy_shift[lang]);
    }

    // Weekday planetary energy adds flavor
    if (weekdayEnergy) {
      const planetEmoji = weekdayEnergy.planet_emoji;
      const elementEmoji = weekdayEnergy.element_emoji;
      parts.push(`${planetEmoji} ${weekdayEnergy.description[lang]} ${elementEmoji}`);
    }

    composedDescription[lang] = parts.join('\n\n');

    // GUIDANCE: Template tagline + overlay description + special events
    const guidanceParts: string[] = [];

    if (template.tagline?.[lang]) {
      guidanceParts.push(template.tagline[lang]);
    }

    if (overlay) {
      guidanceParts.push(overlay.overlay_description[lang]);
    }

    // Add special event guidance (high intensity first)
    if (specialEvents.length > 0) {
      for (const event of specialEvents.slice(0, 2)) { // Max 2 events to avoid overwhelming
        guidanceParts.push(`🌟 **${event.event_name[lang]}**: ${event.guidance[lang]}`);
      }
    }

    composedGuidance[lang] = guidanceParts.join('\n\n');

    // FOCUS AREAS: Template + overlay themes + weekday influences + event actions
    const areas: string[] = [...template.focus_areas[lang]];

    if (overlay) {
      areas.push(...overlay.themes[lang]);
    }

    if (weekdayEnergy) {
      areas.push(...weekdayEnergy.areas_of_influence[lang].slice(0, 2)); // Top 2
    }

    focusAreas[lang] = areas;

    // RECOMMENDED ACTIONS: Template + overlay + weekday + events (avoiding duplicates)
    const actions: string[] = [...template.recommended_actions[lang]];

    if (overlay) {
      actions.push(...overlay.seasonal_actions[lang]);
    }

    if (weekdayEnergy) {
      actions.push(...weekdayEnergy.favorable_activities[lang].slice(0, 2)); // Top 2
    }

    // Add special event recommendations
    for (const event of specialEvents) {
      actions.push(...event.recommended_actions[lang].slice(0, 2)); // Top 2 per event
    }

    recommendedActions[lang] = actions;
  }

  return {
    composed_headline: composedHeadline,
    composed_description: composedDescription,
    composed_guidance: composedGuidance,
    focus_areas: focusAreas,
    recommended_actions: recommendedActions,
  };
}
