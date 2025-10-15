
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_client.dart';
import '../user_identity.dart';
import 'draw_cards_api.dart';

class InterpretationResult {
  InterpretationResult({
    required this.interpretation,
    this.summary,
    this.keywords = const <String>[],
  });

  final String interpretation;
  final String? summary;
  final List<String> keywords;
}

Future<InterpretationResult?> submitInterpretation({
  required String sessionId,
  required CardsDrawResponse draw,
  String? question,
  String locale = 'en',
}) async {
  print('[InterpretationAPI] Starting submitInterpretation');
  final uri = buildApiUri('api/chat/interpret');
  print('[InterpretationAPI] URI: $uri');
  final cardsPayload = draw.result
      .map((card) => <String, dynamic>{
            'id': card.id,
            'name': card.name,
            'suit': card.suit,
            'number': card.number,
            'upright': card.upright,
            'position': card.position,
          })
      .toList();

  final resultsPayload = <String, dynamic>{
    'cards': cardsPayload,
    'spread': draw.spread,
    'seed': draw.seed,
    'method': draw.method,
  };

  final requestBody = <String, dynamic>{
    'sessionId': sessionId,
    'results': resultsPayload,
    'technique': 'tarot',
    'locale': locale,
  };

  // Only include question if it's not null
  if (question != null) {
    requestBody['question'] = question;
  }

  final userId = await UserIdentity.obtain();
  final headers = await buildAuthenticatedHeaders(
    locale: locale,
    userId: userId,
    additional: {
      'content-type': 'application/json',
      'accept': 'application/json',
    },
  );

  print('[InterpretationAPI] Sending POST request...');
  final response = await http.post(
    uri,
    headers: headers,
    body: jsonEncode(requestBody),
  );

  print('[InterpretationAPI] Response status: ${response.statusCode}');
  print('[InterpretationAPI] Response body: ${response.body}');

  if (response.statusCode != 200) {
    throw Exception('Interpretation request failed (${response.statusCode}): ${response.body}');
  }

  final Map<String, dynamic> payload =
      jsonDecode(response.body) as Map<String, dynamic>;
  final data = payload['data'] as Map<String, dynamic>?;
  if (payload['success'] != true || data == null) {
    throw Exception('Interpretation request failed: ${payload['error'] ?? payload}');
  }

  final interpretation = data['interpretation'] as String?;
  if (interpretation == null || interpretation.isEmpty) {
    return null;
  }

  final summary = data['summary'] as String?;
  final keywords = (data['keywords'] as List<dynamic>? ?? <dynamic>[])
      .whereType<String>()
      .toList();

  return InterpretationResult(
    interpretation: interpretation,
    summary: summary,
    keywords: keywords,
  );
}
