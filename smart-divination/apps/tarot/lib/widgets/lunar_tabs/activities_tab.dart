import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../../models/lunar_day.dart';
import '../../theme/tarot_theme.dart';

class ActivitiesTab extends StatelessWidget {
  const ActivitiesTab({
    super.key,
    required this.day,
    required this.strings,
  });

  final LunarDayModel day;
  final CommonStrings strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TarotTheme.brightBlue.withValues(alpha: 0.03),
            TarotTheme.brightBlue.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TarotTheme.brightBlue.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(
            'LIFE AREAS',
            style: TextStyle(
              color: TarotTheme.brightBlue.withValues(alpha: 0.6),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),

          // 6 Life Areas in 2 columns × 3 rows - Table layout
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: TarotTheme.brightBlue.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildLifeAreaRow(
                          icon: Icons.favorite,
                          label: 'Love',
                          favorable: true,
                        ),
                      ),
                      Container(
                        width: 1,
                        color: TarotTheme.brightBlue.withValues(alpha: 0.2),
                      ),
                      Expanded(
                        child: _buildLifeAreaRow(
                          icon: Icons.attach_money,
                          label: 'Money',
                          favorable: false,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: TarotTheme.brightBlue.withValues(alpha: 0.2),
                ),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildLifeAreaRow(
                          icon: Icons.work,
                          label: 'Career',
                          favorable: false,
                        ),
                      ),
                      Container(
                        width: 1,
                        color: TarotTheme.brightBlue.withValues(alpha: 0.2),
                      ),
                      Expanded(
                        child: _buildLifeAreaRow(
                          icon: Icons.health_and_safety,
                          label: 'Health',
                          favorable: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: TarotTheme.brightBlue.withValues(alpha: 0.2),
                ),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildLifeAreaRow(
                          icon: Icons.people,
                          label: 'Social',
                          favorable: false,
                        ),
                      ),
                      Container(
                        width: 1,
                        color: TarotTheme.brightBlue.withValues(alpha: 0.2),
                      ),
                      Expanded(
                        child: _buildLifeAreaRow(
                          icon: Icons.palette,
                          label: 'Creative',
                          favorable: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Peak Energy Times
          _buildPowerHours(),
        ],
      ),
    );
  }

  Widget _buildLifeAreaRow({
    required IconData icon,
    required String label,
    required bool favorable,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: TarotTheme.brightBlue),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: TarotTheme.deepNavy,
              ),
            ),
          ),
          Icon(
            favorable ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: favorable ? const Color(0xFF27AE60) : Colors.orange.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TarotTheme.cosmicAccent.withValues(alpha: 0),
            TarotTheme.cosmicAccent.withValues(alpha: 0.2),
            TarotTheme.cosmicAccent.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildPowerHours() {
    final locale = strings.localeName;

    // Show placeholder times if no sessions available
    final timesText = day.sessions.isEmpty
        ? '6:00 AM • 6:00 PM'
        : day.sessions.take(2).map((s) => _formatSessionTime(s.createdAt, locale)).join(' • ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: TarotTheme.cosmicAccent,
          ),
          child: const Icon(Icons.access_time, color: Colors.white, size: 12),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Peak Energy Times',
                style: TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'When lunar influence is strongest',
                style: TextStyle(
                  color: TarotTheme.deepNavy.withValues(alpha: 0.6),
                  fontSize: 9,
                  fontStyle: FontStyle.italic,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                timesText,
                style: TextStyle(
                  color: TarotTheme.cosmicAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
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
