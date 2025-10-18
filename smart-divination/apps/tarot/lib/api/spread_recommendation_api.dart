import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_client.dart';
import '../user_identity.dart';
import '../models/tarot_spread.dart';

class SpreadRecommendation {
  SpreadRecommendation({
    required this.spreadId,
    required this.spread,
    required this.reasoning,
    required this.confidenceScore,
    required this.keyFactors,
    this.detectedCategory,
    this.detectedComplexity,
    this.alternatives,
  });

  final String spreadId;
  final TarotSpread spread;
  final String reasoning;
  final double confidenceScore;
  final List<String> keyFactors;
  final String? detectedCategory;
  final String? detectedComplexity;
  final List<TarotSpread>? alternatives;

  factory SpreadRecommendation.fromJson(Map<String, dynamic> json) {
    final spreadData = json['spread'] as Map<String, dynamic>;
    final spreadId = spreadData['id'] as String;

    // Get the spread from TarotSpreads predefined spreads
    final spread = TarotSpreads.getById(spreadId) ?? TarotSpreads.threeCard;

    List<TarotSpread>? alternatives;
    if (json['alternatives'] != null) {
      alternatives = (json['alternatives'] as List<dynamic>)
          .map((altData) {
            final alt = altData as Map<String, dynamic>;
            final altId = alt['id'] as String;
            return TarotSpreads.getById(altId) ?? TarotSpreads.threeCard;
          })
          .toList();
    }

    // Choose reasoning based on locale (default to main reasoning)
    String reasoning = json['reasoning'] as String? ?? '';

    return SpreadRecommendation(
      spreadId: spreadData['id'] as String,
      spread: spread,
      reasoning: reasoning,
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble() ?? 0.5,
      keyFactors: (json['keyFactors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      detectedCategory: json['detectedCategory'] as String?,
      detectedComplexity: json['detectedComplexity'] as String?,
      alternatives: alternatives,
    );
  }
}

Future<SpreadRecommendation> recommendSpread({
  required String question,
  String locale = 'es',
  String? preferredComplexity,
  String? preferredCategory,
  String? userId,
}) async {
  print('🔮 DEBUG: recommendSpread called with question="$question", locale=$locale');

  final uri = buildApiUri('api/spread/recommend');
  print('🔮 DEBUG: URI built: $uri');

  final effectiveUserId = userId ?? await UserIdentity.obtain();
  print('🔮 DEBUG: User ID: $effectiveUserId');

  final headers = await buildAuthenticatedHeaders(
    locale: locale,
    userId: effectiveUserId,
    additional: {
      'content-type': 'application/json',
      'accept': 'application/json',
    },
  );
  print('🔮 DEBUG: Headers built, preparing body');

  final body = jsonEncode(<String, dynamic>{
    'question': question,
    'locale': locale,
    if (preferredComplexity != null && preferredComplexity.isNotEmpty)
      'preferredComplexity': preferredComplexity,
    if (preferredCategory != null && preferredCategory.isNotEmpty)
      'preferredCategory': preferredCategory,
  });
  print('🔮 DEBUG: Body: $body');

  print('🔮 DEBUG: Making POST request to $uri');
  final res = await http.post(
    uri,
    headers: headers,
    body: body,
  ).timeout(
    const Duration(seconds: 10),
    onTimeout: () {
      throw Exception('Connection timeout: AI spread selection timed out');
    },
  );
  print('🔮 DEBUG: Response status: ${res.statusCode}');

  if (res.statusCode != 200) {
    print('🔮 DEBUG: Request failed with ${res.statusCode}: ${res.body}');
    throw Exception('Spread recommendation failed (${res.statusCode}): ${res.body}');
  }

  print('🔮 DEBUG: Parsing response body');
  final Map<String, dynamic> payload =
      jsonDecode(res.body) as Map<String, dynamic>;

  if (payload['success'] != true) {
    final error = payload['error'];
    throw Exception('Spread recommendation failed: ${error ?? payload}');
  }

  final data = payload['data'] as Map<String, dynamic>;
  return SpreadRecommendation.fromJson(data);
}
