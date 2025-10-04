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

class RuneResult {
  RuneResult({
    required this.id,
    required this.name,
    required this.symbol,
    required this.isReversed,
    required this.position,
    required this.meaning,
  });

  factory RuneResult.fromJson(Map<String, dynamic> json) => RuneResult(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String,
        symbol: json['symbol'] as String,
        isReversed: json['isReversed'] as bool,
        position: (json['position'] as num).toInt(),
        meaning: json['meaning'] as String,
      );

  final int id;
  final String name;
  final String symbol;
  final bool isReversed;
  final int position;
  final String meaning;
}

class RunesDrawResponse {
  RunesDrawResponse({
    required this.result,
    required this.seed,
    required this.method,
    required this.timestamp,
    required this.locale,
    required this.spread,
  });

  factory RunesDrawResponse.fromJson(Map<String, dynamic> json) =>
      RunesDrawResponse(
        result: (json['result'] as List<dynamic>)
            .map((e) => RuneResult.fromJson(e as Map<String, dynamic>))
            .toList(),
        seed: json['seed'] as String,
        method: json['method'] as String,
        timestamp: json['timestamp'] as String,
        locale: json['locale'] as String,
        spread: (json['spread'] as String?) ?? 'custom',
      );

  final List<RuneResult> result;
  final String seed;
  final String method;
  final String timestamp;
  final String locale;
  final String spread;
}

Future<RunesDrawResponse> drawRunes({
  int count = 3,
  bool allowReversed = true,
  String? seed,
  String locale = 'en',
}) async {
  final uri = Uri.parse('$kApiBaseUrl/api/draw/runes');
  final body = jsonEncode(<String, dynamic>{
    'count': count,
    'allow_reversed': allowReversed,
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
      'Runes are coming soon. Please check back soon.',
    );
    throw TechniqueUnavailableException(message);
  }
  if (res.statusCode != 200) {
    throw Exception(
      'Runes draw failed (${res.statusCode}): ${res.body}',
    );
  }

  final Map<String, dynamic> data =
      jsonDecode(res.body) as Map<String, dynamic>;
  return RunesDrawResponse.fromJson(data);
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
