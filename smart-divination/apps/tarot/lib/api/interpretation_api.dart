
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

/// Sanitizes interpretation text by removing JSON artifacts
String _sanitizeInterpretation(String text) {
  String cleaned = text;

  // Remove JSON field names and syntax (like "interpretation":", "summary":", etc.)
  cleaned = cleaned.replaceAll(RegExp(r'"[a-zA-Z]+"\s*:\s*'), '');

  // Remove stray quotes, brackets, braces
  cleaned = cleaned.replaceAll(RegExp(r'^["\[\{]+|["\]\}]+$'), '');
  cleaned = cleaned.replaceAll(RegExp(r'(?<!\\)"'), ''); // Remove unescaped quotes

  // Remove redundant section headers (in Catalan, Spanish, and English)
  // Matches patterns like "## Apertura", "## Opening", "## Cards", "## Cartas", etc.
  cleaned = cleaned.replaceAll(
    RegExp(
      r'^##\s*(Apertura|Opening|Obertura|Cards?|Cartes|S(?:i|\u00ed)ntesi[s]?|Synthesis|Orientaci[o\u00f3]|Guidance|Guia|Cartas Reveladas)\s*$',
      multiLine: true,
      caseSensitive: false,
    ),
    '',
  );

  // Convert escaped newlines to actual newlines
  cleaned = cleaned.replaceAll(r'\n', '\n');

  // Convert other common escape sequences
  cleaned = cleaned.replaceAll(r'\t', '\t');
  cleaned = cleaned.replaceAll(r'\"', '"');
  cleaned = cleaned.replaceAll(r"\'", "'");
  cleaned = cleaned.replaceAll(r'\\', '\\');

  // Remove any remaining backslashes followed by letters (other escape sequences)
  cleaned = cleaned.replaceAll(RegExp(r'\\[a-zA-Z]'), '');

  // Clean up multiple consecutive newlines
  cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n');

  // Trim whitespace
  cleaned = cleaned.trim();

  return cleaned;
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
  ).timeout(
    const Duration(seconds: 60),
    onTimeout: () {
      throw Exception('Connection timeout: Interpretation server did not respond within 60 seconds');
    },
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

  // Sanitize the interpretation to remove JSON artifacts
  final cleanInterpretation = _sanitizeInterpretation(interpretation);

  final summary = data['summary'] as String?;
  final cleanSummary = summary != null ? _sanitizeInterpretation(summary) : null;

  final keywords = (data['keywords'] as List<dynamic>? ?? <dynamic>[])
      .whereType<String>()
      .toList();

  return InterpretationResult(
    interpretation: cleanInterpretation,
    summary: cleanSummary,
    keywords: keywords,
  );
}
