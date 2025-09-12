import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contracts.dart';
import '../contracts/interpretation_contracts.dart';

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

  // ULTRATHINK: Enhanced interpretation endpoint with proper contract alignment
  Future<InterpretationResponse> getInterpretation(
    InterpretationRequest request
  ) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/chat/interpret'),
      headers: {
        'Content-Type': 'application/json',
        'X-Request-ID': request.requestId ?? 'req_${DateTime.now().millisecondsSinceEpoch}',
      },
      body: jsonEncode(request.toJson()),
    );

    _throwIfError(response);
    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    
    return ApiResponse<InterpretationResponseData>.fromJson(
      responseData,
      (json) => InterpretationResponseData.fromJson(json as Map<String, dynamic>),
    );
  }

  // CONVENIENCE METHODS for easy integration

  /// Get interpretation for tarot cards reading
  Future<InterpretationResponse> getInterpretationForTarot({
    required List<TarotCard> cards,
    String? question,
    String? context,
    String? spread,
    String locale = 'en',
    String? userId,
  }) async {
    final results = DivinationResultsTransformer.fromTarotCards(
      cards: cards,
      spread: spread,
    );

    final request = InterpretationRequest.fromDivinationSession(
      technique: DivinationTechnique.tarot,
      results: results,
      question: question,
      context: context,
      locale: locale,
      userId: userId,
    );

    return await getInterpretation(request);
  }

  /// Get interpretation for runes reading
  Future<InterpretationResponse> getInterpretationForRunes({
    required List<Rune> runes,
    String? question,
    String? context,
    String? runeSet,
    String locale = 'en',
    String? userId,
  }) async {
    final results = DivinationResultsTransformer.fromRunes(
      runes: runes,
      runeSet: runeSet,
    );

    final request = InterpretationRequest.fromDivinationSession(
      technique: DivinationTechnique.runes,
      results: results,
      question: question,
      context: context,
      locale: locale,
      userId: userId,
    );

    return await getInterpretation(request);
  }

  /// Get interpretation for I Ching hexagram reading
  Future<InterpretationResponse> getInterpretationForIChing({
    required Hexagram hexagram,
    String? question,
    String? context,
    String locale = 'en',
    String? userId,
  }) async {
    final results = DivinationResultsTransformer.fromHexagram(
      hexagram: hexagram,
    );

    final request = InterpretationRequest.fromDivinationSession(
      technique: DivinationTechnique.iching,
      results: results,
      question: question,
      context: context,
      locale: locale,
      userId: userId,
    );

    return await getInterpretation(request);
  }

  /// DEPRECATED: Legacy method for backward compatibility
  @Deprecated('Use getInterpretationForTarot, getInterpretationForRunes, or getInterpretationForIChing instead')
  Future<String> getLegacyInterpretation({
    required List<ChatMessage> messages,
  }) async {
    // This is a fallback for existing code that hasn't been updated yet
    // It will attempt to extract divination data from chat messages
    
    throw UnimplementedError(
      'Legacy interpretation method is deprecated. '
      'Please use the new technique-specific methods: '
      'getInterpretationForTarot(), getInterpretationForRunes(), or getInterpretationForIChing()'
    );
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
      // Enhanced error handling with proper API error parsing
      try {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        
        // Check if it's a structured API error response
        if (errorData.containsKey('error') && errorData['error'] is Map) {
          final apiError = ApiError.fromJson(errorData['error'] as Map<String, dynamic>);
          throw ApiException(
            apiError.message,
            statusCode: response.statusCode,
            responseBody: response.body,
            errorCode: apiError.code,
            errorDetails: apiError.details,
            requestId: apiError.requestId,
          );
        }
      } catch (e) {
        // If parsing fails, fall back to generic error
      }
      
      // Generic error handling
      throw ApiException(
        'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        statusCode: response.statusCode,
        responseBody: response.body,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}

// Enhanced API exception with structured error information
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String responseBody;
  final String? errorCode;
  final Map<String, dynamic>? errorDetails;
  final String? requestId;

  const ApiException(
    this.message, {
    required this.statusCode,
    this.responseBody = '',
    this.errorCode,
    this.errorDetails,
    this.requestId,
  });

  @override
  String toString() {
    final buffer = StringBuffer('ApiException: $message');
    if (errorCode != null) {
      buffer.write(' (Code: $errorCode)');
    }
    if (requestId != null) {
      buffer.write(' [Request: $requestId]');
    }
    return buffer.toString();
  }

  /// Check if this is a specific type of error
  bool isValidationError() => errorCode == 'VALIDATION_ERROR';
  bool isServiceError() => errorCode == 'AI_SERVICE_ERROR';
  bool isTimeoutError() => errorCode == 'REQUEST_TIMEOUT';
  bool isConfigurationError() => errorCode == 'MISSING_API_KEY';

  /// Get user-friendly error message
  String getUserFriendlyMessage() {
    switch (errorCode) {
      case 'VALIDATION_ERROR':
        return 'Please check your input and try again.';
      case 'AI_SERVICE_ERROR':
        return 'The interpretation service is temporarily unavailable. Please try again later.';
      case 'REQUEST_TIMEOUT':
        return 'The request took too long to process. Please try again.';
      case 'MISSING_API_KEY':
        return 'The service is temporarily unavailable for maintenance.';
      default:
        return message;
    }
  }
}

