/// Models for Wisdom & Tradition learning journey content
///
/// This file defines the structure for all educational content
/// in the "Wisdom & Tradition" section of the Learn tab.

/// Represents a single lesson in the Wisdom & Tradition journey
class WisdomLesson {
  final String id;
  final String categoryId;
  final int order; // 1-indexed order within category
  final String icon; // emoji icon for the lesson
  final Map<String, String> title; // {'en': '...', 'es': '...', 'ca': '...'}
  final Map<String, String> subtitle; // Short description
  final Map<String, String> content; // Full markdown content
  final Map<String, List<String>> keyPoints; // Bullet point summaries
  final Map<String, List<String>> traditions; // Source references
  final Map<String, List<String>>?
      furtherReading; // Optional further reading
  final String? imageUrl; // Optional illustration
  final int estimatedMinutes; // Reading time estimate
  final String difficulty; // 'beginner', 'intermediate', 'advanced'

  const WisdomLesson({
    required this.id,
    required this.categoryId,
    required this.order,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.keyPoints,
    required this.traditions,
    this.furtherReading,
    this.imageUrl,
    required this.estimatedMinutes,
    required this.difficulty,
  });

  // Getters for localized content
  String getTitle(String locale) => title[locale] ?? title['en'] ?? '';

  String getSubtitle(String locale) =>
      subtitle[locale] ?? subtitle['en'] ?? '';

  String getContent(String locale) => content[locale] ?? content['en'] ?? '';

  List<String> getKeyPoints(String locale) =>
      keyPoints[locale] ?? keyPoints['en'] ?? [];

  List<String> getTraditions(String locale) =>
      traditions[locale] ?? traditions['en'] ?? [];

  List<String> getFurtherReading(String locale) =>
      furtherReading?[locale] ?? furtherReading?['en'] ?? [];

  // Difficulty helpers
  bool get isBeginner => difficulty == 'beginner';
  bool get isIntermediate => difficulty == 'intermediate';
  bool get isAdvanced => difficulty == 'advanced';

  String getDifficultyLabel(String locale) {
    switch (difficulty) {
      case 'beginner':
        return locale == 'ca'
            ? 'Principiant'
            : locale == 'es'
                ? 'Principiante'
                : 'Beginner';
      case 'intermediate':
        return locale == 'ca'
            ? 'Intermedi'
            : locale == 'es'
                ? 'Intermedio'
                : 'Intermediate';
      case 'advanced':
        return locale == 'ca'
            ? 'Avançat'
            : locale == 'es'
                ? 'Avanzado'
                : 'Advanced';
      default:
        return '';
    }
  }
}

/// Represents a category in the Wisdom & Tradition journey
class WisdomTraditionCategory {
  final String id;
  final String icon; // emoji icon for the category
  final Map<String, String> title; // {'en': '...', 'es': '...', 'ca': '...'}
  final Map<String, String> subtitle; // Short description
  final Map<String, String> description; // Longer description
  final String color; // Hex color for theming
  final int lessonCount; // Total number of lessons
  final List<String> lessonIds; // IDs of lessons in this category

  const WisdomTraditionCategory({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.lessonCount,
    required this.lessonIds,
  });

  // Getters for localized content
  String getTitle(String locale) => title[locale] ?? title['en'] ?? '';

  String getSubtitle(String locale) =>
      subtitle[locale] ?? subtitle['en'] ?? '';

  String getDescription(String locale) =>
      description[locale] ?? description['en'] ?? '';
}

/// Overall journey metadata
class WisdomTraditionJourney {
  final String id = 'wisdom_tradition';
  final String icon = '📚';
  final Map<String, String> title = const {
    'en': 'Wisdom & Tradition',
    'es': 'Sabiduría y Tradición',
    'ca': 'Saviesa i Tradició',
  };
  final Map<String, String> description = const {
    'en':
        'Discover the millenary history of tarot. From its origins to contemporary practice, with ethics and respect.',
    'es':
        'Descubre la historia milenaria del tarot. Desde sus orígenes hasta la práctica contemporánea, con ética y respeto.',
    'ca':
        'Descobreix la història mil·lenària del tarot. Des dels seus orígens fins a la pràctica contemporània, amb ètica i respecte.',
  };
  final int totalLessons = 43;
  final int totalCategories = 6;

  const WisdomTraditionJourney();

  String getTitle(String locale) => title[locale] ?? title['en'] ?? '';

  String getDescription(String locale) =>
      description[locale] ?? description['en'] ?? '';
}
