/// Model for Lunar Elements - The 4 classical elements
/// Each element governs 3 zodiac signs and connects to tarot

class LunarElement {
  final String id;
  final String name;
  final String icon;
  final Map<String, String> localizedNames;
  final Map<String, String> description;
  final Map<String, List<String>> zodiacSigns; // 3 signs per element
  final Map<String, List<String>> modalities; // Cardinal, Fixed, Mutable
  final Map<String, List<String>> qualities; // Element characteristics
  final Map<String, List<String>> moonInfluence; // What happens when Moon is in this element
  final String tarotSuit;
  final String color;
  final Map<String, String> energyDescription;

  const LunarElement({
    required this.id,
    required this.name,
    required this.icon,
    required this.localizedNames,
    required this.description,
    required this.zodiacSigns,
    required this.modalities,
    required this.qualities,
    required this.moonInfluence,
    required this.tarotSuit,
    required this.color,
    required this.energyDescription,
  });

  String getLocalizedName(String locale) {
    return localizedNames[locale] ?? localizedNames['en'] ?? name;
  }

  String getDescription(String locale) {
    return description[locale] ?? description['en'] ?? '';
  }

  List<String> getZodiacSigns(String locale) {
    return zodiacSigns[locale] ?? zodiacSigns['en'] ?? [];
  }

  List<String> getModalities(String locale) {
    return modalities[locale] ?? modalities['en'] ?? [];
  }

  List<String> getQualities(String locale) {
    return qualities[locale] ?? qualities['en'] ?? [];
  }

  List<String> getMoonInfluence(String locale) {
    return moonInfluence[locale] ?? moonInfluence['en'] ?? [];
  }

  String getEnergyDescription(String locale) {
    return energyDescription[locale] ?? energyDescription['en'] ?? '';
  }
}
