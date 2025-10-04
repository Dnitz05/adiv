import 'dart:convert';

import 'package:http/http.dart' as http;

const String kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:3001',
);

class TechniqueUnavailableException implements Exception {
  TechniqueUnavailableException(this.message);

  final String message;

  @override
  String toString() => message;
}

class HexagramLine {
  HexagramLine({
    required this.position,
    required this.type,
    required this.isChanging,
    required this.value,
  });

  factory HexagramLine.fromJson(Map<String, dynamic> json) => HexagramLine(
        position: (json['position'] as num).toInt(),
        type: json['type'] as String,
        isChanging: json['isChanging'] as bool,
        value: (json['value'] as num).toInt(),
      );

  final int position;
  final String type;
  final bool isChanging;
  final int value;
}

class HexagramSummary {
  HexagramSummary({
    required this.number,
    required this.name,
    required this.lines,
    required this.trigrams,
  });

  factory HexagramSummary.fromJson(Map<String, dynamic> json) =>
      HexagramSummary(
        number: (json['number'] as num).toInt(),
        name: json['name'] as String,
        lines: (json['lines'] as List<dynamic>)
            .map((e) => HexagramLine.fromJson(e as Map<String, dynamic>))
            .toList(),
        trigrams: (json['trigrams'] as List<dynamic>).cast<String>(),
      );

  final int number;
  final String name;
  final List<HexagramLine> lines;
  final List<String> trigrams;
}

class CoinsDrawResult {
  CoinsDrawResult({
    required this.lines,
    required this.primaryHex,
    required this.changingLines,
    required this.primaryHexagram,
    this.resultHexagram,
  });

  factory CoinsDrawResult.fromJson(Map<String, dynamic> json) =>
      CoinsDrawResult(
        lines: (json['lines'] as List<dynamic>)
            .map((e) => (e as num).toInt())
            .toList(),
        primaryHex: (json['primary_hex'] as num).toInt(),
        changingLines: (json['changing_lines'] as List<dynamic>)
            .map((e) => (e as num).toInt())
            .toList(),
        primaryHexagram: HexagramSummary.fromJson(
            json['primary_hexagram'] as Map<String, dynamic>),
        resultHexagram: json['result_hexagram'] == null
            ? null
            : HexagramSummary.fromJson(
                json['result_hexagram'] as Map<String, dynamic>),
      );

  final List<int> lines;
  final int primaryHex;
  final List<int> changingLines;
  final HexagramSummary primaryHexagram;
  final HexagramSummary? resultHexagram;
}

class CoinsDrawResponse {
  CoinsDrawResponse({
    required this.result,
    required this.seed,
    required this.method,
    required this.timestamp,
    required this.locale,
  });

  factory CoinsDrawResponse.fromJson(Map<String, dynamic> json) =>
      CoinsDrawResponse(
        result:
            CoinsDrawResult.fromJson(json['result'] as Map<String, dynamic>),
        seed: json['seed'] as String,
        method: json['method'] as String,
        timestamp: json['timestamp'] as String,
        locale: json['locale'] as String,
      );

  final CoinsDrawResult result;
  final String seed;
  final String method;
  final String timestamp;
  final String locale;
}

Future<CoinsDrawResponse> drawCoins({
  String? seed,
  String locale = 'en',
}) async {
  final uri = Uri.parse('$kApiBaseUrl/api/draw/coins');
  final body = jsonEncode(<String, dynamic>{
    if (seed != null && seed.isNotEmpty) 'seed': seed,
  });

  final res = await http.post(
    uri,
    headers: <String, String>{
      'content-type': 'application/json',
      'x-locale': locale,
    },
    body: body,
  );

  if (res.statusCode == 503) {
    final message = _extractTechniqueDisabledMessage(
      res.body,
      'I Ching is coming soon. Please check back soon.',
    );
    throw TechniqueUnavailableException(message);
  }
  if (res.statusCode != 200) {
    throw Exception(
      'Coins draw failed (${res.statusCode}): ${res.body}',
    );
  }

  final Map<String, dynamic> data =
      jsonDecode(res.body) as Map<String, dynamic>;
  return CoinsDrawResponse.fromJson(data);
}

class IChingSession {
  IChingSession({
    required this.id,
    required this.createdAt,
    required this.response,
    required this.seed,
    required this.method,
    this.interpretation,
  });

  final String id;
  final DateTime createdAt;
  final CoinsDrawResponse response;
  final String seed;
  final String method;
  final String? interpretation;
}

Future<List<IChingSession>> fetchIChingSessions({
  required String userId,
  int limit = 10,
}) async {
  final uri = Uri.parse(
      '$kApiBaseUrl/api/sessions/$userId?technique=iching&limit=$limit');
  final res = await http.get(
    uri,
    headers: <String, String>{
      'content-type': 'application/json',
      'x-user-id': userId,
    },
  );

  if (res.statusCode != 200) {
    throw Exception('History fetch failed (${res.statusCode}): ${res.body}');
  }

  final Map<String, dynamic> payload =
      jsonDecode(res.body) as Map<String, dynamic>;
  final data = payload['data'] as Map<String, dynamic>?;
  final sessions = (data?['sessions'] as List<dynamic>? ?? <dynamic>[])
      .cast<Map<String, dynamic>>();

  return sessions.map((session) {
    final artifactsList =
        (session['artifacts'] as List<dynamic>? ?? <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map((artifact) => Map<String, dynamic>.from(artifact))
            .toList();
    Map<String, dynamic>? drawPayload;
    for (final artifact in artifactsList) {
      final type = artifact['type'] as String?;
      if (type == 'iching_cast' &&
          artifact['payload'] is Map<String, dynamic>) {
        drawPayload = Map<String, dynamic>.from(artifact['payload'] as Map);
        break;
      }
    }

    Map<String, dynamic> resultPayload;
    if (drawPayload != null && drawPayload.containsKey('lines')) {
      resultPayload = Map<String, dynamic>.from(drawPayload);
    } else {
      final fallback = Map<String, dynamic>.from(
          session['results'] as Map? ?? <String, dynamic>{});
      final hexagram = Map<String, dynamic>.from(
          fallback['hexagram'] as Map? ?? <String, dynamic>{});
      final linesData = (hexagram['lines'] as List<dynamic>? ?? <dynamic>[])
          .map((line) => Map<String, dynamic>.from(line as Map))
          .toList();
      resultPayload = <String, dynamic>{
        'lines': linesData
            .map((line) => (line['value'] as num?)?.toInt() ?? 0)
            .toList(),
        'primary_hex': (hexagram['number'] as num?)?.toInt() ?? 0,
        'changing_lines': linesData
            .where((line) => line['isChanging'] == true)
            .map((line) => (line['position'] as num?)?.toInt() ?? 0)
            .toList(),
        'primary_hexagram': hexagram,
        'result_hexagram': hexagram['transformedTo'],
      };
      if (fallback.containsKey('method')) {
        resultPayload['method'] = fallback['method'];
      }
    }

    final metadata = Map<String, dynamic>.from(
        session['metadata'] as Map? ?? <String, dynamic>{});
    final createdAtStr = session['createdAt'] as String? ??
        session['created_at'] as String? ??
        '';
    final createdAt = DateTime.tryParse(createdAtStr)?.toLocal() ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final seed =
        (drawPayload?['seed'] as String?) ?? metadata['seed'] as String? ?? '';
    final method = (drawPayload?['method'] as String?) ??
        metadata['method'] as String? ??
        'coins';
    final interpretation = session['interpretation'] as String? ??
        drawPayload?['interpretation'] as String?;

    final coinsResult = CoinsDrawResult.fromJson(<String, dynamic>{
      'lines': resultPayload['lines'] ?? <dynamic>[],
      'primary_hex': resultPayload['primary_hex'] ?? 0,
      'changing_lines': resultPayload['changing_lines'] ?? <dynamic>[],
      'primary_hexagram':
          resultPayload['primary_hexagram'] ?? <String, dynamic>{},
      'result_hexagram': resultPayload['result_hexagram'],
    });

    final response = CoinsDrawResponse(
      result: coinsResult,
      seed: seed,
      method: method,
      timestamp: createdAtStr.isEmpty
          ? createdAt.toUtc().toIso8601String()
          : createdAtStr,
      locale: session['locale'] as String? ?? 'en',
    );

    return IChingSession(
      id: session['id'] as String? ?? '',
      createdAt: createdAt,
      response: response,
      seed: seed,
      method: method,
      interpretation: interpretation,
    );
  }).toList();
}

String _extractTechniqueDisabledMessage(String body, String fallback) {
  try {
    final dynamic decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final dynamic error = decoded['error'];
      if (error is Map<String, dynamic>) {
        final dynamic message = error['message'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
    }
  } catch (_) {
    // Ignore parsing issues and fall back to the default copy.
  }
  return fallback;
}
