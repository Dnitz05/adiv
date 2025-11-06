import 'lunar_advice.dart';

class LunarReminder {
  const LunarReminder({
    required this.id,
    required this.userId,
    required this.date,
    required this.topic,
    required this.locale,
    required this.createdAt,
    this.time,
    this.intention,
  });

  final String id;
  final String userId;
  final DateTime date;
  final String topic;
  final String locale;
  final DateTime createdAt;
  final String? time;
  final String? intention;

  factory LunarReminder.fromJson(Map<String, dynamic> json) {
    return LunarReminder(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ??
          DateTime.now().toUtc(),
      topic: json['topic'] as String? ?? 'intentions',
      locale: json['locale'] as String? ?? 'en',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now().toUtc(),
      time: json['time'] as String?,
      intention: json['intention'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'date': date.toIso8601String(),
        'topic': topic,
        'locale': locale,
        'createdAt': createdAt.toIso8601String(),
        if (time != null) 'time': time,
        if (intention != null) 'intention': intention,
      };
}

class CreateLunarReminderInput {
  const CreateLunarReminderInput({
    required this.date,
    required this.topic,
    this.time,
    this.intention,
  });

  final DateTime date;
  final LunarAdviceTopic topic;
  final String? time;
  final String? intention;
}
