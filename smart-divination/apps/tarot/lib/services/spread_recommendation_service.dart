import '../models/spread_basic_info.dart';
import '../data/spread_learning_categories.dart';
import 'learn_progress_service.dart';

/// Service for recommending spreads based on various criteria
///
/// Provides intelligent spread recommendations including:
/// - Similar spreads (based on card count, category, complexity)
/// - Personalized recommendations (based on learning progress)
/// - Next logical step in learning path
class SpreadRecommendationService {
  final _progressService = LearnProgressService();

  /// Find similar spreads to the given spread
  ///
  /// Similarity criteria (in order of priority):
  /// 1. Same category
  /// 2. Similar card count (±2 cards)
  /// 3. Same or adjacent complexity level
  /// 4. Exclude already completed spreads (if excludeCompleted = true)
  Future<List<SpreadBasicInfo>> findSimilarSpreads({
    required String spreadId,
    int maxResults = 3,
    bool excludeCompleted = false,
  }) async {
    final currentSpread = getSpreadBasicInfoById(spreadId);
    if (currentSpread == null) return [];

    final currentCategory = getCategoryForSpread(spreadId);
    if (currentCategory == null) return [];

    // Get all spreads in the same category
    final categorySpreads = getSpreadsForIds(currentCategory.spreadIds)
        .where((spread) => spread.id != spreadId) // Exclude current
        .toList();

    // Get completed spreads if we need to exclude them
    Set<String> completedIds = {};
    if (excludeCompleted) {
      final completed =
          await _progressService.getCompletedLessons('spreads_journey');
      completedIds = completed.toSet();
    }

    // Score each spread based on similarity
    final scoredSpreads = categorySpreads.map((spread) {
      if (excludeCompleted && completedIds.contains(spread.id)) {
        return MapEntry(spread, -1); // Exclude completed
      }

      int score = 0;

      // Card count similarity (max 100 points)
      final cardDiff = (spread.cardCount - currentSpread.cardCount).abs();
      if (cardDiff == 0) {
        score += 100;
      } else if (cardDiff == 1) {
        score += 70;
      } else if (cardDiff == 2) {
        score += 40;
      } else if (cardDiff <= 3) {
        score += 20;
      }

      // Complexity similarity (max 50 points)
      if (spread.complexity == currentSpread.complexity) {
        score += 50;
      } else if (_isAdjacentComplexity(
          spread.complexity, currentSpread.complexity)) {
        score += 25;
      }

      return MapEntry(spread, score);
    }).toList();

    // Sort by score (descending) and take top results
    scoredSpreads.sort((a, b) => b.value.compareTo(a.value));

    return scoredSpreads
        .where((entry) => entry.value > 0) // Exclude negative scores
        .take(maxResults)
        .map((entry) => entry.key)
        .toList();
  }

  /// Find recommended next spreads for the user
  ///
  /// Recommendations based on:
  /// 1. Incomplete spreads in most-visited category
  /// 2. Appropriate complexity level (slightly progressive)
  /// 3. Diverse card counts (avoid recommending all 3-card spreads)
  Future<List<SpreadBasicInfo>> getPersonalizedRecommendations({
    int maxResults = 3,
  }) async {
    final completedLessons =
        await _progressService.getCompletedLessons('spreads_journey');
    final completedSet = completedLessons.toSet();

    // Find the category with most completions (user's favorite)
    String? favoriteCategory;
    int maxCompletions = 0;

    for (final category in SPREAD_LEARNING_CATEGORIES) {
      final completedInCategory = category.spreadIds
          .where((id) => completedSet.contains(id))
          .length;

      if (completedInCategory > maxCompletions) {
        maxCompletions = completedInCategory;
        favoriteCategory = category.id;
      }
    }

    // Get all incomplete spreads
    final allSpreads = getAllSpreadIds()
        .map((id) => getSpreadBasicInfoById(id))
        .whereType<SpreadBasicInfo>()
        .where((spread) => !completedSet.contains(spread.id))
        .toList();

    if (allSpreads.isEmpty) {
      return []; // User completed everything!
    }

    // Score each spread
    final scoredSpreads = allSpreads.map((spread) {
      int score = 0;

      // Prioritize favorite category (50 points)
      if (favoriteCategory != null) {
        final spreadCategory = getCategoryForSpread(spread.id);
        if (spreadCategory?.id == favoriteCategory) {
          score += 50;
        }
      }

      // Prioritize beginner spreads for users with <10% completion (30 points)
      final completionRate = completedLessons.length / 101;
      if (completionRate < 0.1 && spread.complexity == 'beginner') {
        score += 30;
      }

      // Prioritize intermediate spreads for users with 10-50% completion (30 points)
      if (completionRate >= 0.1 &&
          completionRate < 0.5 &&
          spread.complexity == 'intermediate') {
        score += 30;
      }

      // Prioritize advanced spreads for users with >50% completion (30 points)
      if (completionRate >= 0.5 && spread.complexity == 'advanced') {
        score += 30;
      }

      // Prefer spreads with 3-7 cards (more practical) (20 points)
      if (spread.cardCount >= 3 && spread.cardCount <= 7) {
        score += 20;
      }

      // Add some randomness to avoid always showing the same spreads
      score += (spread.id.hashCode % 10);

      return MapEntry(spread, score);
    }).toList();

    // Sort by score and take top results
    scoredSpreads.sort((a, b) => b.value.compareTo(a.value));

    // Ensure diversity in card counts
    final results = <SpreadBasicInfo>[];
    final usedCardCounts = <int>{};

    for (final entry in scoredSpreads) {
      if (results.length >= maxResults) break;

      // Prefer diverse card counts
      if (usedCardCounts.contains(entry.key.cardCount) &&
          results.length < maxResults - 1) {
        continue; // Skip if we already have this card count
      }

      results.add(entry.key);
      usedCardCounts.add(entry.key.cardCount);
    }

    // Fill remaining slots if we skipped too many
    if (results.length < maxResults) {
      for (final entry in scoredSpreads) {
        if (results.length >= maxResults) break;
        if (!results.contains(entry.key)) {
          results.add(entry.key);
        }
      }
    }

    return results;
  }

  /// Find the next recommended spread in a learning path
  ///
  /// Returns the first incomplete spread in the same category
  Future<SpreadBasicInfo?> getNextInCategory(String categoryId) async {
    final category = getCategoryById(categoryId);
    if (category == null) return null;

    final completedLessons =
        await _progressService.getCompletedLessons('spreads_journey');
    final completedSet = completedLessons.toSet();

    // Find first incomplete spread in category
    for (final spreadId in category.spreadIds) {
      if (!completedSet.contains(spreadId)) {
        return getSpreadBasicInfoById(spreadId);
      }
    }

    return null; // All completed!
  }

  /// Check if two complexity levels are adjacent
  bool _isAdjacentComplexity(String complexity1, String complexity2) {
    const levels = ['beginner', 'simple', 'intermediate', 'moderate', 'advanced', 'complex'];

    final index1 = levels.indexOf(_normalizeComplexity(complexity1));
    final index2 = levels.indexOf(_normalizeComplexity(complexity2));

    if (index1 == -1 || index2 == -1) return false;

    return (index1 - index2).abs() == 1;
  }

  /// Normalize complexity names to standard values
  String _normalizeComplexity(String complexity) {
    switch (complexity.toLowerCase()) {
      case 'simple':
        return 'beginner';
      case 'moderate':
        return 'intermediate';
      case 'complex':
        return 'advanced';
      default:
        return complexity.toLowerCase();
    }
  }
}
