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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPhaseGuide(context),
          const SizedBox(height: 16),
          _buildPowerHours(context),
        ],
      ),
    );
  }

  Widget _buildPhaseGuide(BuildContext context) {
    final locale = strings.localeName;
    final activities = getPhaseActivities(day.phaseId, locale);

    return LunarCardHelpers.buildCardWithHeader(
      context: context,
      icon: Icons.auto_awesome,
      title: getLunarLabel('phase_guide', locale),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phase Description
          Text(
            getPhaseDescription(day.phaseId, locale),
            style: LunarCardHelpers.cardBodyStyle,
          ),
          const SizedBox(height: 12),

          // Keywords
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: getPhaseKeywords(day.phaseId, locale).map((keyword) {
              return LunarCardHelpers.buildBadge(
                text: keyword,
                backgroundColor: TarotTheme.brightBlue20,
                textColor: TarotTheme.brightBlue,
              );
            }).toList(),
          ),

          LunarCardHelpers.buildCardDivider(),

          // Optimal Activities - Compact format
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF2ECC71), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getLunarLabel('optimal', locale),
                      style: const TextStyle(
                        color: Color(0xFF2ECC71),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activities['favored']!.join(' • '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (activities['avoid']!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.orangeAccent, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getLunarLabel('avoid', locale),
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        activities['avoid']!.join(' • '),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
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
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            TarotTheme.cosmicBlue.withValues(alpha: 0.2),
            TarotTheme.cosmicPurple.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [TarotTheme.cosmicBlue, TarotTheme.cosmicAccent],
                  ),
                ),
                child: const Icon(Icons.schedule, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                getLunarLabel('power_hours', locale),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            getLunarLabel('power_hours_subtitle', locale),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const SizedBox(height: 12),
          ...day.sessions.take(3).map((session) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    _formatSessionTime(session.createdAt, locale),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
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
