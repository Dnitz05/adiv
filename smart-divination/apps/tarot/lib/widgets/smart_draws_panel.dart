import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../theme/tarot_theme.dart';

/// Panel that showcases Smart Selection prominently with themed categories
class SmartDrawsPanel extends StatelessWidget {
  const SmartDrawsPanel({
    super.key,
    required this.strings,
    required this.onSmartSelection,
    required this.onLove,
    required this.onCareer,
    required this.onFinances,
    required this.onPersonalGrowth,
    required this.onDecisions,
    required this.onGeneral,
  });

  final CommonStrings strings;
  final VoidCallback onSmartSelection;
  final VoidCallback onLove;
  final VoidCallback onCareer;
  final VoidCallback onFinances;
  final VoidCallback onPersonalGrowth;
  final VoidCallback onDecisions;
  final VoidCallback onGeneral;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = strings.localeName;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      TarotTheme.cosmicBlue,
                      TarotTheme.cosmicAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.style,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTitle(locale),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: TarotTheme.midnightBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getSubtitle(locale),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Smart Selection Hero Card
          _buildSmartSelectionHero(context, locale),

          const SizedBox(height: 8),

          // "Or choose by theme" text
          Text(
            _getChooseByThemeText(locale),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 6),

          // Themed categories grid (2x3)
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.5,
            children: [
              _buildThemeCategory(
                icon: Icons.favorite,
                label: _getLoveLabel(locale),
                color: Colors.pink[300]!,
                onTap: onLove,
              ),
              _buildThemeCategory(
                icon: Icons.work,
                label: _getCareerLabel(locale),
                color: Colors.amber[700]!,
                onTap: onCareer,
              ),
              _buildThemeCategory(
                icon: Icons.account_balance,
                label: _getFinancesLabel(locale),
                color: Colors.green[400]!,
                onTap: onFinances,
              ),
              _buildThemeCategory(
                icon: Icons.self_improvement,
                label: _getPersonalGrowthLabel(locale),
                color: Colors.purple[400]!,
                onTap: onPersonalGrowth,
              ),
              _buildThemeCategory(
                icon: Icons.balance,
                label: _getDecisionsLabel(locale),
                color: Colors.teal[400]!,
                onTap: onDecisions,
              ),
              _buildThemeCategory(
                icon: Icons.blur_on,
                label: _getGeneralLabel(locale),
                color: TarotTheme.cosmicBlue,
                onTap: onGeneral,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmartSelectionHero(BuildContext context, String locale) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSmartSelection,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                TarotTheme.cosmicBlue,
                TarotTheme.cosmicAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: TarotTheme.cosmicBlue.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _getSmartSelectionTitle(locale),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.stars,
                          color: Colors.yellow[300],
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'AI',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _getSmartSelectionDescription(locale),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.95),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getSmartSelectionCTA(locale),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: TarotTheme.cosmicBlue,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: TarotTheme.cosmicBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeCategory({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color.withValues(alpha: 0.1),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Localized strings
  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Tirades Intel·ligents';
      case 'es':
        return 'Tiradas Inteligentes';
      default:
        return 'Smart Draws';
    }
  }

  String _getSubtitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Trobar la tirada perfecta per tu';
      case 'es':
        return 'Encuentra la tirada perfecta para ti';
      default:
        return 'Find the perfect spread for you';
    }
  }

  String _getSmartSelectionTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Selecció Intel·ligent';
      case 'es':
        return 'Selección Inteligente';
      default:
        return 'Smart Selection';
    }
  }

  String _getSmartSelectionDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'Descriu la teva situació i l\'AI et recomana la millor tirada';
      case 'es':
        return 'Describe tu situación y la IA te recomienda la mejor tirada';
      default:
        return 'Describe your situation and AI recommends the best spread';
    }
  }

  String _getSmartSelectionCTA(String locale) {
    switch (locale) {
      case 'ca':
        return 'Prova-ho ara';
      case 'es':
        return 'Pruébalo ahora';
      default:
        return 'Try it now';
    }
  }

  String _getChooseByThemeText(String locale) {
    switch (locale) {
      case 'ca':
        return 'O tria per temàtica:';
      case 'es':
        return 'O elige por temática:';
      default:
        return 'Or choose by theme:';
    }
  }

  String _getLoveLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Amor';
      case 'es':
        return 'Amor';
      default:
        return 'Love';
    }
  }

  String _getCareerLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Carrera';
      case 'es':
        return 'Carrera';
      default:
        return 'Career';
    }
  }

  String _getFinancesLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Diners';
      case 'es':
        return 'Dinero';
      default:
        return 'Money';
    }
  }

  String _getPersonalGrowthLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Personal';
      case 'es':
        return 'Personal';
      default:
        return 'Personal';
    }
  }

  String _getDecisionsLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Decisions';
      case 'es':
        return 'Decisiones';
      default:
        return 'Decisions';
    }
  }

  String _getGeneralLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'General';
      case 'es':
        return 'General';
      default:
        return 'General';
    }
  }
}
