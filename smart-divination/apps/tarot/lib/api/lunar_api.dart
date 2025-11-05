import 'dart:convert';

import 'package:http/http.dart' as http;

import '../user_identity.dart';
import 'api_client.dart';
import '../models/lunar_day.dart';

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
}
