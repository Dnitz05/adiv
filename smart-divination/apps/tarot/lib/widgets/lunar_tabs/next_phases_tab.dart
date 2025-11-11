import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../../models/lunar_day.dart';
import '../../theme/tarot_theme.dart';

class NextPhasesTab extends StatelessWidget {
  const NextPhasesTab({
    super.key,
    required this.day,
    required this.strings,
  });

  final LunarDayModel day;
  final CommonStrings strings;

  @override
  Widget build(BuildContext context) {
    final upcoming = _calculateUpcomingPhases();

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
      padding: const EdgeInsets.all(12),
      child: Column(
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
              children: upcoming.map((phase) => _buildPhaseCard(
                phase['emoji']!,
                phase['name']!,
                phase['date']!,
                phase['days']!,
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _calculateUpcomingPhases() {
    // Phase cycle: 0=New, 1=Wax Cresc, 2=1st Quarter, 3=Wax Gibb, 4=Full, 5=Wan Gibb, 6=Last Quarter, 7=Wan Cresc
    final int currentPhase = day.phaseId is int ? day.phaseId as int : int.parse(day.phaseId.toString());
    final currentDate = day.date;

    // Average days between major phases
    final List<int> phaseCycle = [0, 2, 4, 6]; // New, First Quarter, Full, Last Quarter indices
    final phaseEmojis = ['🌑', '🌓', '🌕', '🌗'];
    final phaseNames = {
      'en': ['New Moon', 'First Quarter', 'Full Moon', 'Last Quarter'],
      'es': ['Luna Nueva', 'Cuarto Creciente', 'Luna Llena', 'Cuarto Menguante'],
      'ca': ['Lluna Nova', 'Quart Creixent', 'Lluna Plena', 'Quart Minvant'],
    };

    final locale = strings.localeName;
    final names = phaseNames[locale] ?? phaseNames['en']!;

    final upcoming = <Map<String, String>>[];
    final lunarCycleDays = 29.53;
    final quarterDays = lunarCycleDays / 4;

    // Calculate next 4 major phases
    for (int i = 0; i < 4; i++) {
      // Find next major phase
      int nextPhaseIndex = 0;
      for (int j = 0; j < phaseCycle.length; j++) {
        if (phaseCycle[j] > currentPhase) {
          nextPhaseIndex = j;
          break;
        }
      }

      // Calculate approximate days until this phase
      final phaseDistance = (phaseCycle[nextPhaseIndex] - currentPhase + 8) % 8;
      final daysUntil = (phaseDistance * quarterDays / 2).round() + (i * quarterDays).round();

      final futureDate = currentDate.add(Duration(days: daysUntil));
      final formattedDate = _formatDate(futureDate);

      final daysLabel = _getDaysLabel(daysUntil);

      upcoming.add({
        'emoji': phaseEmojis[(nextPhaseIndex + i) % 4],
        'name': names[(nextPhaseIndex + i) % 4],
        'date': formattedDate,
        'days': daysLabel,
      });
    }

    return upcoming;
  }

  String _formatDate(DateTime date) {
    final locale = strings.localeName;
    final months = {
      'en': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
      'es': ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
      'ca': ['Gen', 'Feb', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Oct', 'Nov', 'Des'],
    };

    final monthNames = months[locale] ?? months['en']!;
    return '${monthNames[date.month - 1]} ${date.day}';
  }

  String _getDaysLabel(int days) {
    final locale = strings.localeName;

    if (days == 0) {
      return locale == 'en' ? 'Today' : (locale == 'es' ? 'Hoy' : 'Avui');
    } else if (days == 1) {
      return locale == 'en' ? '1 day' : (locale == 'es' ? '1 día' : '1 dia');
    } else {
      final dayWord = locale == 'en' ? 'days' : (locale == 'es' ? 'días' : 'dies');
      return '$days $dayWord';
    }
  }

  Widget _buildPhaseCard(String emoji, String label, String date, String daysLabel) {
    return Column(
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
          const SizedBox(height: 2),
          Text(
            daysLabel,
            style: TextStyle(
              color: TarotTheme.brightBlue.withValues(alpha: 0.8),
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
    );
  }

  String _localisedLabel(String key) {
    final locale = strings.localeName;
    final labels = {
      'upcoming_phases': {'en': 'Upcoming Phases', 'es': 'Próximas Fases', 'ca': 'Properes Fases'},
    };
    return labels[key]?[locale] ?? labels[key]?['en'] ?? key;
  }
}
