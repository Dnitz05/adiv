/// API Contracts - Type-safe request/response models for divination services
/// 
/// This file defines the core contracts for all API communication between
/// the Flutter client and the Vercel serverless backend. All models include
/// comprehensive validation and serialization support.
library api_contracts;

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'divination_technique.dart';

part 'api_contracts.g.dart';

// ============================================================================
// BASE CONTRACTS
// ============================================================================

/// Base class for all API requests
/// 
/// Provides common fields and validation logic shared across all requests
@immutable
abstract class ApiRequest {
  /// Creates a base API request
  const ApiRequest({
    required this.timestamp,
    this.requestId,
    this.userId,
  });
  
  /// ISO8601 timestamp when request was created on client
  final DateTime timestamp;
  
  /// Unique request identifier for tracing and deduplication
  final String? requestId;
  
  /// User identifier for session tracking (anonymous or authenticated)
  final String? userId;
  
  /// Convert to JSON for API transmission
  Map<String, dynamic> toJson();
  
  /// Validate request data before transmission
  /// 
  /// Throws [ArgumentError] if validation fails
  void validate() {
    if (timestamp.isAfter(DateTime.now().add(const Duration(minutes: 1)))) {
      throw ArgumentError('Request timestamp cannot be in the future');
    }
  }
}

/// Base class for all API responses
/// 
/// Provides common fields and metadata shared across all responses
@immutable
abstract class ApiResponse {
  /// Creates a base API response
  const ApiResponse({
    required this.timestamp,
    required this.seed,
    this.requestId,
    this.processingTimeMs,
  });
  
  /// ISO8601 timestamp when response was generated on server
  final DateTime timestamp;
  
  /// Cryptographic seed used for reproducible randomness
  /// 
  /// This seed can be used to replay the exact same result by calling
  /// the API again with the same seed parameter
  final String seed;
  
  /// Echo of request ID for correlation
  final String? requestId;
  
  /// Server processing time in milliseconds for performance monitoring
  final int? processingTimeMs;
  
  /// Convert to JSON for client consumption
  Map<String, dynamic> toJson();
  
  /// Validate response data after reception
  /// 
  /// Throws [ArgumentError] if validation fails
  void validate() {
    if (seed.isEmpty) {
      throw ArgumentError('Response seed cannot be empty');
    }
    if (seed.length < 16) {
      throw ArgumentError('Response seed too short for cryptographic security');
    }
    if (processingTimeMs != null && processingTimeMs! < 0) {
      throw ArgumentError('Processing time cannot be negative');
    }
  }
}

// ============================================================================
// TAROT CONTRACTS
// ============================================================================

/// Request to draw tarot cards
@JsonSerializable()
@immutable
class DrawCardsRequest extends ApiRequest {
  /// Creates a tarot card draw request
  const DrawCardsRequest({
    required super.timestamp,
    required this.count,
    super.requestId,
    super.userId,
    this.spread,
    this.seed,
    this.allowReversed = true,
  });
  
  /// Number of cards to draw (1-10)
  final int count;
  
  /// Spread type for positioned readings
  final String? spread;
  
  /// Optional seed for reproducible results
  final String? seed;
  
  /// Whether reversed cards are allowed
  final bool allowReversed;
  
  /// Create from JSON
  factory DrawCardsRequest.fromJson(Map<String, dynamic> json) =>
      _$DrawCardsRequestFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$DrawCardsRequestToJson(this);
  
  @override
  void validate() {
    super.validate();
    if (count < 1 || count > 10) {
      throw ArgumentError('Card count must be between 1 and 10');
    }
    if (seed != null && seed!.length < 8) {
      throw ArgumentError('Seed must be at least 8 characters');
    }
  }
}

/// Single tarot card data
@JsonSerializable()
@immutable
class TarotCard {
  /// Creates a tarot card
  const TarotCard({
    required this.id,
    required this.name,
    required this.suit,
    required this.number,
    required this.isReversed,
    required this.position,
  });
  
  /// Unique card identifier (0-77 for standard 78-card deck)
  final int id;
  
  /// Card name in English (e.g., "The Fool", "Three of Cups")
  final String name;
  
  /// Card suit (Major Arcana, Wands, Cups, Swords, Pentacles)
  final String suit;
  
  /// Card number within suit (null for Major Arcana)
  final int? number;
  
  /// Whether card is drawn in reversed position
  final bool isReversed;
  
  /// Position index in the spread (0-based)
  final int position;
  
  /// Create from JSON
  factory TarotCard.fromJson(Map<String, dynamic> json) =>
      _$TarotCardFromJson(json);
  
  /// Convert to JSON
  Map<String, dynamic> toJson() => _$TarotCardToJson(this);
  
  /// Get card asset path for images
  String get assetPath => 'assets/packs/tarot/cards/card_${id.toString().padLeft(2, '0')}.png';
  
  /// Check if this is a Major Arcana card
  bool get isMajorArcana => suit == 'Major Arcana';
  
  /// Get display name with reversed indicator
  String get displayName => isReversed ? '$name (Reversed)' : name;
}

/// Response containing drawn tarot cards
@JsonSerializable()
@immutable
class DrawCardsResponse extends ApiResponse {
  /// Creates a tarot cards response
  const DrawCardsResponse({
    required super.timestamp,
    required super.seed,
    required this.cards,
    required this.spread,
    super.requestId,
    super.processingTimeMs,
    this.randomOrgSignature,
  });
  
  /// List of drawn cards in order
  final List<TarotCard> cards;
  
  /// Spread type used for this reading
  final String spread;
  
  /// Optional Random.org signature for verification
  final String? randomOrgSignature;
  
  /// Create from JSON
  factory DrawCardsResponse.fromJson(Map<String, dynamic> json) =>
      _$DrawCardsResponseFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$DrawCardsResponseToJson(this);
  
  @override
  void validate() {
    super.validate();
    if (cards.isEmpty) {
      throw ArgumentError('Response must contain at least one card');
    }
    if (cards.length > 10) {
      throw ArgumentError('Response cannot contain more than 10 cards');
    }
    
    // Validate unique positions
    final Set<int> positions = cards.map((TarotCard card) => card.position).toSet();
    if (positions.length != cards.length) {
      throw ArgumentError('All cards must have unique positions');
    }
  }
  
  /// Get cards by position for spread layout
  Map<int, TarotCard> get cardsByPosition => {
    for (TarotCard card in cards) card.position: card
  };
}

// ============================================================================
// I CHING CONTRACTS  
// ============================================================================

/// Request to toss coins for I Ching hexagram
@JsonSerializable()
@immutable
class TossCoinsRequest extends ApiRequest {
  /// Creates an I Ching coin toss request
  const TossCoinsRequest({
    required super.timestamp,
    super.requestId,
    super.userId,
    this.seed,
    this.method = 'coins',
  });
  
  /// Optional seed for reproducible results
  final String? seed;
  
  /// Divination method ('coins' or 'yarrow')
  final String method;
  
  /// Create from JSON
  factory TossCoinsRequest.fromJson(Map<String, dynamic> json) =>
      _$TossCoinsRequestFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$TossCoinsRequestToJson(this);
  
  @override
  void validate() {
    super.validate();
    if (!['coins', 'yarrow'].contains(method)) {
      throw ArgumentError('Method must be "coins" or "yarrow"');
    }
  }
}

/// Single I Ching hexagram line
@JsonSerializable()
@immutable
class HexagramLine {
  /// Creates a hexagram line
  const HexagramLine({
    required this.position,
    required this.type,
    required this.isChanging,
    required this.value,
  });
  
  /// Line position (1-6, bottom to top)
  final int position;
  
  /// Line type ('yin' or 'yang')
  final String type;
  
  /// Whether this line is changing
  final bool isChanging;
  
  /// Numeric value (6=yin changing, 7=yang, 8=yin, 9=yang changing)
  final int value;
  
  /// Create from JSON
  factory HexagramLine.fromJson(Map<String, dynamic> json) =>
      _$HexagramLineFromJson(json);
  
  /// Convert to JSON
  Map<String, dynamic> toJson() => _$HexagramLineToJson(this);
  
  /// Get symbol representation
  String get symbol {
    if (type == 'yang') {
      return isChanging ? '⚋' : '━━━';
    } else {
      return isChanging ? '⚌' : '━ ━';
    }
  }
}

/// I Ching hexagram result
@JsonSerializable()
@immutable
class Hexagram {
  /// Creates a hexagram
  const Hexagram({
    required this.number,
    required this.name,
    required this.lines,
    required this.trigrams,
    this.transformedTo,
  });
  
  /// Hexagram number (1-64)
  final int number;
  
  /// Hexagram name (e.g., "The Creative")
  final String name;
  
  /// Six lines from bottom to top
  final List<HexagramLine> lines;
  
  /// Upper and lower trigrams
  final List<String> trigrams;
  
  /// Transformed hexagram if there are changing lines
  final Hexagram? transformedTo;
  
  /// Create from JSON
  factory Hexagram.fromJson(Map<String, dynamic> json) =>
      _$HexagramFromJson(json);
  
  /// Convert to JSON
  Map<String, dynamic> toJson() => _$HexagramToJson(this);
  
  /// Check if hexagram has changing lines
  bool get hasChangingLines => lines.any((HexagramLine line) => line.isChanging);
  
  /// Get visual representation
  String get visual => lines.map((HexagramLine line) => line.symbol).join('\n');
}

/// Response containing I Ching hexagram result
@JsonSerializable()
@immutable
class TossCoinsResponse extends ApiResponse {
  /// Creates an I Ching response
  const TossCoinsResponse({
    required super.timestamp,
    required super.seed,
    required this.result,
    super.requestId,
    super.processingTimeMs,
    this.randomOrgSignature,
  });
  
  /// Generated hexagram
  final Hexagram result;
  
  /// Optional Random.org signature for verification
  final String? randomOrgSignature;
  
  /// Create from JSON
  factory TossCoinsResponse.fromJson(Map<String, dynamic> json) =>
      _$TossCoinsResponseFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$TossCoinsResponseToJson(this);
  
  @override
  void validate() {
    super.validate();
    if (result.number < 1 || result.number > 64) {
      throw ArgumentError('Hexagram number must be between 1 and 64');
    }
    if (result.lines.length != 6) {
      throw ArgumentError('Hexagram must have exactly 6 lines');
    }
  }
}

// ============================================================================
// RUNES CONTRACTS
// ============================================================================

/// Request to draw runes
@JsonSerializable()
@immutable
class DrawRunesRequest extends ApiRequest {
  /// Creates a rune draw request
  const DrawRunesRequest({
    required super.timestamp,
    required this.count,
    super.requestId,
    super.userId,
    this.seed,
    this.allowReversed = true,
    this.runeSet = 'elder_futhark',
  });
  
  /// Number of runes to draw (1-5)
  final int count;
  
  /// Optional seed for reproducible results
  final String? seed;
  
  /// Whether reversed runes are allowed
  final bool allowReversed;
  
  /// Rune set to use
  final String runeSet;
  
  /// Create from JSON
  factory DrawRunesRequest.fromJson(Map<String, dynamic> json) =>
      _$DrawRunesRequestFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$DrawRunesRequestToJson(this);
  
  @override
  void validate() {
    super.validate();
    if (count < 1 || count > 5) {
      throw ArgumentError('Rune count must be between 1 and 5');
    }
    if (runeSet != 'elder_futhark') {
      throw ArgumentError('Only Elder Futhark runes are currently supported');
    }
  }
}

/// Single rune data
@JsonSerializable()
@immutable
class Rune {
  /// Creates a rune
  const Rune({
    required this.id,
    required this.name,
    required this.symbol,
    required this.isReversed,
    required this.position,
    required this.meaning,
  });
  
  /// Unique rune identifier (0-23 for Elder Futhark)
  final int id;
  
  /// Rune name (e.g., "Fehu", "Uruz")
  final String name;
  
  /// Unicode rune symbol
  final String symbol;
  
  /// Whether rune is drawn in reversed position
  final bool isReversed;
  
  /// Position index in the spread (0-based)
  final int position;
  
  /// Brief meaning/keyword
  final String meaning;
  
  /// Create from JSON
  factory Rune.fromJson(Map<String, dynamic> json) => _$RuneFromJson(json);
  
  /// Convert to JSON
  Map<String, dynamic> toJson() => _$RuneToJson(this);
  
  /// Get rune asset path for images
  String get assetPath => 'assets/packs/runes/runes/rune_${id.toString().padLeft(2, '0')}.png';
  
  /// Get display name with reversed indicator
  String get displayName => isReversed ? '$name (Reversed)' : name;
}

/// Response containing drawn runes
@JsonSerializable()
@immutable
class DrawRunesResponse extends ApiResponse {
  /// Creates a runes response
  const DrawRunesResponse({
    required super.timestamp,
    required super.seed,
    required this.runes,
    super.requestId,
    super.processingTimeMs,
    this.randomOrgSignature,
  });
  
  /// List of drawn runes in order
  final List<Rune> runes;
  
  /// Optional Random.org signature for verification
  final String? randomOrgSignature;
  
  /// Create from JSON
  factory DrawRunesResponse.fromJson(Map<String, dynamic> json) =>
      _$DrawRunesResponseFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$DrawRunesResponseToJson(this);
  
  @override
  void validate() {
    super.validate();
    if (runes.isEmpty) {
      throw ArgumentError('Response must contain at least one rune');
    }
    if (runes.length > 5) {
      throw ArgumentError('Response cannot contain more than 5 runes');
    }
    
    // Validate unique positions
    final Set<int> positions = runes.map((Rune rune) => rune.position).toSet();
    if (positions.length != runes.length) {
      throw ArgumentError('All runes must have unique positions');
    }
  }
}

// ============================================================================
// AI INTERPRETATION CONTRACTS
// ============================================================================

/// Request for AI interpretation of divination results
@JsonSerializable()
@immutable
class InterpretationRequest extends ApiRequest {
  /// Creates an interpretation request
  const InterpretationRequest({
    required super.timestamp,
    required this.technique,
    required this.results,
    required this.locale,
    super.requestId,
    super.userId,
    this.question,
    this.context,
  });
  
  /// Divination technique used
  final DivinationTechnique technique;
  
  /// Raw divination results (cards, hexagram, runes)
  final Map<String, dynamic> results;
  
  /// Locale for interpretation language
  final String locale;
  
  /// Optional user question or topic
  final String? question;
  
  /// Optional additional context
  final String? context;
  
  /// Create from JSON
  factory InterpretationRequest.fromJson(Map<String, dynamic> json) =>
      _$InterpretationRequestFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$InterpretationRequestToJson(this);
  
  @override
  void validate() {
    super.validate();
    if (results.isEmpty) {
      throw ArgumentError('Results cannot be empty');
    }
    if (!['en', 'es', 'ca'].contains(locale)) {
      throw ArgumentError('Unsupported locale: $locale');
    }
  }
}

/// Response containing AI interpretation
@JsonSerializable()
@immutable
class InterpretationResponse extends ApiResponse {
  /// Creates an interpretation response
  const InterpretationResponse({
    required super.timestamp,
    required super.seed,
    required this.interpretation,
    required this.summary,
    super.requestId,
    super.processingTimeMs,
    this.confidence,
    this.followUpQuestions,
  });
  
  /// Full interpretation text
  final String interpretation;
  
  /// Brief summary/key message
  final String summary;
  
  /// AI confidence score (0.0-1.0)
  final double? confidence;
  
  /// Suggested follow-up questions
  final List<String>? followUpQuestions;
  
  /// Create from JSON
  factory InterpretationResponse.fromJson(Map<String, dynamic> json) =>
      _$InterpretationResponseFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$InterpretationResponseToJson(this);
  
  @override
  void validate() {
    super.validate();
    if (interpretation.trim().isEmpty) {
      throw ArgumentError('Interpretation cannot be empty');
    }
    if (summary.trim().isEmpty) {
      throw ArgumentError('Summary cannot be empty');
    }
    if (confidence != null && (confidence! < 0.0 || confidence! > 1.0)) {
      throw ArgumentError('Confidence must be between 0.0 and 1.0');
    }
  }
}