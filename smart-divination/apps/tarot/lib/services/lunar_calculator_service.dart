import 'dart:math' as math;

/// Lunar phase calculation data
class LunarPhaseData {
  final double phase; // 0-1 (0 = new moon, 0.5 = full moon)
  final double age; // Age in days (0-29.53)
  final double illumination; // Percentage illuminated (0-100)
  final String name; // Human-readable phase name

  const LunarPhaseData({
    required this.phase,
    required this.age,
    required this.illumination,
    required this.name,
  });
}

/// Service for calculating lunar phases and zodiac positions
/// Mirrors the logic in the Edge Function for consistency
class LunarCalculatorService {
  static const double _lunarMonth = 29.53058867; // Average lunar month in days
  static final DateTime _knownNewMoon =
      DateTime.utc(2000, 1, 6, 18, 14); // Known new moon reference

  /// Calculate lunar phase for a given date
  LunarPhaseData calculateLunarPhase(DateTime date) {
    // Calculate days since known new moon
    final daysSince =
        date.difference(_knownNewMoon).inMilliseconds / (1000 * 60 * 60 * 24);

    // Calculate current lunar age (days into current cycle)
    final age = daysSince % _lunarMonth;

    // Calculate phase (0-1)
    final phase = age / _lunarMonth;

    // Calculate illumination percentage
    final illumination = (1 - math.cos(phase * 2 * math.pi)) * 50;

    // Determine phase name
    final name = _getPhaseName(phase);

    return LunarPhaseData(
      phase: phase,
      age: age,
      illumination: illumination,
      name: name,
    );
  }

  /// Convert phase (0-1) to human-readable phase name
  String _getPhaseName(double phase) {
    if (phase < 0.033 || phase >= 0.967) return 'New Moon';
    if (phase < 0.216) return 'Waxing Crescent';
    if (phase < 0.283) return 'First Quarter';
    if (phase < 0.467) return 'Waxing Gibbous';
    if (phase < 0.533) return 'Full Moon';
    if (phase < 0.716) return 'Waning Gibbous';
    if (phase < 0.783) return 'Last Quarter';
    return 'Waning Crescent';
  }

  /// Convert phase to phase_id for database lookup
  String getPhaseId(double phase) {
    if (phase < 0.033 || phase >= 0.967) return 'new_moon';
    if (phase < 0.216) return 'waxing_crescent';
    if (phase < 0.283) return 'first_quarter';
    if (phase < 0.467) return 'waxing_gibbous';
    if (phase < 0.533) return 'full_moon';
    if (phase < 0.716) return 'waning_gibbous';
    if (phase < 0.783) return 'last_quarter';
    return 'waning_crescent';
  }

  /// Calculate zodiac sign for moon position on a given date
  /// Simplified calculation based on solar zodiac + lunar offset
  /// For production, consider using astronomy library for precise moon position
  String getZodiacSign(DateTime date) {
    final month = date.month;
    final day = date.day;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return 'aries';
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return 'taurus';
    }
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return 'gemini';
    }
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return 'cancer';
    }
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'leo';
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return 'virgo';
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return 'libra';
    }
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return 'scorpio';
    }
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return 'sagittarius';
    }
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return 'capricorn';
    }
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return 'aquarius';
    }
    return 'pisces';
  }

  /// Get element from zodiac sign
  String getElementFromZodiac(String zodiacSign) {
    const fireSigns = ['aries', 'leo', 'sagittarius'];
    const earthSigns = ['taurus', 'virgo', 'capricorn'];
    const airSigns = ['gemini', 'libra', 'aquarius'];
    const waterSigns = ['cancer', 'scorpio', 'pisces'];

    if (fireSigns.contains(zodiacSign)) return 'fire';
    if (earthSigns.contains(zodiacSign)) return 'earth';
    if (airSigns.contains(zodiacSign)) return 'air';
    if (waterSigns.contains(zodiacSign)) return 'water';

    // Fallback
    return 'fire';
  }

  /// Get element icon
  String getElementIcon(String element) {
    switch (element) {
      case 'fire':
        return '🔥';
      case 'earth':
        return '🌍';
      case 'air':
        return '💨';
      case 'water':
        return '💧';
      default:
        return '✨';
    }
  }

  /// Get zodiac emoji
  String getZodiacEmoji(String zodiacSign) {
    switch (zodiacSign) {
      case 'aries':
        return '♈';
      case 'taurus':
        return '♉';
      case 'gemini':
        return '♊';
      case 'cancer':
        return '♋';
      case 'leo':
        return '♌';
      case 'virgo':
        return '♍';
      case 'libra':
        return '♎';
      case 'scorpio':
        return '♏';
      case 'sagittarius':
        return '♐';
      case 'capricorn':
        return '♑';
      case 'aquarius':
        return '♒';
      case 'pisces':
        return '♓';
      default:
        return '⭐';
    }
  }

  /// Get phase emoji
  String getPhaseEmoji(String phaseId) {
    switch (phaseId) {
      case 'new_moon':
        return '🌑';
      case 'waxing_crescent':
        return '🌒';
      case 'first_quarter':
        return '🌓';
      case 'waxing_gibbous':
        return '🌔';
      case 'full_moon':
        return '🌕';
      case 'waning_gibbous':
        return '🌖';
      case 'last_quarter':
        return '🌗';
      case 'waning_crescent':
        return '🌘';
      default:
        return '🌙';
    }
  }

  /// Get human-readable zodiac name
  String getZodiacName(String zodiacSign) {
    return zodiacSign[0].toUpperCase() + zodiacSign.substring(1);
  }

  /// Get human-readable element name
  String getElementName(String element) {
    return element[0].toUpperCase() + element.substring(1);
  }
}
