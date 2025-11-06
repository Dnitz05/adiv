import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../theme/tarot_theme.dart';

/// Text input field with send button for chat interface
///
/// Styled similar to Telegram/WhatsApp with rounded text field
/// and circular send button
class ChatInputField extends StatefulWidget {
  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.strings,
    this.enabled = true,
    this.focusNode,
  });

  final TextEditingController controller;
  final Function(String) onSend;
  final CommonStrings strings;
  final bool enabled;
  final FocusNode? focusNode;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _handleSend() {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty && widget.enabled) {
      widget.onSend(text);
      widget.controller.clear();
      // Keep focus on input field after sending
      widget.focusNode?.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8F7FC),
            Colors.white,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.9),
            width: 1.5,
          ),
        ),
      ),
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Text input field
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                enabled: widget.enabled,
                maxLines: null,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSend(),
                decoration: InputDecoration(
                  hintText: _getHintText(),
                  hintStyle: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: TarotTheme.cosmicAccent,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: widget.enabled
                      ? Colors.white
                      : const Color(0xFFF0F0F0),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  isDense: true,
                ),
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send button
            AnimatedScale(
              scale: _hasText && widget.enabled ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: AnimatedOpacity(
                opacity: _hasText && widget.enabled ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        TarotTheme.cosmicBlue,
                        TarotTheme.cosmicAccent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: _hasText && widget.enabled
                        ? [
                            BoxShadow(
                              color: TarotTheme.cosmicBlue.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: _hasText && widget.enabled ? _handleSend : null,
                      customBorder: const CircleBorder(),
                      child: Container(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHintText() {
    switch (widget.strings.localeName) {
      case 'ca':
        return 'Escriu un missatge...';
      case 'es':
        return 'Escribe un mensaje...';
      default:
        return 'Type a message...';
    }
  }
}
