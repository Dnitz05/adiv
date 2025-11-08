import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import '../theme/tarot_theme.dart';

class ChatBanner extends StatelessWidget {
  final VoidCallback onTap;
  final CommonStrings strings;

  const ChatBanner({
    super.key,
    required this.onTap,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              TarotTheme.brightBlue.withOpacity(0.1),
              TarotTheme.lunarLavenderLight.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: TarotTheme.brightBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: TarotTheme.brightBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                color: TarotTheme.brightBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getTitle(),
                    style: const TextStyle(
                      color: TarotTheme.deepNavy,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getDescription(),
                    style: TextStyle(
                      color: TarotTheme.softBlueGrey.withOpacity(0.9),
                      fontSize: 13,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: TarotTheme.brightBlue,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    switch (strings.localeName) {
      case 'es':
        return 'Charla sobre Tarot';
      case 'ca':
        return 'Conversa sobre Tarot';
      default:
        return 'Chat about Tarot';
    }
  }

  String _getDescription() {
    switch (strings.localeName) {
      case 'es':
        return 'Habla de forma distendida y directa sobre tarot y haz tus consultas';
      case 'ca':
        return 'Parla de forma distesa i directa sobre tarot i fes les teves consultes';
      default:
        return 'Have relaxed and direct conversations about tarot and ask your questions';
    }
  }
}
