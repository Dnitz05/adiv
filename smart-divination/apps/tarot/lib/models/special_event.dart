/// Model for Special Moon Events
/// Eclipses, supermoons, blue moons and other rare lunar phenomena

class SpecialEvent {
  final String id;
  final String icon;
  final String name;
  final Map<String, String> localizedNames;
  final String type; // 'eclipse', 'phenomenon', 'astrological'
  final Map<String, String> scientificExplanation;
  final Map<String, String> astrologicalMeaning;
  final Map<String, String> description;
  final Map<String, List<String>> spiritualThemes;
  final Map<String, List<String>> practices;
  final Map<String, List<String>> whatToAvoid;
  final String frequency; // How often it occurs
  final String color;
  final String intensity; // 'high', 'medium', 'low'

  const SpecialEvent({
    required this.id,
    required this.icon,
    required this.name,
    required this.localizedNames,
    required this.type,
    required this.scientificExplanation,
    required this.astrologicalMeaning,
    required this.description,
    required this.spiritualThemes,
    required this.practices,
    required this.whatToAvoid,
    required this.frequency,
    required this.color,
    required this.intensity,
  });

  String getLocalizedName(String locale) {
    return localizedNames[locale] ?? localizedNames['en'] ?? name;
  }

  String getScientificExplanation(String locale) {
    return scientificExplanation[locale] ?? scientificExplanation['en'] ?? '';
  }

  String getAstrologicalMeaning(String locale) {
    return astrologicalMeaning[locale] ?? astrologicalMeaning['en'] ?? '';
  }

  String getDescription(String locale) {
    return description[locale] ?? description['en'] ?? '';
  }

  List<String> getSpiritualThemes(String locale) {
    return spiritualThemes[locale] ?? spiritualThemes['en'] ?? [];
  }

  List<String> getPractices(String locale) {
    return practices[locale] ?? practices['en'] ?? [];
  }

  List<String> getWhatToAvoid(String locale) {
    return whatToAvoid[locale] ?? whatToAvoid['en'] ?? [];
  }
}
