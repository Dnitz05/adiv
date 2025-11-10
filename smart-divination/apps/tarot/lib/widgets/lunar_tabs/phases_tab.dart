import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../../models/lunar_day.dart';
import '../../theme/tarot_theme.dart';

class PhasesTab extends StatelessWidget {
  const PhasesTab({
    super.key,
    required this.day,
    required this.strings,
  });

  final LunarDayModel day;
  final CommonStrings strings;

  @override
  Widget build(BuildContext context) {
    // NO SCROLL - fixed height grid layout
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(Icons.brightness_3, color: TarotTheme.cosmicAccent, size: 18),
              const SizedBox(width: 8),
              Text(
                _localisedLabel('upcoming_phases'),
                style: const TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        // Compact 2x2 grid
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.6,
            children: [
              _buildPhaseCard('🌑', _localisedLabel('new_moon'), 'Nov 13'),
              _buildPhaseCard('🌓', _localisedLabel('first_quarter'), 'Nov 20'),
              _buildPhaseCard('🌕', _localisedLabel('full_moon'), 'Nov 27'),
              _buildPhaseCard('🌗', _localisedLabel('last_quarter'), 'Dec 5'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseCard(String emoji, String label, String date) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            TarotTheme.cosmicBlue.withValues(alpha: 0.12),
            TarotTheme.cosmicPurple.withValues(alpha: 0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: TarotTheme.deepNavy,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            date,
            style: const TextStyle(
              color: TarotTheme.softBlueGrey,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _localisedLabel(String key) {
    final locale = strings.localeName;
    final labels = {
      'upcoming_phases': {'en': 'Upcoming Phases', 'es': 'Próximas Fases', 'ca': 'Properes Fases'},
      'new_moon': {'en': 'New Moon', 'es': 'Luna Nueva', 'ca': 'Lluna Nova'},
      'first_quarter': {'en': 'First Quarter', 'es': 'Cuarto Creciente', 'ca': 'Quart Creixent'},
      'full_moon': {'en': 'Full Moon', 'es': 'Luna Llena', 'ca': 'Lluna Plena'},
      'last_quarter': {'en': 'Last Quarter', 'es': 'Cuarto Menguante', 'ca': 'Quart Minvant'},
    };
    return labels[key]?[locale] ?? labels[key]?['en'] ?? key;
  }
}
