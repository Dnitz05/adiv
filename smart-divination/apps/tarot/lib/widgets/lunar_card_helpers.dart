import 'package:flutter/material.dart';
import '../models/lunar_day.dart';
import '../theme/tarot_theme.dart';
import '../l10n/lunar/lunar_translations.dart';

/// UI Helpers for Lunar cards and widgets
class LunarCardHelpers {
  /// Builds a white card container with consistent styling
  static Widget buildWhiteCard({
    required BuildContext context,
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }

  /// Builds a badge widget with background color and text
  static Widget buildBadge({
    required String text,
    required Color backgroundColor,
    Color? textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? TarotTheme.deepNavy,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Card title text style
  static const TextStyle cardTitleStyle = TextStyle(
    color: TarotTheme.deepNavy,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );

  /// Card body text style
  static const TextStyle cardBodyStyle = TextStyle(
    color: TarotTheme.softBlueGrey,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Card small text style
  static const TextStyle cardSmallStyle = TextStyle(
    color: TarotTheme.softBlueGrey,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  /// Card subtitle text style (used by history panels)
  static const TextStyle cardSubtitleStyle = TextStyle(
    color: TarotTheme.softBlueGrey,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  /// Builds a card with a header and content
  static Widget buildCardWithHeader({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: cardTitleStyle,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: cardSubtitleStyle,
            ),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

}

/// Returns whether moon is waxing (creixent) or waning (minvant)
String getMoonTrend(double phaseAngle, String locale) {
  // 0° to 180° = Waxing, 180° to 360° = Waning
  final key = phaseAngle < 180 ? 'waxing' : 'waning';
  return getMoonTrendLabel(key, locale);
}

/// Returns the zodiac quality (Cardinal, Fixed, Mutable)
String getZodiacQuality(String zodiacId, String locale) {
  const cardinal = ['aries', 'cancer', 'libra', 'capricorn'];
  const fixed = ['taurus', 'leo', 'scorpio', 'aquarius'];
  const mutable = ['gemini', 'virgo', 'sagittarius', 'pisces'];

  final id = zodiacId.toLowerCase();
  if (cardinal.contains(id)) return getZodiacQualityLabel('cardinal', locale);
  if (fixed.contains(id)) return getZodiacQualityLabel('fixed', locale);
  if (mutable.contains(id)) return getZodiacQualityLabel('mutable', locale);
  return '';
}

/// Returns the zodiac polarity (Yang/Yin based on element)
String getZodiacPolarity(String element, String locale) {
  const yang = ['fire', 'air', 'foc', 'aire'];
  const yin = ['earth', 'water', 'terra', 'aigua'];

  final el = element.toLowerCase();
  if (yang.contains(el)) return getPolarityLabel('yang', locale);
  if (yin.contains(el)) return getPolarityLabel('yin', locale);
  return '';
}

/// Returns the ruling planet for a zodiac sign
String getRulingPlanet(String zodiacId) {
  const rulers = {
    'aries': 'Mars',
    'taurus': 'Venus',
    'gemini': 'Mercury',
    'cancer': 'Moon',
    'leo': 'Sun',
    'virgo': 'Mercury',
    'libra': 'Venus',
    'scorpio': 'Pluto',
    'sagittarius': 'Jupiter',
    'capricorn': 'Saturn',
    'aquarius': 'Uranus',
    'pisces': 'Neptune',
  };

  return rulers[zodiacId.toLowerCase()] ?? '';
}

/// Calculates days until next major phase (New, First Quarter, Full, Last Quarter)
int getDaysToNextPhase(double age) {
  // Lunar cycle phases occur at:
  // New Moon: 0 days
  // First Quarter: 7.4 days
  // Full Moon: 14.8 days
  // Last Quarter: 22.1 days
  // New Moon: 29.5 days

  const phases = [0.0, 7.4, 14.8, 22.1, 29.5];

  for (final phase in phases) {
    if (age < phase) {
      return (phase - age).ceil();
    }
  }

  // If past last quarter, calculate days to new moon
  return (29.5 - age).ceil();
}

/// Returns the name of the next phase
String getNextPhaseName(double age, String locale) {
  if (age < 7.4) return getNextPhaseLabel('first_quarter', locale);
  if (age < 14.8) return getNextPhaseLabel('full_moon', locale);
  if (age < 22.1) return getNextPhaseLabel('last_quarter', locale);
  return getNextPhaseLabel('new_moon', locale);
}

/// Helper to get complete lunar info for display
class LunarInfoHelper {
  final LunarDayModel day;
  final String locale;

  LunarInfoHelper(this.day, this.locale);

  String get trend => getMoonTrend(day.phaseAngle, locale);
  String get quality => getZodiacQuality(day.zodiac.id, locale);
  String get polarity => getZodiacPolarity(day.zodiac.element, locale);
  String get ruler => getRulingPlanet(day.zodiac.id);
  int get daysToNext => getDaysToNextPhase(day.age);
  String get nextPhase => getNextPhaseName(day.age, locale);
}
