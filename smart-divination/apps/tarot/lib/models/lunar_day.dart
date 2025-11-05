class LunarZodiac {
  const LunarZodiac({
    required this.id,
    required this.name,
    required this.symbol,
    required this.element,
  });

  final String id;
  final String name;
  final String symbol;
  final String element;

  factory LunarZodiac.fromJson(Map<String, dynamic> json) => LunarZodiac(
        id: json['id'] as String,
        name: json['name'] as String,
        symbol: json['symbol'] as String? ?? '',
        element: json['element'] as String? ?? 'unknown',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'symbol': symbol,
        'element': element,
      };
}

class LunarGuidanceModel {
  const LunarGuidanceModel({
    required this.locale,
    required this.text,
    required this.source,
    required this.generatedAt,
  });

  final String locale;
  final String text;
  final String source;
  final DateTime generatedAt;

  factory LunarGuidanceModel.fromJson(Map<String, dynamic> json) =>
      LunarGuidanceModel(
        locale: json['locale'] as String? ?? 'en',
        text: json['text'] as String? ?? '',
        source: json['source'] as String? ?? 'fallback',
        generatedAt: DateTime.tryParse(json['generatedAt'] as String? ?? '') ??
            DateTime.now().toUtc(),
      );

  Map<String, dynamic> toJson() => {
        'locale': locale,
        'text': text,
        'source': source,
        'generatedAt': generatedAt.toIso8601String(),
      };
}

class LunarSessionSummaryModel {
  const LunarSessionSummaryModel({
    required this.id,
    required this.createdAt,
    required this.technique,
    required this.locale,
    required this.question,
    required this.spreadId,
    required this.summary,
    required this.interpretation,
    required this.metadata,
  });

  final String id;
  final DateTime createdAt;
  final String technique;
  final String locale;
  final String? question;
  final String? spreadId;
  final String? summary;
  final String? interpretation;
  final Map<String, dynamic>? metadata;

  factory LunarSessionSummaryModel.fromJson(Map<String, dynamic> json) =>
      LunarSessionSummaryModel(
        id: json['id'] as String,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now().toUtc(),
        technique: json['technique'] as String? ?? 'tarot',
        locale: json['locale'] as String? ?? 'en',
        question: json['question'] as String?,
        spreadId: json['spreadId'] as String?,
        summary: json['summary'] as String?,
        interpretation: json['interpretation'] as String?,
        metadata: json['metadata'] is Map<String, dynamic>
            ? json['metadata'] as Map<String, dynamic>
            : null,
      );
}

class LunarDayModel {
  const LunarDayModel({
    required this.date,
    required this.phaseId,
    required this.phaseName,
    required this.phaseEmoji,
    required this.phaseAngle,
    required this.illumination,
    required this.age,
    required this.zodiac,
    required this.recommendedSpreads,
    this.guidance,
    this.sessions = const <LunarSessionSummaryModel>[],
    this.sessionCount = 0,
  });

  final DateTime date;
  final String phaseId;
  final String phaseName;
  final String phaseEmoji;
  final double phaseAngle;
  final double illumination;
  final double age;
  final LunarZodiac zodiac;
  final List<String> recommendedSpreads;
  final LunarGuidanceModel? guidance;
  final List<LunarSessionSummaryModel> sessions;
  final int sessionCount;

  factory LunarDayModel.fromJson(Map<String, dynamic> json) {
    final sessionsJson = json['sessions'];
    final sessionList = sessionsJson is List
        ? sessionsJson
            .whereType<Map<String, dynamic>>()
            .map(LunarSessionSummaryModel.fromJson)
            .toList()
        : <LunarSessionSummaryModel>[];

    return LunarDayModel(
      date: DateTime.tryParse(json['date'] as String? ?? '') ??
          DateTime.now().toUtc(),
      phaseId: json['phaseId'] as String? ?? 'new_moon',
      phaseName: json['phaseName'] as String? ?? 'New Moon',
      phaseEmoji: json['phaseEmoji'] as String? ?? '',
      phaseAngle: (json['phaseAngle'] as num?)?.toDouble() ?? 0,
      illumination: (json['illumination'] as num?)?.toDouble() ?? 0,
      age: (json['age'] as num?)?.toDouble() ?? 0,
      zodiac: LunarZodiac.fromJson(
        json['zodiac'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      recommendedSpreads:
          (json['recommendedSpreads'] as List?)?.whereType<String>().toList() ??
              const <String>[],
      guidance: json['guidance'] is Map<String, dynamic>
          ? LunarGuidanceModel.fromJson(
              json['guidance'] as Map<String, dynamic>,
            )
          : null,
      sessions: sessionList,
      sessionCount: json['sessionCount'] is num
          ? (json['sessionCount'] as num).toInt()
          : sessionList.length,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'phaseId': phaseId,
        'phaseName': phaseName,
        'phaseEmoji': phaseEmoji,
        'phaseAngle': phaseAngle,
        'illumination': illumination,
        'age': age,
        'zodiac': zodiac.toJson(),
        'recommendedSpreads': recommendedSpreads,
        if (guidance != null) 'guidance': guidance!.toJson(),
        'sessions': sessions
            .map((s) => {
                  'id': s.id,
                  'createdAt': s.createdAt.toIso8601String(),
                  'technique': s.technique,
                  'locale': s.locale,
                  'question': s.question,
                  'spreadId': s.spreadId,
                  'summary': s.summary,
                  'interpretation': s.interpretation,
                  'metadata': s.metadata,
                })
            .toList(),
        'sessionCount': sessionCount,
      };
}

class LunarRangeItemModel {
  const LunarRangeItemModel({
    required this.date,
    required this.phaseId,
    required this.phaseName,
    required this.phaseEmoji,
    required this.phaseAngle,
    required this.illumination,
    required this.age,
    required this.zodiac,
    required this.recommendedSpreads,
    required this.sessionCount,
    this.guidance,
  });

  final DateTime date;
  final String phaseId;
  final String phaseName;
  final String phaseEmoji;
  final double phaseAngle;
  final double illumination;
  final double age;
  final LunarZodiac zodiac;
  final List<String> recommendedSpreads;
  final int sessionCount;
  final LunarGuidanceModel? guidance;

  factory LunarRangeItemModel.fromJson(Map<String, dynamic> json) =>
      LunarRangeItemModel(
        date: DateTime.tryParse(json['date'] as String? ?? '') ??
            DateTime.now().toUtc(),
        phaseId: json['phaseId'] as String? ?? 'new_moon',
        phaseName: json['phaseName'] as String? ?? 'New Moon',
        phaseEmoji: json['phaseEmoji'] as String? ?? '',
        phaseAngle: (json['phaseAngle'] as num?)?.toDouble() ?? 0,
        illumination: (json['illumination'] as num?)?.toDouble() ?? 0,
        age: (json['age'] as num?)?.toDouble() ?? 0,
        zodiac: LunarZodiac.fromJson(
          json['zodiac'] as Map<String, dynamic>? ?? <String, dynamic>{},
        ),
        recommendedSpreads: (json['recommendedSpreads'] as List?)
                ?.whereType<String>()
                .toList() ??
            const <String>[],
        sessionCount: json['sessionCount'] is num
            ? (json['sessionCount'] as num).toInt()
            : 0,
        guidance: json['guidance'] is Map<String, dynamic>
            ? LunarGuidanceModel.fromJson(
                json['guidance'] as Map<String, dynamic>,
              )
            : null,
      );

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'phaseId': phaseId,
        'phaseName': phaseName,
        'phaseEmoji': phaseEmoji,
        'phaseAngle': phaseAngle,
        'illumination': illumination,
        'age': age,
        'zodiac': zodiac.toJson(),
        'recommendedSpreads': recommendedSpreads,
        'sessionCount': sessionCount,
        if (guidance != null) 'guidance': guidance!.toJson(),
      };
}
