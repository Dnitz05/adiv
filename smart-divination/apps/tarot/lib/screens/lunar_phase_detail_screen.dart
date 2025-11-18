import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../models/lunar_guide_template.dart';
import '../theme/tarot_theme.dart';

class LunarPhaseDetailScreen extends StatelessWidget {
  const LunarPhaseDetailScreen({
    super.key,
    required this.template,
    required this.strings,
  });

  final LunarGuideTemplate template;
  final CommonStrings strings;

  @override
  Widget build(BuildContext context) {
    final locale = strings.localeName;
    final phaseColor = _getPhaseColor(template.phaseId);
    final phaseIcon = _getPhaseIcon(template.phaseId);

    return Scaffold(
      backgroundColor: TarotTheme.veryLightLilacBlue,
      body: CustomScrollView(
        slivers: [
          // App bar with gradient
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: phaseColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      phaseColor,
                      phaseColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        phaseIcon,
                        style: const TextStyle(fontSize: 64),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        template.getHeadline(locale),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      if (template.getTagline(locale) != null)
                        Text(
                          template.getTagline(locale)!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Energy Description
                  _SectionCard(
                    icon: '✨',
                    title: _getEnergyTitle(locale),
                    color: phaseColor,
                    child: Text(
                      template.getEnergyDescription(locale),
                      style: const TextStyle(
                        color: TarotTheme.deepNavy,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Focus Areas
                  _SectionCard(
                    icon: '🎯',
                    title: _getFocusTitle(locale),
                    color: phaseColor,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: template
                          .getFocusAreas(locale)
                          .map(
                            (area) => _Chip(
                              label: area,
                              color: phaseColor,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Recommended Actions
                  _SectionCard(
                    icon: '📝',
                    title: _getActionsTitle(locale),
                    color: phaseColor,
                    child: Column(
                      children: template
                          .getRecommendedActions(locale)
                          .asMap()
                          .entries
                          .map(
                            (entry) => Padding(
                              padding: EdgeInsets.only(
                                bottom: entry.key <
                                        template
                                                .getRecommendedActions(locale)
                                                .length -
                                            1
                                    ? 12
                                    : 0,
                              ),
                              child: _ActionItem(
                                number: entry.key + 1,
                                text: entry.value,
                                color: phaseColor,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Journal Prompts
                  if (template.getJournalPrompts(locale) != null &&
                      template.getJournalPrompts(locale)!.isNotEmpty)
                    _SectionCard(
                      icon: '📖',
                      title: _getJournalTitle(locale),
                      color: phaseColor,
                      child: Column(
                        children: template
                            .getJournalPrompts(locale)!
                            .asMap()
                            .entries
                            .map(
                              (entry) => Padding(
                                padding: EdgeInsets.only(
                                  bottom: entry.key <
                                          template
                                                  .getJournalPrompts(locale)!
                                                  .length -
                                              1
                                      ? 12
                                      : 0,
                                ),
                                child: _JournalPrompt(
                                  text: entry.value,
                                  color: phaseColor,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getEnergyTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Energia de la Fase';
      case 'es':
        return 'Energía de la Fase';
      default:
        return 'Phase Energy';
    }
  }

  String _getFocusTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Àrees de Focus';
      case 'es':
        return 'Áreas de Enfoque';
      default:
        return 'Focus Areas';
    }
  }

  String _getActionsTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Accions Recomanades';
      case 'es':
        return 'Acciones Recomendadas';
      default:
        return 'Recommended Actions';
    }
  }

  String _getJournalTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Reflexions del Diari';
      case 'es':
        return 'Reflexiones del Diario';
      default:
        return 'Journal Reflections';
    }
  }

  String _getPhaseIcon(String phaseId) {
    switch (phaseId) {
      case 'new_moon':
        return '🌑';
      case 'waxing_crescent':
        return '🌒';
      case 'first_quarter':
        return '🌓';
      case 'waxing_gibbous':
        return '🌔';
      case 'full_moon':
        return '🌕';
      case 'waning_gibbous':
        return '🌖';
      case 'last_quarter':
        return '🌗';
      case 'waning_crescent':
        return '🌘';
      default:
        return '🌙';
    }
  }

  Color _getPhaseColor(String phaseId) {
    switch (phaseId) {
      case 'new_moon':
        return const Color(0xFF1E293B);
      case 'waxing_crescent':
        return const Color(0xFF3B82F6);
      case 'first_quarter':
        return const Color(0xFF8B5CF6);
      case 'waxing_gibbous':
        return const Color(0xFFEC4899);
      case 'full_moon':
        return const Color(0xFFF59E0B);
      case 'waning_gibbous':
        return const Color(0xFF10B981);
      case 'last_quarter':
        return const Color(0xFF06B6D4);
      case 'waning_crescent':
        return const Color(0xFF6366F1);
      default:
        return const Color(0xFF8B5CF6);
    }
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.child,
  });

  final String icon;
  final String title;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.number,
    required this.text,
    required this.color,
  });

  final int number;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: TarotTheme.deepNavy,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _JournalPrompt extends StatelessWidget {
  const _JournalPrompt({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💭',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: TarotTheme.deepNavy,
                fontSize: 14,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
