import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:common/l10n/common_strings.dart';

import '../data/wisdom_tradition_data.dart';
import '../models/wisdom_tradition_content.dart';
import '../theme/tarot_theme.dart';
import '../services/learn_progress_service.dart';
import '../services/lesson_bookmark_service.dart';

/// Displays a single wisdom lesson with full content
class WisdomLessonScreen extends StatefulWidget {
  const WisdomLessonScreen({
    super.key,
    required this.lessonId,
    required this.strings,
  });

  final String lessonId;
  final CommonStrings strings;

  @override
  State<WisdomLessonScreen> createState() => _WisdomLessonScreenState();
}

class _WisdomLessonScreenState extends State<WisdomLessonScreen> {
  final _progressService = LearnProgressService();
  final _bookmarkService = LessonBookmarkService();
  final _scrollController = ScrollController();
  bool _isCompleted = false;
  bool _isBookmarked = false;
  bool _showCompletionButton = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _loadBookmark();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Show completion button when user scrolls past 80% of content
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final shouldShow = currentScroll > maxScroll * 0.8;

      if (shouldShow != _showCompletionButton) {
        setState(() {
          _showCompletionButton = shouldShow;
        });
      }
    }
  }

  Future<void> _loadProgress() async {
    final completed = await _progressService.isLessonCompleted(
      journeyId: 'wisdom_tradition',
      lessonId: widget.lessonId,
    );

    if (mounted) {
      setState(() {
        _isCompleted = completed;
        _showCompletionButton = completed; // Show immediately if already completed
      });
    }
  }

  Future<void> _loadBookmark() async {
    final bookmarked = await _bookmarkService.isBookmarked(widget.lessonId);

    if (mounted) {
      setState(() {
        _isBookmarked = bookmarked;
      });
    }
  }

  Future<void> _toggleBookmark() async {
    await _bookmarkService.toggleBookmark(widget.lessonId);

    if (mounted) {
      setState(() {
        _isBookmarked = !_isBookmarked;
      });

      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isBookmarked
                ? _getBookmarkedMessage(widget.strings.localeName)
                : _getUnbookmarkedMessage(widget.strings.localeName),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _toggleCompletion() async {
    if (_isCompleted) {
      await _progressService.markLessonIncomplete(
        journeyId: 'wisdom_tradition',
        lessonId: widget.lessonId,
      );
    } else {
      await _progressService.markLessonComplete(
        journeyId: 'wisdom_tradition',
        lessonId: widget.lessonId,
      );
    }

    if (mounted) {
      setState(() {
        _isCompleted = !_isCompleted;
      });

      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isCompleted
                ? _getCompletedMessage(widget.strings.localeName)
                : _getUncompletedMessage(widget.strings.localeName),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.strings.localeName;
    final lesson = WisdomTraditionData.getLessonById(widget.lessonId);

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(_getNotFoundMessage(locale)),
        ),
      );
    }

    final category =
        WisdomTraditionData.getCategoryById(lesson.categoryId);
    final color = category != null
        ? Color(int.parse('0xFF${category.color.substring(1)}'))
        : const Color(0xFFF59E0B);

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
          lesson.getTitle(locale),
          style: const TextStyle(
            color: TarotTheme.deepNavy,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          // Bookmark toggle
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? color : TarotTheme.softBlueGrey,
            ),
            onPressed: _toggleBookmark,
          ),
          // Completion toggle
          IconButton(
            icon: Icon(
              _isCompleted ? Icons.check_circle : Icons.circle_outlined,
              color: _isCompleted ? color : TarotTheme.softBlueGrey,
            ),
            onPressed: _toggleCompletion,
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              // Lesson header
              _LessonHeader(
                lesson: lesson,
                category: category,
                color: color,
                locale: locale,
              ),

              const SizedBox(height: 24),

              // Main content (simplified markdown rendering)
              _ContentSection(
                content: lesson.getContent(locale),
                color: color,
              ),

              const SizedBox(height: 28),

              // Key points
              _KeyPointsSection(
                keyPoints: lesson.getKeyPoints(locale),
                color: color,
                locale: locale,
              ),

              const SizedBox(height: 24),

              // Traditional sources
              _SourcesSection(
                sources: lesson.getTraditions(locale),
                color: color,
                locale: locale,
              ),

              const SizedBox(height: 24),

              // Further reading (if available)
              if (lesson.getFurtherReading(locale).isNotEmpty) ...[
                _FurtherReadingSection(
                  readings: lesson.getFurtherReading(locale),
                  color: color,
                  locale: locale,
                ),
                const SizedBox(height: 24),
              ],

              // Navigation buttons
              _NavigationButtons(
                lessonId: widget.lessonId,
                locale: locale,
                strings: widget.strings,
              ),

              const SizedBox(height: 100), // Space for floating button
            ],
          ),

          // Floating completion button
          if (_showCompletionButton)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _FloatingCompletionButton(
                isCompleted: _isCompleted,
                color: color,
                locale: locale,
                onPressed: _toggleCompletion,
              ),
            ),
        ],
      ),
    );
  }

  String _getCompletedMessage(String locale) {
    switch (locale) {
      case 'ca':
        return '✓ Lliçó marcada com a completada';
      case 'es':
        return '✓ Lección marcada como completada';
      default:
        return '✓ Lesson marked as completed';
    }
  }

  String _getUncompletedMessage(String locale) {
    switch (locale) {
      case 'ca':
        return 'Lliçó marcada com a no completada';
      case 'es':
        return 'Lección marcada como no completada';
      default:
        return 'Lesson marked as not completed';
    }
  }

  String _getNotFoundMessage(String locale) {
    switch (locale) {
      case 'ca':
        return 'Lliçó no trobada';
      case 'es':
        return 'Lección no encontrada';
      default:
        return 'Lesson not found';
    }
  }

  String _getBookmarkedMessage(String locale) {
    switch (locale) {
      case 'ca':
        return '🔖 Lliçó afegida als favorits';
      case 'es':
        return '🔖 Lección añadida a favoritos';
      default:
        return '🔖 Lesson bookmarked';
    }
  }

  String _getUnbookmarkedMessage(String locale) {
    switch (locale) {
      case 'ca':
        return 'Lliçó eliminada dels favorits';
      case 'es':
        return 'Lección eliminada de favoritos';
      default:
        return 'Lesson removed from bookmarks';
    }
  }
}

// ============================================================================
// Lesson Header
// ============================================================================

class _LessonHeader extends StatelessWidget {
  const _LessonHeader({
    required this.lesson,
    required this.category,
    required this.color,
    required this.locale,
  });

  final WisdomLesson lesson;
  final WisdomTraditionCategory? category;
  final Color color;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Category badge
          if (category != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category!.icon,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category!.getTitle(locale),
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Lesson icon and title
          Row(
            children: [
              Text(
                lesson.icon,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.getTitle(locale),
                      style: const TextStyle(
                        color: TarotTheme.deepNavy,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lesson.getSubtitle(locale),
                      style: const TextStyle(
                        color: TarotTheme.softBlueGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Metadata row
          Row(
            children: [
              // Difficulty
              _MetaChip(
                icon: Icons.signal_cellular_alt,
                label: lesson.getDifficultyLabel(locale),
                color: _getDifficultyColor(lesson.difficulty),
              ),
              const SizedBox(width: 8),
              // Reading time
              _MetaChip(
                icon: Icons.access_time,
                label: '${lesson.estimatedMinutes} min',
                color: TarotTheme.softBlueGrey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return const Color(0xFF10B981);
      case 'intermediate':
        return const Color(0xFFF59E0B);
      case 'advanced':
        return const Color(0xFFEF4444);
      default:
        return TarotTheme.softBlueGrey;
    }
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Content Section (Simplified Markdown)
// ============================================================================

class _ContentSection extends StatelessWidget {
  const _ContentSection({
    required this.content,
    required this.color,
  });

  final String content;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: MarkdownBody(
        data: content,
        styleSheet: MarkdownStyleSheet(
          h1: const TextStyle(
            color: TarotTheme.deepNavy,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.4,
          ),
          h2: const TextStyle(
            color: TarotTheme.deepNavy,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
          h3: const TextStyle(
            color: TarotTheme.deepNavy,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          p: const TextStyle(
            color: TarotTheme.deepNavy,
            fontSize: 15,
            height: 1.8,
            letterSpacing: 0.2,
          ),
          strong: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
          ),
          em: const TextStyle(
            fontStyle: FontStyle.italic,
            color: TarotTheme.softBlueGrey,
          ),
          blockquote: TextStyle(
            color: TarotTheme.softBlueGrey,
            fontStyle: FontStyle.italic,
            fontSize: 14,
          ),
          blockquoteDecoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: color,
                width: 4,
              ),
            ),
          ),
          listBullet: TextStyle(color: color),
        ),
      ),
    );
  }
}

// ============================================================================
// Key Points Section
// ============================================================================

class _KeyPointsSection extends StatelessWidget {
  const _KeyPointsSection({
    required this.keyPoints,
    required this.color,
    required this.locale,
  });

  final List<String> keyPoints;
  final Color color;
  final String locale;

  @override
  Widget build(BuildContext context) {
    if (keyPoints.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                _getKeyPointsTitle(locale),
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...keyPoints.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(
                        color: TarotTheme.deepNavy,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getKeyPointsTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Punts Clau';
      case 'es':
        return 'Puntos Clave';
      default:
        return 'Key Points';
    }
  }
}

// ============================================================================
// Sources Section
// ============================================================================

class _SourcesSection extends StatelessWidget {
  const _SourcesSection({
    required this.sources,
    required this.color,
    required this.locale,
  });

  final List<String> sources;
  final Color color;
  final String locale;

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                _getSourcesTitle(locale),
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...sources.map(
            (source) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                source,
                style: const TextStyle(
                  color: TarotTheme.softBlueGrey,
                  fontSize: 13,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSourcesTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Fonts Tradicionals';
      case 'es':
        return 'Fuentes Tradicionales';
      default:
        return 'Traditional Sources';
    }
  }
}

// ============================================================================
// Further Reading Section
// ============================================================================

class _FurtherReadingSection extends StatelessWidget {
  const _FurtherReadingSection({
    required this.readings,
    required this.color,
    required this.locale,
  });

  final List<String> readings;
  final Color color;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_stories, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                _getFurtherReadingTitle(locale),
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...readings.map(
            (reading) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '• $reading',
                style: TextStyle(
                  color: color.withValues(alpha: 0.9),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFurtherReadingTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Lectures Recomanades';
      case 'es':
        return 'Lecturas Recomendadas';
      default:
        return 'Further Reading';
    }
  }
}

// ============================================================================
// Navigation Buttons
// ============================================================================

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons({
    required this.lessonId,
    required this.locale,
    required this.strings,
  });

  final String lessonId;
  final String locale;
  final CommonStrings strings;

  @override
  Widget build(BuildContext context) {
    final previousLesson = WisdomTraditionData.getPreviousLesson(lessonId);
    final nextLesson = WisdomTraditionData.getNextLesson(lessonId);

    return Row(
      children: [
        if (previousLesson != null)
          Expanded(
            child: _NavButton(
              label: _getPreviousLabel(locale),
              icon: Icons.arrow_back,
              isNext: false,
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => WisdomLessonScreen(
                      lessonId: previousLesson.id,
                      strings: strings,
                    ),
                  ),
                );
              },
            ),
          ),
        if (previousLesson != null && nextLesson != null)
          const SizedBox(width: 12),
        if (nextLesson != null)
          Expanded(
            child: _NavButton(
              label: _getNextLabel(locale),
              icon: Icons.arrow_forward,
              isNext: true,
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => WisdomLessonScreen(
                      lessonId: nextLesson.id,
                      strings: strings,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  String _getPreviousLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Anterior';
      case 'es':
        return 'Anterior';
      default:
        return 'Previous';
    }
  }

  String _getNextLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Següent';
      case 'es':
        return 'Siguiente';
      default:
        return 'Next';
    }
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    required this.isNext,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isNext;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: TarotTheme.softBlueGrey.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isNext) Icon(icon, size: 18, color: TarotTheme.deepNavy),
            if (!isNext) const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: TarotTheme.deepNavy,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (isNext) const SizedBox(width: 8),
            if (isNext) Icon(icon, size: 18, color: TarotTheme.deepNavy),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Floating Completion Button
// ============================================================================

class _FloatingCompletionButton extends StatelessWidget {
  const _FloatingCompletionButton({
    required this.isCompleted,
    required this.color,
    required this.locale,
    required this.onPressed,
  });

  final bool isCompleted;
  final Color color;
  final String locale;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isCompleted ? Colors.white : color,
        foregroundColor: isCompleted ? color : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isCompleted
              ? BorderSide(color: color, width: 2)
              : BorderSide.none,
        ),
        elevation: 8,
        shadowColor: color.withValues(alpha: 0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.circle_outlined,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            isCompleted
                ? _getCompletedLabel(locale)
                : _getMarkCompleteLabel(locale),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _getMarkCompleteLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Marcar com a Completada';
      case 'es':
        return 'Marcar como Completada';
      default:
        return 'Mark as Complete';
    }
  }

  String _getCompletedLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Completada';
      case 'es':
        return 'Completada';
      default:
        return 'Completed';
    }
  }
}
