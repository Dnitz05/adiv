import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../data/spread_learning_categories.dart';
import '../models/spread_basic_info.dart';
import '../theme/tarot_theme.dart';
import '../services/learn_progress_service.dart';
import '../services/spread_recommendation_service.dart';
import 'spread_category_detail_screen.dart';
import 'spread_lesson_screen.dart';

/// Main hub for the Spreads & Methods learning journey
///
/// Displays all 6 spread learning categories and allows navigation
/// to individual category detail screens.
class SpreadsJourneyScreen extends StatelessWidget {
  const SpreadsJourneyScreen({
    super.key,
    required this.strings,
  });

  final CommonStrings strings;

  @override
  Widget build(BuildContext context) {
    final locale = strings.localeName;

    return Scaffold(
      backgroundColor: TarotTheme.veryLightLilacBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TarotTheme.deepNavy),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _getTitle(locale),
          style: const TextStyle(
            color: TarotTheme.deepNavy,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header card
          _HeaderCard(locale: locale),

          const SizedBox(height: 24),

          // Progress overview
          _ProgressOverviewCard(locale: locale),

          const SizedBox(height: 24),

          // Recommended for you
          _RecommendedForYouCard(
            locale: locale,
            strings: strings,
          ),

          const SizedBox(height: 28),

          // Section title
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              _getCategoriesTitle(locale),
              style: const TextStyle(
                color: TarotTheme.deepNavy,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),

          // Categories grid
          ...SPREAD_LEARNING_CATEGORIES.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _CategoryCard(
                category: category,
                locale: locale,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SpreadCategoryDetailScreen(
                        category: category,
                        strings: strings,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Tirades i Mètodes';
      case 'es':
        return 'Tiradas y Métodos';
      default:
        return 'Spreads & Methods';
    }
  }

  String _getCategoriesTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Categories d\'Aprenentatge';
      case 'es':
        return 'Categorías de Aprendizaje';
      default:
        return 'Learning Categories';
    }
  }
}

// ============================================================================
// Header Card
// ============================================================================

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.locale});

  final String locale;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF06B6D4), // Cyan
            Color(0xFF0891B2), // Darker cyan
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF06B6D4).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and title row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  '🎯',
                  style: TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTitle(locale),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSubtitle(locale),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Description
          Text(
            _getDescription(locale),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 15,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 20),

          // Stats row
          Row(
            children: [
              _StatChip(
                icon: '📚',
                value: '101',
                label: _getSpreadsLabel(locale),
              ),
              const SizedBox(width: 12),
              _StatChip(
                icon: '🎓',
                value: '6',
                label: _getCategoriesLabel(locale),
              ),
              const SizedBox(width: 12),
              _StatChip(
                icon: '⭐',
                value: '3',
                label: _getLevelsLabel(locale),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Tirades i Mètodes';
      case 'es':
        return 'Tiradas y Métodos';
      default:
        return 'Spreads & Methods';
    }
  }

  String _getSubtitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Del principiant a l\'expert';
      case 'es':
        return 'Del principiante al experto';
      default:
        return 'From Beginner to Expert';
    }
  }

  String _getDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'Domina l\'art de la lectura del tarot amb 101 tirades detallades. Cada tirada inclou guies completes sobre quan usar-la, com interpretar-la i les relacions entre posicions.';
      case 'es':
        return 'Domina el arte de la lectura del tarot con 101 tiradas detalladas. Cada tirada incluye guías completas sobre cuándo usarla, cómo interpretarla y las relaciones entre posiciones.';
      default:
        return 'Master the art of tarot reading with 101 detailed spreads. Each spread includes complete guides on when to use it, how to interpret it, and position relationships.';
    }
  }

  String _getSpreadsLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Tirades';
      case 'es':
        return 'Tiradas';
      default:
        return 'Spreads';
    }
  }

  String _getCategoriesLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Categories';
      case 'es':
        return 'Categorías';
      default:
        return 'Categories';
    }
  }

  String _getLevelsLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Nivells';
      case 'es':
        return 'Niveles';
      default:
        return 'Levels';
    }
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  final String icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Progress Overview Card
// ============================================================================

class _ProgressOverviewCard extends StatefulWidget {
  const _ProgressOverviewCard({required this.locale});

  final String locale;

  @override
  State<_ProgressOverviewCard> createState() => _ProgressOverviewCardState();
}

class _ProgressOverviewCardState extends State<_ProgressOverviewCard> {
  final _progressService = LearnProgressService();
  int _completedSpreads = 0;
  final int _totalSpreads = 101;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final completed = await _progressService.getCompletedCount('spreads_journey');
    if (mounted) {
      setState(() {
        _completedSpreads = completed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalSpreads > 0 ? _completedSpreads / _totalSpreads : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF06B6D4).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.insights,
                  color: Color(0xFF06B6D4),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _getTitle(widget.locale),
                style: const TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress text
          Text(
            _getProgressText(widget.locale, _completedSpreads, _totalSpreads),
            style: const TextStyle(
              color: TarotTheme.softBlueGrey,
              fontSize: 14,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF06B6D4).withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF06B6D4),
              ),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 8),

          // Percentage
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Color(0xFF06B6D4),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'El Teu Progrés';
      case 'es':
        return 'Tu Progreso';
      default:
        return 'Your Progress';
    }
  }

  String _getProgressText(String locale, int completed, int total) {
    switch (locale) {
      case 'ca':
        return 'Has completat $completed de $total tirades. Continua explorant per dominar diferents tècniques de lectura!';
      case 'es':
        return 'Has completado $completed de $total tiradas. ¡Continúa explorando para dominar diferentes técnicas de lectura!';
      default:
        return 'You\'ve completed $completed of $total spreads. Keep exploring to master different reading techniques!';
    }
  }
}

// ============================================================================
// Category Card
// ============================================================================

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.locale,
    required this.onTap,
  });

  final SpreadLearningCategory category;
  final String locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(category.color);
    final title = category.title[locale] ?? category.title['en'] ?? '';
    final description =
        category.description[locale] ?? category.description['en'] ?? '';
    final spreadCount = category.spreadIds.length;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon, title and arrow
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    category.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: TarotTheme.deepNavy,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getSpreadCountText(locale, spreadCount),
                        style: TextStyle(
                          color: color.withValues(alpha: 0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: TarotTheme.softBlueGrey,
                  size: 16,
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Description
            Text(
              description,
              style: const TextStyle(
                color: TarotTheme.softBlueGrey,
                fontSize: 14,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 16),

            // Complexity badge
            _ComplexityBadge(
              complexity: category.complexity,
              locale: locale,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  String _getSpreadCountText(String locale, int count) {
    switch (locale) {
      case 'ca':
        return '$count tirades';
      case 'es':
        return '$count tiradas';
      default:
        return '$count spreads';
    }
  }
}

// ============================================================================
// Recommended For You Card
// ============================================================================

class _RecommendedForYouCard extends StatefulWidget {
  const _RecommendedForYouCard({
    required this.locale,
    required this.strings,
  });

  final String locale;
  final CommonStrings strings;

  @override
  State<_RecommendedForYouCard> createState() => _RecommendedForYouCardState();
}

class _RecommendedForYouCardState extends State<_RecommendedForYouCard> {
  final _recommendationService = SpreadRecommendationService();
  List<SpreadBasicInfo> _recommendations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    final recommendations =
        await _recommendationService.getPersonalizedRecommendations(
      maxResults: 3,
    );

    if (mounted) {
      setState(() {
        _recommendations = recommendations;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    if (_recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF59E0B), // Amber
            Color(0xFFF97316), // Orange
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTitle(widget.locale),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSubtitle(widget.locale),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Recommended spreads
          ..._recommendations.asMap().entries.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key < _recommendations.length - 1 ? 10 : 0,
                  ),
                  child: _RecommendedSpreadCard(
                    spread: entry.value,
                    locale: widget.locale,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SpreadLessonScreen(
                            spreadId: entry.value.id,
                            strings: widget.strings,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
        ],
      ),
    );
  }

  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Recomanat per a Tu';
      case 'es':
        return 'Recomendado para Ti';
      default:
        return 'Recommended for You';
    }
  }

  String _getSubtitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Basant-nos en el teu progrés';
      case 'es':
        return 'Basado en tu progreso';
      default:
        return 'Based on your progress';
    }
  }
}

class _RecommendedSpreadCard extends StatelessWidget {
  const _RecommendedSpreadCard({
    required this.spread,
    required this.locale,
    required this.onTap,
  });

  final SpreadBasicInfo spread;
  final String locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Card count badge
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${spread.cardCount}',
                  style: const TextStyle(
                    color: Color(0xFFF59E0B),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Spread info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spread.getName(locale),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    spread.getComplexityLabel(locale),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward,
              color: Colors.white.withValues(alpha: 0.8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Complexity Badge
// ============================================================================

class _ComplexityBadge extends StatelessWidget {
  const _ComplexityBadge({
    required this.complexity,
    required this.locale,
    required this.color,
  });

  final String complexity;
  final String locale;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getComplexityIcon(),
            color: color,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            _getComplexityLabel(locale),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getComplexityIcon() {
    switch (complexity) {
      case 'beginner':
        return Icons.star_outline;
      case 'intermediate':
        return Icons.star_half;
      case 'advanced':
        return Icons.star;
      default:
        return Icons.help_outline;
    }
  }

  String _getComplexityLabel(String locale) {
    switch (complexity) {
      case 'beginner':
        switch (locale) {
          case 'ca':
            return 'Principiant';
          case 'es':
            return 'Principiante';
          default:
            return 'Beginner';
        }
      case 'intermediate':
        switch (locale) {
          case 'ca':
            return 'Intermedi';
          case 'es':
            return 'Intermedio';
          default:
            return 'Intermediate';
        }
      case 'advanced':
        switch (locale) {
          case 'ca':
            return 'Avançat';
          case 'es':
            return 'Avanzado';
          default:
            return 'Advanced';
        }
      default:
        return complexity;
    }
  }
}
