import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/chat_message.dart';
import '../theme/tarot_theme.dart';

/// A chat message bubble styled like WhatsApp/Telegram
///
/// User messages appear on the right with purple background
/// AI messages appear on the left with light grey background
class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    this.animate = false,
  });

  final ChatMessage message;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final bubble = Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          gradient: message.isUser
              ? LinearGradient(
                  colors: [
                    TarotTheme.cosmicBlue.withValues(alpha: 0.9),
                    TarotTheme.cosmicAccent.withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: message.isUser ? null : Colors.white,
          border: message.isUser
              ? null
              : Border.all(
                  color: const Color(0xFFE0E0E0),
                  width: 1,
                ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isUser ? 18 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Message content
            Text(
              message.content,
              style: TextStyle(
                color: message.isUser
                    ? Colors.white
                    : const Color(0xFF1A1A1A),
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            // Timestamp and status
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _formatTimestamp(message.timestamp),
                  style: TextStyle(
                    fontSize: 11,
                    color: message.isUser
                        ? Colors.white.withValues(alpha: 0.7)
                        : const Color(0xFF757575),
                  ),
                ),
                if (message.isUser) ...[
                  const SizedBox(width: 4),
                  _buildStatusIcon(),
                ],
              ],
            ),
          ],
        ),
      ),
    );

    // Add animation if requested
    if (animate) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween<double>(begin: 0, end: 1),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            alignment: message.isUser
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: bubble,
      );
    }

    return bubble;
  }

  /// Format timestamp as HH:mm (e.g., "14:32")
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    // If today, just show time
    if (messageDate == today) {
      return DateFormat.Hm().format(timestamp);
    }

    // If yesterday
    final yesterday = today.subtract(const Duration(days: 1));
    if (messageDate == yesterday) {
      return 'Yesterday ${DateFormat.Hm().format(timestamp)}';
    }

    // Otherwise show date + time
    return DateFormat('dd/MM HH:mm').format(timestamp);
  }

  /// Build status icon for user messages (checkmarks)
  Widget _buildStatusIcon() {
    switch (message.status) {
      case MessageStatus.sending:
        return Icon(
          Icons.access_time,
          size: 14,
          color: Colors.white.withValues(alpha: 0.7),
        );
      case MessageStatus.sent:
        return Icon(
          Icons.done_all,
          size: 14,
          color: Colors.white.withValues(alpha: 0.7),
        );
      case MessageStatus.error:
        return Icon(
          Icons.error_outline,
          size: 14,
          color: Colors.red[300],
        );
    }
  }
}
