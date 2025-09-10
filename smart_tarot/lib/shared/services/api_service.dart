import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contracts.dart';

class ApiService {
  final String baseUrl;
  final http.Client _client;

  ApiService({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  // Divination tool endpoints
  Future<DrawCardsResponse> drawCards(DrawCardsRequest request) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/draw/cards'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    _throwIfError(response);
    return DrawCardsResponse.fromJson(jsonDecode(response.body));
  }

  Future<TossCoinsResponse> tossCoins(TossCoinsRequest request) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/draw/coins'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    _throwIfError(response);
    return TossCoinsResponse.fromJson(jsonDecode(response.body));
  }

  Future<DrawRunesResponse> drawRunes(DrawRunesRequest request) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/draw/runes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    _throwIfError(response);
    return DrawRunesResponse.fromJson(jsonDecode(response.body));
  }

  // Chat interpretation endpoint
  Future<String> getInterpretation(
    {required List<ChatMessage> messages}
  ) async {
    final payload = {
      'messages': messages.map((m) => m.toJson()).toList(),
    };

    final response = await _client.post(
      Uri.parse('$baseUrl/api/chat/interpret'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    _throwIfError(response);
    final data = jsonDecode(response.body);
    return data['content'] as String;
  }

  // Session management
  Future<void> saveSession(SessionState session) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/sessions'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(session.toJson()),
    );

    _throwIfError(response);
  }

  Future<List<SessionState>> getUserSessions(String userId, {int limit = 20}) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/api/sessions/$userId?limit=$limit'),
      headers: {'Content-Type': 'application/json'},
    );

    _throwIfError(response);
    final data = jsonDecode(response.body);
    return (data['sessions'] as List)
        .map((s) => SessionState.fromJson(s))
        .toList();
  }

  Future<SessionState?> getSession(String sessionId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/api/sessions/detail/$sessionId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 404) return null;
    _throwIfError(response);
    
    final data = jsonDecode(response.body);
    return SessionState.fromJson(data);
  }

  // Premium/billing endpoints
  Future<Map<String, dynamic>> getUserPremiumStatus(String userId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/api/users/$userId/premium'),
      headers: {'Content-Type': 'application/json'},
    );

    _throwIfError(response);
    return jsonDecode(response.body);
  }

  Future<bool> canUserStartSession(String userId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/api/users/$userId/can-start-session'),
      headers: {'Content-Type': 'application/json'},
    );

    _throwIfError(response);
    final data = jsonDecode(response.body);
    return data['can_start'] as bool;
  }

  // Pack/content endpoints
  Future<Map<String, dynamic>> getPackManifest(String packId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/api/packs/$packId/manifest'),
      headers: {'Content-Type': 'application/json'},
    );

    _throwIfError(response);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getPackContent(String packId, String locale) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/api/packs/$packId/content/$locale'),
      headers: {'Content-Type': 'application/json'},
    );

    _throwIfError(response);
    return jsonDecode(response.body);
  }

  // Health check
  Future<bool> healthCheck() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/health'),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void _throwIfError(http.Response response) {
    if (response.statusCode >= 400) {
      String message;
      try {
        final data = jsonDecode(response.body);
        message = data['error'] ?? 'HTTP ${response.statusCode}';
      } catch (e) {
        message = 'HTTP ${response.statusCode}: ${response.body}';
      }
      throw ApiException(message, response.statusCode);
    }
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (HTTP $statusCode)';
}

extension SessionStateFromJson on SessionState {
  static SessionState fromJson(Map<String, dynamic> json) {
    return SessionState(
      sessionId: json['session_id'] as String,
      userId: json['user_id'] as String,
      technique: json['technique'] != null 
          ? DivinationTechnique.values.byName(json['technique']) 
          : null,
      locale: json['locale'] as String,
      topic: json['topic'] as String?,
      messages: (json['messages'] as List)
          .map((m) => ChatMessage.fromJson(m))
          .toList(),
      isPremium: json['is_premium'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastActivity: DateTime.parse(json['last_activity'] as String),
    );
  }
}