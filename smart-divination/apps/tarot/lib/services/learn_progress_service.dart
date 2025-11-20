import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service for tracking learning progress in the Learn section
///
/// Stores completion status for lessons across all learning journeys
/// using SharedPreferences for local persistence.
class LearnProgressService {
  static const String _keyPrefix = 'learn_progress_';
  static const String _keyCompletedLessons = 'completed_lessons';
  static const String _keyLastAccessed = 'last_accessed';
  static const String _keyDailyStreak = 'daily_streak';
  static const String _keyLastLearningDate = 'last_learning_date';

  /// Singleton instance
  static final LearnProgressService _instance = LearnProgressService._internal();
  factory LearnProgressService() => _instance;
  LearnProgressService._internal();

  SharedPreferences? _prefs;

  /// Initialize the service (call once at app startup)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ==========================================================================
  // Lesson Completion
  // ==========================================================================

  /// Mark a lesson as completed
  Future<bool> markLessonComplete({
    required String journeyId,
    required String lessonId,
  }) async {
    if (_prefs == null) await init();

    final key = '$_keyPrefix${journeyId}_$_keyCompletedLessons';
    final completedLessons = await getCompletedLessons(journeyId);

    if (!completedLessons.contains(lessonId)) {
      completedLessons.add(lessonId);
      final success = await _prefs!.setStringList(key, completedLessons);

      if (success) {
        await _updateLastAccessed(journeyId);
        await _updateDailyStreak();
      }

      return success;
    }

    return true; // Already completed
  }

  /// Mark a lesson as incomplete (remove from completed list)
  Future<bool> markLessonIncomplete({
    required String journeyId,
    required String lessonId,
  }) async {
    if (_prefs == null) await init();

    final key = '$_keyPrefix${journeyId}_$_keyCompletedLessons';
    final completedLessons = await getCompletedLessons(journeyId);

    if (completedLessons.contains(lessonId)) {
      completedLessons.remove(lessonId);
      return await _prefs!.setStringList(key, completedLessons);
    }

    return true; // Already incomplete
  }

  /// Check if a lesson is completed
  Future<bool> isLessonCompleted({
    required String journeyId,
    required String lessonId,
  }) async {
    final completedLessons = await getCompletedLessons(journeyId);
    return completedLessons.contains(lessonId);
  }

  /// Get all completed lessons for a journey
  Future<List<String>> getCompletedLessons(String journeyId) async {
    if (_prefs == null) await init();

    final key = '$_keyPrefix${journeyId}_$_keyCompletedLessons';
    return _prefs!.getStringList(key) ?? [];
  }

  /// Get completion count for a journey
  Future<int> getCompletedCount(String journeyId) async {
    final completed = await getCompletedLessons(journeyId);
    return completed.length;
  }

  // ==========================================================================
  // Progress Calculation
  // ==========================================================================

  /// Get journey progress (0.0 to 1.0)
  Future<double> getJourneyProgress({
    required String journeyId,
    required int totalLessons,
  }) async {
    if (totalLessons == 0) return 0.0;

    final completedCount = await getCompletedCount(journeyId);
    return completedCount / totalLessons;
  }

  /// Get overall learning progress across all journeys
  Future<double> getOverallProgress({
    required Map<String, int> journeyTotals,
  }) async {
    if (journeyTotals.isEmpty) return 0.0;

    int totalCompleted = 0;
    int totalLessons = 0;

    for (final entry in journeyTotals.entries) {
      final journeyId = entry.key;
      final lessonCount = entry.value;

      totalCompleted += await getCompletedCount(journeyId);
      totalLessons += lessonCount;
    }

    if (totalLessons == 0) return 0.0;
    return totalCompleted / totalLessons;
  }

  // ==========================================================================
  // Journey Metadata
  // ==========================================================================

  /// Update last accessed timestamp for a journey
  Future<bool> _updateLastAccessed(String journeyId) async {
    if (_prefs == null) await init();

    final key = '$_keyPrefix${journeyId}_$_keyLastAccessed';
    return await _prefs!.setString(
      key,
      DateTime.now().toIso8601String(),
    );
  }

  /// Get last accessed timestamp for a journey
  Future<DateTime?> getLastAccessed(String journeyId) async {
    if (_prefs == null) await init();

    final key = '$_keyPrefix${journeyId}_$_keyLastAccessed';
    final timestamp = _prefs!.getString(key);

    if (timestamp != null) {
      try {
        return DateTime.parse(timestamp);
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  // ==========================================================================
  // Daily Streak
  // ==========================================================================

  /// Update daily learning streak
  Future<void> _updateDailyStreak() async {
    if (_prefs == null) await init();

    final today = _getDateString(DateTime.now());
    final lastDate = _prefs!.getString(_keyLastLearningDate);

    if (lastDate == null) {
      // First time learning
      await _prefs!.setInt(_keyDailyStreak, 1);
      await _prefs!.setString(_keyLastLearningDate, today);
      return;
    }

    if (lastDate == today) {
      // Already learned today, no change
      return;
    }

    final yesterday = _getDateString(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    if (lastDate == yesterday) {
      // Consecutive day, increment streak
      final currentStreak = _prefs!.getInt(_keyDailyStreak) ?? 0;
      await _prefs!.setInt(_keyDailyStreak, currentStreak + 1);
    } else {
      // Streak broken, reset to 1
      await _prefs!.setInt(_keyDailyStreak, 1);
    }

    await _prefs!.setString(_keyLastLearningDate, today);
  }

  /// Get current daily streak
  Future<int> getDailyStreak() async {
    if (_prefs == null) await init();
    return _prefs!.getInt(_keyDailyStreak) ?? 0;
  }

  String _getDateString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // ==========================================================================
  // Recommendations
  // ==========================================================================

  /// Get next recommended lesson in a journey
  /// Returns the first incomplete lesson, or null if all complete
  Future<String?> getNextRecommendedLesson({
    required String journeyId,
    required List<String> allLessonIds,
  }) async {
    final completed = await getCompletedLessons(journeyId);

    for (final lessonId in allLessonIds) {
      if (!completed.contains(lessonId)) {
        return lessonId;
      }
    }

    return null; // All completed
  }

  // ==========================================================================
  // Reset & Clear
  // ==========================================================================

  /// Clear all progress for a specific journey
  Future<bool> clearJourneyProgress(String journeyId) async {
    if (_prefs == null) await init();

    final completedKey = '$_keyPrefix${journeyId}_$_keyCompletedLessons';
    final accessedKey = '$_keyPrefix${journeyId}_$_keyLastAccessed';

    final success1 = await _prefs!.remove(completedKey);
    final success2 = await _prefs!.remove(accessedKey);

    return success1 && success2;
  }

  /// Clear ALL learning progress (use with caution!)
  Future<bool> clearAllProgress() async {
    if (_prefs == null) await init();

    final keys = _prefs!.getKeys();
    final progressKeys = keys.where((key) => key.startsWith(_keyPrefix));

    for (final key in progressKeys) {
      await _prefs!.remove(key);
    }

    await _prefs!.remove(_keyDailyStreak);
    await _prefs!.remove(_keyLastLearningDate);

    return true;
  }

  // ==========================================================================
  // Export & Import (for backup/sync)
  // ==========================================================================

  /// Export all progress as JSON string
  Future<String> exportProgress() async {
    if (_prefs == null) await init();

    final keys = _prefs!.getKeys();
    final progressKeys = keys.where(
      (key) =>
          key.startsWith(_keyPrefix) ||
          key == _keyDailyStreak ||
          key == _keyLastLearningDate,
    );

    final Map<String, dynamic> data = {};

    for (final key in progressKeys) {
      final value = _prefs!.get(key);
      if (value is List<String>) {
        data[key] = value;
      } else if (value is String) {
        data[key] = value;
      } else if (value is int) {
        data[key] = value;
      }
    }

    return jsonEncode(data);
  }

  /// Import progress from JSON string
  Future<bool> importProgress(String jsonString) async {
    if (_prefs == null) await init();

    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);

      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is List) {
          await _prefs!.setStringList(
            key,
            List<String>.from(value),
          );
        } else if (value is String) {
          await _prefs!.setString(key, value);
        } else if (value is int) {
          await _prefs!.setInt(key, value);
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
