import 'dart:async';

import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_spread_bubble.dart';
import '../widgets/chat_action_bubble.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/typing_indicator.dart';
import '../theme/tarot_theme.dart';
import '../api/chat_api.dart';
import '../services/credits_service.dart';

const _uuid = Uuid();

/// Main chat screen with AI assistant
///
/// Features:
/// - WhatsApp/Telegram-style message bubbles
/// - Typing indicator when AI is responding
/// - Auto-scroll to latest message
/// - Message status tracking
class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.userId,
    required this.strings,
    this.showAppBar = true,
    this.initialMessages,
  });

  final String userId;
  final CommonStrings strings;
  final bool showAppBar;
  final List<ChatMessage>? initialMessages;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final CreditsService _creditsService = CreditsService();
  late final ValueNotifier<DailyCredits> _creditsNotifier;

  bool _isTyping = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _creditsNotifier = _creditsService.notifier;
    unawaited(_creditsService.initialize());
    _initializeChat();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Initialize chat with welcome message
  void _initializeChat() {
    final messages = <ChatMessage>[
      ChatMessage.text(
        id: _uuid.v4(),
        isUser: false,
        timestamp: DateTime.now(),
        text: _getWelcomeMessage(),
      ),
    ];

    if (widget.initialMessages != null && widget.initialMessages!.isNotEmpty) {
      final sanitized = widget.initialMessages!
          .map(
            (message) => message.copyWith(
              id: message.id.isEmpty ? _uuid.v4() : message.id,
              timestamp: message.timestamp,
              status: MessageStatus.sent,
            ),
          )
          .toList();
      messages.addAll(sanitized);
    }

    setState(() {
      _messages.addAll(messages);
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.showAppBar ? _buildAppBar() : null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              TarotTheme.cosmicAccent.withValues(alpha: 0.03),
              TarotTheme.cosmicBlue.withValues(alpha: 0.05),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: _buildMessagesList(),
            ),
            // Typing indicator
            if (_isTyping) const TypingIndicator(),
            // Input field
            ValueListenableBuilder<DailyCredits>(
              valueListenable: _creditsNotifier,
              builder: (context, credits, _) {
                final hasCredits = credits.remaining > 0;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!hasCredits)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          border: Border(
                            top: BorderSide(color: Colors.orange.withValues(alpha: 0.4)),
                            bottom: BorderSide(color: Colors.orange.withValues(alpha: 0.2)),
                          ),
                        ),
                        child: Text(
                          _getNoCreditsBannerText(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFBF360C),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ChatInputField(
                      controller: _textController,
                      onSend: _handleSendMessage,
                      strings: widget.strings,
                      enabled: !_isTyping && hasCredits,
                      focusNode: _focusNode,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TarotTheme.cosmicBlue,
              TarotTheme.cosmicAccent,
            ],
          ),
        ),
      ),
      elevation: 4,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          // AI Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Title and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getAssistantName(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (_isTyping)
                  Text(
                    _getTypingText(),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      reverse: true, // Show latest at bottom
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        // Reverse index to show latest at bottom
        final message = _messages[_messages.length - 1 - index];
        final animate = index == 0;
        switch (message.kind) {
          case ChatMessageKind.text:
            return ChatMessageBubble(
              message: message,
              animate: animate,
            );
          case ChatMessageKind.spread:
            final spread = message.spread;
            if (spread == null) {
              return const SizedBox.shrink();
            }
            return ChatSpreadBubble(
              spread: spread,
              animate: animate,
            );
          case ChatMessageKind.action:
            final action = message.action;
            if (action == null) {
              return const SizedBox.shrink();
            }
            return ChatActionBubble(
              action: action,
              animate: animate,
              onPressed: () => _handleActionTap(message),
            );
        }
      },
    );
  }

  Future<void> _handleSendMessage(String text) async {
    if (text.trim().isEmpty) return;

    await _creditsService.initialize();
    if (!_creditsService.hasCredits) {
      _showSnackBar(_getNoCreditsSnackText());
      return;
    }

    // Build conversation history BEFORE adding the new message to avoid duplication
    final conversationHistory = _buildConversationHistory();

    final userMessage = ChatMessage.text(
      id: _uuid.v4(),
      isUser: true,
      timestamp: DateTime.now(),
      text: text,
      status: MessageStatus.sending,
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    _scrollToBottom();

    try {
      final aiMessages = await sendChatMessage(
        message: text,
        userId: widget.userId,
        locale: widget.strings.localeName,
        conversationHistory: conversationHistory.isEmpty ? null : conversationHistory,
      );

      setState(() {
        final index = _messages.indexOf(userMessage);
        if (index != -1) {
          _messages[index] = userMessage.copyWith(status: MessageStatus.sent);
        }
        _messages.addAll(aiMessages);
        _isTyping = false;
      });

      await _creditsService.consume();
      _scrollToBottom();
    } catch (error) {
      // Update user message status to error
      final errorMessage = userMessage.copyWith(
        status: MessageStatus.error,
      );
      setState(() {
        final index = _messages.indexOf(userMessage);
        if (index != -1) {
          _messages[index] = errorMessage;
        }
        _isTyping = false;
      });

      _showSnackBar(
        _getErrorMessage(),
        actionLabel: _getRetryText(),
        onAction: () => _handleSendMessage(text),
      );
    }
  }

  List<Map<String, String>> _buildConversationHistory() {
    final history = <Map<String, String>>[];
    for (var i = _messages.length - 1; i >= 0; i--) {
      final message = _messages[i];
      if (!message.isText) continue;
      final text = message.text;
      if (text == null || text.trim().isEmpty) continue;
      history.add({
        'role': message.isUser ? 'user' : 'assistant',
        'content': text.trim(),
      });
      if (history.length >= 12) {
        break;
      }
    }
    return history.reversed.toList();
  }

  Future<void> _handleActionTap(ChatMessage message) async {
    final action = message.action;
    if (action == null) {
      return;
    }

    if (action.state == ChatActionState.loading || action.state == ChatActionState.completed) {
      return;
    }

    final spreadMessage = _findSpreadMessage(action.spreadMessageId);
    final spreadData = spreadMessage?.spread;
    if (spreadData == null) {
      setState(() {
        _updateMessageAction(message.id, action.copyWith(state: ChatActionState.error));
      });
      _showSnackBar(_getErrorMessage());
      return;
    }
    if (spreadData.cards.isEmpty) {
      setState(() {
        _updateMessageAction(message.id, action.copyWith(state: ChatActionState.error));
      });
      _showSnackBar(_getErrorMessage());
      return;
    }

    await _creditsService.initialize();
    if (!_creditsService.hasCredits) {
      _showSnackBar(_getNoCreditsSnackText());
      return;
    }

    setState(() {
      _updateMessageAction(message.id, action.copyWith(state: ChatActionState.loading));
      _isTyping = true;
    });

    try {
      final interpretationMessages = await interpretChatSpread(
        spreadId: action.spreadId,
        spreadMessageId: action.spreadMessageId,
        cards: spreadData.cards,
        question: _getLatestUserQuestion(),
        userId: widget.userId,
        locale: widget.strings.localeName,
      );

      setState(() {
        _updateMessageAction(message.id, action.copyWith(state: ChatActionState.completed));
        _messages.addAll(interpretationMessages);
        _isTyping = false;
      });
      await _creditsService.consume();
      _scrollToBottom();
    } catch (error) {
      setState(() {
        _updateMessageAction(message.id, action.copyWith(state: ChatActionState.error));
        _isTyping = false;
      });
      _showSnackBar(_getErrorMessage());
    }
  }

  ChatMessage? _findSpreadMessage(String spreadMessageId) {
    for (final message in _messages) {
      if (message.id == spreadMessageId && message.kind == ChatMessageKind.spread) {
        return message;
      }
    }
    return null;
  }

  void _updateMessageAction(String messageId, ChatActionData updatedAction) {
    final index = _messages.indexWhere((message) => message.id == messageId);
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(action: updatedAction);
    }
  }

  String? _getLatestUserQuestion() {
    for (var i = _messages.length - 1; i >= 0; i--) {
      final message = _messages[i];
      if (!message.isUser || !message.isText) {
        continue;
      }
      final text = message.text;
      if (text != null && text.trim().isNotEmpty) {
        return text.trim();
      }
    }
    return null;
  }

  void _showSnackBar(
    String text, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.red[700],
        action: (actionLabel != null && onAction != null)
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  // Localized strings

  String _getWelcomeMessage() {
    switch (widget.strings.localeName) {
      case 'ca':
        return '👋 Hola! Sóc el teu assistent de tarot. Pregunta\'m el que vulguis sobre espiritualitat, tarot o el teu camí personal.';
      case 'es':
        return '👋 ¡Hola! Soy tu asistente de tarot. Pregúntame lo que quieras sobre espiritualidad, tarot o tu camino personal.';
      default:
        return '👋 Hi! I\'m your tarot assistant. Ask me anything about spirituality, tarot, or your personal journey.';
    }
  }

  String _getAssistantName() {
    switch (widget.strings.localeName) {
      case 'ca':
        return 'Assistent de Tarot';
      case 'es':
        return 'Asistente de Tarot';
      default:
        return 'Tarot Assistant';
    }
  }

  String _getTypingText() {
    switch (widget.strings.localeName) {
      case 'ca':
        return 'escrivint...';
      case 'es':
        return 'escribiendo...';
      default:
        return 'typing...';
    }
  }

  String _getErrorMessage() {
    switch (widget.strings.localeName) {
      case 'ca':
        return 'Error enviant el missatge';
      case 'es':
        return 'Error enviando el mensaje';
      default:
        return 'Error sending message';
    }
  }

  String _getRetryText() {
    switch (widget.strings.localeName) {
      case 'ca':
        return 'Reintentar';
      case 'es':
        return 'Reintentar';
      default:
        return 'Retry';
    }
  }

  String _getNoCreditsBannerText() {
    switch (widget.strings.localeName) {
      case 'ca':
        return 'Has utilitzat tots els credits d avui. Torna dema!';
      case 'es':
        return 'Has usado todos los creditos de hoy. Vuelve manana.';
      default:
        return 'You\'ve used all today\'s credits. Come back tomorrow!';
    }
  }

  String _getNoCreditsSnackText() {
    switch (widget.strings.localeName) {
      case 'ca':
        return 'No et queden credits avui.';
      case 'es':
        return 'No te quedan creditos hoy.';
      default:
        return 'No credits left for today.';
    }
  }
}
