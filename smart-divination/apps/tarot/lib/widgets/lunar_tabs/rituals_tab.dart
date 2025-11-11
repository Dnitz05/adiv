import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../../models/lunar_day.dart';
import '../../theme/tarot_theme.dart';
import '../../l10n/lunar/lunar_ritual_recommendations.dart';

class RitualsTab extends StatelessWidget {
  const RitualsTab({
    super.key,
    required this.day,
    required this.strings,
  });

  final LunarDayModel day;
  final CommonStrings strings;

  @override
  Widget build(BuildContext context) {
    final recommendations = getLunarRitualRecommendations(strings.localeName);
    final rituals = recommendations[day.phaseId] ?? [];

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
                Icon(Icons.wb_twilight, color: TarotTheme.cosmicAccent, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _localisedLabel('recommended_rituals'),
                    style: const TextStyle(
                      color: TarotTheme.deepNavy,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  day.phaseName,
                  style: const TextStyle(
                    color: TarotTheme.softBlueGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Rituals grid
          Expanded(child: _buildRitualsGrid(rituals)),
        ],
      ),
    );
  }

  Widget _buildRitualsGrid(List<Map<String, String>> rituals) {
    if (rituals.isEmpty) {
      return Center(
        child: Text(
          _localisedLabel('no_rituals'),
          style: const TextStyle(
            color: TarotTheme.softBlueGrey,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: rituals.length,
      itemBuilder: (context, index) => _buildRitualCard(rituals[index]),
    );
  }

  Widget _buildRitualCard(Map<String, String> ritual) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ritual['icon'] ?? '✨',
            style: const TextStyle(fontSize: 26),
          ),
          const SizedBox(height: 6),
          Text(
            ritual['name'] ?? '',
            style: const TextStyle(
              color: TarotTheme.deepNavy,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
    );
  }

  String _localisedLabel(String key) {
    final locale = strings.localeName;
    final labels = {
      'recommended_rituals': {
        'en': 'Recommended Rituals',
        'es': 'Rituales Recomendados',
        'ca': 'Rituals Recomanats'
      },
      'no_rituals': {
        'en': 'No rituals for this phase',
        'es': 'No hay rituales para esta fase',
        'ca': 'No hi ha rituals per aquesta fase'
      },
    };
    return labels[key]?[locale] ?? labels[key]?['en'] ?? key;
  }
}
