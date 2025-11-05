import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/typing_indicator.dart';
import '../theme/tarot_theme.dart';
import '../api/chat_api.dart';

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
  });

  final String userId;
  final CommonStrings strings;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool _isTyping = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
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
    setState(() {
      _messages.add(ChatMessage(
        id: _uuid.v4(),
        content: _getWelcomeMessage(),
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _buildMessagesList(),
          ),
          // Typing indicator
          if (_isTyping) const TypingIndicator(),
          // Input field
          ChatInputField(
            controller: _textController,
            onSend: _handleSendMessage,
            strings: widget.strings,
            enabled: !_isTyping,
            focusNode: _focusNode,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
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
              gradient: LinearGradient(
                colors: [
                  TarotTheme.cosmicPurple,
                  TarotTheme.cosmicBlue,
                ],
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
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_isTyping)
                  Text(
                    _getTypingText(),
                    style: TextStyle(
                      color: TarotTheme.cosmicPurple,
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
        return ChatMessageBubble(
          message: message,
          animate: index == 0, // Animate only the latest message
        );
      },
    );
  }

  Future<void> _handleSendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Create user message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: text,
      isUser: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    _scrollToBottom();

    try {
      // Call API to get AI response
      final aiResponse = await sendChatMessage(
        message: text,
        userId: widget.userId,
        locale: widget.strings.localeName,
      );

      // Update user message status to sent
      final updatedUserMessage = userMessage.copyWith(
        status: MessageStatus.sent,
      );
      setState(() {
        final index = _messages.indexOf(userMessage);
        if (index != -1) {
          _messages[index] = updatedUserMessage;
        }
      });

      // Add AI response
      final aiMessage = ChatMessage(
        id: _uuid.v4(),
        content: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(aiMessage);
        _isTyping = false;
      });

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

      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getErrorMessage()),
            backgroundColor: Colors.red[700],
            action: SnackBarAction(
              label: _getRetryText(),
              textColor: Colors.white,
              onPressed: () => _handleSendMessage(text),
            ),
          ),
        );
      }
    }
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
}
