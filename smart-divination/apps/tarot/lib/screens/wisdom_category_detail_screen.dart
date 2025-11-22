import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../data/wisdom_tradition_data.dart';
import '../models/wisdom_tradition_content.dart';
import '../theme/tarot_theme.dart';
import '../services/learn_progress_service.dart';
import 'wisdom_lesson_screen.dart';

/// Shows all lessons within a specific Wisdom & Tradition category
class WisdomCategoryDetailScreen extends StatefulWidget {
  const WisdomCategoryDetailScreen({
    super.key,
    required this.category,
    required this.strings,
  });

  final WisdomTraditionCategory category;
  final CommonStrings strings;

  @override
  State<WisdomCategoryDetailScreen> createState() =>
      _WisdomCategoryDetailScreenState();
}

class _WisdomCategoryDetailScreenState
    extends State<WisdomCategoryDetailScreen> {
  final _progressService = LearnProgressService();
  Set<String> _completedLessons = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final completed =
        await _progressService.getCompletedLessons('wisdom_tradition');
    if (mounted) {
      setState(() {
        _completedLessons = completed.toSet();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.strings.localeName;
    final lessons = WisdomTraditionData.getLessonsForCategory(widget.category.id);
    final color = _parseColor(widget.category.color);
    final title = widget.category.getTitle(locale);
    final description = widget.category.getDescription(locale);

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
            lessonCount: widget.category.lessonCount,
            completed: _completedLessons
                .where((id) => id.startsWith(widget.category.id))
                .length,
            color: color,
            locale: locale,
          ),

          const SizedBox(height: 24),

          // Section title
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              _getLessonsTitle(locale),
              style: const TextStyle(
                color: TarotTheme.deepNavy,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),

          // Lessons list
          if (lessons.isEmpty)
            _EmptyState(locale: locale)
          else
            ...lessons.asMap().entries.map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(
                      bottom: entry.key < lessons.length - 1 ? 12 : 0,
                    ),
                    child: _LessonCard(
                      lesson: entry.value,
                      color: color,
                      locale: locale,
                      isCompleted: _completedLessons.contains(entry.value.id),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => WisdomLessonScreen(
                              lessonId: entry.value.id,
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

  String _getLessonsTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Lliçons en aquesta categoria';
      case 'es':
        return 'Lecciones en esta categoría';
      default:
        return 'Lessons in this category';
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
    required this.lessonCount,
    required this.completed,
    required this.color,
    required this.locale,
  });

  final String icon;
  final String title;
  final String description;
  final int lessonCount;
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
                      _getLessonCountText(locale, lessonCount),
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

          const SizedBox(height: 20),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: lessonCount > 0 ? completed / lessonCount : 0.0,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 10),

          // Progress text
          Text(
            _getProgressText(locale, completed, lessonCount),
            style: const TextStyle(
              color: TarotTheme.softBlueGrey,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getLessonCountText(String locale, int count) {
    switch (locale) {
      case 'ca':
        return count == 1 ? '$count lliçó' : '$count lliçons';
      case 'es':
        return count == 1 ? '$count lección' : '$count lecciones';
      default:
        return count == 1 ? '$count lesson' : '$count lessons';
    }
  }

  String _getProgressText(String locale, int completed, int total) {
    switch (locale) {
      case 'ca':
        return '$completed de $total completades';
      case 'es':
        return '$completed de $total completadas';
      default:
        return '$completed of $total completed';
    }
  }
}

// ============================================================================
// Lesson Card
// ============================================================================

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.lesson,
    required this.color,
    required this.locale,
    required this.isCompleted,
    required this.onTap,
  });

  final WisdomLesson lesson;
  final Color color;
  final String locale;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
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
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Lesson number or icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCompleted
                    ? color.withValues(alpha: 0.15)
                    : TarotTheme.softBlueGrey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: isCompleted
                    ? Icon(
                        Icons.check_circle,
                        color: color,
                        size: 24,
                      )
                    : Text(
                        lesson.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
              ),
            ),

            const SizedBox(width: 14),

            // Lesson info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.getTitle(locale),
                    style: TextStyle(
                      color: isCompleted
                          ? color
                          : TarotTheme.deepNavy,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson.getSubtitle(locale),
                    style: TextStyle(
                      color: TarotTheme.softBlueGrey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Difficulty badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(lesson.difficulty)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          lesson.getDifficultyLabel(locale),
                          style: TextStyle(
                            color: _getDifficultyColor(lesson.difficulty),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Reading time
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: TarotTheme.softBlueGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getReadingTimeText(locale, lesson.estimatedMinutes),
                        style: const TextStyle(
                          color: TarotTheme.softBlueGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isCompleted
                  ? color
                  : TarotTheme.softBlueGrey,
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return const Color(0xFF10B981); // Green
      case 'intermediate':
        return const Color(0xFFF59E0B); // Amber
      case 'advanced':
        return const Color(0xFFEF4444); // Red
      default:
        return TarotTheme.softBlueGrey;
    }
  }

  String _getReadingTimeText(String locale, int minutes) {
    switch (locale) {
      case 'ca':
        return '$minutes min';
      case 'es':
        return '$minutes min';
      default:
        return '$minutes min';
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
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Icon(
            Icons.menu_book,
            size: 64,
            color: TarotTheme.softBlueGrey,
          ),
          const SizedBox(height: 16),
          Text(
            _getMessage(locale),
            style: const TextStyle(
              color: TarotTheme.softBlueGrey,
              fontSize: 15,
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
        return 'No hi ha lliçons disponibles en aquesta categoria encara.';
      case 'es':
        return 'No hay lecciones disponibles en esta categoría todavía.';
      default:
        return 'No lessons available in this category yet.';
    }
  }
}
