import 'lunar_advice.dart';

class LunarAdviceHistoryItem {
  const LunarAdviceHistoryItem({
    required this.id,
    required this.date,
    required this.topic,
    required this.locale,
    required this.createdAt,
    required this.advice,
    required this.context,
    this.intention,
  });

  final String id;
  final DateTime date;
  final String topic;
  final String locale;
  final DateTime createdAt;
  final LunarAdvice advice;
  final LunarAdviceContext context;
  final String? intention;

  factory LunarAdviceHistoryItem.fromJson(Map<String, dynamic> json) {
    return LunarAdviceHistoryItem(
      id: json['id'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ??
          DateTime.now().toUtc(),
      topic: json['topic'] as String? ?? 'intentions',
      locale: json['locale'] as String? ?? 'en',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now().toUtc(),
      intention: json['intention'] as String?,
      advice: LunarAdvice.fromJson(
        json['advice'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      context: LunarAdviceContext.fromJson(
        json['context'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }
}
