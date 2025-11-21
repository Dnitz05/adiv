import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../data/spread_learning_categories.dart';
import '../models/spread_basic_info.dart';
import '../theme/tarot_theme.dart';
import '../services/learn_progress_service.dart';
import 'spread_lesson_screen.dart';

/// Shows all spreads within a specific learning category
class SpreadCategoryDetailScreen extends StatefulWidget {
  const SpreadCategoryDetailScreen({
    super.key,
    required this.category,
    required this.strings,
  });

  final SpreadLearningCategory category;
  final CommonStrings strings;

  @override
  State<SpreadCategoryDetailScreen> createState() =>
      _SpreadCategoryDetailScreenState();
}

class _SpreadCategoryDetailScreenState
    extends State<SpreadCategoryDetailScreen> {
  final _progressService = LearnProgressService();
  Set<String> _completedLessons = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final completed =
        await _progressService.getCompletedLessons('spreads_journey');
    if (mounted) {
      setState(() {
        _completedLessons = completed.toSet();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.strings.localeName;
    final spreads = getSpreadsForIds(widget.category.spreadIds);
    final color = _parseColor(widget.category.color);
    final title = widget.category.title[locale] ?? widget.category.title['en'] ?? '';
    final description =
        widget.category.description[locale] ?? widget.category.description['en'] ?? '';

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
          title,
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
          // Category header
          _CategoryHeader(
            icon: widget.category.icon,
            title: title,
            description: description,
            spreadCount: widget.category.spreadIds.length,
            completed: _completedLessons.length,
            color: color,
            locale: locale,
          ),

          const SizedBox(height: 24),

          // Section title
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              _getSpreadsTitle(locale),
              style: const TextStyle(
                color: TarotTheme.deepNavy,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),

          // Spreads list
          if (spreads.isEmpty)
            _EmptyState(locale: locale)
          else
            ...spreads.asMap().entries.map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(
                      bottom: entry.key < spreads.length - 1 ? 12 : 0,
                    ),
                    child: _SpreadCard(
                      spread: entry.value,
                      color: color,
                      locale: locale,
                      isCompleted: _completedLessons.contains(entry.value.id),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SpreadLessonScreen(
                              spreadId: entry.value.id,
                              strings: widget.strings,
                            ),
                          ),
                        );
                        // Reload progress when returning
                        _loadProgress();
                      },
                    ),
                  ),
                ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  String _getSpreadsTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Tirades en aquesta categoria';
      case 'es':
        return 'Tiradas en esta categoría';
      default:
        return 'Spreads in this category';
    }
  }
}

// ============================================================================
// Category Header
// ============================================================================

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({
    required this.icon,
    required this.title,
    required this.description,
    required this.spreadCount,
    required this.completed,
    required this.color,
    required this.locale,
  });

  final String icon;
  final String title;
  final String description;
  final int spreadCount;
  final int completed;
  final Color color;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 36),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: TarotTheme.deepNavy,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getSpreadCountText(locale, spreadCount),
                      style: TextStyle(
                        color: color.withValues(alpha: 0.9),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
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
            description,
            style: const TextStyle(
              color: TarotTheme.softBlueGrey,
              fontSize: 15,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 18),

          // Progress
          _ProgressIndicator(
            completed: completed,
            total: spreadCount,
            color: color,
            locale: locale,
          ),
        ],
      ),
    );
  }

  String _getSpreadCountText(String locale, int count) {
    switch (locale) {
      case 'ca':
        return '$count tirades disponibles';
      case 'es':
        return '$count tiradas disponibles';
      default:
        return '$count spreads available';
    }
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    required this.completed,
    required this.total,
    required this.color,
    required this.locale,
  });

  final int completed;
  final int total;
  final Color color;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? completed / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getProgressLabel(locale),
              style: const TextStyle(
                color: TarotTheme.softBlueGrey,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$completed / $total',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  String _getProgressLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Completades';
      case 'es':
        return 'Completadas';
      default:
        return 'Completed';
    }
  }
}

// ============================================================================
// Spread Card
// ============================================================================

class _SpreadCard extends StatelessWidget {
  const _SpreadCard({
    required this.spread,
    required this.color,
    required this.locale,
    required this.isCompleted,
    required this.onTap,
  });

  final SpreadBasicInfo spread;
  final Color color;
  final String locale;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? color.withValues(alpha: 0.4)
                : TarotTheme.softBlueGrey.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // SVG spread visualization
            Container(
              width: 80,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: SvgPicture.network(
                buildApiUri('api/spread/svg/${spread.id}').toString(),
                fit: BoxFit.contain,
                placeholderBuilder: (context) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${spread.cardCount}',
                        style: TextStyle(
                          color: color,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        _getCardsLabel(locale),
                        style: TextStyle(
                          color: color.withValues(alpha: 0.8),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Spread info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          spread.getName(locale),
                          style: const TextStyle(
                            color: TarotTheme.deepNavy,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                      if (isCompleted)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: color,
                            size: 14,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Description
                  Text(
                    spread.getDescription(locale),
                    style: const TextStyle(
                      color: TarotTheme.softBlueGrey,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Complexity badge
                  _ComplexityChip(
                    complexity: spread.complexity,
                    locale: locale,
                    color: color,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              color: TarotTheme.softBlueGrey.withValues(alpha: 0.5),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  String _getCardsLabel(String locale) {
    switch (locale) {
      case 'ca':
        return spread.cardCount == 1 ? 'carta' : 'cartes';
      case 'es':
        return spread.cardCount == 1 ? 'carta' : 'cartas';
      default:
        return spread.cardCount == 1 ? 'card' : 'cards';
    }
  }
}

class _ComplexityChip extends StatelessWidget {
  const _ComplexityChip({
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _getLabel(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getLabel() {
    switch (complexity) {
      case 'simple':
      case 'beginner':
        switch (locale) {
          case 'ca':
            return 'Principiant';
          case 'es':
            return 'Principiante';
          default:
            return 'Beginner';
        }
      case 'moderate':
      case 'intermediate':
        switch (locale) {
          case 'ca':
            return 'Intermedi';
          case 'es':
            return 'Intermedio';
          default:
            return 'Intermediate';
        }
      case 'complex':
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

// ============================================================================
// Empty State
// ============================================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.locale});

  final String locale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            '🎴',
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 16),
          Text(
            _getMessage(locale),
            style: const TextStyle(
              color: TarotTheme.softBlueGrey,
              fontSize: 15,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getMessage(String locale) {
    switch (locale) {
      case 'ca':
        return 'No s\'han trobat tirades en aquesta categoria.';
      case 'es':
        return 'No se encontraron tiradas en esta categoría.';
      default:
        return 'No spreads found in this category.';
    }
  }
}
