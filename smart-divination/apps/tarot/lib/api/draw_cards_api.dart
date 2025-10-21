import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import 'api_client.dart';
import '../user_identity.dart';

class CardResult {
  CardResult({
    required this.id,
    required this.name,
    required this.suit,
    required this.number,
    required this.upright,
    required this.position,
  });

  final String id;
  final String name;
  final String suit;
  final int? number;
  final bool upright;
  final int position;

  factory CardResult.fromJson(Map<String, dynamic> json) => CardResult(
        id: json['id'] as String,
        name: json['name'] as String,
        suit: json['suit'] as String,
        number: json['number'] == null ? null : (json['number'] as num).toInt(),
        upright: json['upright'] as bool,
        position: (json['position'] as num).toInt(),
      );
}

class CardsDrawResponse {
  CardsDrawResponse({
    required this.result,
    required this.seed,
    required this.method,
    required this.timestamp,
    required this.locale,
    required this.spread,
    this.signature,
    this.sessionId,
  });

  final List<CardResult> result;
  final String seed;
  final String method;
  final String timestamp;
  final String locale;
  final String spread;
  final String? signature;
  final String? sessionId;

  factory CardsDrawResponse.fromJson(Map<String, dynamic> json) =>
      CardsDrawResponse(
        result: (json['result'] as List<dynamic>)
            .map((e) => CardResult.fromJson(e as Map<String, dynamic>))
            .toList(),
        seed: json['seed'] as String,
        method: json['method'] as String,
        timestamp: json['timestamp'] as String,
        locale: json['locale'] as String? ?? 'en',
        spread: (json['spread'] as String?) ?? 'custom',
        signature: json['signature'] as String?,
        sessionId: json['sessionId'] as String?,
      );
}

Future<T> _retryWithBackoff<T>(
  Future<T> Function() operation, {
  int maxAttempts = 3,
  Duration initialDelay = const Duration(seconds: 1),
}) async {
  int attempt = 0;
  Duration delay = initialDelay;

  while (true) {
    attempt++;
    try {
      return await operation();
    } catch (e) {
      if (attempt >= maxAttempts) {
        rethrow;
      }

      await Future.delayed(delay);
      delay *= 2; // Exponential backoff
    }
  }
}

Future<CardsDrawResponse> drawCards({
  int count = 3,
  bool allowReversed = true,
  String? seed,
  String? question,
  String? spread,
  String? userId,
  String locale = 'en',
}) async {
  return _retryWithBackoff<CardsDrawResponse>(() async {
    final uri = buildApiUri('api/draw/cards');
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
      'count': count,
      'allow_reversed': allowReversed,
      if (seed != null && seed.isNotEmpty) 'seed': seed,
      if (question != null && question.isNotEmpty) 'question': question,
      if (spread != null && spread.isNotEmpty) 'spread': spread,
    });

    final res = await http.post(
      uri,
      headers: headers,
      body: body,
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw Exception('Connection timeout: Server did not respond within 30 seconds');
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Draw failed (${res.statusCode}): ${res.body}');
    }
    final Map<String, dynamic> data =
        jsonDecode(res.body) as Map<String, dynamic>;
    return CardsDrawResponse.fromJson(data);
  });
}

String generateSeed() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  return base64Url.encode(bytes).replaceAll('=', '');
}

class TarotSession {
  TarotSession({
    required this.id,
    required this.createdAt,
    required this.cards,
    required this.spread,
    required this.seed,
    required this.method,
    this.interpretation,
    this.interpretationSummary,
    this.question,
    List<String>? keywords,
  }) : keywords = keywords ?? const <String>[];

  final String id;
  final DateTime createdAt;
  final List<CardResult> cards;
  final String spread;
  final String seed;
  final String method;
  final String? interpretation;
  final String? interpretationSummary;
  final String? question;
  final List<String> keywords;
}

Future<List<TarotSession>> fetchTarotSessions({
  required String userId,
  int limit = 10,
}) async {
  final uri = buildApiUri(
    'api/sessions/$userId',
    <String, String>{
      'limit': '$limit',
      'technique': 'tarot',
      'orderBy': 'created_at',
      'orderDir': 'desc',
    },
  );

  final historyHeaders = await buildAuthenticatedHeaders(
    userId: userId,
    additional: {
      'accept': 'application/json',
    },
  );

  final res = await http.get(
    uri,
    headers: historyHeaders,
  ).timeout(
    const Duration(seconds: 30),
    onTimeout: () {
      throw Exception('Connection timeout: Server did not respond within 30 seconds');
    },
  );

  if (res.statusCode != 200) {
    throw Exception('History fetch failed (${res.statusCode}): ${res.body}');
  }

  final Map<String, dynamic> payload =
      jsonDecode(res.body) as Map<String, dynamic>;

  if (payload['success'] != true) {
    final error = payload['error'];
    throw Exception('History fetch failed: ${error ?? payload}');
  }

  final data = payload['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
  final sessions = (data['sessions'] as List<dynamic>? ?? <dynamic>[])
      .cast<Map<String, dynamic>>();

  return sessions.map(_mapSession).toList();
}

TarotSession _mapSession(Map<String, dynamic> session) {
  final artifactsList = (session['artifacts'] as List<dynamic>? ?? <dynamic>[])
      .whereType<Map<String, dynamic>>()
      .map((artifact) => Map<String, dynamic>.from(artifact))
      .toList();

  Map<String, dynamic>? drawPayload;
  String? interpretation;
  String? interpretationSummary;
  String? question;
  List<String> keywords = <String>[];

  for (final artifact in artifactsList) {
    final type = artifact['type'] as String?;
    if (type == 'tarot_draw' && artifact['payload'] is Map<String, dynamic>) {
      drawPayload = Map<String, dynamic>.from(
        artifact['payload'] as Map<String, dynamic>,
      );
      continue;
    }

    if (type == 'interpretation' &&
        artifact['payload'] is Map<String, dynamic>) {
      final payload = Map<String, dynamic>.from(
        artifact['payload'] as Map<String, dynamic>,
      );
      interpretation ??= payload['interpretation'] as String?;
      interpretationSummary ??= payload['summary'] as String?;
      question ??= payload['question'] as String?;
      final artifactKeywords =
          (payload['keywords'] as List<dynamic>? ?? <dynamic>[])
              .whereType<String>()
              .toList();
      if (artifactKeywords.isNotEmpty) {
        keywords = artifactKeywords;
      }
    }
  }

  final dynamic sessionResults = session['results'];
  final results = drawPayload ??
      (sessionResults is Map
          ? Map<String, dynamic>.from(sessionResults)
          : <String, dynamic>{});

  final List<Map<String, dynamic>> cardsJson =
      (results['cards'] as List<dynamic>? ?? <dynamic>[]).map((rawCard) {
    Map<String, dynamic> card;
    if (rawCard is Map<String, dynamic>) {
      card = Map<String, dynamic>.from(rawCard);
    } else if (rawCard is Map) {
      card = rawCard.map((key, value) => MapEntry(key.toString(), value));
    } else {
      card = <String, dynamic>{};
    }
    final dynamic originalId = card['id'];
    card['id'] =
        originalId != null ? originalId.toString() : (card['name'] ?? 'card');
    final dynamic isReversedValue = card['isReversed'];
    final bool isReversed = isReversedValue is bool ? isReversedValue : false;
    card['upright'] = card['upright'] ?? !isReversed;
    if (!card.containsKey('position') && card.containsKey('index')) {
      final dynamic positionIndex = card['index'];
      if (positionIndex is num) {
        card['position'] = positionIndex.toInt();
      }
    }
    return card;
  }).toList();

  final dynamic sessionMetadata = session['metadata'];
  final metadata = sessionMetadata is Map
      ? Map<String, dynamic>.from(sessionMetadata)
      : <String, dynamic>{};

  final createdAt =
      session['createdAt'] as String? ?? session['created_at'] as String? ?? '';
  final seed =
      (drawPayload?['seed'] as String?) ?? metadata['seed'] as String? ?? '';
  final method = (drawPayload?['method'] as String?) ??
      metadata['method'] as String? ??
      'unknown';
  final spread = results['spread'] as String? ?? 'custom';
  final interpretationFallback = session['interpretation'] as String?;

  final messagesList = (session['messages'] as List<dynamic>? ?? <dynamic>[])
      .whereType<Map<String, dynamic>>()
      .map((message) => Map<String, dynamic>.from(message))
      .toList();

  String? userQuestion = question;
  if (userQuestion == null) {
    for (final message in messagesList.reversed) {
      final sender = message['sender'] as String?;
      if (sender == 'user') {
        userQuestion = (message['content'] as String?)?.trim();
        final metadataMap = message['metadata'] as Map<String, dynamic>?;
        if (metadataMap != null && keywords.isEmpty) {
          final messageKeywords =
              (metadataMap['keywords'] as List<dynamic>? ?? <dynamic>[])
                  .whereType<String>()
                  .toList();
          if (messageKeywords.isNotEmpty) {
            keywords = messageKeywords;
          }
        }
        break;
      }
    }
  }

  String? assistantInterpretation = interpretation ?? interpretationFallback;
  if (assistantInterpretation == null) {
    for (final message in messagesList.reversed) {
      final sender = message['sender'] as String?;
      if (sender == 'assistant') {
        assistantInterpretation = message['content'] as String?;
        final metadataMap = message['metadata'] as Map<String, dynamic>?;
        if (metadataMap != null) {
          interpretationSummary ??=
              metadataMap['summary'] as String? ?? interpretationSummary;
          if (keywords.isEmpty) {
            final messageKeywords =
                (metadataMap['keywords'] as List<dynamic>? ?? <dynamic>[])
                    .whereType<String>()
                    .toList();
            if (messageKeywords.isNotEmpty) {
              keywords = messageKeywords;
            }
          }
        }
        break;
      }
    }
  }

  return TarotSession(
    id: session['id'] as String? ?? '',
    createdAt: DateTime.tryParse(createdAt)?.toLocal() ??
        DateTime.fromMillisecondsSinceEpoch(0),
    cards: cardsJson.map(CardResult.fromJson).toList(),
    spread: spread,
    seed: seed,
    method: method,
    interpretation: assistantInterpretation,
    interpretationSummary: interpretationSummary,
    question: userQuestion,
    keywords: keywords,
  );
}
