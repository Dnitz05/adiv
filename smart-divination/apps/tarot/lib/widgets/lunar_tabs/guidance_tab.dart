import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../../models/lunar_day.dart';
import '../../models/lunar_guidance_content.dart';
import '../../theme/tarot_theme.dart';
import '../lunar_ai_advisor.dart';

class GuidanceTab extends StatelessWidget {
  const GuidanceTab({
    super.key,
    required this.day,
    required this.strings,
    this.userId,
  });

  final LunarDayModel day;
  final CommonStrings strings;
  final String? userId;

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

          LunarAiAdvisor(
            strings: strings,
            userId: userId,
            locale: locale,
            onShareAdvice: (message) {
              // Handle sharing advice
            },
          ),
          const SizedBox(height: 16),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: TarotTheme.cosmicAccent,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            TarotTheme.cosmicPurple.withValues(alpha: 0.3),
            TarotTheme.cosmicBlue.withValues(alpha: 0.3),
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
              Text(
                day.phaseEmoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  day.phaseName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            guidance.getMeaning(locale),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: TarotTheme.cosmicAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.wb_sunny_outlined,
                  color: TarotTheme.cosmicAccent,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    guidance.getEnergy(locale),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            bestForLabel,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: TarotTheme.cosmicAccent,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          ...guidance.getBestFor(locale).map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✓ ',
                    style: TextStyle(
                      color: TarotTheme.cosmicAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                          ),
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
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.orange[300],
                    fontWeight: FontWeight.w700,
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
                        color: Colors.orange[300],
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                              height: 1.4,
                            ),
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            elementColor.withValues(alpha: 0.2),
            elementColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: elementColor.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
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
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      _getElementLabel(guidance.element, locale),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 16),

          Text(
            focusLabel,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: elementColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: guidance.getFocusAreas(locale).map(
              (area) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: elementColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: elementColor.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  area,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
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
