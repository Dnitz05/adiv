/// Model for modular-composed daily lunar insights
/// Contains guidance composed from: Base Template + Seasonal Overlay + Weekday Energy + Special Events
/// ZERO AI cost - uses pre-written astrological content
class DailyLunarInsight {
  final String id;
  final DateTime date;
  final String phaseId;
  final String zodiacSign;
  final String element;
  final double lunarAge;
  final double illumination;

  // Reference to the base template used
  final String? templateId;

  // Composed multilingual content (en/es/ca)
  final Map<String, String> composedHeadline;
  final Map<String, String> composedDescription;
  final Map<String, String> composedGuidance;
  final Map<String, List<String>> focusAreas;
  final Map<String, List<String>> recommendedActions;

  // Composition metadata
  final String? seasonalOverlayId;
  final String weekday;
  final List<String> specialEventIds;
  final DateTime composedAt;
  final String compositionVersion;

  const DailyLunarInsight({
    required this.id,
    required this.date,
    required this.phaseId,
    required this.zodiacSign,
    required this.element,
    required this.lunarAge,
    required this.illumination,
    required this.templateId,
    required this.composedHeadline,
    required this.composedDescription,
    required this.composedGuidance,
    required this.focusAreas,
    required this.recommendedActions,
    this.seasonalOverlayId,
    required this.weekday,
    required this.specialEventIds,
    required this.composedAt,
    required this.compositionVersion,
  });

  factory DailyLunarInsight.fromJson(Map<String, dynamic> json) {
    return DailyLunarInsight(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      phaseId: json['phase_id'] as String,
      zodiacSign: json['zodiac_sign'] as String,
      element: json['element'] as String,
      lunarAge: (json['lunar_age'] as num).toDouble(),
      illumination: (json['illumination'] as num).toDouble(),
      templateId: json['template_id'] as String?,
      composedHeadline: Map<String, String>.from(
        json['composed_headline'] as Map,
      ),
      composedDescription: Map<String, String>.from(
        json['composed_description'] as Map,
      ),
      composedGuidance: Map<String, String>.from(
        json['composed_guidance'] as Map,
      ),
      focusAreas: (json['focus_areas'] as Map).map(
        (key, value) => MapEntry(
          key as String,
          List<String>.from(value as List),
        ),
      ),
      recommendedActions: (json['recommended_actions'] as Map).map(
        (key, value) => MapEntry(
          key as String,
          List<String>.from(value as List),
        ),
      ),
      seasonalOverlayId: json['seasonal_overlay_id'] as String?,
      weekday: json['weekday'] as String,
      specialEventIds: List<String>.from(json['special_event_ids'] as List? ?? []),
      composedAt: DateTime.parse(json['composed_at'] as String),
      compositionVersion: json['composition_version'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String().split('T')[0],
      'phase_id': phaseId,
      'zodiac_sign': zodiacSign,
      'element': element,
      'lunar_age': lunarAge,
      'illumination': illumination,
      'template_id': templateId,
      'composed_headline': composedHeadline,
      'composed_description': composedDescription,
      'composed_guidance': composedGuidance,
      'focus_areas': focusAreas,
      'recommended_actions': recommendedActions,
      'seasonal_overlay_id': seasonalOverlayId,
      'weekday': weekday,
      'special_event_ids': specialEventIds,
      'composed_at': composedAt.toIso8601String(),
      'composition_version': compositionVersion,
    };
  }

  // Localized getters

  String getHeadline(String locale) =>
      composedHeadline[locale] ?? composedHeadline['en'] ?? '';

  String getDescription(String locale) =>
      composedDescription[locale] ?? composedDescription['en'] ?? '';

  String getGuidance(String locale) =>
      composedGuidance[locale] ?? composedGuidance['en'] ?? '';

  List<String> getFocusAreas(String locale) =>
      focusAreas[locale] ?? focusAreas['en'] ?? [];

  List<String> getRecommendedActions(String locale) =>
      recommendedActions[locale] ?? recommendedActions['en'] ?? [];

  @override
  String toString() {
    return 'DailyLunarInsight(date: $date, phase: $phaseId, zodiac: $zodiacSign)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DailyLunarInsight &&
        other.date.year == date.year &&
        other.date.month == date.month &&
        other.date.day == date.day;
  }

  @override
  int get hashCode => date.hashCode;
}
