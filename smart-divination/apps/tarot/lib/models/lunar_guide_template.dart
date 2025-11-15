/// Model for lunar guide base templates
/// Contains foundational astrological guidance for lunar phases
class LunarGuideTemplate {
  final String id;
  final String phaseId;
  final String? element;
  final String? zodiacSign;

  final Map<String, String> headline;
  final Map<String, String>? tagline;

  final Map<String, List<String>> focusAreas;
  final Map<String, String> energyDescription;

  final Map<String, List<String>> recommendedActions;
  final Map<String, List<String>>? journalPrompts;

  final int priority;
  final bool active;

  const LunarGuideTemplate({
    required this.id,
    required this.phaseId,
    this.element,
    this.zodiacSign,
    required this.headline,
    this.tagline,
    required this.focusAreas,
    required this.energyDescription,
    required this.recommendedActions,
    this.journalPrompts,
    this.priority = 0,
    this.active = true,
  });

  factory LunarGuideTemplate.fromJson(Map<String, dynamic> json) {
    return LunarGuideTemplate(
      id: json['id'] as String,
      phaseId: json['phase_id'] as String,
      element: json['element'] as String?,
      zodiacSign: json['zodiac_sign'] as String?,
      headline: Map<String, String>.from(json['headline'] as Map),
      tagline: json['tagline'] != null
          ? Map<String, String>.from(json['tagline'] as Map)
          : null,
      focusAreas: _parseStringListMap(json['focus_areas']),
      energyDescription: Map<String, String>.from(
        json['energy_description'] as Map,
      ),
      recommendedActions: _parseStringListMap(json['recommended_actions']),
      journalPrompts: json['journal_prompts'] != null
          ? _parseStringListMap(json['journal_prompts'])
          : null,
      priority: json['priority'] as int? ?? 0,
      active: json['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phase_id': phaseId,
      'element': element,
      'zodiac_sign': zodiacSign,
      'headline': headline,
      'tagline': tagline,
      'focus_areas': focusAreas,
      'energy_description': energyDescription,
      'recommended_actions': recommendedActions,
      'journal_prompts': journalPrompts,
      'priority': priority,
      'active': active,
    };
  }

  /// Helper to parse Map<String, List<String>> from JSON
  static Map<String, List<String>> _parseStringListMap(dynamic json) {
    final map = json as Map;
    return map.map(
      (key, value) => MapEntry(
        key as String,
        (value as List).map((e) => e as String).toList(),
      ),
    );
  }

  // Localized getters

  String getHeadline(String locale) =>
      headline[locale] ?? headline['en'] ?? '';

  String? getTagline(String locale) =>
      tagline?[locale] ?? tagline?['en'];

  List<String> getFocusAreas(String locale) =>
      focusAreas[locale] ?? focusAreas['en'] ?? [];

  String getEnergyDescription(String locale) =>
      energyDescription[locale] ?? energyDescription['en'] ?? '';

  List<String> getRecommendedActions(String locale) =>
      recommendedActions[locale] ?? recommendedActions['en'] ?? [];

  List<String>? getJournalPrompts(String locale) =>
      journalPrompts?[locale] ?? journalPrompts?['en'];

  @override
  String toString() {
    return 'LunarGuideTemplate(id: $id, phase: $phaseId, element: $element)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LunarGuideTemplate && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
