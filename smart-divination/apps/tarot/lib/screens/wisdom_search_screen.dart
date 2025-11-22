import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../data/wisdom_tradition_data.dart';
import '../models/wisdom_tradition_content.dart';
import '../theme/tarot_theme.dart';
import 'wisdom_lesson_screen.dart';

/// Search screen for Wisdom & Tradition lessons
class WisdomSearchScreen extends StatefulWidget {
  const WisdomSearchScreen({
    super.key,
    required this.strings,
  });

  final CommonStrings strings;

  @override
  State<WisdomSearchScreen> createState() => _WisdomSearchScreenState();
}

class _WisdomSearchScreenState extends State<WisdomSearchScreen> {
  final _searchController = TextEditingController();
  List<WisdomLesson> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    final locale = widget.strings.localeName;
    final lowerQuery = query.toLowerCase();

    final allLessons = WisdomTraditionData.lessons;
    final results = allLessons.where((lesson) {
      final title = lesson.getTitle(locale).toLowerCase();
      final subtitle = lesson.getSubtitle(locale).toLowerCase();
      final content = lesson.getContent(locale).toLowerCase();
      final keyPoints = lesson.getKeyPoints(locale).join(' ').toLowerCase();

      return title.contains(lowerQuery) ||
             subtitle.contains(lowerQuery) ||
             content.contains(lowerQuery) ||
             keyPoints.contains(lowerQuery);
    }).toList();

    setState(() {
      _searchResults = results;
      _isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.strings.localeName;

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
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _performSearch,
                style: const TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: _getSearchHint(locale),
                  hintStyle: const TextStyle(
                    color: TarotTheme.softBlueGrey,
                    fontSize: 16,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: TarotTheme.softBlueGrey,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: TarotTheme.softBlueGrey,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),

          // Results
          Expanded(
            child: _isSearching
                ? _searchResults.isEmpty
                    ? _buildEmptyState(locale)
                    : _buildResults(locale)
                : _buildInitialState(locale),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(String locale) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final lesson = _searchResults[index];
        final category = WisdomTraditionData.getCategoryById(lesson.categoryId);
        final color = category != null
            ? Color(int.parse('0xFF${category.color.substring(1)}'))
            : const Color(0xFFF59E0B);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _SearchResultCard(
            lesson: lesson,
            category: category,
            color: color,
            locale: locale,
            query: _searchController.text,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WisdomLessonScreen(
                    lessonId: lesson.id,
                    strings: widget.strings,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String locale) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: TarotTheme.softBlueGrey,
            ),
            const SizedBox(height: 16),
            Text(
              _getNoResultsMessage(locale),
              style: const TextStyle(
                color: TarotTheme.softBlueGrey,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState(String locale) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search,
              size: 64,
              color: TarotTheme.softBlueGrey,
            ),
            const SizedBox(height: 16),
            Text(
              _getInitialMessage(locale),
              style: const TextStyle(
                color: TarotTheme.softBlueGrey,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Cercar Lliçons';
      case 'es':
        return 'Buscar Lecciones';
      default:
        return 'Search Lessons';
    }
  }

  String _getSearchHint(String locale) {
    switch (locale) {
      case 'ca':
        return 'Cercar per títol, contingut o paraula clau...';
      case 'es':
        return 'Buscar por título, contenido o palabra clave...';
      default:
        return 'Search by title, content, or keyword...';
    }
  }

  String _getNoResultsMessage(String locale) {
    switch (locale) {
      case 'ca':
        return 'No s\'han trobat lliçons. Prova amb altres paraules clau.';
      case 'es':
        return 'No se encontraron lecciones. Prueba con otras palabras clave.';
      default:
        return 'No lessons found. Try different keywords.';
    }
  }

  String _getInitialMessage(String locale) {
    switch (locale) {
      case 'ca':
        return 'Escriu per cercar lliçons per títol, contingut o temes específics del tarot.';
      case 'es':
        return 'Escribe para buscar lecciones por título, contenido o temas específicos del tarot.';
      default:
        return 'Type to search lessons by title, content, or specific tarot topics.';
    }
  }
}

// ============================================================================
// Search Result Card
// ============================================================================

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({
    required this.lesson,
    required this.category,
    required this.color,
    required this.locale,
    required this.query,
    required this.onTap,
  });

  final WisdomLesson lesson;
  final WisdomTraditionCategory? category;
  final Color color;
  final String locale;
  final String query;
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
            color: color.withValues(alpha: 0.25),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category badge
            if (category != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category!.icon,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category!.getTitle(locale),
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

            // Lesson title and icon
            Row(
              children: [
                Text(
                  lesson.icon,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.getTitle(locale),
                        style: const TextStyle(
                          color: TarotTheme.deepNavy,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lesson.getSubtitle(locale),
                        style: const TextStyle(
                          color: TarotTheme.softBlueGrey,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Metadata row
            Row(
              children: [
                // Difficulty
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  '${lesson.estimatedMinutes} min',
                  style: const TextStyle(
                    color: TarotTheme.softBlueGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
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
