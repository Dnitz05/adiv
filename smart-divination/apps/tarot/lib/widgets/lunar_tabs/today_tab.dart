import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../../models/lunar_day.dart';
import '../../theme/tarot_theme.dart';
import '../lunar_card_helpers.dart';
import '../../l10n/lunar/lunar_phase_data.dart';
import '../../l10n/lunar/lunar_translations.dart';

class TodayTab extends StatelessWidget {
  const TodayTab({
    super.key,
    required this.day,
    required this.strings,
  });

  final LunarDayModel day;
  final CommonStrings strings;

  @override
  Widget build(BuildContext context) {
    // NO SCROLL - fixed height optimized layout
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPhaseGuide(context),
        const SizedBox(height: 12),
        _buildPowerHours(context),
      ],
    );
  }

  Widget _buildPhaseGuide(BuildContext context) {
    final locale = strings.localeName;
    final activities = getPhaseActivities(day.phaseId, locale);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [
              TarotTheme.cosmicBlue.withValues(alpha: 0.15),
              TarotTheme.cosmicPurple.withValues(alpha: 0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: TarotTheme.cosmicAccent.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compact Header
            Row(
              children: [
                Icon(Icons.auto_awesome, color: TarotTheme.cosmicAccent, size: 18),
                const SizedBox(width: 8),
                Text(
                  getLunarLabel('phase_guide', locale),
                  style: const TextStyle(
                    color: TarotTheme.deepNavy,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Phase Description - compact
            Text(
              getPhaseDescription(day.phaseId, locale),
              style: const TextStyle(
                color: TarotTheme.deepNavy,
                fontSize: 12,
                height: 1.35,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Keywords - compact, max 4
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: getPhaseKeywords(day.phaseId, locale).take(4).map((keyword) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: TarotTheme.brightBlue20,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    keyword,
                    style: const TextStyle(
                      color: TarotTheme.brightBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            // Compact divider
            Container(
              height: 1,
              color: TarotTheme.cosmicAccent.withValues(alpha: 0.15),
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),

            // Optimal Activities - ultra compact
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF2ECC71), size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    activities['favored']!.take(3).join(' • '),
                    style: const TextStyle(
                      color: TarotTheme.deepNavy,
                      fontSize: 11,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPowerHours(BuildContext context) {
    if (day.sessions.isEmpty) {
      return const SizedBox.shrink();
    }

    final locale = strings.localeName;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: TarotTheme.brightBlue.withValues(alpha: 0.08),
        border: Border.all(
          color: TarotTheme.brightBlue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TarotTheme.brightBlue,
            ),
            child: const Icon(Icons.schedule, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getLunarLabel('power_hours', locale),
                  style: const TextStyle(
                    color: TarotTheme.deepNavy,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  day.sessions.take(2).map((s) => _formatSessionTime(s.createdAt, locale)).join(' • '),
                  style: const TextStyle(
                    color: TarotTheme.softBlueGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatSessionTime(DateTime createdAt, String locale) {
    final hour = createdAt.hour;
    final minute = createdAt.minute.toString().padLeft(2, '0');

    // Use 12h format for English, 24h for Spanish/Catalan
    if (locale == 'en') {
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } else {
      // 24h format for es/ca
      return '$hour:$minute';
    }
  }
}
