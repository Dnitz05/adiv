/// Status of a chat message
enum MessageStatus {
  /// Message is being sent to server
  sending,

  /// Message successfully sent
  sent,

  /// Message failed to send
  error,
}

/// Represents a single message in the chat conversation
class ChatMessage {
  /// Unique identifier for this message
  final String id;

  /// The text content of the message
  final String content;

  /// Whether this message was sent by the user (true) or AI assistant (false)
  final bool isUser;

  /// When this message was created
  final DateTime timestamp;

  /// Current status of the message (only relevant for user messages)
  final MessageStatus status;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });

  /// Create a copy of this message with updated fields
  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    MessageStatus? status,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  /// Convert message to JSON (for persistence)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
    };
  }

  /// Create message from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, isUser: $isUser, status: $status, content: ${content.substring(0, content.length > 30 ? 30 : content.length)}...)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatMessage &&
        other.id == id &&
        other.content == content &&
        other.isUser == isUser &&
        other.timestamp == timestamp &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        content.hashCode ^
        isUser.hashCode ^
        timestamp.hashCode ^
        status.hashCode;
  }
}
