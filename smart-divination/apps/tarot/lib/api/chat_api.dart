import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_client.dart';
import '../user_identity.dart';

/// Send a chat message to the AI assistant and get a response
///
/// This is a general chat endpoint (not tarot-specific interpretation)
/// The AI will respond conversationally about spirituality, tarot, etc.
Future<String> sendChatMessage({
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

  // Handle both success response formats
  if (data['success'] == true && data['data'] != null) {
    final responseData = data['data'] as Map<String, dynamic>;
    return responseData['reply'] as String? ?? responseData['response'] as String;
  } else if (data['reply'] != null) {
    return data['reply'] as String;
  } else if (data['response'] != null) {
    return data['response'] as String;
  }

  throw Exception('Invalid response format from chat API');
}
