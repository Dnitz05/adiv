import 'dart:convert';

import 'package:http/http.dart' as http;

import '../user_identity.dart';
import 'api_client.dart';
import '../models/lunar_advice.dart';
import '../models/lunar_day.dart';
import '../models/lunar_advice_history.dart';
import '../models/lunar_reminder.dart';

class LunarApiException implements Exception {
  LunarApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'LunarApiException($statusCode): $message';
}

class LunarApiClient {
  const LunarApiClient();

  Future<LunarDayModel> fetchDay({
    DateTime? date,
    String? locale,
    String? userId,
  }) async {
    final effectiveUserId = userId ?? await UserIdentity.obtain();
    final query = <String, String>{
      if (date != null) 'date': _formatDate(date),
      if (locale != null && locale.isNotEmpty) 'locale': locale,
      if (effectiveUserId.isNotEmpty) 'userId': effectiveUserId,
    };

    final uri = buildApiUri('api/lunar/day', query);
    final headers = await buildAuthenticatedHeaders(
      locale: locale,
      userId: effectiveUserId,
      additional: const {
        'accept': 'application/json',
      },
    );

    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw LunarApiException(
        'Failed to load lunar day (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final data = payload['data'];
    if (data is! Map<String, dynamic>) {
      throw LunarApiException('Malformed lunar day response');
    }
    return LunarDayModel.fromJson(data);
  }

  Future<List<LunarRangeItemModel>> fetchRange({
    required DateTime from,
    required DateTime to,
    String? locale,
    String? userId,
  }) async {
    final effectiveUserId = userId ?? await UserIdentity.obtain();

    final query = <String, String>{
      'from': _formatDate(from),
      'to': _formatDate(to),
      if (locale != null && locale.isNotEmpty) 'locale': locale,
      if (effectiveUserId.isNotEmpty) 'userId': effectiveUserId,
    };

    final uri = buildApiUri('api/lunar/range', query);
    final headers = await buildAuthenticatedHeaders(
      locale: locale,
      userId: effectiveUserId,
      additional: const {
        'accept': 'application/json',
      },
    );

    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw LunarApiException(
        'Failed to load lunar range (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final data = payload['data'];
    if (data is! List) {
      throw LunarApiException('Malformed lunar range response');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(LunarRangeItemModel.fromJson)
        .toList();
  }

  String _formatDate(DateTime value) {
    final utc = DateTime.utc(value.year, value.month, value.day);
    return '${utc.year.toString().padLeft(4, '0')}-'
        '${utc.month.toString().padLeft(2, '0')}-'
        '${utc.day.toString().padLeft(2, '0')}';
  }

  Future<LunarAdviceResponse> fetchAdvice({
    required LunarAdviceTopic topic,
    String? intention,
    DateTime? date,
    String? locale,
    String? userId,
  }) async {
    final effectiveUserId = userId ?? await UserIdentity.obtain();

    final uri = buildApiUri('api/lunar/advice');
    final headers = await buildAuthenticatedHeaders(
      locale: locale,
      userId: effectiveUserId,
      additional: const {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );

    final body = jsonEncode(<String, dynamic>{
      'topic': topic.apiValue,
      if (intention != null && intention.trim().isNotEmpty) 'intention': intention.trim(),
      if (date != null) 'date': _formatDate(date),
      if (locale != null && locale.isNotEmpty) 'locale': locale,
      if (effectiveUserId.isNotEmpty) 'userId': effectiveUserId,
    });

    final response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode != 200) {
      throw LunarApiException(
        'Failed to generate lunar advice (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final data = payload['data'];
    if (data is! Map<String, dynamic>) {
      throw LunarApiException('Malformed lunar advice response');
    }

    return LunarAdviceResponse.fromJson(data);
  }

  Future<List<LunarAdviceHistoryItem>> fetchAdviceHistory({
    String? userId,
    String? locale,
    int limit = 5,
  }) async {
    final effectiveUserId = userId ?? await UserIdentity.obtain();
    if (effectiveUserId.isEmpty) {
      return <LunarAdviceHistoryItem>[];
    }

    final query = <String, String>{
      'limit': limit.toString(),
      if (locale != null && locale.isNotEmpty) 'locale': locale,
      'userId': effectiveUserId,
    };

    final uri = buildApiUri('api/lunar/history', query);
    final headers = await buildAuthenticatedHeaders(
      locale: locale,
      userId: effectiveUserId,
      additional: const {
        'accept': 'application/json',
      },
    );

    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw LunarApiException(
        'Failed to load lunar advice history (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final data = payload['data'];
    if (data is! Map<String, dynamic>) {
      throw LunarApiException('Malformed lunar history response');
    }
    final items = data['items'];
    if (items is! List) {
      return <LunarAdviceHistoryItem>[];
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map(LunarAdviceHistoryItem.fromJson)
        .toList();
  }

  Future<List<LunarReminder>> fetchReminders({
    String? userId,
    String? locale,
    DateTime? from,
    DateTime? to,
    int limit = 20,
  }) async {
    final effectiveUserId = userId ?? await UserIdentity.obtain();
    if (effectiveUserId.isEmpty) {
      return <LunarReminder>[];
    }

    final query = <String, String>{
      'userId': effectiveUserId,
      'limit': limit.toString(),
      if (locale != null && locale.isNotEmpty) 'locale': locale,
      if (from != null) 'from': _formatDate(from),
      if (to != null) 'to': _formatDate(to),
    };

    final uri = buildApiUri('api/lunar/schedule', query);
    final headers = await buildAuthenticatedHeaders(
      locale: locale,
      userId: effectiveUserId,
      additional: const {
        'accept': 'application/json',
      },
    );

    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw LunarApiException(
        'Failed to load lunar reminders (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final data = payload['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final remindersRaw = data['reminders'];
    if (remindersRaw is! List) {
      return <LunarReminder>[];
    }

    return remindersRaw
        .whereType<Map<String, dynamic>>()
        .map(LunarReminder.fromJson)
        .toList();
  }

  Future<LunarReminder> createReminder({
    required LunarAdviceTopic topic,
    required DateTime date,
    String? time,
    String? intention,
    String? locale,
    String? userId,
  }) async {
    final effectiveUserId = userId ?? await UserIdentity.obtain();
    if (effectiveUserId.isEmpty) {
      throw LunarApiException('User must be authenticated to create reminders');
    }

    final uri = buildApiUri('api/lunar/schedule');
    final headers = await buildAuthenticatedHeaders(
      locale: locale,
      userId: effectiveUserId,
      additional: const {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );

    final body = jsonEncode(<String, dynamic>{
      'userId': effectiveUserId,
      'date': _formatDate(date),
      if (time != null && time.isNotEmpty) 'time': time,
      'topic': topic.apiValue,
      if (intention != null && intention.trim().isNotEmpty) 'intention': intention.trim(),
      if (locale != null && locale.isNotEmpty) 'locale': locale,
    });

    final response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode != 201) {
      throw LunarApiException(
        'Failed to create reminder (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final data = payload['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final reminderJson = data['reminder'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return LunarReminder.fromJson(reminderJson);
  }

  Future<LunarReminder> updateReminder({
    required String id,
    required String userId,
    String? date,
    String? time,
    LunarAdviceTopic? topic,
    String? intention,
    String? locale,
  }) async {
    final uri = buildApiUri('api/lunar/schedule');
    final headers = await buildAuthenticatedHeaders(
      locale: locale,
      userId: userId,
      additional: const {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );

    final body = <String, dynamic>{
      'id': id,
      'userId': userId,
    };
    if (date != null) body['date'] = date;
    if (time != null) body['time'] = time;
    if (topic != null) body['topic'] = topic.apiValue;
    if (intention != null) body['intention'] = intention;
    if (locale != null) body['locale'] = locale;

    final response = await http.patch(uri, headers: headers, body: jsonEncode(body));
    if (response.statusCode != 200) {
      throw LunarApiException(
        'Failed to update reminder (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final data = payload['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final reminderJson = data['reminder'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return LunarReminder.fromJson(reminderJson);
  }

  Future<void> deleteReminder({
    required String id,
    required String userId,
    String? locale,
  }) async {
    final uri = buildApiUri('api/lunar/schedule');
    final headers = await buildAuthenticatedHeaders(
      locale: locale,
      userId: userId,
      additional: const {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );

    final body = jsonEncode(<String, dynamic>{
      'id': id,
      'userId': userId,
    });

    final response = await http.delete(uri, headers: headers, body: body);
    if (response.statusCode != 200) {
      throw LunarApiException(
        'Failed to delete reminder (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }
  }
}
