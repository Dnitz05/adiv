import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../api/lunar_api.dart';
import '../models/lunar_day.dart';
import '../user_identity.dart';

class LunarCycleRepository {
  LunarCycleRepository({
    LunarApiClient? apiClient,
    Future<SharedPreferences>? sharedPreferences,
  })  : _api = apiClient ?? const LunarApiClient(),
        _prefsFuture = sharedPreferences ?? SharedPreferences.getInstance();

  final LunarApiClient _api;
  final Future<SharedPreferences> _prefsFuture;

  static const Duration _cacheTtl = Duration(hours: 6);
  static const String _dayCachePrefix = 'lunar_day_cache_v1';
  static const String _rangeCachePrefix = 'lunar_range_cache_v1';

  Future<LunarDayModel> getDay({
    DateTime? date,
    String? locale,
    String? userId,
    bool forceRefresh = false,
  }) async {
    final resolvedUserId = await _resolveUserId(userId);
    final resolvedLocale = (locale ?? 'en').toLowerCase();
    final targetDate = date ?? DateTime.now();
    final cacheKey =
        _buildDayCacheKey(targetDate, resolvedLocale, resolvedUserId);

    if (!forceRefresh) {
      final cached = await _readDayFromCache(cacheKey);
      if (cached != null) {
        return cached;
      }
    }

    final fetched = await _api.fetchDay(
      date: targetDate,
      locale: resolvedLocale,
      userId: resolvedUserId,
    );

    await _saveDayToCache(cacheKey, fetched);
    return fetched;
  }

  Future<List<LunarRangeItemModel>> getRange({
    required DateTime from,
    required DateTime to,
    String? locale,
    String? userId,
    bool forceRefresh = false,
  }) async {
    final resolvedUserId = await _resolveUserId(userId);
    final resolvedLocale = (locale ?? 'en').toLowerCase();
    final cacheKey =
        _buildRangeCacheKey(from, to, resolvedLocale, resolvedUserId);

    if (!forceRefresh) {
      final cached = await _readRangeFromCache(cacheKey);
      if (cached != null) {
        return cached;
      }
    }

    final fetched = await _api.fetchRange(
      from: from,
      to: to,
      locale: resolvedLocale,
      userId: resolvedUserId,
    );

    await _saveRangeToCache(cacheKey, fetched);
    return fetched;
  }

  Future<String> _resolveUserId(String? userId) async {
    if (userId != null && userId.isNotEmpty) {
      return userId;
    }
    return UserIdentity.obtain();
  }

  String _buildDayCacheKey(
    DateTime date,
    String locale,
    String userId,
  ) {
    final formatted = _formatDate(date);
    return '$_dayCachePrefix::$locale::$userId::$formatted';
  }

  String _buildRangeCacheKey(
    DateTime from,
    DateTime to,
    String locale,
    String userId,
  ) {
    final start = _formatDate(from);
    final end = _formatDate(to);
    return '$_rangeCachePrefix::$locale::$userId::$start::$end';
  }

  Future<LunarDayModel?> _readDayFromCache(String key) async {
    final prefs = await _prefsFuture;
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final fetchedAt =
          DateTime.tryParse(decoded['fetchedAt'] as String? ?? '');
      if (fetchedAt == null ||
          DateTime.now().difference(fetchedAt) > _cacheTtl) {
        await prefs.remove(key);
        return null;
      }
      final payload = decoded['payload'];
      if (payload is Map<String, dynamic>) {
        return LunarDayModel.fromJson(payload);
      }
    } catch (_) {
      await prefs.remove(key);
    }
    return null;
  }

  Future<void> _saveDayToCache(String key, LunarDayModel day) async {
    final prefs = await _prefsFuture;
    final entry = <String, dynamic>{
      'fetchedAt': DateTime.now().toIso8601String(),
      'payload': day.toJson(),
    };
    await prefs.setString(key, jsonEncode(entry));
  }

  Future<List<LunarRangeItemModel>?> _readRangeFromCache(String key) async {
    final prefs = await _prefsFuture;
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final fetchedAt =
          DateTime.tryParse(decoded['fetchedAt'] as String? ?? '');
      if (fetchedAt == null ||
          DateTime.now().difference(fetchedAt) > _cacheTtl) {
        await prefs.remove(key);
        return null;
      }
      final payload = decoded['payload'];
      if (payload is List) {
        return payload
            .whereType<Map<String, dynamic>>()
            .map(LunarRangeItemModel.fromJson)
            .toList();
      }
    } catch (_) {
      await prefs.remove(key);
    }
    return null;
  }

  Future<void> _saveRangeToCache(
    String key,
    List<LunarRangeItemModel> items,
  ) async {
    final prefs = await _prefsFuture;
    final entry = <String, dynamic>{
      'fetchedAt': DateTime.now().toIso8601String(),
      'payload': items.map((item) => item.toJson()).toList(),
    };
    await prefs.setString(key, jsonEncode(entry));
  }

  String _formatDate(DateTime value) {
    final utc = DateTime.utc(value.year, value.month, value.day);
    return '${utc.year.toString().padLeft(4, '0')}-'
        '${utc.month.toString().padLeft(2, '0')}-'
        '${utc.day.toString().padLeft(2, '0')}';
  }
}
