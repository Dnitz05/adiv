import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/journal_entry.dart';
import '../models/journal_filters.dart';
import 'api_client.dart';

class JournalApiClient {
  JournalApiClient({
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<Map<String, dynamic>> _performGet(
    String path, {
    Map<String, String>? query,
    String? locale,
    String? userId,
  }) async {
    final uri = buildApiUri(path, query);
    final headers = await buildAuthenticatedHeaders(
      locale: locale,
      userId: userId,
      additional: const {'accept': 'application/json'},
    );

    final response = await _httpClient.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Journal API request failed (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return Map<String, dynamic>.from(body['data'] as Map? ?? const {});
  }

  Future<JournalTimelineResponse> fetchTimeline({
    required int limit,
    String? cursor,
    JournalFilters? filters,
    String? locale,
    String? userId,
  }) async {
    final query = <String, String>{
      'limit': limit.toString(),
      if (cursor != null) 'cursor': cursor,
      if (filters != null && filters.phase != 'any') 'phase': filters.phase,
      if (filters != null && (filters.searchTerm?.isNotEmpty ?? false))
        'search': filters.searchTerm!,
      if (filters != null && filters.types.isNotEmpty)
        'types': filters.types.map((type) => type.value).join(','),
    };

    final data = await _performGet(
      '/api/journal/timeline',
      query: query,
      locale: locale,
      userId: userId,
    );

    final items = (data['items'] as List? ?? const [])
        .map((entry) => JournalEntry.fromJson(Map<String, dynamic>.from(entry as Map)))
        .toList();
    return JournalTimelineResponse(
      entries: items,
      nextCursor: data['nextCursor'] as String?,
      hasMore: data['hasMore'] as bool? ?? false,
    );
  }

  Future<JournalDaySummary> fetchDaySummary({
    required String date,
    String? locale,
    String? userId,
  }) async {
    final data = await _performGet(
      '/api/journal/day/$date',
      locale: locale,
      userId: userId,
    );
    return JournalDaySummary.fromJson(data);
  }

  Future<JournalStats> fetchStats({
    String period = 'month',
    String? locale,
    String? userId,
  }) async {
    final data = await _performGet(
      '/api/journal/stats',
      query: {'period': period},
      locale: locale,
      userId: userId,
    );
    return JournalStats.fromJson(data);
  }
}

class JournalTimelineResponse {
  const JournalTimelineResponse({
    required this.entries,
    required this.hasMore,
    this.nextCursor,
  });

  final List<JournalEntry> entries;
  final bool hasMore;
  final String? nextCursor;
}
