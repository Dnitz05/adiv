// TypeScript-style contracts for the divination tools

import 'dart:convert';

/// Base tool request/response contracts
abstract class ToolRequest {
  String get toolName;
  String? get seed;
  Map<String, dynamic> toJson();
}

abstract class ToolResponse {
  final String seed;
  final DateTime timestamp;
  final String locale;
  
  const ToolResponse({
    required this.seed,
    required this.timestamp,
    required this.locale,
  });

  Map<String, dynamic> toJson();
}

/// Tarot Tool Contracts
class DrawCardsRequest extends ToolRequest {
  final int count;
  final bool allowReversed;
  final String deckId;
  @override
  final String? seed;

  const DrawCardsRequest({
    required this.count,
    this.allowReversed = true,
    this.deckId = 'rws',
    this.seed,
  });

  @override
  String get toolName => 'draw_cards';

  @override
  Map<String, dynamic> toJson() => {
    'count': count,
    'allow_reversed': allowReversed,
    'deck_id': deckId,
    if (seed != null) 'seed': seed,
  };
}

class CardResult {
  final String id;
  final bool upright;
  final int position;

  const CardResult({
    required this.id,
    required this.upright,
    required this.position,
  });

  factory CardResult.fromJson(Map<String, dynamic> json) => CardResult(
    id: json['id'] as String,
    upright: json['upright'] as bool,
    position: json['position'] as int,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'upright': upright,
    'position': position,
  };
}

class DrawCardsResponse extends ToolResponse {
  final List<CardResult> cards;

  const DrawCardsResponse({
    required this.cards,
    required super.seed,
    required super.timestamp,
    required super.locale,
  });

  factory DrawCardsResponse.fromJson(Map<String, dynamic> json) => DrawCardsResponse(
    cards: (json['result'] as List).map((e) => CardResult.fromJson(e)).toList(),
    seed: json['seed'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    locale: json['locale'] as String,
  );

  @override
  Map<String, dynamic> toJson() => {
    'result': cards.map((c) => c.toJson()).toList(),
    'seed': seed,
    'timestamp': timestamp.toIso8601String(),
    'locale': locale,
  };
}

/// I Ching Tool Contracts
class TossCoinsRequest extends ToolRequest {
  final int rounds;
  @override
  final String? seed;

  const TossCoinsRequest({
    this.rounds = 6,
    this.seed,
  });

  @override
  String get toolName => 'toss_coins';

  @override
  Map<String, dynamic> toJson() => {
    'rounds': rounds,
    if (seed != null) 'seed': seed,
  };
}

class IChingResult {
  final List<int> lines; // 6-9 values for each line
  final int primaryHex;
  final List<int> changingLines;
  final int? resultHex;

  const IChingResult({
    required this.lines,
    required this.primaryHex,
    required this.changingLines,
    this.resultHex,
  });

  factory IChingResult.fromJson(Map<String, dynamic> json) => IChingResult(
    lines: List<int>.from(json['lines']),
    primaryHex: json['primary_hex'] as int,
    changingLines: List<int>.from(json['changing_lines']),
    resultHex: json['result_hex'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'lines': lines,
    'primary_hex': primaryHex,
    'changing_lines': changingLines,
    if (resultHex != null) 'result_hex': resultHex,
  };
}

class TossCoinsResponse extends ToolResponse {
  final IChingResult result;

  const TossCoinsResponse({
    required this.result,
    required super.seed,
    required super.timestamp,
    required super.locale,
  });

  factory TossCoinsResponse.fromJson(Map<String, dynamic> json) => TossCoinsResponse(
    result: IChingResult.fromJson(json['result']),
    seed: json['seed'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    locale: json['locale'] as String,
  );

  @override
  Map<String, dynamic> toJson() => {
    'result': result.toJson(),
    'seed': seed,
    'timestamp': timestamp.toIso8601String(),
    'locale': locale,
  };
}

/// Runes Tool Contracts
class DrawRunesRequest extends ToolRequest {
  final int count;
  final bool allowReversed;
  @override
  final String? seed;

  const DrawRunesRequest({
    required this.count,
    this.allowReversed = true,
    this.seed,
  });

  @override
  String get toolName => 'draw_runes';

  @override
  Map<String, dynamic> toJson() => {
    'count': count,
    'allow_reversed': allowReversed,
    if (seed != null) 'seed': seed,
  };
}

class RuneResult {
  final String id;
  final bool upright;
  final String slot;

  const RuneResult({
    required this.id,
    required this.upright,
    required this.slot,
  });

  factory RuneResult.fromJson(Map<String, dynamic> json) => RuneResult(
    id: json['id'] as String,
    upright: json['upright'] as bool,
    slot: json['slot'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'upright': upright,
    'slot': slot,
  };
}

class DrawRunesResponse extends ToolResponse {
  final List<RuneResult> runes;

  const DrawRunesResponse({
    required this.runes,
    required super.seed,
    required super.timestamp,
    required super.locale,
  });

  factory DrawRunesResponse.fromJson(Map<String, dynamic> json) => DrawRunesResponse(
    runes: (json['result'] as List).map((e) => RuneResult.fromJson(e)).toList(),
    seed: json['seed'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    locale: json['locale'] as String,
  );

  @override
  Map<String, dynamic> toJson() => {
    'result': runes.map((r) => r.toJson()).toList(),
    'seed': seed,
    'timestamp': timestamp.toIso8601String(),
    'locale': locale,
  };
}

/// Chat contracts
enum ChatRole { user, assistant, system }

class ChatMessage {
  final ChatRole role;
  final String content;
  final DateTime timestamp;
  final Map<String, dynamic>? toolCall;
  final Map<String, dynamic>? toolResult;

  const ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
    this.toolCall,
    this.toolResult,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    role: ChatRole.values.byName(json['role']),
    content: json['content'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    toolCall: json['tool_call'],
    toolResult: json['tool_result'],
  );

  Map<String, dynamic> toJson() => {
    'role': role.name,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    if (toolCall != null) 'tool_call': toolCall,
    if (toolResult != null) 'tool_result': toolResult,
  };
}

/// Session state
enum DivinationTechnique { tarot, iching, runes }

class SessionState {
  final String sessionId;
  final String userId;
  final DivinationTechnique? technique;
  final String locale;
  final String? topic;
  final List<ChatMessage> messages;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime lastActivity;

  const SessionState({
    required this.sessionId,
    required this.userId,
    this.technique,
    required this.locale,
    this.topic,
    required this.messages,
    required this.isPremium,
    required this.createdAt,
    required this.lastActivity,
  });

  SessionState copyWith({
    DivinationTechnique? technique,
    String? topic,
    List<ChatMessage>? messages,
    DateTime? lastActivity,
  }) {
    return SessionState(
      sessionId: sessionId,
      userId: userId,
      technique: technique ?? this.technique,
      locale: locale,
      topic: topic ?? this.topic,
      messages: messages ?? this.messages,
      isPremium: isPremium,
      createdAt: createdAt,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }

  Map<String, dynamic> toJson() => {
    'session_id': sessionId,
    'user_id': userId,
    'technique': technique?.name,
    'locale': locale,
    'topic': topic,
    'messages': messages.map((m) => m.toJson()).toList(),
    'is_premium': isPremium,
    'created_at': createdAt.toIso8601String(),
    'last_activity': lastActivity.toIso8601String(),
  };
}