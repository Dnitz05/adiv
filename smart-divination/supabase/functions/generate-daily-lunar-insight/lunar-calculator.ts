// Lunar Phase and Zodiac Calculation
// Based on astronomical algorithms

export interface LunarPhaseData {
  phase: number; // 0-1 (0 = new moon, 0.5 = full moon)
  age: number; // Age in days (0-29.53)
  illumination: number; // Percentage illuminated (0-100)
  name: string; // Human-readable phase name
}

const LUNAR_MONTH = 29.53058867; // Average lunar month in days
const KNOWN_NEW_MOON = new Date('2000-01-06T18:14:00Z'); // Known new moon reference

/**
 * Calculate lunar phase for a given date
 */
export function calculateLunarPhase(date: Date): LunarPhaseData {
  // Calculate days since known new moon
  const daysSince = (date.getTime() - KNOWN_NEW_MOON.getTime()) / (1000 * 60 * 60 * 24);

  // Calculate current lunar age (days into current cycle)
  const age = daysSince % LUNAR_MONTH;

  // Calculate phase (0-1)
  const phase = age / LUNAR_MONTH;

  // Calculate illumination percentage
  const illumination = (1 - Math.cos(phase * 2 * Math.PI)) * 50;

  // Determine phase name
  const name = getPhaseName(phase);

  return {
    phase,
    age,
    illumination,
    name,
  };
}

/**
 * Convert phase (0-1) to phase name
 */
function getPhaseName(phase: number): string {
  if (phase < 0.033 || phase >= 0.967) return 'New Moon';
  if (phase < 0.216) return 'Waxing Crescent';
  if (phase < 0.283) return 'First Quarter';
  if (phase < 0.467) return 'Waxing Gibbous';
  if (phase < 0.533) return 'Full Moon';
  if (phase < 0.716) return 'Waning Gibbous';
  if (phase < 0.783) return 'Last Quarter';
  return 'Waning Crescent';
}

/**
 * Convert phase name to phase_id for database
 */
export function getLunarPhaseId(phase: number): string {
  if (phase < 0.033 || phase >= 0.967) return 'new_moon';
  if (phase < 0.216) return 'waxing_crescent';
  if (phase < 0.283) return 'first_quarter';
  if (phase < 0.467) return 'waxing_gibbous';
  if (phase < 0.533) return 'full_moon';
  if (phase < 0.716) return 'waning_gibbous';
  if (phase < 0.783) return 'last_quarter';
  return 'waning_crescent';
}

/**
 * Calculate zodiac sign for moon position on a given date
 * Simplified calculation based on solar zodiac + lunar offset
 * For production, consider using astronomy library for precise moon position
 */
export function getZodiacSign(date: Date): string {
  // Get month and day
  const month = date.getMonth() + 1; // 1-12
  const day = date.getDate();

  // Approximate lunar zodiac based on solar zodiac
  // Moon moves through zodiac ~2.5 days per sign
  // This is a simplified approximation

  if ((month === 3 && day >= 21) || (month === 4 && day <= 19)) return 'aries';
  if ((month === 4 && day >= 20) || (month === 5 && day <= 20)) return 'taurus';
  if ((month === 5 && day >= 21) || (month === 6 && day <= 20)) return 'gemini';
  if ((month === 6 && day >= 21) || (month === 7 && day <= 22)) return 'cancer';
  if ((month === 7 && day >= 23) || (month === 8 && day <= 22)) return 'leo';
  if ((month === 8 && day >= 23) || (month === 9 && day <= 22)) return 'virgo';
  if ((month === 9 && day >= 23) || (month === 10 && day <= 22)) return 'libra';
  if ((month === 10 && day >= 23) || (month === 11 && day <= 21)) return 'scorpio';
  if ((month === 11 && day >= 22) || (month === 12 && day <= 21)) return 'sagittarius';
  if ((month === 12 && day >= 22) || (month === 1 && day <= 19)) return 'capricorn';
  if ((month === 1 && day >= 20) || (month === 2 && day <= 18)) return 'aquarius';
  return 'pisces';
}

/**
 * Get element from zodiac sign
 */
export function getElementFromZodiac(zodiacSign: string): string {
  const fireSigns = ['aries', 'leo', 'sagittarius'];
  const earthSigns = ['taurus', 'virgo', 'capricorn'];
  const airSigns = ['gemini', 'libra', 'aquarius'];
  const waterSigns = ['cancer', 'scorpio', 'pisces'];

  if (fireSigns.includes(zodiacSign)) return 'fire';
  if (earthSigns.includes(zodiacSign)) return 'earth';
  if (airSigns.includes(zodiacSign)) return 'air';
  if (waterSigns.includes(zodiacSign)) return 'water';

  // Fallback
  return 'fire';
}
