import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../../models/lunar_day.dart';
import '../../theme/tarot_theme.dart';
import '../../l10n/lunar/lunar_spread_recommendations.dart';

class SpreadsTab extends StatelessWidget {
  const SpreadsTab({
    super.key,
    required this.day,
    required this.strings,
  });

  final LunarDayModel day;
  final CommonStrings strings;

  @override
  Widget build(BuildContext context) {
    final recommendations = getLunarSpreadRecommendations(strings.localeName);
    final spreads = recommendations[day.phaseId] ?? [];

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
                Icon(Icons.style, color: TarotTheme.cosmicAccent, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _localisedLabel('recommended_spreads'),
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
          // Spreads grid
          Expanded(child: _buildSpreadsGrid(spreads)),
        ],
      ),
    );
  }

  Widget _buildSpreadsGrid(List<Map<String, String>> spreads) {
    if (spreads.isEmpty) {
      return Center(
        child: Text(
          _localisedLabel('no_spreads'),
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
      itemCount: spreads.length,
      itemBuilder: (context, index) => _buildSpreadCard(spreads[index]),
    );
  }

  Widget _buildSpreadCard(Map<String, String> spread) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            spread['icon'] ?? '🃏',
            style: const TextStyle(fontSize: 26),
          ),
          const SizedBox(height: 6),
          Text(
            spread['name'] ?? '',
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
      'recommended_spreads': {
        'en': 'Recommended Spreads',
        'es': 'Tiradas Recomendadas',
        'ca': 'Tirades Recomanades'
      },
      'no_spreads': {
        'en': 'No spreads for this phase',
        'es': 'No hay tiradas para esta fase',
        'ca': 'No hi ha tirades per aquesta fase'
      },
    };
    return labels[key]?[locale] ?? labels[key]?['en'] ?? key;
  }
}
