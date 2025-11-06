enum LunarAdviceTopic {
  intentions,
  projects,
  relationships,
  wellbeing,
  creativity,
}

extension LunarAdviceTopicExt on LunarAdviceTopic {
  String get apiValue {
    switch (this) {
      case LunarAdviceTopic.intentions:
        return 'intentions';
      case LunarAdviceTopic.projects:
        return 'projects';
      case LunarAdviceTopic.relationships:
        return 'relationships';
      case LunarAdviceTopic.wellbeing:
        return 'wellbeing';
      case LunarAdviceTopic.creativity:
        return 'creativity';
    }
  }
}

class LunarAdviceNext {
  const LunarAdviceNext({
    required this.phaseId,
    required this.date,
    required this.name,
    required this.advice,
  });

  final String phaseId;
  final String date;
  final String name;
  final String advice;

  factory LunarAdviceNext.fromJson(Map<String, dynamic> json) {
    return LunarAdviceNext(
      phaseId: json['phaseId'] as String? ?? '',
      date: json['date'] as String? ?? '',
      name: json['name'] as String? ?? '',
      advice: json['advice'] as String? ?? '',
    );
  }
}

class LunarAdvice {
  const LunarAdvice({
    required this.focus,
    required this.today,
    required this.next,
  });

  final String focus;
  final List<String> today;
  final LunarAdviceNext next;

  factory LunarAdvice.fromJson(Map<String, dynamic> json) {
    final todayRaw = json['today'];
    final today = todayRaw is List
        ? todayRaw.whereType<String>().map((item) => item.trim()).where((item) => item.isNotEmpty).toList()
        : <String>[];

    return LunarAdvice(
      focus: (json['focus'] as String? ?? '').trim(),
      today: today,
      next: LunarAdviceNext.fromJson(
        (json['next'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      ),
    );
  }
}

class LunarAdviceContext {
  const LunarAdviceContext({
    required this.date,
    required this.phaseId,
    required this.phaseName,
    required this.phaseEmoji,
    required this.illumination,
    required this.zodiac,
  });

  final String date;
  final String phaseId;
  final String phaseName;
  final String phaseEmoji;
  final double illumination;
  final Map<String, dynamic> zodiac;

  factory LunarAdviceContext.fromJson(Map<String, dynamic> json) {
    return LunarAdviceContext(
      date: json['date'] as String? ?? '',
      phaseId: json['phaseId'] as String? ?? '',
      phaseName: json['phaseName'] as String? ?? '',
      phaseEmoji: json['phaseEmoji'] as String? ?? '',
      illumination: (json['illumination'] as num?)?.toDouble() ?? 0,
      zodiac: Map<String, dynamic>.from(json['zodiac'] as Map? ?? <String, dynamic>{}),
    );
  }
}

class LunarAdviceResponse {
  const LunarAdviceResponse({
    required this.advice,
    required this.context,
  });

  final LunarAdvice advice;
  final LunarAdviceContext context;

  factory LunarAdviceResponse.fromJson(Map<String, dynamic> json) {
    final adviceJson = json['advice'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final contextJson = json['context'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return LunarAdviceResponse(
      advice: LunarAdvice.fromJson(adviceJson),
      context: LunarAdviceContext.fromJson(contextJson),
    );
  }
}
