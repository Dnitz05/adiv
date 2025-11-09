import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import '../theme/tarot_theme.dart';

class ArchiveBanner extends StatelessWidget {
  final VoidCallback onTap;
  final CommonStrings strings;

  const ArchiveBanner({
    super.key,
    required this.onTap,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    TarotTheme.cosmicPurple,
                    TarotTheme.twilightPurple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.history,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
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
              color: TarotTheme.cosmicPurple.withValues(alpha: 0.7),
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
        return 'Historial de Lecturas';
      case 'ca':
        return 'Historial de Lectures';
      default:
        return 'Reading Archive';
    }
  }

  String _getDescription() {
    switch (strings.localeName) {
      case 'es':
        return 'Revisa tus lecturas y diarios pasados';
      case 'ca':
        return 'Revisa les teves lectures i diaris anteriors';
      default:
        return 'Review your past readings and journal entries';
    }
  }
}
