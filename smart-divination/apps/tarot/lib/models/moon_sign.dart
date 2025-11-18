/// Model for Moon in Zodiac Signs
/// Each sign represents how the Moon expresses emotions and intuition

class MoonSign {
  final String id;
  final String name;
  final String symbol; // ♈, ♉, etc.
  final String icon;
  final Map<String, String> localizedNames;
  final String element; // Fire, Earth, Air, Water
  final String modality; // Cardinal, Fixed, Mutable
  final String rulingPlanet;
  final Map<String, String> archetype;
  final Map<String, String> description;
  final Map<String, String> emotionalNature;
  final Map<String, List<String>> moonQualities; // How emotions are expressed
  final Map<String, List<String>> bestActivities; // What to do when Moon is in this sign
  final String tarotCard; // Associated Major Arcana
  final int tarotNumber;
  final String color;
  final String dateRange; // Approximate sun transit dates

  const MoonSign({
    required this.id,
    required this.name,
    required this.symbol,
    required this.icon,
    required this.localizedNames,
    required this.element,
    required this.modality,
    required this.rulingPlanet,
    required this.archetype,
    required this.description,
    required this.emotionalNature,
    required this.moonQualities,
    required this.bestActivities,
    required this.tarotCard,
    required this.tarotNumber,
    required this.color,
    required this.dateRange,
  });

  String getLocalizedName(String locale) {
    return localizedNames[locale] ?? localizedNames['en'] ?? name;
  }

  String getArchetype(String locale) {
    return archetype[locale] ?? archetype['en'] ?? '';
  }

  String getDescription(String locale) {
    return description[locale] ?? description['en'] ?? '';
  }

  String getEmotionalNature(String locale) {
    return emotionalNature[locale] ?? emotionalNature['en'] ?? '';
  }

  List<String> getMoonQualities(String locale) {
    return moonQualities[locale] ?? moonQualities['en'] ?? [];
  }

  List<String> getBestActivities(String locale) {
    return bestActivities[locale] ?? bestActivities['en'] ?? [];
  }

  /// Check if this is the current sun sign (approximately)
  bool get isCurrentSunSign {
    final now = DateTime.now();
    final month = now.month;
    final day = now.day;

    // Very approximate date ranges
    switch (id) {
      case 'aries':
        return (month == 3 && day >= 21) || (month == 4 && day <= 19);
      case 'taurus':
        return (month == 4 && day >= 20) || (month == 5 && day <= 20);
      case 'gemini':
        return (month == 5 && day >= 21) || (month == 6 && day <= 20);
      case 'cancer':
        return (month == 6 && day >= 21) || (month == 7 && day <= 22);
      case 'leo':
        return (month == 7 && day >= 23) || (month == 8 && day <= 22);
      case 'virgo':
        return (month == 8 && day >= 23) || (month == 9 && day <= 22);
      case 'libra':
        return (month == 9 && day >= 23) || (month == 10 && day <= 22);
      case 'scorpio':
        return (month == 10 && day >= 23) || (month == 11 && day <= 21);
      case 'sagittarius':
        return (month == 11 && day >= 22) || (month == 12 && day <= 21);
      case 'capricorn':
        return (month == 12 && day >= 22) || (month == 1 && day <= 19);
      case 'aquarius':
        return (month == 1 && day >= 20) || (month == 2 && day <= 18);
      case 'pisces':
        return (month == 2 && day >= 19) || (month == 3 && day <= 20);
      default:
        return false;
    }
  }
}
