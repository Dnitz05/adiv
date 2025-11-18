/// Model for Planetary Days - The 7 weekdays and their celestial rulers
/// Based on the Chaldean order and traditional correspondences

class PlanetaryDay {
  final String id;
  final String weekday; // 'sunday', 'monday', etc.
  final String planet; // 'Sun', 'Moon', etc.
  final String icon; // Planet emoji
  final Map<String, String> localizedNames;
  final String element;
  final Map<String, String> themes;
  final Map<String, List<String>> activities; // Recommended activities
  final Map<String, List<String>> qualities; // Planetary qualities
  final String color;
  final String tarotCard; // Associated Major Arcana
  final int tarotNumber; // Card number
  final Map<String, String> description;
  final Map<String, String> energyDescription;

  const PlanetaryDay({
    required this.id,
    required this.weekday,
    required this.planet,
    required this.icon,
    required this.localizedNames,
    required this.element,
    required this.themes,
    required this.activities,
    required this.qualities,
    required this.color,
    required this.tarotCard,
    required this.tarotNumber,
    required this.description,
    required this.energyDescription,
  });

  String getLocalizedName(String locale) {
    return localizedNames[locale] ?? localizedNames['en'] ?? weekday;
  }

  String getThemes(String locale) {
    return themes[locale] ?? themes['en'] ?? '';
  }

  List<String> getActivities(String locale) {
    return activities[locale] ?? activities['en'] ?? [];
  }

  List<String> getQualities(String locale) {
    return qualities[locale] ?? qualities['en'] ?? [];
  }

  String getDescription(String locale) {
    return description[locale] ?? description['en'] ?? '';
  }

  String getEnergyDescription(String locale) {
    return energyDescription[locale] ?? energyDescription['en'] ?? '';
  }

  /// Get the day of week index (0 = Sunday, 6 = Saturday)
  int get dayOfWeekIndex {
    switch (weekday) {
      case 'sunday':
        return 0;
      case 'monday':
        return 1;
      case 'tuesday':
        return 2;
      case 'wednesday':
        return 3;
      case 'thursday':
        return 4;
      case 'friday':
        return 5;
      case 'saturday':
        return 6;
      default:
        return 0;
    }
  }

  /// Check if this is today's planetary day
  bool get isToday {
    final now = DateTime.now();
    // DateTime.weekday uses Monday = 1, Sunday = 7
    // We need to convert to our 0-6 system where Sunday = 0
    final todayIndex = now.weekday == 7 ? 0 : now.weekday;
    final ourIndex = dayOfWeekIndex == 0 ? 7 : dayOfWeekIndex;
    return todayIndex == ourIndex;
  }
}
