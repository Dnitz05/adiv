/// Base model for all educational content in Lunar Academy
class EducationalContent {
  final String id;
  final String icon; // emoji or icon name
  final Map<String, String> title;
  final Map<String, String> description;
  final Map<String, String>? detailedContent;
  final Map<String, List<String>>? keyPoints;
  final Map<String, List<String>>? traditions;
  final String? color; // hex color for theming
  final List<String>? relatedTopics;

  const EducationalContent({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    this.detailedContent,
    this.keyPoints,
    this.traditions,
    this.color,
    this.relatedTopics,
  });

  String getTitle(String locale) =>
      title[locale] ?? title['en'] ?? '';

  String getDescription(String locale) =>
      description[locale] ?? description['en'] ?? '';

  String? getDetailedContent(String locale) =>
      detailedContent?[locale] ?? detailedContent?['en'];

  List<String> getKeyPoints(String locale) =>
      keyPoints?[locale] ?? keyPoints?['en'] ?? [];

  List<String> getTraditions(String locale) =>
      traditions?[locale] ?? traditions?['en'] ?? [];
}

/// Category in the Lunar Academy
class LunarAcademyCategory {
  final String id;
  final String icon;
  final Map<String, String> title;
  final Map<String, String> subtitle;
  final String color;
  final int itemCount;

  const LunarAcademyCategory({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.itemCount,
  });

  String getTitle(String locale) =>
      title[locale] ?? title['en'] ?? '';

  String getSubtitle(String locale) =>
      subtitle[locale] ?? subtitle['en'] ?? '';
}
