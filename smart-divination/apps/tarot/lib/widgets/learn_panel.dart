import 'package:common/l10n/common_strings.dart';
import 'package:flutter/material.dart';

import '../theme/tarot_theme.dart';

class LearnPanel extends StatelessWidget {
  const LearnPanel({
    super.key,
    required this.strings,
    required this.onNavigateToCards,
    required this.onNavigateToKnowledge,
    required this.onNavigateToSpreads,
    required this.onNavigateToAstrology,
    required this.onNavigateToKabbalah,
    required this.onNavigateToMoonPowers,
  });

  final CommonStrings strings;
  final VoidCallback onNavigateToCards;
  final VoidCallback onNavigateToKnowledge;
  final VoidCallback onNavigateToSpreads;
  final VoidCallback onNavigateToAstrology;
  final VoidCallback onNavigateToKabbalah;
  final VoidCallback onNavigateToMoonPowers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = _buildCategories();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TarotTheme.skyBlueLight,
            TarotTheme.skyBlueSoft,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: TarotTheme.skyBlueShadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: TarotTheme.brightBlue10,
            blurRadius: 32,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: TarotTheme.brightBlue20,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.auto_stories,
                  color: TarotTheme.brightBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getLearnTitle(strings),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: TarotTheme.deepNavy,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getLearnSubtitle(strings),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: TarotTheme.softBlueGrey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 620;
              final itemsPerRow = isWide ? 3 : 2;
              const gap = 12.0;
              final itemWidth =
                  (constraints.maxWidth - (itemsPerRow - 1) * gap) /
                      itemsPerRow;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: categories
                    .map(
                      (category) => SizedBox(
                        width: itemWidth,
                        child: _LearnCategoryCard(category: category),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  List<_LearnCategoryData> _buildCategories() {
    return [
      _LearnCategoryData(
        icon: Icons.style,
        title: _getCardsTitle(strings),
        description: _getCardsDescription(strings),
        onTap: onNavigateToCards,
      ),
      _LearnCategoryData(
        icon: Icons.auto_awesome,
        title: _getAstrologyTitle(strings),
        description: _getAstrologyDescription(strings),
        onTap: onNavigateToAstrology,
      ),
      _LearnCategoryData(
        icon: Icons.grid_view,
        title: _getSpreadsTitle(strings),
        description: _getSpreadsDescription(strings),
        onTap: onNavigateToSpreads,
      ),
      _LearnCategoryData(
        icon: Icons.psychology_alt,
        title: _getKnowledgeTitle(strings),
        description: _getKnowledgeDescription(strings),
        onTap: onNavigateToKnowledge,
      ),
      _LearnCategoryData(
        icon: Icons.brightness_3,
        title: _getMoonTitle(strings),
        description: _getMoonDescription(strings),
        onTap: onNavigateToMoonPowers,
      ),
      _LearnCategoryData(
        icon: Icons.auto_stories,
        title: _getKabbalahTitle(strings),
        description: _getKabbalahDescription(strings),
        onTap: onNavigateToKabbalah,
      ),
    ];
  }

  String _getLearnTitle(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Aprèn Tarot';
      case 'es':
        return 'Aprende Tarot';
      default:
        return 'Learn Tarot';
    }
  }

  String _getLearnSubtitle(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Guies, rituals i art del tarot per créixer cada dia.';
      case 'es':
        return 'Guías, rituales y arte del tarot para crecer cada día.';
      default:
        return 'Guides, rituals and tarot art to grow every day.';
    }
  }

  String _getCardsTitle(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Cartes & simbolisme';
      case 'es':
        return 'Cartas & simbolismo';
      default:
        return 'Cards & symbolism';
    }
  }

  String _getCardsDescription(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Significat de cada arcà i correspondències.';
      case 'es':
        return 'Significado de cada arcano y correspondencias.';
      default:
        return 'Meaning of every arcana and correspondences.';
    }
  }

  String _getAstrologyTitle(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Astrologia & Tarot';
      case 'es':
        return 'Astrología & Tarot';
      default:
        return 'Astrology & Tarot';
    }
  }

  String _getAstrologyDescription(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Signes, cases i fases lunars a les lectures.';
      case 'es':
        return 'Signos, casas y fases lunares en las lecturas.';
      default:
        return 'Signs, houses and moon phases in readings.';
    }
  }

  String _getSpreadsTitle(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Tirades i mètodes';
      case 'es':
        return 'Tiradas y métodos';
      default:
        return 'Spreads & methods';
    }
  }

  String _getSpreadsDescription(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Tirades des de bàsiques fins a avançades.';
      case 'es':
        return 'Tiradas desde básicas hasta avanzadas.';
      default:
        return 'Spreads from basics to advanced.';
    }
  }

  String _getKnowledgeTitle(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Coneixement sacre';
      case 'es':
        return 'Conocimiento sagrado';
      default:
        return 'Sacred knowledge';
    }
  }

  String _getKnowledgeDescription(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Història, ètica i pràctica professional.';
      case 'es':
        return 'Historia, ética y práctica profesional.';
      default:
        return 'History, ethics and professional practice.';
    }
  }

  String _getMoonTitle(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Poder lunar';
      case 'es':
        return 'Poder lunar';
      default:
        return 'Moon power';
    }
  }

  String _getMoonDescription(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Rituals i calendaris lunars.';
      case 'es':
        return 'Rituales y calendarios lunares.';
      default:
        return 'Rituals and lunar calendars.';
    }
  }

  String _getKabbalahTitle(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Mística & Kabbalah';
      case 'es':
        return 'Mística & Kabbalah';
      default:
        return 'Mysticism & Kabbalah';
    }
  }

  String _getKabbalahDescription(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Arbre de la vida i correspondències.';
      case 'es':
        return 'Árbol de la vida y correspondencias.';
      default:
        return 'Tree of life and correspondences.';
    }
  }
}

class _LearnCategoryData {
  const _LearnCategoryData({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
}

class _LearnCategoryCard extends StatelessWidget {
  const _LearnCategoryCard({
    required this.category,
  });

  final _LearnCategoryData category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: category.onTap,
      child: Container(
        height: 115,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(
            color: TarotTheme.brightBlue20,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: TarotTheme.brightBlue10,
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              category.icon,
              color: TarotTheme.brightBlue,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              category.title,
              style: const TextStyle(
                color: TarotTheme.deepNavy,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              category.description,
              style: const TextStyle(
                color: TarotTheme.softBlueGrey,
                fontSize: 12,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
