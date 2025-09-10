/// Session & Chat Contracts - State management for divination sessions
/// 
/// This file defines the contracts for managing chat-based divination sessions,
/// including message handling, session state, and user interaction patterns.
library session_contracts;

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'divination_technique.dart';

part 'session_contracts.g.dart';

// ============================================================================
// CHAT MESSAGE SYSTEM
// ============================================================================

/// Chat message roles in the conversation
@JsonEnum()
enum ChatRole {
  /// Messages from the user
  user('user'),
  
  /// Messages from the AI assistant
  assistant('assistant'),
  
  /// System messages for context and instructions
  system('system');
  
  const ChatRole(this.value);
  
  /// String value for API serialization
  final String value;
}

/// Chat message type for UI presentation
@JsonEnum()
enum MessageType {
  /// Regular text message
  text('text'),
  
  /// Message containing divination results (cards, hexagram, runes)
  divination('divination'),
  
  /// AI interpretation of results
  interpretation('interpretation'),
  
  /// System notification or status update
  notification('notification'),
  
  /// Error message
  error('error');
  
  const MessageType(this.value);
  
  /// String value for serialization
  final String value;
}

/// Individual chat message in a divination session
@JsonSerializable()
@immutable
class ChatMessage {
  /// Creates a chat message
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.metadata,
    this.toolCall,
    this.divinationResults,
    this.isStreaming = false,
    this.reactions,
  });
  
  /// Unique message identifier
  final String id;
  
  /// Message role (user, assistant, system)
  final ChatRole role;
  
  /// Message content (text)
  final String content;
  
  /// When the message was created
  final DateTime timestamp;
  
  /// Message type for UI presentation
  final MessageType type;
  
  /// Additional metadata for message
  final Map<String, dynamic>? metadata;
  
  /// Tool call information if this is a function call
  final Map<String, dynamic>? toolCall;
  
  /// Divination results if this message contains them
  final Map<String, dynamic>? divinationResults;
  
  /// Whether message is currently being streamed
  final bool isStreaming;
  
  /// User reactions to message (like, dislike, etc.)
  final List<String>? reactions;
  
  /// Create from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
  
  /// Convert to JSON
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
  
  /// Create a copy with updated fields
  ChatMessage copyWith({
    String? id,
    ChatRole? role,
    String? content,
    DateTime? timestamp,
    MessageType? type,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? toolCall,
    Map<String, dynamic>? divinationResults,
    bool? isStreaming,
    List<String>? reactions,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      toolCall: toolCall ?? this.toolCall,
      divinationResults: divinationResults ?? this.divinationResults,
      isStreaming: isStreaming ?? this.isStreaming,
      reactions: reactions ?? this.reactions,
    );
  }
  
  /// Check if message has divination results
  bool get hasDivinationResults => divinationResults?.isNotEmpty == true;
  
  /// Check if message is from user
  bool get isFromUser => role == ChatRole.user;
  
  /// Check if message is from assistant
  bool get isFromAssistant => role == ChatRole.assistant;
  
  /// Check if message represents an error
  bool get isError => type == MessageType.error;
  
  /// Get formatted timestamp for display
  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

// ============================================================================
// SESSION STATE MANAGEMENT
// ============================================================================

/// Session phase indicating current state in the divination process
@JsonEnum()
enum SessionPhase {
  /// Session is being initialized
  initializing('initializing'),
  
  /// Waiting for user to specify their question/topic
  waitingForTopic('waiting_for_topic'),
  
  /// Performing divination (drawing cards, tossing coins, etc.)
  performingDivination('performing_divination'),
  
  /// Getting AI interpretation of results
  interpretingResults('interpreting_results'),
  
  /// Waiting for follow-up questions or conversation
  conversational('conversational'),
  
  /// Session completed successfully
  completed('completed'),
  
  /// Session ended with error
  error('error'),
  
  /// Session paused by user
  paused('paused');
  
  const SessionPhase(this.value);
  
  /// String value for serialization
  final String value;
  
  /// Check if session is in active state
  bool get isActive => [
    SessionPhase.waitingForTopic,
    SessionPhase.performingDivination,
    SessionPhase.interpretingResults,
    SessionPhase.conversational,
  ].contains(this);
  
  /// Check if session is in loading state
  bool get isLoading => [
    SessionPhase.initializing,
    SessionPhase.performingDivination,
    SessionPhase.interpretingResults,
  ].contains(this);
}

/// User tier for premium feature access
@JsonEnum()
enum UserTier {
  /// Free tier with limited features
  free('free'),
  
  /// Premium monthly subscription
  premium('premium'),
  
  /// Premium annual subscription  
  premiumAnnual('premium_annual');
  
  const UserTier(this.value);
  
  /// String value for serialization
  final String value;
  
  /// Check if user has premium access
  bool get isPremium => this != UserTier.free;
  
  /// Get maximum sessions per week for this tier
  int get maxSessionsPerWeek {
    switch (this) {
      case UserTier.free:
        return 7; // 1 per day
      case UserTier.premium:
      case UserTier.premiumAnnual:
        return -1; // Unlimited
    }
  }
  
  /// Get maximum history retention for this tier
  int get maxHistoryDays {
    switch (this) {
      case UserTier.free:
        return 7; // 1 week
      case UserTier.premium:
      case UserTier.premiumAnnual:
        return 365; // 1 year
    }
  }
}

/// Complete divination session state
@JsonSerializable()
@immutable
class DivinationSession {
  /// Creates a divination session
  const DivinationSession({
    required this.id,
    required this.userId,
    required this.technique,
    required this.locale,
    required this.createdAt,
    required this.lastActivity,
    required this.phase,
    required this.messages,
    this.topic,
    this.divinationResults,
    this.interpretation,
    this.summary,
    this.userTier = UserTier.free,
    this.metadata,
    this.isDeleted = false,
    this.deletedAt,
  });
  
  /// Unique session identifier
  final String id;
  
  /// User identifier (anonymous or authenticated)
  final String userId;
  
  /// Divination technique for this session
  final DivinationTechnique technique;
  
  /// Session language locale
  final String locale;
  
  /// When session was created
  final DateTime createdAt;
  
  /// When session was last active
  final DateTime lastActivity;
  
  /// Current session phase
  final SessionPhase phase;
  
  /// All messages in chronological order
  final List<ChatMessage> messages;
  
  /// User's question or topic (optional)
  final String? topic;
  
  /// Raw divination results (cards, hexagram, runes)
  final Map<String, dynamic>? divinationResults;
  
  /// AI interpretation of results
  final String? interpretation;
  
  /// Session summary for history view
  final String? summary;
  
  /// User's subscription tier
  final UserTier userTier;
  
  /// Additional session metadata
  final Map<String, dynamic>? metadata;
  
  /// Soft delete flag
  final bool isDeleted;
  
  /// When session was deleted
  final DateTime? deletedAt;
  
  /// Create from JSON
  factory DivinationSession.fromJson(Map<String, dynamic> json) =>
      _$DivinationSessionFromJson(json);
  
  /// Convert to JSON
  Map<String, dynamic> toJson() => _$DivinationSessionToJson(this);
  
  /// Create a copy with updated fields
  DivinationSession copyWith({
    String? id,
    String? userId,
    DivinationTechnique? technique,
    String? locale,
    DateTime? createdAt,
    DateTime? lastActivity,
    SessionPhase? phase,
    List<ChatMessage>? messages,
    String? topic,
    Map<String, dynamic>? divinationResults,
    String? interpretation,
    String? summary,
    UserTier? userTier,
    Map<String, dynamic>? metadata,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return DivinationSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      technique: technique ?? this.technique,
      locale: locale ?? this.locale,
      createdAt: createdAt ?? this.createdAt,
      lastActivity: lastActivity ?? this.lastActivity,
      phase: phase ?? this.phase,
      messages: messages ?? this.messages,
      topic: topic ?? this.topic,
      divinationResults: divinationResults ?? this.divinationResults,
      interpretation: interpretation ?? this.interpretation,
      summary: summary ?? this.summary,
      userTier: userTier ?? this.userTier,
      metadata: metadata ?? this.metadata,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
  
  /// Add a message to the session
  DivinationSession addMessage(ChatMessage message) {
    return copyWith(
      messages: [...messages, message],
      lastActivity: DateTime.now(),
    );
  }
  
  /// Update session phase
  DivinationSession updatePhase(SessionPhase newPhase) {
    return copyWith(
      phase: newPhase,
      lastActivity: DateTime.now(),
    );
  }
  
  /// Set divination results
  DivinationSession setDivinationResults(Map<String, dynamic> results) {
    return copyWith(
      divinationResults: results,
      lastActivity: DateTime.now(),
    );
  }
  
  /// Set interpretation
  DivinationSession setInterpretation(String interpretationText) {
    return copyWith(
      interpretation: interpretationText,
      lastActivity: DateTime.now(),
    );
  }
  
  /// Check if session is active
  bool get isActive => phase.isActive && !isDeleted;
  
  /// Check if session is complete
  bool get isComplete => phase == SessionPhase.completed;
  
  /// Check if session has divination results
  bool get hasResults => divinationResults?.isNotEmpty == true;
  
  /// Check if session has interpretation
  bool get hasInterpretation => interpretation?.isNotEmpty == true;
  
  /// Get session duration in minutes
  int get durationMinutes {
    return lastActivity.difference(createdAt).inMinutes;
  }
  
  /// Get message count
  int get messageCount => messages.length;
  
  /// Get user messages count
  int get userMessageCount => 
      messages.where((ChatMessage m) => m.isFromUser).length;
  
  /// Get assistant messages count
  int get assistantMessageCount => 
      messages.where((ChatMessage m) => m.isFromAssistant).length;
  
  /// Get last user message
  ChatMessage? get lastUserMessage => 
      messages.reversed.cast<ChatMessage?>()
          .firstWhere((ChatMessage? m) => m?.isFromUser == true, orElse: () => null);
  
  /// Get last assistant message
  ChatMessage? get lastAssistantMessage => 
      messages.reversed.cast<ChatMessage?>()
          .firstWhere((ChatMessage? m) => m?.isFromAssistant == true, orElse: () => null);
  
  /// Generate display title for session
  String get displayTitle {
    if (topic?.isNotEmpty == true) {
      return topic!.length > 50 ? '${topic!.substring(0, 50)}...' : topic!;
    }
    
    final String techniqueDisplay = technique.displayName;
    final String date = '${createdAt.day}/${createdAt.month}';
    return '$techniqueDisplay - $date';
  }
  
  /// Get session icon based on technique
  String get icon => technique.icon;
  
  /// Generate session summary for history
  String get autoSummary {
    if (summary?.isNotEmpty == true) {
      return summary!;
    }
    
    if (interpretation?.isNotEmpty == true) {
      // Extract first sentence of interpretation as summary
      final List<String> sentences = interpretation!.split('.');
      if (sentences.isNotEmpty) {
        return '${sentences.first.trim()}.';
      }
    }
    
    return 'A ${technique.displayName.toLowerCase()} reading session';
  }
}

// ============================================================================
// SESSION QUERY & FILTER CONTRACTS
// ============================================================================

/// Parameters for querying sessions
@JsonSerializable()
@immutable
class SessionQuery {
  /// Creates session query parameters
  const SessionQuery({
    this.userId,
    this.technique,
    this.locale,
    this.userTier,
    this.phases,
    this.startDate,
    this.endDate,
    this.includeDeleted = false,
    this.limit = 20,
    this.offset = 0,
    this.sortBy = SessionSortBy.lastActivity,
    this.sortOrder = SortOrder.descending,
  });
  
  /// Filter by user ID
  final String? userId;
  
  /// Filter by technique
  final DivinationTechnique? technique;
  
  /// Filter by locale
  final String? locale;
  
  /// Filter by user tier
  final UserTier? userTier;
  
  /// Filter by session phases
  final List<SessionPhase>? phases;
  
  /// Filter by start date
  final DateTime? startDate;
  
  /// Filter by end date
  final DateTime? endDate;
  
  /// Include soft-deleted sessions
  final bool includeDeleted;
  
  /// Maximum number of results
  final int limit;
  
  /// Number of results to skip
  final int offset;
  
  /// Sort field
  final SessionSortBy sortBy;
  
  /// Sort order
  final SortOrder sortOrder;
  
  /// Create from JSON
  factory SessionQuery.fromJson(Map<String, dynamic> json) =>
      _$SessionQueryFromJson(json);
  
  /// Convert to JSON
  Map<String, dynamic> toJson() => _$SessionQueryToJson(this);
}

/// Session sorting options
@JsonEnum()
enum SessionSortBy {
  /// Sort by creation date
  createdAt('created_at'),
  
  /// Sort by last activity
  lastActivity('last_activity'),
  
  /// Sort by message count
  messageCount('message_count'),
  
  /// Sort by duration
  duration('duration');
  
  const SessionSortBy(this.value);
  
  /// String value for database queries
  final String value;
}

/// Sort order options
@JsonEnum()
enum SortOrder {
  /// Ascending order
  ascending('asc'),
  
  /// Descending order
  descending('desc');
  
  const SortOrder(this.value);
  
  /// String value for database queries
  final String value;
}