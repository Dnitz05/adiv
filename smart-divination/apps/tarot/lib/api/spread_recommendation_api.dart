import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_client.dart';
import '../user_identity.dart';
import '../models/tarot_spread.dart';

// For streaming
const utf8 = Utf8Codec();

class SpreadRecommendation {
  SpreadRecommendation({
    required this.spreadId,
    required this.spread,
    required this.reasoning,
    this.interpretationGuide,
    required this.confidenceScore,
    required this.keyFactors,
    this.detectedCategory,
    this.detectedComplexity,
    this.alternatives,
  });

  final String spreadId;
  final TarotSpread spread;
  final String reasoning;
  final String? interpretationGuide;
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
    String? interpretationGuide = json['interpretationGuide'] as String?;

    return SpreadRecommendation(
      spreadId: spreadData['id'] as String,
      spread: spread,
      reasoning: reasoning,
      interpretationGuide: interpretationGuide,
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
  void Function(String)? onReasoningChunk,
}) async {
  // Use streaming endpoint if callback provided
  if (onReasoningChunk != null) {
    return _recommendSpreadStreaming(
      question: question,
      locale: locale,
      userId: userId,
      onReasoningChunk: onReasoningChunk,
    );
  }

  // Otherwise use regular endpoint
  final uri = buildApiUri('api/spread/recommend');

  final effectiveUserId = userId ?? await UserIdentity.obtain();

  final headers = await buildAuthenticatedHeaders(
    locale: locale,
    userId: effectiveUserId,
    additional: {
      'content-type': 'application/json',
      'accept': 'application/json',
    },
  );

  final body = jsonEncode(<String, dynamic>{
    'question': question,
    'locale': locale,
    if (preferredComplexity != null && preferredComplexity.isNotEmpty)
      'preferredComplexity': preferredComplexity,
    if (preferredCategory != null && preferredCategory.isNotEmpty)
      'preferredCategory': preferredCategory,
  });

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

  if (res.statusCode != 200) {
    throw Exception('Spread recommendation failed (${res.statusCode}): ${res.body}');
  }

  final Map<String, dynamic> payload =
      jsonDecode(res.body) as Map<String, dynamic>;

  if (payload['success'] != true) {
    final error = payload['error'];
    throw Exception('Spread recommendation failed: ${error ?? payload}');
  }

  final outerData = payload['data'] as Map<String, dynamic>;
  final data = outerData['data'] as Map<String, dynamic>;
  return SpreadRecommendation.fromJson(data);
}

Future<SpreadRecommendation> _recommendSpreadStreaming({
  required String question,
  required String locale,
  String? userId,
  required void Function(String) onReasoningChunk,
}) async {
  final uri = buildApiUri('api/spread/recommend-stream');
  final effectiveUserId = userId ?? await UserIdentity.obtain();

  final headers = await buildAuthenticatedHeaders(
    locale: locale,
    userId: effectiveUserId,
    additional: {
      'content-type': 'application/json',
      'accept': 'text/event-stream',
    },
  );

  final body = jsonEncode(<String, dynamic>{
    'question': question,
    'locale': locale,
  });
  final request = http.Request('POST', uri);
  request.headers.addAll(headers);
  request.body = body;

  final response = await http.Client().send(request);

  if (response.statusCode != 200) {
    throw Exception('Streaming request failed (${response.statusCode})');
  }

  String? spreadId;
  TarotSpread? spread;
  String fullReason = '';
  double confidenceScore = 0.5;

  await for (final chunk in response.stream.transform(utf8.decoder)) {
    final lines = chunk.split('\n');
    for (final line in lines) {
      if (line.startsWith('data: ')) {
        final data = line.substring(6);
        if (data == '[DONE]') continue;

        try {
          final parsed = jsonDecode(data) as Map<String, dynamic>;
          final type = parsed['type'] as String?;

          if (type == 'chunk') {
            final content = parsed['content'] as String;
            fullReason += content;
            onReasoningChunk(content);
          } else if (type == 'complete') {
            spreadId = parsed['spreadId'] as String;
            spread = TarotSpreads.getById(spreadId!) ?? TarotSpreads.threeCard;
            confidenceScore = (parsed['confidenceScore'] as num?)?.toDouble() ?? 0.9;
            fullReason = parsed['reasoning'] as String? ?? fullReason;
          } else if (type == 'error') {
            throw Exception(parsed['error'] as String);
          }
        } catch (e) {
          // Silently skip malformed SSE events
        }
      }
    }
  }

  if (spreadId == null || spread == null) {
    throw Exception('No spread received from streaming API');
  }

  return SpreadRecommendation(
    spreadId: spreadId,
    spread: spread,
    reasoning: fullReason,
    confidenceScore: confidenceScore,
    keyFactors: [],
  );
}
