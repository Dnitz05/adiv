import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../theme/tarot_theme.dart';

class ChatActionBubble extends StatelessWidget {
  const ChatActionBubble({
    super.key,
    required this.action,
    required this.onPressed,
    this.animate = false,
  });

  final ChatActionData action;
  final VoidCallback onPressed;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final bubble = Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionButton(
              action: action,
              onPressed: onPressed,
            ),
            if (action.state == ChatActionState.completed) ...[
              const SizedBox(height: 8),
              const Text(
                'Interpretation added to the conversation.',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ] else if (action.state == ChatActionState.error) ...[
              const SizedBox(height: 8),
              const Text(
                'Something went wrong. Tap to try again.',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFFD32F2F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (animate) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween<double>(begin: 0, end: 1),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            alignment: Alignment.centerLeft,
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
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.action,
    required this.onPressed,
  });

  final ChatActionData action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isLoading = action.state == ChatActionState.loading;
    final isCompleted = action.state == ChatActionState.completed;
    final isError = action.state == ChatActionState.error;

    final Color backgroundColor;
    if (isCompleted) {
      backgroundColor = TarotTheme.cosmicBlue.withValues(alpha: 0.35);
    } else if (isError) {
      backgroundColor = Colors.red[600]!;
    } else {
      backgroundColor = TarotTheme.cosmicBlue;
    }

    final bool enabled = !isLoading && !isCompleted;

    return SizedBox(
      height: 42,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withValues(alpha: 0.9)),
                ),
              )
            else if (isCompleted)
              const Icon(
                Icons.check_circle,
                size: 18,
                color: Colors.white,
              )
            else if (isError)
              const Icon(
                Icons.refresh,
                size: 18,
                color: Colors.white,
              )
            else
              const Icon(
                Icons.auto_awesome,
                size: 18,
                color: Colors.white,
              ),
            const SizedBox(width: 8),
            Text(
              isCompleted ? '${action.label}' : action.label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
