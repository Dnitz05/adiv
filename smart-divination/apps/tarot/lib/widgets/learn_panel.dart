import 'dart:math' as math;
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
          colors: [
            TarotTheme.deepNight,
            TarotTheme.midnightBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: TarotTheme.midnightBlue.withValues(alpha: 0.35),
            blurRadius: 36,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.auto_stories,
                  color: Colors.white,
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
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getLearnSubtitle(strings),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: onNavigateToKnowledge,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.45),
                  ),
                ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(
                  _getHeaderActionLabel(strings),
                  style: const TextStyle(fontWeight: FontWeight.w600),
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
        colors: const [Color(0xFFFB7BA2), Color(0xFFFCE043)],
      ),
      _LearnCategoryData(
        icon: Icons.auto_awesome,
        title: _getAstrologyTitle(strings),
        description: _getAstrologyDescription(strings),
        onTap: onNavigateToAstrology,
        colors: const [Color(0xFF4FACFE), Color(0xFF00F2FE)],
      ),
      _LearnCategoryData(
        icon: Icons.grid_view,
        title: _getSpreadsTitle(strings),
        description: _getSpreadsDescription(strings),
        onTap: onNavigateToSpreads,
        colors: const [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
        tags: [
          _resolveLink(strings, 'basic'),
          _resolveLink(strings, 'advanced'),
        ],
      ),
      _LearnCategoryData(
        icon: Icons.psychology_alt,
        title: _getKnowledgeTitle(strings),
        description: _getKnowledgeDescription(strings),
        onTap: onNavigateToKnowledge,
        colors: const [Color(0xFF833AB4), Color(0xFFFF5F6D)],
      ),
      _LearnCategoryData(
        icon: Icons.brightness_3,
        title: _getMoonTitle(strings),
        description: _getMoonDescription(strings),
        onTap: onNavigateToMoonPowers,
        colors: const [Color(0xFF00C6FB), Color(0xFF005BEA)],
        tags: [
          _resolveLink(strings, 'rituals'),
        ],
      ),
      _LearnCategoryData(
        icon: Icons.auto_stories,
        title: _getKabbalahTitle(strings),
        description: _getKabbalahDescription(strings),
        onTap: onNavigateToKabbalah,
        colors: const [Color(0xFFFBD986), Color(0xFFF7797D)],
      ),
    ];
  }

  String _resolveLink(CommonStrings strings, String id) {
    return _getLinkLabel(strings, id);
  }

  String _getLinkLabel(CommonStrings strings, String id) {
    switch (id) {
      case 'basic':
        switch (strings.localeName) {
          case 'ca':
            return 'Bàsic';
          case 'es':
            return 'Básico';
          default:
            return 'Basics';
        }
      case 'advanced':
        switch (strings.localeName) {
          case 'ca':
            return 'Avançat';
          case 'es':
            return 'Avanzado';
          default:
            return 'Advanced';
        }
      case 'rituals':
        switch (strings.localeName) {
          case 'ca':
            return 'Rituals';
          case 'es':
            return 'Rituales';
          default:
            return 'Rituals';
        }
      default:
        return '';
    }
  }

  String _getLearnTitle(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Aprèn Tarot amb nosaltres';
      case 'es':
        return 'Aprende Tarot con nosotros';
      default:
        return 'Learn Tarot';
    }
  }

  String _getLearnSubtitle(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Guies premium, rituals i art del tarot per créixer cada dia.';
      case 'es':
        return 'Guías premium, rituales y arte del tarot para crecer cada día.';
      default:
        return 'Premium guides, rituals and tarot art to grow every day.';
    }
  }

  String _getHeaderActionLabel(CommonStrings strings) {
    switch (strings.localeName) {
      case 'ca':
        return 'Explora';
      case 'es':
        return 'Explorar';
      default:
        return 'Explore';
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
        return 'Significat detallat de cada arcà, correspondències i inversions.';
      case 'es':
        return 'Significado detallado de cada arcano, correspondencias e inversiones.';
      default:
        return 'Detailed meaning of every arcana, correspondences and reversals.';
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
        return 'Integra signes, cases i fases lunars a les lectures.';
      case 'es':
        return 'Integra signos, casas y fases lunares en las lecturas.';
      default:
        return 'Blend star signs, houses and moon phases into your readings.';
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
        return 'Des de tirades bàsiques fins a dissenys avançats per sessions pro.';
      case 'es':
        return 'Desde tiradas básicas hasta diseños avanzados para sesiones pro.';
      default:
        return 'From foundational spreads to advanced layouts for pro sessions.';
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
        return 'Història del tarot, codis ètics i pràctica professional.';
      case 'es':
        return 'Historia del tarot, códigos éticos y práctica profesional.';
      default:
        return 'Tarot history, ethical codes and professional practice.';
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
        return 'Rituals, intencions i calendaris per manifestar amb la lluna.';
      case 'es':
        return 'Rituales, intenciones y calendarios para manifestar con la luna.';
      default:
        return 'Rituals, intentions and calendars to manifest with the moon.';
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
        return 'Arbre de la vida, camins i correspondències amb els arcanes.';
      case 'es':
        return 'Árbol de la vida, caminos y correspondencias con los arcanos.';
      default:
        return 'Tree of life, paths and correspondences with the arcana.';
    }
  }
}

class _LearnCategoryData {
  const _LearnCategoryData({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    required this.colors,
    this.tags = const [],
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final List<String> tags;
  final List<Color> colors;
}

class _LearnCategoryCard extends StatelessWidget {
  const _LearnCategoryCard({
    required this.category,
  });

  final _LearnCategoryData category;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: category.colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final cardHeight = category.tags.isNotEmpty ? 195.0 : 175.0;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: category.onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: cardHeight),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: category.colors.last.withValues(alpha: 0.3),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -6,
              child: Transform.rotate(
                angle: math.pi / 6,
                child: Icon(
                  Icons.auto_awesome_motion,
                  size: 68,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    category.icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  category.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  category.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    height: 1.35,
                    fontSize: 13,
                  ),
                  maxLines: category.tags.isEmpty ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (category.tags.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: category.tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
