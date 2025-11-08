import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../../models/lunar_day.dart';
import '../../models/lunar_guidance_content.dart';
import '../../theme/tarot_theme.dart';
import '../lunar_card_helpers.dart';

class GuidanceTab extends StatelessWidget {
  const GuidanceTab({
    super.key,
    required this.day,
    required this.strings,
  });

  final LunarDayModel day;
  final CommonStrings strings;

  @override
  Widget build(BuildContext context) {
    final locale = strings.localeName;
    final phaseGuidance = LunarGuidanceRepository.getPhaseGuidance(day.phaseId);
    final zodiacGuidance = LunarGuidanceRepository.getZodiacGuidance(day.zodiac.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, locale),
          const SizedBox(height: 20),

          if (phaseGuidance != null) ...[
            _buildPhaseCard(context, phaseGuidance, locale),
            const SizedBox(height: 16),
          ],

          if (zodiacGuidance != null) ...[
            _buildZodiacCard(context, zodiacGuidance, locale),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String locale) {
    String title, subtitle;

    switch (locale) {
      case 'es':
        title = 'Guía astrológica';
        subtitle = 'Sabiduría tradicional para hoy';
        break;
      case 'ca':
        title = 'Guia astrològica';
        subtitle = 'Saviesa tradicional per avui';
        break;
      default:
        title = 'Astrological guidance';
        subtitle = 'Traditional wisdom for today';
    }

    return LunarCardHelpers.buildCardWithHeader(
      context: context,
      icon: Icons.auto_awesome,
      title: title,
      subtitle: subtitle,
      content: const SizedBox.shrink(),
    );
  }

  Widget _buildPhaseCard(
    BuildContext context,
    PhaseGuidanceContent guidance,
    String locale,
  ) {
    String bestForLabel, avoidLabel;

    switch (locale) {
      case 'es':
        bestForLabel = 'Mejor para';
        avoidLabel = 'Evitar';
        break;
      case 'ca':
        bestForLabel = 'Millor per';
        avoidLabel = 'Evitar';
        break;
      default:
        bestForLabel = 'Best for';
        avoidLabel = 'Avoid';
    }

    return LunarCardHelpers.buildWhiteCard(
      context: context,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                day.phaseEmoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  day.phaseName,
                  style: LunarCardHelpers.cardTitleStyle.copyWith(fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            guidance.getMeaning(locale),
            style: LunarCardHelpers.cardBodyStyle,
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: TarotTheme.brightBlue10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.wb_sunny_outlined,
                  color: TarotTheme.brightBlue,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    guidance.getEnergy(locale),
                    style: LunarCardHelpers.cardSubtitleStyle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            bestForLabel,
            style: LunarCardHelpers.cardSubtitleStyle.copyWith(
              color: TarotTheme.brightBlue,
            ),
          ),
          const SizedBox(height: 8),
          ...guidance.getBestFor(locale).map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '✓ ',
                    style: TextStyle(
                      color: TarotTheme.brightBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: LunarCardHelpers.cardBodyStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (guidance.getAvoid(locale).isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              avoidLabel,
              style: LunarCardHelpers.cardSubtitleStyle.copyWith(
                color: Colors.orange[700],
              ),
            ),
            const SizedBox(height: 8),
            ...guidance.getAvoid(locale).map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚠ ',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: LunarCardHelpers.cardBodyStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildZodiacCard(
    BuildContext context,
    ZodiacGuidanceContent guidance,
    String locale,
  ) {
    String focusLabel;

    switch (locale) {
      case 'es':
        focusLabel = 'Áreas de enfoque';
        break;
      case 'ca':
        focusLabel = 'Àrees d\'enfocament';
        break;
      default:
        focusLabel = 'Focus areas';
    }

    final elementColor = _getElementColor(guidance.element);

    return LunarCardHelpers.buildWhiteCard(
      context: context,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                day.zodiac.symbol,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day.zodiac.name,
                      style: LunarCardHelpers.cardTitleStyle.copyWith(fontSize: 18),
                    ),
                    Text(
                      _getElementLabel(guidance.element, locale),
                      style: LunarCardHelpers.cardSmallStyle.copyWith(
                        color: elementColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            guidance.getEmotionalTone(locale),
            style: LunarCardHelpers.cardBodyStyle,
          ),
          const SizedBox(height: 16),

          Text(
            focusLabel,
            style: LunarCardHelpers.cardSubtitleStyle.copyWith(
              color: elementColor,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: guidance.getFocusAreas(locale).map(
              (area) => LunarCardHelpers.buildBadge(
                text: area,
                backgroundColor: elementColor.withValues(alpha: 0.2),
                textColor: TarotTheme.deepNavy,
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }

  Color _getElementColor(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return Colors.orange;
      case 'earth':
        return Colors.green;
      case 'air':
        return Colors.blue[300]!;
      case 'water':
        return Colors.cyan;
      default:
        return TarotTheme.cosmicAccent;
    }
  }

  String _getElementLabel(String element, String locale) {
    final elementLower = element.toLowerCase();

    switch (locale) {
      case 'es':
        switch (elementLower) {
          case 'fire': return 'Fuego';
          case 'earth': return 'Tierra';
          case 'air': return 'Aire';
          case 'water': return 'Agua';
          default: return element;
        }
      case 'ca':
        switch (elementLower) {
          case 'fire': return 'Foc';
          case 'earth': return 'Terra';
          case 'air': return 'Aire';
          case 'water': return 'Aigua';
          default: return element;
        }
      default:
        switch (elementLower) {
          case 'fire': return 'Fire';
          case 'earth': return 'Earth';
          case 'air': return 'Air';
          case 'water': return 'Water';
          default: return element;
        }
    }
  }
}
