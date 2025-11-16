import 'lunar_guide_template.dart';
import 'daily_lunar_insight.dart';

/// Composite model combining base template with AI-generated daily insight
/// Represents complete lunar guidance for a specific day
class LunarGuide {
  final LunarGuideTemplate template;
  final DailyLunarInsight? dailyInsight;

  const LunarGuide({
    required this.template,
    this.dailyInsight,
  });

  /// Whether this guide has modular-composed insights available
  bool get hasAiInsight => dailyInsight != null;

  /// Whether this day has special astronomical events
  bool get isSpecialDay => dailyInsight?.specialEventIds.isNotEmpty ?? false;

  /// Get the number of special events for this day
  int get specialEventCount => dailyInsight?.specialEventIds.length ?? 0;

  @override
  String toString() {
    return 'LunarGuide(phase: ${template.phaseId}, element: ${template.element}, hasAI: $hasAiInsight)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LunarGuide &&
        other.template == template &&
        other.dailyInsight == dailyInsight;
  }

  @override
  int get hashCode => Object.hash(template, dailyInsight);
}
