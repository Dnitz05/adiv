import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../theme/tarot_theme.dart';

/// Panel de aprendizaje sobre tarot con recursos educativos
///
/// Incluye:
/// - Significado de las cartas
/// - Conocimientos generales
/// - Explicaciones de tiradas
class LearnPanel extends StatelessWidget {
  const LearnPanel({
    super.key,
    required this.strings,
    required this.onNavigateToCards,
    required this.onNavigateToKnowledge,
    required this.onNavigateToSpreads,
  });

  final CommonStrings strings;
  final VoidCallback onNavigateToCards;
  final VoidCallback onNavigateToKnowledge;
  final VoidCallback onNavigateToSpreads;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: TarotTheme.midnightBlue,
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.15),
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
      padding: const EdgeInsets.all(20),
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
                  color: TarotTheme.cosmicAccent.withValues(alpha: 0.15),
                ),
                child: Icon(
                  Icons.school,
                  color: TarotTheme.cosmicAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getLearnTitle(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: TarotTheme.moonlight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getLearnSubtitle(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: TarotTheme.stardust,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Learning categories
          _LearnCategory(
            icon: Icons.style,
            title: _getCardsTitle(),
            description: _getCardsDescription(),
            onTap: onNavigateToCards,
          ),
          const SizedBox(height: 12),
          _LearnCategory(
            icon: Icons.lightbulb_outline,
            title: _getKnowledgeTitle(),
            description: _getKnowledgeDescription(),
            onTap: onNavigateToKnowledge,
          ),
          const SizedBox(height: 12),
          _LearnCategory(
            icon: Icons.grid_view,
            title: _getSpreadsTitle(),
            description: _getSpreadsDescription(),
            onTap: onNavigateToSpreads,
          ),
        ],
      ),
    );
  }

  String _getLearnTitle() {
    switch (strings.localeName) {
      case 'ca':
        return 'Aprèn Tarot';
      case 'es':
        return 'Aprende Tarot';
      default:
        return 'Learn Tarot';
    }
  }

  String _getLearnSubtitle() {
    switch (strings.localeName) {
      case 'ca':
        return 'Coneixements i guies';
      case 'es':
        return 'Conocimientos y guías';
      default:
        return 'Knowledge and guides';
    }
  }

  String _getCardsTitle() {
    switch (strings.localeName) {
      case 'ca':
        return 'Significat de les Cartes';
      case 'es':
        return 'Significado de las Cartas';
      default:
        return 'Card Meanings';
    }
  }

  String _getCardsDescription() {
    switch (strings.localeName) {
      case 'ca':
        return 'Explora el significat de cada carta del tarot';
      case 'es':
        return 'Explora el significado de cada carta del tarot';
      default:
        return 'Explore the meaning of each tarot card';
    }
  }

  String _getKnowledgeTitle() {
    switch (strings.localeName) {
      case 'ca':
        return 'Coneixements Generals';
      case 'es':
        return 'Conocimientos Generales';
      default:
        return 'General Knowledge';
    }
  }

  String _getKnowledgeDescription() {
    switch (strings.localeName) {
      case 'ca':
        return 'Història, simbologia i pràctiques del tarot';
      case 'es':
        return 'Historia, simbología y prácticas del tarot';
      default:
        return 'History, symbolism and tarot practices';
    }
  }

  String _getSpreadsTitle() {
    switch (strings.localeName) {
      case 'ca':
        return 'Tirades i Interpretació';
      case 'es':
        return 'Tiradas e Interpretación';
      default:
        return 'Spreads & Interpretation';
    }
  }

  String _getSpreadsDescription() {
    switch (strings.localeName) {
      case 'ca':
        return 'Aprèn diferents tirades i com interpretar-les';
      case 'es':
        return 'Aprende diferentes tiradas y cómo interpretarlas';
      default:
        return 'Learn different spreads and how to interpret them';
    }
  }
}

class _LearnCategory extends StatelessWidget {
  const _LearnCategory({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: TarotTheme.cosmicPurple.withValues(alpha: 0.3),
            border: Border.all(
              color: TarotTheme.twilightPurple.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
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
                child: Icon(
                  icon,
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
                      title,
                      style: TextStyle(
                        color: TarotTheme.moonlight,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        color: TarotTheme.stardust,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: TarotTheme.stardust,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
