import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyCredits {
  const DailyCredits({
    required this.max,
    required this.remaining,
    required this.lastReset,
  });

  final int max;
  final int remaining;
  final DateTime lastReset;

  DailyCredits copyWith({
    int? max,
    int? remaining,
    DateTime? lastReset,
  }) {
    return DailyCredits(
      max: max ?? this.max,
      remaining: remaining ?? this.remaining,
      lastReset: lastReset ?? this.lastReset,
    );
  }
}

class CreditsService {
  CreditsService._();

  static final CreditsService _instance = CreditsService._();

  factory CreditsService() => _instance;

  static const int defaultDailyCredits = 3;
  static const String _remainingKey = 'daily_credits_remaining';
  static const String _lastResetKey = 'daily_credits_last_reset';
  static const String _maxKey = 'daily_credits_max';

  final ValueNotifier<DailyCredits> notifier = ValueNotifier<DailyCredits>(
    DailyCredits(
      max: defaultDailyCredits,
      remaining: defaultDailyCredits,
      lastReset: DateTime.now(),
    ),
  );

  bool _initialised = false;

  Future<void> initialize() async {
    if (_initialised) {
      await _resetIfNeeded();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedMax = prefs.getInt(_maxKey) ?? defaultDailyCredits;
    final storedRemaining = prefs.getInt(_remainingKey) ?? storedMax;
    final storedReset = prefs.getString(_lastResetKey);

    DateTime lastReset;
    if (storedReset != null) {
      lastReset = DateTime.tryParse(storedReset) ?? DateTime.now();
    } else {
      lastReset = DateTime.now();
    }

    notifier.value = DailyCredits(
      max: storedMax,
      remaining: storedRemaining.clamp(0, storedMax),
      lastReset: lastReset,
    );

    _initialised = true;
    await _resetIfNeeded();
  }

  bool get hasCredits => notifier.value.remaining > 0;

  Future<void> consume({int amount = 1}) async {
    await initialize();
    if (amount <= 0) {
      return;
    }
    final current = notifier.value;
    final nextRemaining = (current.remaining - amount).clamp(0, current.max);
    await _saveCredits(current.copyWith(remaining: nextRemaining));
  }

  Future<void> addCredits(int amount) async {
    await initialize();
    if (amount <= 0) {
      return;
    }
    final current = notifier.value;
    final nextRemaining = (current.remaining + amount).clamp(0, current.max);
    await _saveCredits(current.copyWith(remaining: nextRemaining));
  }

  Future<void> setMaxCredits(int value) async {
    final clamped = value <= 0 ? defaultDailyCredits : value;
    final current = notifier.value;
    final updatedRemaining = current.remaining.clamp(0, clamped);
    await _saveCredits(
      current.copyWith(
        max: clamped,
        remaining: updatedRemaining,
      ),
    );
  }

  Future<void> forceReset() async {
    final current = notifier.value;
    await _saveCredits(
      current.copyWith(
        remaining: current.max,
        lastReset: DateTime.now(),
      ),
    );
  }

  Future<void> _resetIfNeeded() async {
    final current = notifier.value;
    final now = DateTime.now();
    final needsReset = !_isSameDay(now, current.lastReset);

    if (!needsReset) {
      return;
    }

    await _saveCredits(
      current.copyWith(
        remaining: current.max,
        lastReset: DateTime.now(),
      ),
    );
  }

  Future<void> _saveCredits(DailyCredits credits) async {
    notifier.value = credits;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_remainingKey, credits.remaining);
    await prefs.setInt(_maxKey, credits.max);
    await prefs.setString(_lastResetKey, credits.lastReset.toIso8601String());
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
