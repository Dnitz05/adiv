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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
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
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: widget.enabled
                      ? Colors.grey[100]
                      : Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  isDense: true,
                ),
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
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
                child: Material(
                  color: TarotTheme.cosmicPurple,
                  shape: const CircleBorder(),
                  elevation: _hasText && widget.enabled ? 2 : 0,
                  child: InkWell(
                    onTap: _hasText && widget.enabled ? _handleSend : null,
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 44,
                      height: 44,
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
