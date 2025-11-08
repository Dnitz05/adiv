import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../../models/lunar_day.dart';
import '../lunar_card_helpers.dart';

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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildUpcomingPhases(context),
        ],
      ),
    );
  }

  Widget _buildUpcomingPhases(BuildContext context) {
    return LunarCardHelpers.buildCardWithHeader(
      context: context,
      icon: Icons.calendar_month,
      title: _localisedLabel('upcoming_phases'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPhaseItem('🌑', _localisedLabel('new_moon'), 'Nov 13'),
          _buildPhaseItem('🌓', _localisedLabel('first_quarter'), 'Nov 20'),
          _buildPhaseItem('🌕', _localisedLabel('full_moon'), 'Nov 27'),
          _buildPhaseItem('🌗', _localisedLabel('last_quarter'), 'Dec 5'),
        ],
      ),
    );
  }

  Widget _buildPhaseItem(String emoji, String label, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: LunarCardHelpers.cardBodyStyle,
            ),
          ),
          Text(
            date,
            style: LunarCardHelpers.cardSubtitleStyle,
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
