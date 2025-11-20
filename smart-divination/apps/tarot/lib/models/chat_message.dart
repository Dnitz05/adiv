enum MessageStatus {
  sending,
  sent,
  error,
}

enum ChatMessageKind {
  text,
  spread,
  action,
}

enum ChatActionType {
  interpretSpread,
}

enum ChatActionState {
  idle,
  loading,
  completed,
  error,
}

class ChatSpreadCardData {
  ChatSpreadCardData({
    required this.id,
    required this.name,
    required this.suit,
    required this.number,
    required this.upright,
    required this.position,
    required this.row,
    required this.column,
    this.image,
    this.meaning,
    this.meaningShort,
  });

  final String id;
  final String name;
  final String suit;
  final int? number;
  final bool upright;
  final int position;
  final int row;
  final int column;
  final String? image;
  final String? meaning;
  final String? meaningShort;

  factory ChatSpreadCardData.fromJson(Map<String, dynamic> json) {
    return ChatSpreadCardData(
      id: json['id'] as String,
      name: json['name'] as String,
      suit: json['suit'] as String,
      number: json['number'] == null ? null : (json['number'] as num).toInt(),
      upright: json['upright'] as bool? ?? true,
      position: (json['position'] as num).toInt(),
      row: (json['row'] as num).toInt(),
      column: (json['column'] as num).toInt(),
      image: json['image'] as String?,
      meaning: json['meaning'] as String?,
      meaningShort: json['meaningShort'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'suit': suit,
      'number': number,
      'upright': upright,
      'position': position,
      'row': row,
      'column': column,
      'image': image,
      'meaning': meaning,
      'meaningShort': meaningShort,
    };
  }
}

class ChatSpreadData {
  ChatSpreadData({
    required this.spreadId,
    required this.spreadName,
    required this.rows,
    required this.columns,
    required this.cards,
    this.spreadDescription,
  });

  final String spreadId;
  final String spreadName;
  final int rows;
  final int columns;
  final List<ChatSpreadCardData> cards;
  final String? spreadDescription;

  factory ChatSpreadData.fromJson(Map<String, dynamic> json) {
    final cardsJson = json['cards'] as List<dynamic>? ?? <dynamic>[];
    return ChatSpreadData(
      spreadId: json['spreadId'] as String,
      spreadName: json['spreadName'] as String,
      spreadDescription: json['spreadDescription'] as String?,
      rows: (json['layout']?['rows'] as num?)?.toInt() ?? (json['rows'] as num?)?.toInt() ?? 1,
      columns:
          (json['layout']?['columns'] as num?)?.toInt() ?? (json['columns'] as num?)?.toInt() ?? cardsJson.length,
      cards: cardsJson
          .whereType<Map<String, dynamic>>()
          .map(ChatSpreadCardData.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'spreadId': spreadId,
      'spreadName': spreadName,
      'spreadDescription': spreadDescription,
      'layout': {
        'rows': rows,
        'columns': columns,
      },
      'cards': cards.map((card) => card.toJson()).toList(),
    };
  }
}

class ChatActionData {
  ChatActionData({
    required this.type,
    required this.label,
    required this.spreadMessageId,
    required this.spreadId,
    this.state = ChatActionState.idle,
  });

  final ChatActionType type;
  final String label;
  final String spreadMessageId;
  final String spreadId;
  final ChatActionState state;

  ChatActionData copyWith({
    ChatActionState? state,
  }) {
    return ChatActionData(
      type: type,
      label: label,
      spreadMessageId: spreadMessageId,
      spreadId: spreadId,
      state: state ?? this.state,
    );
  }

  factory ChatActionData.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>? ?? json;
    final actionType = payload['action'] as String? ?? 'interpret_spread';
    return ChatActionData(
      type: _parseActionType(actionType),
      label: json['label'] as String? ?? 'Interpretation',
      spreadMessageId: payload['spreadMessageId'] as String? ?? '',
      spreadId: payload['spreadId'] as String? ?? '',
      state: _parseActionState(json['state'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'payload': {
        'action': _actionTypeToString(type),
        'spreadMessageId': spreadMessageId,
        'spreadId': spreadId,
      },
      'state': state.name,
    };
  }

  static ChatActionType _parseActionType(String raw) {
    switch (raw) {
      case 'interpret_spread':
      default:
        return ChatActionType.interpretSpread;
    }
  }

  static ChatActionState _parseActionState(String? raw) {
    if (raw == null) {
      return ChatActionState.idle;
    }
    return ChatActionState.values.firstWhere(
      (state) => state.name == raw,
      orElse: () => ChatActionState.idle,
    );
  }

  static String _actionTypeToString(ChatActionType type) {
    switch (type) {
      case ChatActionType.interpretSpread:
        return 'interpret_spread';
    }
  }
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.kind,
    required this.isUser,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.text,
    this.spread,
    this.action,
  });

  final String id;
  final ChatMessageKind kind;
  final bool isUser;
  final DateTime timestamp;
  final MessageStatus status;
  final String? text;
  final ChatSpreadData? spread;
  final ChatActionData? action;

  bool get isText => kind == ChatMessageKind.text;
  bool get isSpread => kind == ChatMessageKind.spread;
  bool get isAction => kind == ChatMessageKind.action;

  ChatMessage copyWith({
    String? id,
    ChatMessageKind? kind,
    bool? isUser,
    DateTime? timestamp,
    MessageStatus? status,
    String? text,
    ChatSpreadData? spread,
    ChatActionData? action,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      text: text ?? this.text,
      spread: spread ?? this.spread,
      action: action ?? this.action,
    );
  }

  factory ChatMessage.text({
    required String id,
    required bool isUser,
    required DateTime timestamp,
    required String text,
    MessageStatus status = MessageStatus.sent,
  }) {
    return ChatMessage(
      id: id,
      kind: ChatMessageKind.text,
      isUser: isUser,
      timestamp: timestamp,
      status: status,
      text: text,
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final kindString = json['kind'] as String? ?? 'text';
    final kind = ChatMessageKind.values.firstWhere(
      (value) => value.name == kindString,
      orElse: () => ChatMessageKind.text,
    );

    return ChatMessage(
      id: json['id'] as String,
      kind: kind,
      isUser: json['isUser'] as bool? ?? false,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: MessageStatus.values.firstWhere(
        (value) => value.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      text: json['text'] as String?,
      spread: json['spread'] is Map<String, dynamic>
          ? ChatSpreadData.fromJson(json['spread'] as Map<String, dynamic>)
          : null,
      action: json['action'] is Map<String, dynamic>
          ? ChatActionData.fromJson(json['action'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kind': kind.name,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
      'text': text,
      'spread': spread?.toJson(),
      'action': action?.toJson(),
    };
  }

  @override
  String toString() {
    switch (kind) {
      case ChatMessageKind.text:
        return 'ChatMessage.text(id: $id, user: $isUser, status: $status, text: ${text ?? ''})';
      case ChatMessageKind.spread:
        return 'ChatMessage.spread(id: $id, spread: ${spread?.spreadId})';
      case ChatMessageKind.action:
        return 'ChatMessage.action(id: $id, action: ${action?.type}, state: ${action?.state})';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatMessage &&
        other.id == id &&
        other.kind == kind &&
        other.isUser == isUser &&
        other.timestamp == timestamp &&
        other.status == status &&
        other.text == text &&
        _spreadEquals(other.spread, spread) &&
        _actionEquals(other.action, action);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        kind.hashCode ^
        isUser.hashCode ^
        timestamp.hashCode ^
        status.hashCode ^
        text.hashCode ^
        (spread?.hashCode ?? 0) ^
        (action?.hashCode ?? 0);
  }

  static bool _spreadEquals(ChatSpreadData? a, ChatSpreadData? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return false;
    if (a.spreadId != b.spreadId ||
        a.spreadName != b.spreadName ||
        a.spreadDescription != b.spreadDescription ||
        a.rows != b.rows ||
        a.columns != b.columns ||
        a.cards.length != b.cards.length) {
      return false;
    }
    for (var i = 0; i < a.cards.length; i++) {
      final cardA = a.cards[i];
      final cardB = b.cards[i];
      if (cardA.id != cardB.id ||
          cardA.name != cardB.name ||
          cardA.suit != cardB.suit ||
          cardA.number != cardB.number ||
          cardA.upright != cardB.upright ||
          cardA.position != cardB.position ||
          cardA.row != cardB.row ||
          cardA.column != cardB.column ||
          cardA.image != cardB.image ||
          cardA.meaning != cardB.meaning ||
          cardA.meaningShort != cardB.meaningShort) {
        return false;
      }
    }
    return true;
  }

  static bool _actionEquals(ChatActionData? a, ChatActionData? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return false;
    return a.type == b.type &&
        a.label == b.label &&
        a.spreadMessageId == b.spreadMessageId &&
        a.spreadId == b.spreadId &&
        a.state == b.state;
  }
}

/// FASE 3: Chat response data containing messages and optional position interactions
class ChatResponseData {
  const ChatResponseData({
    required this.messages,
    this.positionInteractions,
  });

  final List<ChatMessage> messages;
  final List<PositionInteraction>? positionInteractions;

  factory ChatResponseData.fromJson(Map<String, dynamic> json) {
    final messagesJson = json['messages'] as List<dynamic>? ?? <dynamic>[];
    final interactionsJson = json['positionInteractions'] as List<dynamic>?;

    return ChatResponseData(
      messages: messagesJson
          .whereType<Map<String, dynamic>>()
          .map((m) => _parseSingleMessage(m))
          .toList(),
      positionInteractions: interactionsJson
          ?.whereType<Map<String, dynamic>>()
          .map(PositionInteraction.fromJson)
          .toList(),
    );
  }

  /// Helper to parse a single message (used internally)
  static ChatMessage _parseSingleMessage(Map<String, dynamic> rawMessage) {
    final type = rawMessage['type'] as String? ?? 'text';
    final messageId = rawMessage['id'] as String? ?? 'msg_${DateTime.now().microsecondsSinceEpoch}';
    final now = DateTime.now();

    switch (type) {
      case 'tarot_spread':
        final spreadData = ChatSpreadData.fromJson(rawMessage);
        return ChatMessage(
          id: messageId,
          kind: ChatMessageKind.spread,
          isUser: false,
          timestamp: now,
          spread: spreadData,
        );
      case 'cta':
        final payload = rawMessage['payload'] as Map<String, dynamic>? ?? <String, dynamic>{};
        final actionData = ChatActionData(
          type: ChatActionType.interpretSpread,
          label: rawMessage['label'] as String? ?? 'Interpretation',
          spreadMessageId: payload['spreadMessageId'] as String? ?? '',
          spreadId: payload['spreadId'] as String? ?? '',
        );
        return ChatMessage(
          id: messageId,
          kind: ChatMessageKind.action,
          isUser: false,
          timestamp: now,
          action: actionData,
        );
      default:
        final text = rawMessage['text'] as String? ?? '';
        return ChatMessage.text(
          id: messageId,
          isUser: false,
          timestamp: now,
          text: text,
        );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((m) => m.toJson()).toList(),
      if (positionInteractions != null)
        'positionInteractions': positionInteractions!.map((i) => i.toJson()).toList(),
    };
  }
}

/// FASE 3: Position Interaction (card relationship for user education)
/// Represents how two or more positions relate to each other in a spread
class PositionInteraction {
  const PositionInteraction({
    required this.positions,
    required this.description,
    required this.aiGuidance,
    this.descriptionMultilingual,
  });

  /// Position codes involved, e.g. ["PAST", "PRESENT"] or ["SELF", "ENVIRONMENT"]
  final List<String> positions;

  /// Human-readable description (localized) - legacy field
  final String description;

  /// Technical guidance that was provided to AI
  final String aiGuidance;

  /// Multilingual description map (FASE 3 enhancement)
  final Map<String, String>? descriptionMultilingual;

  /// Get localized description, falling back to default language
  String getDescription(String locale) {
    if (descriptionMultilingual != null && descriptionMultilingual!.isNotEmpty) {
      // Try requested locale first
      final localized = descriptionMultilingual![locale] ??
                       descriptionMultilingual!['en'] ??
                       descriptionMultilingual!['ca'] ??
                       descriptionMultilingual!['es'];
      if (localized != null && localized.isNotEmpty) {
        return localized;
      }
    }
    return description.isNotEmpty ? description : 'No description available';
  }

  factory PositionInteraction.fromJson(Map<String, dynamic> json) {
    final positionsJson = json['positions'] as List<dynamic>? ?? <dynamic>[];

    // Handle both old format (string) and new format (multilingual map)
    String descriptionString = '';
    Map<String, String>? descriptionMap;

    final descriptionJson = json['description'];
    if (descriptionJson is String) {
      descriptionString = descriptionJson;
    } else if (descriptionJson is Map) {
      descriptionMap = Map<String, String>.from(descriptionJson as Map);
      // Use English as default for backward compatibility
      descriptionString = descriptionMap['en'] ??
                         descriptionMap['ca'] ??
                         descriptionMap['es'] ??
                         '';
    }

    return PositionInteraction(
      positions: positionsJson.whereType<String>().toList(),
      description: descriptionString,
      aiGuidance: json['aiGuidance'] as String? ?? '',
      descriptionMultilingual: descriptionMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'positions': positions,
      'description': descriptionMultilingual ?? {'en': description},
      'aiGuidance': aiGuidance,
    };
  }

  @override
  String toString() {
    return 'PositionInteraction(positions: ${positions.join(", ")}, description: "$description")';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PositionInteraction) return false;

    if (positions.length != other.positions.length) return false;
    for (var i = 0; i < positions.length; i++) {
      if (positions[i] != other.positions[i]) return false;
    }

    return description == other.description && aiGuidance == other.aiGuidance;
  }

  @override
  int get hashCode {
    return positions.fold<int>(0, (hash, pos) => hash ^ pos.hashCode) ^
        description.hashCode ^
        aiGuidance.hashCode;
  }
}

/// FASE 3: Spread Educational Content
/// Comprehensive educational information for a tarot spread
class SpreadEducational {
  const SpreadEducational({
    required this.purpose,
    required this.whenToUse,
    required this.whenToAvoid,
    required this.interpretationMethod,
    required this.positionInteractions,
    this.traditionalOrigin,
  });

  /// Why this spread exists (multilingual)
  final Map<String, String> purpose;

  /// When to choose this spread (multilingual)
  final Map<String, String> whenToUse;

  /// When to skip this spread (multilingual)
  final Map<String, String> whenToAvoid;

  /// How to read and interpret this spread (multilingual)
  final Map<String, String> interpretationMethod;

  /// Optional historical context (multilingual)
  final Map<String, String>? traditionalOrigin;

  /// Card position relationships for deeper understanding
  final List<PositionInteraction> positionInteractions;

  factory SpreadEducational.fromJson(Map<String, dynamic> json) {
    final interactionsJson = json['positionInteractions'] as List<dynamic>? ?? <dynamic>[];
    final interactions = interactionsJson
        .map((item) => PositionInteraction.fromJson(item as Map<String, dynamic>))
        .toList();

    return SpreadEducational(
      purpose: _parseMultilingualText(json['purpose']),
      whenToUse: _parseMultilingualText(json['whenToUse']),
      whenToAvoid: _parseMultilingualText(json['whenToAvoid']),
      interpretationMethod: _parseMultilingualText(json['interpretationMethod']),
      positionInteractions: interactions,
      traditionalOrigin: json['traditionalOrigin'] != null
          ? _parseMultilingualText(json['traditionalOrigin'])
          : null,
    );
  }

  static Map<String, String> _parseMultilingualText(dynamic json) {
    if (json is Map) {
      final result = <String, String>{};
      json.forEach((key, value) {
        if (key is String && value is String) {
          result[key] = value;
        }
      });
      return result;
    }
    return {};
  }

  Map<String, dynamic> toJson() {
    return {
      'purpose': purpose,
      'whenToUse': whenToUse,
      'whenToAvoid': whenToAvoid,
      'interpretationMethod': interpretationMethod,
      if (traditionalOrigin != null) 'traditionalOrigin': traditionalOrigin,
      'positionInteractions':
          positionInteractions.map((item) => item.toJson()).toList(),
    };
  }
}
