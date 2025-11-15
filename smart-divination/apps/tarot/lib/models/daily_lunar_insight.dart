/// Model for AI-generated daily lunar insights
/// Contains personalized guidance for each specific day
class DailyLunarInsight {
  final String id;
  final DateTime date;
  final String phaseId;
  final String zodiacSign;
  final String element;
  final double lunarAge;
  final double illumination;

  final Map<String, String> universalInsight;
  final Map<String, String> specificInsight;

  final bool isSpecialEvent;
  final String? specialEventType;

  final DateTime generatedAt;

  const DailyLunarInsight({
    required this.id,
    required this.date,
    required this.phaseId,
    required this.zodiacSign,
    required this.element,
    required this.lunarAge,
    required this.illumination,
    required this.universalInsight,
    required this.specificInsight,
    this.isSpecialEvent = false,
    this.specialEventType,
    required this.generatedAt,
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
      universalInsight: Map<String, String>.from(
        json['universal_insight'] as Map,
      ),
      specificInsight: Map<String, String>.from(
        json['specific_insight'] as Map,
      ),
      isSpecialEvent: json['is_special_event'] as bool? ?? false,
      specialEventType: json['special_event_type'] as String?,
      generatedAt: DateTime.parse(json['generated_at'] as String),
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
      'universal_insight': universalInsight,
      'specific_insight': specificInsight,
      'is_special_event': isSpecialEvent,
      'special_event_type': specialEventType,
      'generated_at': generatedAt.toIso8601String(),
    };
  }

  // Localized getters

  String getUniversalInsight(String locale) =>
      universalInsight[locale] ?? universalInsight['en'] ?? '';

  String getSpecificInsight(String locale) =>
      specificInsight[locale] ?? specificInsight['en'] ?? '';

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
