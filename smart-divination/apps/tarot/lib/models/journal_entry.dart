import 'package:equatable/equatable.dart';

import '../models/lunar_day.dart';

enum JournalActivityType {
  tarotReading('tarot_reading'),
  ichingCast('iching_cast'),
  runeCast('rune_cast'),
  chat('chat'),
  lunarAdvice('lunar_advice'),
  ritual('ritual'),
  meditation('meditation'),
  note('note'),
  reminder('reminder'),
  insight('insight'),
  custom('custom');

  const JournalActivityType(this.value);
  final String value;

  static JournalActivityType fromJson(String value) {
    return JournalActivityType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => JournalActivityType.custom,
    );
  }
}

enum JournalActivityStatus {
  draft('draft'),
  scheduled('scheduled'),
  inProgress('in_progress'),
  completed('completed'),
  missed('missed'),
  cancelled('cancelled'),
  archived('archived');

  const JournalActivityStatus(this.value);
  final String value;

  static JournalActivityStatus fromJson(String value) {
    return JournalActivityStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => JournalActivityStatus.completed,
    );
  }
}

class JournalEntry extends Equatable {
  const JournalEntry({
    required this.id,
    required this.activityType,
    required this.status,
    required this.timestamp,
    this.title,
    this.summary,
    this.payload = const {},
    this.metadata = const {},
    this.lunarPhase,
    this.lunarZodiac,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      activityType: JournalActivityType.fromJson(json['activityType'] as String),
      status: JournalActivityStatus.fromJson(json['status'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      title: json['title'] as String?,
      summary: json['summary'] as String?,
      payload: Map<String, dynamic>.from(json['payload'] as Map? ?? const {}),
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? const {}),
      lunarPhase: json['lunarPhase'] as String?,
      lunarZodiac: json['lunarZodiac'] as String?,
    );
  }

  final String id;
  final JournalActivityType activityType;
  final JournalActivityStatus status;
  final DateTime timestamp;
  final String? title;
  final String? summary;
  final Map<String, dynamic> payload;
  final Map<String, dynamic> metadata;
  final String? lunarPhase;
  final String? lunarZodiac;

  @override
  List<Object?> get props => [
        id,
        activityType,
        status,
        timestamp,
        title,
        summary,
        payload,
        metadata,
        lunarPhase,
        lunarZodiac,
      ];
}

class JournalDaySummary extends Equatable {
  const JournalDaySummary({
    required this.date,
    required this.entries,
    required this.totalActivities,
    required this.totalsByType,
    this.lunar,
  });

  factory JournalDaySummary.fromJson(Map<String, dynamic> json) {
    return JournalDaySummary(
      date: DateTime.parse(json['date'] as String),
      entries: (json['activities'] as List? ?? const [])
          .map((entry) => JournalEntry.fromJson(Map<String, dynamic>.from(entry as Map)))
          .toList(),
      totalActivities: json['totalActivities'] as int? ?? 0,
      totalsByType: Map<String, int>.from(json['totalsByType'] as Map? ?? const {}),
      lunar: json['lunar'] == null
          ? null
          : JournalLunarMetadata.fromJson(Map<String, dynamic>.from(json['lunar'] as Map)),
    );
  }

  final DateTime date;
  final List<JournalEntry> entries;
  final int totalActivities;
  final Map<String, int> totalsByType;
  final JournalLunarMetadata? lunar;

  @override
  List<Object?> get props => [date, entries, totalActivities, totalsByType, lunar];
}

class JournalLunarMetadata extends Equatable {
  const JournalLunarMetadata({
    this.phaseId,
    this.phaseName,
    this.zodiac,
    this.guidance,
  });

  factory JournalLunarMetadata.fromJson(Map<String, dynamic> json) {
    return JournalLunarMetadata(
      phaseId: json['phaseId'] as String?,
      phaseName: json['phaseName'] as String?,
      zodiac: json['zodiac'] as String?,
      guidance: json['guidance'] as String?,
    );
  }

  final String? phaseId;
  final String? phaseName;
  final String? zodiac;
  final String? guidance;

  LunarPhaseModel? toLunarPhaseModel() {
    if (phaseId == null) {
      return null;
    }
    return LunarPhaseModel(
      id: phaseId!,
      emoji: null,
      angleStart: 0,
      angleEnd: 0,
      names: PhaseLocalizedName(
        en: phaseName ?? phaseId!,
        es: phaseName ?? phaseId!,
        ca: phaseName ?? phaseId!,
      ),
      focus: PhaseLocalizedName(
        en: guidance ?? '',
        es: guidance ?? '',
        ca: guidance ?? '',
      ),
    );
  }

  @override
  List<Object?> get props => [phaseId, phaseName, zodiac, guidance];
}

class JournalStats extends Equatable {
  const JournalStats({
    required this.period,
    required this.totalActivities,
    required this.totalsByType,
    required this.totalsByPhase,
    required this.generatedAt,
    this.from,
    this.to,
  });

  factory JournalStats.fromJson(Map<String, dynamic> json) {
    return JournalStats(
      period: json['period'] as String? ?? 'month',
      totalActivities: json['totalActivities'] as int? ?? 0,
      totalsByType: Map<String, int>.from(json['totalsByType'] as Map? ?? const {}),
      totalsByPhase: Map<String, int>.from(json['totalsByPhase'] as Map? ?? const {}),
      from: json['from'] != null ? DateTime.tryParse(json['from'] as String) : null,
      to: json['to'] != null ? DateTime.tryParse(json['to'] as String) : null,
      generatedAt: DateTime.now(),
    );
  }

  final String period;
  final int totalActivities;
  final Map<String, int> totalsByType;
  final Map<String, int> totalsByPhase;
  final DateTime generatedAt;
  final DateTime? from;
  final DateTime? to;

  @override
  List<Object?> get props => [
        period,
        totalActivities,
        totalsByType,
        totalsByPhase,
        generatedAt,
        from,
        to,
      ];
}
