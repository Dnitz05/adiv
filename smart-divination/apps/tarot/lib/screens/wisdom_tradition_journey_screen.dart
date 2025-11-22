import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../data/wisdom_tradition_data.dart';
import '../models/wisdom_tradition_content.dart';
import '../theme/tarot_theme.dart';
import '../services/learn_progress_service.dart';
import 'wisdom_category_detail_screen.dart';
import 'wisdom_search_screen.dart';

/// Main hub for the Wisdom & Tradition learning journey
///
/// Displays all 6 wisdom categories and allows navigation
/// to individual category detail screens.
class WisdomTraditionJourneyScreen extends StatelessWidget {
  const WisdomTraditionJourneyScreen({
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: TarotTheme.deepNavy),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WisdomSearchScreen(strings: strings),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header card
          _HeaderCard(locale: locale),

          const SizedBox(height: 24),

          // Progress overview
          _ProgressOverviewCard(locale: locale),

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
          ...WisdomTraditionData.categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _CategoryCard(
                category: category,
                locale: locale,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => WisdomCategoryDetailScreen(
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
        return 'Saviesa i Tradició';
      case 'es':
        return 'Sabiduría y Tradición';
      default:
        return 'Wisdom & Tradition';
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
            Color(0xFFF59E0B), // Amber
            Color(0xFFD97706), // Darker amber
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
                  '📚',
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
                icon: '📖',
                value: '43',
                label: _getLessonsLabel(locale),
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
        return 'Saviesa i Tradició';
      case 'es':
        return 'Sabiduría y Tradición';
      default:
        return 'Wisdom & Tradition';
    }
  }

  String _getSubtitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Història • Ètica • Pràctica conscient';
      case 'es':
        return 'Historia • Ética • Práctica consciente';
      default:
        return 'History • Ethics • Conscious practice';
    }
  }

  String _getDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'Descobreix la història mil·lenària del tarot. Des dels seus orígens fins a la pràctica contemporània, amb ètica i respecte per totes les tradicions.';
      case 'es':
        return 'Descubre la historia milenaria del tarot. Desde sus orígenes hasta la práctica contemporánea, con ética y respeto por todas las tradiciones.';
      default:
        return 'Discover the millenary history of tarot. From its origins to contemporary practice, with ethics and respect for all traditions.';
    }
  }

  String _getLessonsLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Lliçons';
      case 'es':
        return 'Lecciones';
      default:
        return 'Lessons';
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
  int _completedLessons = 0;
  final int _totalLessons = 43;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final completed =
        await _progressService.getCompletedCount('wisdom_tradition');
    if (mounted) {
      setState(() {
        _completedLessons = completed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalLessons > 0 ? _completedLessons / _totalLessons : 0.0;
    final percentage = (progress * 100).toInt();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
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
          // Title and percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getProgressTitle(widget.locale),
                style: const TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: Color(0xFFF59E0B),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 10),

          // Stats text
          Text(
            _getProgressStats(widget.locale, _completedLessons, _totalLessons),
            style: const TextStyle(
              color: TarotTheme.softBlueGrey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getProgressTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'El Teu Progrés';
      case 'es':
        return 'Tu Progreso';
      default:
        return 'Your Progress';
    }
  }

  String _getProgressStats(String locale, int completed, int total) {
    switch (locale) {
      case 'ca':
        return '$completed de $total lliçons completades';
      case 'es':
        return '$completed de $total lecciones completadas';
      default:
        return '$completed of $total lessons completed';
    }
  }
}

// ============================================================================
// Category Card
// ============================================================================

class _CategoryCard extends StatefulWidget {
  const _CategoryCard({
    required this.category,
    required this.locale,
    required this.onTap,
  });

  final WisdomTraditionCategory category;
  final String locale;
  final VoidCallback onTap;

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  final _progressService = LearnProgressService();
  int _completedLessons = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    // Get completed lessons for this specific category
    final allCompleted =
        await _progressService.getCompletedLessons('wisdom_tradition');
    final categoryCompleted =
        allCompleted.where((id) => id.startsWith(widget.category.id)).length;

    if (mounted) {
      setState(() {
        _completedLessons = categoryCompleted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.category.lessonCount > 0
        ? _completedLessons / widget.category.lessonCount
        : 0.0;

    final color = Color(
      int.parse('0xFF${widget.category.color.substring(1)}'),
    );

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.25),
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
            // Icon, title and lesson count
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    widget.category.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.category.getTitle(widget.locale),
                        style: const TextStyle(
                          color: TarotTheme.deepNavy,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.category.getSubtitle(widget.locale),
                        style: TextStyle(
                          color: color.withValues(alpha: 0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Lesson count badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.category.lessonCount}',
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              widget.category.getDescription(widget.locale),
              style: const TextStyle(
                color: TarotTheme.softBlueGrey,
                fontSize: 14,
                height: 1.6,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 18),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
