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
                      strings.smartDrawsTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: TarotTheme.midnightBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      strings.smartDrawsSubtitle,
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
          _buildSmartSelectionHero(context),

          const SizedBox(height: 16),

          // "Or choose by theme" text
          Text(
            strings.smartDrawsChooseByTheme,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),

          // Themed categories grid - Responsive
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              // Càlcul dinàmic segons amplada disponible
              final int crossAxisCount;
              final double aspectRatio;
              final double fontSize;

              if (width > 550) {
                // Tablets: 4 columnes
                crossAxisCount = 4;
                aspectRatio = 2.5;
                fontSize = 12.0;
              } else if (width > 300) {
                // Mòbils normals: 3 columnes
                crossAxisCount = 3;
                aspectRatio = 1.9;
                fontSize = 11.0;
              } else {
                // Mòbils molt petits: 2 columnes
                crossAxisCount = 2;
                aspectRatio = 2.5;
                fontSize = 12.0;
              }

              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: aspectRatio,
                children: [
                  _buildThemeCategory(
                    icon: Icons.favorite,
                    label: strings.smartDrawsThemeLove,
                    color: TarotTheme.cosmicRose,
                    fontSize: fontSize,
                    onTap: onLove,
                  ),
                  _buildThemeCategory(
                    icon: Icons.work,
                    label: strings.smartDrawsThemeCareer,
                    color: TarotTheme.cosmicAmber,
                    fontSize: fontSize,
                    onTap: onCareer,
                  ),
                  _buildThemeCategory(
                    icon: Icons.account_balance,
                    label: strings.smartDrawsThemeMoney,
                    color: TarotTheme.cosmicEmerald,
                    fontSize: fontSize,
                    onTap: onFinances,
                  ),
                  _buildThemeCategory(
                    icon: Icons.self_improvement,
                    label: strings.smartDrawsThemePersonal,
                    color: TarotTheme.cosmicOrchid,
                    fontSize: fontSize,
                    onTap: onPersonalGrowth,
                  ),
                  _buildThemeCategory(
                    icon: Icons.balance,
                    label: strings.smartDrawsThemeDecisions,
                    color: TarotTheme.cosmicTeal,
                    fontSize: fontSize,
                    onTap: onDecisions,
                  ),
                  _buildThemeCategory(
                    icon: Icons.blur_on,
                    label: strings.smartDrawsThemeGeneral,
                    color: TarotTheme.cosmicBlue,
                    fontSize: fontSize,
                    onTap: onGeneral,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSmartSelectionHero(BuildContext context) {
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
                      strings.smartDrawsSelectionTitle,
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
                strings.smartDrawsSelectionDescription,
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
                      strings.smartDrawsSelectionCTA,
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
    double fontSize = 11.0,
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
                  fontSize: fontSize,
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
}
