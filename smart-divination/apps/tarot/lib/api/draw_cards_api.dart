import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

// Compile-time configurable base URL
const String kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:3001',
);

class CardResult {
  final String id;
  final bool upright;
  final int position;

  CardResult({required this.id, required this.upright, required this.position});

  factory CardResult.fromJson(Map<String, dynamic> json) => CardResult(
        id: json['id'] as String,
        upright: json['upright'] as bool,
        position: (json['position'] as num).toInt(),
      );
}

class CardsDrawResponse {
  final List<CardResult> result;
  final String seed;
  final String timestamp;
  final String locale;

  CardsDrawResponse({
    required this.result,
    required this.seed,
    required this.timestamp,
    required this.locale,
  });

  factory CardsDrawResponse.fromJson(Map<String, dynamic> json) => CardsDrawResponse(
        result: (json['result'] as List<dynamic>)
            .map((e) => CardResult.fromJson(e as Map<String, dynamic>))
            .toList(),
        seed: json['seed'] as String,
        timestamp: json['timestamp'] as String,
        locale: json['locale'] as String,
      );
}

Future<CardsDrawResponse> drawCards({
  int count = 3,
  bool allowReversed = true,
  String? seed,
  String locale = 'en',
}) async {
  final uri = Uri.parse('$kApiBaseUrl/api/draw/cards');
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

  if (res.statusCode != 200) {
    throw Exception('Draw failed (${res.statusCode}): ${res.body}');
  }

  final Map<String, dynamic> data = jsonDecode(res.body) as Map<String, dynamic>;
  return CardsDrawResponse.fromJson(data);
}

String generateSeed() {
  // Simple, reasonably unique seed for client-side requests
  final r = Random.secure();
  final bytes = List<int>.generate(16, (_) => r.nextInt(256));
  return base64Url.encode(bytes).replaceAll('=', '');
}

