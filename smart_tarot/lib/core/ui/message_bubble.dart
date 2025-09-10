import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/models/contracts.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final DivinationTechnique? technique;

  const MessageBubble({
    super.key,
    required this.message,
    this.technique,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;
    final isSystem = message.role == ChatRole.system;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser && !isSystem) ...[
            _buildAvatar(context),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              decoration: BoxDecoration(
                color: _getBubbleColor(context, isUser, isSystem),
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: !isUser && !isSystem 
                      ? const Radius.circular(4) 
                      : const Radius.circular(16),
                  bottomRight: isUser 
                      ? const Radius.circular(4) 
                      : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isSystem) ...[
                    _buildMessageContent(context, isUser),
                    const SizedBox(height: 4),
                    _buildTimestamp(context, isUser),
                  ] else
                    _buildSystemMessage(context),
                ],
              ),
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            _buildUserAvatar(context),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final color = _getTechniqueColor();
    final icon = _getTechniqueIcon();
    
    return CircleAvatar(
      radius: 20,
      backgroundColor: color,
      child: Text(
        icon,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, bool isUser) {
    return SelectableText(
      message.content,
      style: TextStyle(
        color: _getTextColor(context, isUser),
        fontSize: 16,
        height: 1.4,
      ),
      onTap: () {
        // Copy to clipboard on long press
        Clipboard.setData(ClipboardData(text: message.content));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message copied to clipboard'),
            duration: Duration(seconds: 1),
          ),
        );
      },
    );
  }

  Widget _buildTimestamp(BuildContext context, bool isUser) {
    return Text(
      _formatTime(message.timestamp),
      style: TextStyle(
        color: _getTextColor(context, isUser).withOpacity(0.7),
        fontSize: 12,
      ),
    );
  }

  Widget _buildSystemMessage(BuildContext context) {
    return Text(
      message.content,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 14,
        fontStyle: FontStyle.italic,
      ),
      textAlign: TextAlign.center,
    );
  }

  Color _getBubbleColor(BuildContext context, bool isUser, bool isSystem) {
    if (isSystem) {
      return Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5);
    }
    
    if (isUser) {
      return _getTechniqueColor();
    }
    
    return Theme.of(context).colorScheme.surface;
  }

  Color _getTextColor(BuildContext context, bool isUser) {
    if (isUser) {
      return Colors.white;
    }
    return Theme.of(context).colorScheme.onSurface;
  }

  Color _getTechniqueColor() {
    switch (technique) {
      case DivinationTechnique.tarot:
        return const Color(0xFF4C1D95);
      case DivinationTechnique.iching:
        return const Color(0xFFDC2626);
      case DivinationTechnique.runes:
        return const Color(0xFF059669);
      case null:
        return const Color(0xFF6366F1);
    }
  }

  String _getTechniqueIcon() {
    switch (technique) {
      case DivinationTechnique.tarot:
        return '🃏';
      case DivinationTechnique.iching:
        return '☯️';
      case DivinationTechnique.runes:
        return 'ᚱ';
      case null:
        return '🔮';
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}