/// Models for Seasonal Wisdom content in Lunar Academy
/// Based on Wheel of the Year traditions

class Season {
  final String id;
  final String icon;
  final String name;
  final Map<String, String> localizedNames;
  final Map<String, String> archetype;
  final Map<String, String> description;
  final Map<String, String> energy;
  final Map<String, List<String>> themes;
  final Map<String, List<String>> zodiacSigns;
  final Map<String, List<String>> elements;
  final String color;
  final List<String> sabbatIds; // IDs of Sabbats in this season

  const Season({
    required this.id,
    required this.icon,
    required this.name,
    required this.localizedNames,
    required this.archetype,
    required this.description,
    required this.energy,
    required this.themes,
    required this.zodiacSigns,
    required this.elements,
    required this.color,
    required this.sabbatIds,
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

  String getEnergy(String locale) {
    return energy[locale] ?? energy['en'] ?? '';
  }

  List<String> getThemes(String locale) {
    return themes[locale] ?? themes['en'] ?? [];
  }

  List<String> getZodiacSigns(String locale) {
    return zodiacSigns[locale] ?? zodiacSigns['en'] ?? [];
  }

  List<String> getElements(String locale) {
    return elements[locale] ?? elements['en'] ?? [];
  }
}

class Sabbat {
  final String id;
  final String icon;
  final String name;
  final Map<String, String> localizedNames;
  final String type; // 'solar' or 'fire'
  final String date; // Approximate date (e.g., "~21 December")
  final Map<String, String> astrological; // Sol enters sign
  final String element;
  final String modality;
  final Map<String, String> meaning;
  final Map<String, String> description;
  final Map<String, List<String>> traditions;
  final Map<String, List<String>> themes;
  final String color;
  final String seasonId; // Which season this belongs to

  const Sabbat({
    required this.id,
    required this.icon,
    required this.name,
    required this.localizedNames,
    required this.type,
    required this.date,
    required this.astrological,
    required this.element,
    required this.modality,
    required this.meaning,
    required this.description,
    required this.traditions,
    required this.themes,
    required this.color,
    required this.seasonId,
  });

  String getLocalizedName(String locale) {
    return localizedNames[locale] ?? localizedNames['en'] ?? name;
  }

  String getAstrological(String locale) {
    return astrological[locale] ?? astrological['en'] ?? '';
  }

  String getMeaning(String locale) {
    return meaning[locale] ?? meaning['en'] ?? '';
  }

  String getDescription(String locale) {
    return description[locale] ?? description['en'] ?? '';
  }

  List<String> getTraditions(String locale) {
    return traditions[locale] ?? traditions['en'] ?? [];
  }

  List<String> getThemes(String locale) {
    return themes[locale] ?? themes['en'] ?? [];
  }

  bool get isSolarFestival => type == 'solar';
}
