import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_client.dart';
import '../models/chat_message.dart';
import '../user_identity.dart';

/// Send a chat message to the AI assistant and get a response composed of one or more assistant messages.
Future<List<ChatMessage>> sendChatMessage({
  required String message,
  String? userId,
  String locale = 'en',
  List<Map<String, String>>? conversationHistory,
}) async {
  final uri = buildApiUri('api/chat/general');
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
    'message': message,
    'userId': effectiveUserId,
    'locale': locale,
    if (conversationHistory != null && conversationHistory.isNotEmpty)
      'conversationHistory': conversationHistory,
  });

  final res = await http.post(
    uri,
    headers: headers,
    body: body,
  ).timeout(
    const Duration(seconds: 60), // Longer timeout for AI responses
    onTimeout: () {
      throw Exception('Connection timeout: Server did not respond within 60 seconds');
    },
  );

  if (res.statusCode != 200) {
    throw Exception('Chat request failed (${res.statusCode}): ${res.body}');
  }

  final Map<String, dynamic> data = jsonDecode(res.body) as Map<String, dynamic>;

  if (data['success'] == true && data['data'] != null) {
    final responseData = data['data'] as Map<String, dynamic>;
    final messagesJson = responseData['messages'] as List<dynamic>?;
    if (messagesJson != null) {
      return _parseAssistantMessages(messagesJson);
    }
    final fallbackText = responseData['reply'] as String? ?? responseData['response'] as String?;
    if (fallbackText != null) {
      return [
        ChatMessage.text(
          id: _generateMessageId('text', 0, DateTime.now()),
          isUser: false,
          timestamp: DateTime.now(),
          text: fallbackText,
        ),
      ];
    }
  }

  final reply = data['reply'] as String?;
  if (reply != null) {
    final now = DateTime.now();
    return [
      ChatMessage.text(
        id: _generateMessageId('text', 0, now),
        isUser: false,
        timestamp: now,
        text: reply,
      ),
    ];
  }

  final responseText = data['response'] as String?;
  if (responseText != null) {
    final now = DateTime.now();
    return [
      ChatMessage.text(
        id: _generateMessageId('text', 0, now),
        isUser: false,
        timestamp: now,
        text: responseText,
      ),
    ];
  }

  throw Exception('Invalid response format from chat API');
}

/// FASE 3: Returns ChatResponseData containing messages and optional position interactions
Future<ChatResponseData> interpretChatSpread({
  required String spreadId,
  required String spreadMessageId,
  required List<ChatSpreadCardData> cards,
  String? question,
  String? userId,
  String locale = 'en',
}) async {
  final uri = buildApiUri('api/chat/interpret');
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
    'spreadMessageId': spreadMessageId,
    'spreadId': spreadId,
    'userId': effectiveUserId,
    'locale': locale,
    if (question != null && question.isNotEmpty) 'question': question,
    'cards': cards
        .map((card) => {
              'id': card.id,
              'upright': card.upright,
              'position': card.position,
              'meaning': card.meaning ?? card.meaningShort ?? 'Position ${card.position}',
            })
        .toList(),
  });

  final res = await http.post(
    uri,
    headers: headers,
    body: body,
  ).timeout(
    const Duration(seconds: 60),
    onTimeout: () {
      throw Exception('Connection timeout: Server did not respond within 60 seconds');
    },
  );

  if (res.statusCode != 200) {
    throw Exception('Interpretation request failed (${res.statusCode}): ${res.body}');
  }

  final Map<String, dynamic> data = jsonDecode(res.body) as Map<String, dynamic>;
  if (data['success'] == true && data['data'] != null) {
    final responseData = data['data'] as Map<String, dynamic>;
    // FASE 3: Use ChatResponseData.fromJson to parse messages + positionInteractions
    return ChatResponseData.fromJson(responseData);
  }

  throw Exception('Invalid response format from interpretation API');
}

List<ChatMessage> _parseAssistantMessages(List<dynamic> messagesJson) {
  final now = DateTime.now();
  final List<ChatMessage> messages = [];

  for (var index = 0; index < messagesJson.length; index++) {
    final rawMessage = messagesJson[index];
    if (rawMessage is! Map<String, dynamic>) {
      continue;
    }

    final type = rawMessage['type'] as String? ?? 'text';
    final messageId = (rawMessage['id'] as String?) ?? _generateMessageId(type, index, now);

    switch (type) {
      case 'tarot_spread':
        final spreadData = ChatSpreadData.fromJson(rawMessage);
        messages.add(
          ChatMessage(
            id: messageId,
            kind: ChatMessageKind.spread,
            isUser: false,
            timestamp: now,
            spread: spreadData,
          ),
        );
        break;
      case 'cta':
        final payload = rawMessage['payload'] as Map<String, dynamic>? ?? <String, dynamic>{};
        final actionData = ChatActionData(
          type: ChatActionType.interpretSpread,
          label: rawMessage['label'] as String? ?? 'Interpretation',
          spreadMessageId: payload['spreadMessageId'] as String? ?? '',
          spreadId: payload['spreadId'] as String? ?? '',
        );
        messages.add(
          ChatMessage(
            id: messageId,
            kind: ChatMessageKind.action,
            isUser: false,
            timestamp: now,
            action: actionData,
          ),
        );
        break;
      default:
        final text = rawMessage['text'] as String? ?? '';
        messages.add(
          ChatMessage.text(
            id: messageId,
            isUser: false,
            timestamp: now,
            text: text,
          ),
        );
        break;
    }
  }

  return messages;
}

String _generateMessageId(String type, int index, DateTime timestamp) {
  return '${type}_${timestamp.microsecondsSinceEpoch}_$index';
}
