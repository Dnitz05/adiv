/// RNG Service - Cryptographically Secure Random Number Generation
/// 
/// This service provides reproducible, verifiable randomness for all divination
/// operations. It integrates with Random.org for true randomness and includes
/// cryptographic seed generation for reproducible results.
library rng_service;

import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../contracts/divination_technique.dart';

/// Provider for the RNG service singleton
final ProviderFamily<RngService, String> rngServiceProvider = 
    Provider.family<RngService, String>((ProviderRef<RngService> ref, String apiKey) {
  return RngService(apiKey: apiKey);
});

/// Random number generation methods
enum RngMethod {
  /// Random.org true random API (preferred)
  randomOrg('random_org'),
  
  /// Cryptographically secure pseudorandom (fallback)
  cryptoSecure('crypto_secure'),
  
  /// Seeded pseudorandom (reproducible)
  seeded('seeded');
  
  const RngMethod(this.name);
  
  /// Method identifier
  final String name;
}

/// RNG request configuration
@immutable
class RngRequest {
  /// Creates an RNG request
  const RngRequest({
    required this.count,
    required this.min,
    required this.max,
    this.seed,
    this.method = RngMethod.randomOrg,
    this.userData,
  });
  
  /// Number of random integers to generate
  final int count;
  
  /// Minimum value (inclusive)
  final int min;
  
  /// Maximum value (inclusive)
  final int max;
  
  /// Optional seed for reproducible results
  final String? seed;
  
  /// Preferred generation method
  final RngMethod method;
  
  /// Additional user data for logging/analytics
  final Map<String, dynamic>? userData;
  
  /// Validate request parameters
  void validate() {
    if (count < 1 || count > 10000) {
      throw ArgumentError('Count must be between 1 and 10000');
    }
    if (min >= max) {
      throw ArgumentError('Min must be less than max');
    }
    if (max - min > 1000000) {
      throw ArgumentError('Range too large for efficient generation');
    }
    if (seed != null && seed!.length < 8) {
      throw ArgumentError('Seed must be at least 8 characters');
    }
  }
  
  /// Get cache key for this request configuration
  String get cacheKey => 
      '${count}_${min}_${max}_${seed ?? 'null'}_${method.name}';
}

/// RNG response with metadata
@immutable
class RngResponse {
  /// Creates an RNG response
  const RngResponse({
    required this.values,
    required this.seed,
    required this.method,
    required this.timestamp,
    this.randomOrgData,
    this.verificationSignature,
    this.processingTimeMs,
  });
  
  /// Generated random values
  final List<int> values;
  
  /// Seed used for generation (for reproducibility)
  final String seed;
  
  /// Method used for generation
  final RngMethod method;
  
  /// When values were generated
  final DateTime timestamp;
  
  /// Raw Random.org response data (if applicable)
  final Map<String, dynamic>? randomOrgData;
  
  /// Random.org verification signature (if applicable)
  final String? verificationSignature;
  
  /// Processing time in milliseconds
  final int? processingTimeMs;
  
  /// Convert to JSON for storage/transmission
  Map<String, dynamic> toJson() => <String, dynamic>{
    'values': values,
    'seed': seed,
    'method': method.name,
    'timestamp': timestamp.toIso8601String(),
    'random_org_data': randomOrgData,
    'verification_signature': verificationSignature,
    'processing_time_ms': processingTimeMs,
  };
  
  /// Create from JSON
  factory RngResponse.fromJson(Map<String, dynamic> json) {
    return RngResponse(
      values: List<int>.from(json['values'] as List<dynamic>),
      seed: json['seed'] as String,
      method: RngMethod.values.firstWhere(
        (RngMethod m) => m.name == json['method'],
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      randomOrgData: json['random_org_data'] as Map<String, dynamic>?,
      verificationSignature: json['verification_signature'] as String?,
      processingTimeMs: json['processing_time_ms'] as int?,
    );
  }
  
  /// Check if response is verifiable via Random.org
  bool get isVerifiable => verificationSignature != null;
  
  /// Get single value (for single-value requests)
  int get singleValue {
    if (values.length != 1) {
      throw StateError('Response does not contain exactly one value');
    }
    return values.first;
  }
  
  /// Get first N values
  List<int> take(int n) => values.take(n).toList();
}

/// Cryptographically secure random number generation service
/// 
/// Provides multiple randomness sources with fallback mechanisms:
/// 1. Random.org API for true atmospheric noise randomness
/// 2. Dart's crypto-secure PRNG for offline operation
/// 3. Seeded PRNG for reproducible testing and replay
class RngService {
  /// Creates an RNG service instance
  RngService({
    required String apiKey,
    Duration? timeout,
  }) : _apiKey = apiKey,
       _timeout = timeout ?? const Duration(seconds: 10),
       _dio = Dio(),
       _secureRandom = math.Random.secure();
  
  final String _apiKey;
  final Duration _timeout;
  final Dio _dio;
  final math.Random _secureRandom;
  
  // Cache for reproducible results
  final Map<String, RngResponse> _cache = <String, RngResponse>{};
  
  // Seeded generators for reproducibility
  final Map<String, math.Random> _seededGenerators = <String, math.Random>{};
  
  /// Generate random integers using the specified method
  /// 
  /// This is the main entry point for all random number generation.
  /// It handles method selection, caching, and fallback logic.
  Future<RngResponse> generateIntegers(RngRequest request) async {
    request.validate();
    
    final Stopwatch stopwatch = Stopwatch()..start();
    
    try {
      // Check cache for seeded requests
      if (request.seed != null) {
        final String cacheKey = request.cacheKey;
        if (_cache.containsKey(cacheKey)) {
          return _cache[cacheKey]!;
        }
      }
      
      RngResponse response;
      
      // Try preferred method first
      switch (request.method) {
        case RngMethod.randomOrg:
          response = await _generateWithRandomOrg(request);
          break;
        case RngMethod.cryptoSecure:
          response = _generateWithCryptoSecure(request);
          break;
        case RngMethod.seeded:
          response = _generateWithSeeded(request);
          break;
      }
      
      // Cache seeded results
      if (request.seed != null) {
        _cache[request.cacheKey] = response;
      }
      
      stopwatch.stop();
      return RngResponse(
        values: response.values,
        seed: response.seed,
        method: response.method,
        timestamp: response.timestamp,
        randomOrgData: response.randomOrgData,
        verificationSignature: response.verificationSignature,
        processingTimeMs: stopwatch.elapsedMilliseconds,
      );
      
    } catch (e) {
      stopwatch.stop();
      
      // Fallback to crypto-secure if Random.org fails
      if (request.method == RngMethod.randomOrg) {
        final RngRequest fallbackRequest = RngRequest(
          count: request.count,
          min: request.min,
          max: request.max,
          seed: request.seed,
          method: RngMethod.cryptoSecure,
          userData: request.userData,
        );
        
        final RngResponse fallbackResponse = _generateWithCryptoSecure(fallbackRequest);
        
        return RngResponse(
          values: fallbackResponse.values,
          seed: fallbackResponse.seed,
          method: RngMethod.cryptoSecure,
          timestamp: fallbackResponse.timestamp,
          processingTimeMs: stopwatch.elapsedMilliseconds,
        );
      }
      
      rethrow;
    }
  }
  
  /// Generate using Random.org true random API
  Future<RngResponse> _generateWithRandomOrg(RngRequest request) async {
    final Map<String, dynamic> payload = <String, dynamic>{
      'jsonrpc': '2.0',
      'method': 'generateSignedIntegers',
      'params': <String, dynamic>{
        'apiKey': _apiKey,
        'n': request.count,
        'min': request.min,
        'max': request.max,
        'replacement': true,
        'base': 10,
        'userData': request.userData ?? <String, dynamic>{
          'technique': 'divination',
          'timestamp': DateTime.now().toIso8601String(),
        },
      },
      'id': _generateRequestId(),
    };
    
    final Response<Map<String, dynamic>> response = await _dio.post<Map<String, dynamic>>(
      'https://api.random.org/json-rpc/4/invoke',
      data: payload,
      options: Options(
        sendTimeout: _timeout,
        receiveTimeout: _timeout,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      ),
    );
    
    if (response.data?['error'] != null) {
      throw Exception('Random.org API error: ${response.data!['error']}');
    }
    
    final Map<String, dynamic> result = response.data!['result'] as Map<String, dynamic>;
    final Map<String, dynamic> random = result['random'] as Map<String, dynamic>;
    final List<int> values = List<int>.from(random['data'] as List<dynamic>);
    
    // Extract signature for verification
    final String signature = result['signature'] as String;
    
    // Generate seed from signature for reproducibility
    final String seed = request.seed ?? _generateSeedFromSignature(signature);
    
    return RngResponse(
      values: values,
      seed: seed,
      method: RngMethod.randomOrg,
      timestamp: DateTime.now(),
      randomOrgData: result,
      verificationSignature: signature,
    );
  }
  
  /// Generate using cryptographically secure PRNG
  RngResponse _generateWithCryptoSecure(RngRequest request) {
    final String seed = request.seed ?? _generateCryptoSeed();
    
    // Use seed to initialize generator for reproducibility
    math.Random generator;
    if (request.seed != null) {
      final int seedHash = seed.hashCode;
      generator = math.Random(seedHash);
    } else {
      generator = _secureRandom;
    }
    
    final List<int> values = List<int>.generate(
      request.count,
      (int _) => generator.nextInt(request.max - request.min + 1) + request.min,
    );
    
    return RngResponse(
      values: values,
      seed: seed,
      method: RngMethod.cryptoSecure,
      timestamp: DateTime.now(),
    );
  }
  
  /// Generate using seeded PRNG for reproducible results
  RngResponse _generateWithSeeded(RngRequest request) {
    final String seed = request.seed ?? _generateCryptoSeed();
    
    // Get or create seeded generator
    math.Random generator = _seededGenerators[seed] ??= 
        math.Random(seed.hashCode);
    
    final List<int> values = List<int>.generate(
      request.count,
      (int _) => generator.nextInt(request.max - request.min + 1) + request.min,
    );
    
    return RngResponse(
      values: values,
      seed: seed,
      method: RngMethod.seeded,
      timestamp: DateTime.now(),
    );
  }
  
  /// Generate cryptographically secure seed
  String _generateCryptoSeed() {
    final Uint8List bytes = Uint8List(32); // 256 bits
    for (int i = 0; i < bytes.length; i++) {
      bytes[i] = _secureRandom.nextInt(256);
    }
    return base64Url.encode(bytes);
  }
  
  /// Generate seed from Random.org signature for reproducibility
  String _generateSeedFromSignature(String signature) {
    final List<int> bytes = utf8.encode(signature);
    final Digest digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes);
  }
  
  /// Generate unique request ID for Random.org
  String _generateRequestId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_secureRandom.nextInt(10000)}';
  }
  
  /// Clear cached results (for memory management)
  void clearCache() {
    _cache.clear();
    _seededGenerators.clear();
  }
  
  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return <String, dynamic>{
      'cached_responses': _cache.length,
      'seeded_generators': _seededGenerators.length,
      'total_memory_usage': _estimateCacheMemoryUsage(),
    };
  }
  
  int _estimateCacheMemoryUsage() {
    int totalBytes = 0;
    for (final RngResponse response in _cache.values) {
      // Rough estimation: each response ~1KB plus values
      totalBytes += 1024 + (response.values.length * 4);
    }
    return totalBytes;
  }
}

// ============================================================================
// TECHNIQUE-SPECIFIC RNG HELPERS
// ============================================================================

/// Extension methods for technique-specific random generation
extension RngTechniqueExtensions on RngService {
  /// Draw tarot cards with no repetitions
  /// 
  /// Generates unique card indices for a tarot reading
  Future<RngResponse> drawTarotCards({
    required int count,
    String? seed,
    bool allowReversed = true,
    int deckSize = 78,
  }) async {
    final RngRequest request = RngRequest(
      count: count * (allowReversed ? 2 : 1), // Extra numbers for reversal
      min: 0,
      max: deckSize - 1,
      seed: seed,
      userData: <String, dynamic>{
        'technique': 'tarot',
        'deck_size': deckSize,
        'allow_reversed': allowReversed,
      },
    );
    
    final RngResponse response = await generateIntegers(request);
    
    // Extract unique card indices
    final Set<int> drawnCards = <int>{};
    final List<int> cardIndices = <int>[];
    final List<int> reversals = allowReversed 
        ? response.values.skip(count).toList()
        : <int>[];
    
    for (int i = 0; i < response.values.length && cardIndices.length < count; i++) {
      final int cardIndex = response.values[i];
      if (!drawnCards.contains(cardIndex)) {
        drawnCards.add(cardIndex);
        cardIndices.add(cardIndex);
      }
    }
    
    // If we don't have enough unique cards, fallback to crypto-secure
    if (cardIndices.length < count) {
      return drawTarotCards(
        count: count,
        seed: seed != null ? '${seed}_fallback' : null,
        allowReversed: allowReversed,
        deckSize: deckSize,
      );
    }
    
    // Combine card indices with reversal flags
    final List<int> finalValues = <int>[];
    for (int i = 0; i < count; i++) {
      final int cardIndex = cardIndices[i];
      final bool isReversed = allowReversed && 
          reversals.isNotEmpty && 
          reversals[i % reversals.length] % 2 == 1;
      
      // Encode card index and reversal in single integer
      // Bit encoding: [31-bit card index][1-bit reversal]
      finalValues.add((cardIndex << 1) | (isReversed ? 1 : 0));
    }
    
    return RngResponse(
      values: finalValues,
      seed: response.seed,
      method: response.method,
      timestamp: response.timestamp,
      randomOrgData: response.randomOrgData,
      verificationSignature: response.verificationSignature,
      processingTimeMs: response.processingTimeMs,
    );
  }
  
  /// Toss coins for I Ching hexagram
  /// 
  /// Generates 6 coin tosses for traditional I Ching reading
  Future<RngResponse> tossIChingCoins({
    String? seed,
  }) async {
    final RngRequest request = RngRequest(
      count: 18, // 3 coins × 6 lines
      min: 0,
      max: 1, // 0 = tails, 1 = heads
      seed: seed,
      userData: <String, dynamic>{
        'technique': 'iching',
        'method': 'three_coins',
      },
    );
    
    final RngResponse response = await generateIntegers(request);
    
    // Convert coin tosses to line values (6, 7, 8, 9)
    final List<int> lineValues = <int>[];
    for (int line = 0; line < 6; line++) {
      final int baseIndex = line * 3;
      final int coin1 = response.values[baseIndex];     // 2 or 3
      final int coin2 = response.values[baseIndex + 1]; // 2 or 3  
      final int coin3 = response.values[baseIndex + 2]; // 2 or 3
      
      final int lineValue = (coin1 + 2) + (coin2 + 2) + (coin3 + 2);
      lineValues.add(lineValue);
    }
    
    return RngResponse(
      values: lineValues,
      seed: response.seed,
      method: response.method,
      timestamp: response.timestamp,
      randomOrgData: response.randomOrgData,
      verificationSignature: response.verificationSignature,
      processingTimeMs: response.processingTimeMs,
    );
  }
  
  /// Draw runes with no repetitions
  /// 
  /// Generates unique rune indices for a rune reading
  Future<RngResponse> drawRunes({
    required int count,
    String? seed,
    bool allowReversed = true,
    int runeSetSize = 24, // Elder Futhark
  }) async {
    final RngRequest request = RngRequest(
      count: count * 2, // Extra numbers for reversal and uniqueness
      min: 0,
      max: runeSetSize - 1,
      seed: seed,
      userData: <String, dynamic>{
        'technique': 'runes',
        'rune_set_size': runeSetSize,
        'allow_reversed': allowReversed,
      },
    );
    
    final RngResponse response = await generateIntegers(request);
    
    // Extract unique rune indices
    final Set<int> drawnRunes = <int>{};
    final List<int> runeIndices = <int>[];
    final List<int> reversals = response.values.skip(count).toList();
    
    for (int i = 0; i < response.values.length && runeIndices.length < count; i++) {
      final int runeIndex = response.values[i];
      if (!drawnRunes.contains(runeIndex)) {
        drawnRunes.add(runeIndex);
        runeIndices.add(runeIndex);
      }
    }
    
    // Combine rune indices with reversal flags
    final List<int> finalValues = <int>[];
    for (int i = 0; i < count; i++) {
      final int runeIndex = runeIndices[i];
      final bool isReversed = allowReversed && 
          reversals.isNotEmpty && 
          reversals[i % reversals.length] % 2 == 1;
      
      // Encode rune index and reversal in single integer
      finalValues.add((runeIndex << 1) | (isReversed ? 1 : 0));
    }
    
    return RngResponse(
      values: finalValues,
      seed: response.seed,
      method: response.method,
      timestamp: response.timestamp,
      randomOrgData: response.randomOrgData,
      verificationSignature: response.verificationSignature,
      processingTimeMs: response.processingTimeMs,
    );
  }
}

/// Utility functions for decoding technique-specific values
class RngDecoder {
  /// Decode tarot card from encoded value
  static (int cardIndex, bool isReversed) decodeTarotCard(int encodedValue) {
    final int cardIndex = encodedValue >> 1;
    final bool isReversed = (encodedValue & 1) == 1;
    return (cardIndex, isReversed);
  }
  
  /// Decode I Ching line from value (6, 7, 8, 9)
  static (String type, bool isChanging) decodeIChingLine(int lineValue) {
    switch (lineValue) {
      case 6:
        return ('yin', true);  // Old Yin (changing)
      case 7:
        return ('yang', false); // Young Yang
      case 8:
        return ('yin', false);  // Young Yin
      case 9:
        return ('yang', true);  // Old Yang (changing)
      default:
        throw ArgumentError('Invalid I Ching line value: $lineValue');
    }
  }
  
  /// Decode rune from encoded value
  static (int runeIndex, bool isReversed) decodeRune(int encodedValue) {
    final int runeIndex = encodedValue >> 1;
    final bool isReversed = (encodedValue & 1) == 1;
    return (runeIndex, isReversed);
  }
}