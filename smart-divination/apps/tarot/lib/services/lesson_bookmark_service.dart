import 'package:shared_preferences/shared_preferences.dart';

/// Service for bookmarking favorite lessons
///
/// Allows users to save lessons for quick access
/// using SharedPreferences for local persistence.
class LessonBookmarkService {
  static const String _keyPrefix = 'lesson_bookmarks';

  /// Singleton instance
  static final LessonBookmarkService _instance =
      LessonBookmarkService._internal();
  factory LessonBookmarkService() => _instance;
  LessonBookmarkService._internal();

  SharedPreferences? _prefs;

  /// Initialize the service (call once at app startup)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Add a lesson to bookmarks
  Future<bool> addBookmark(String lessonId) async {
    if (_prefs == null) await init();

    final bookmarks = await getBookmarks();
    if (!bookmarks.contains(lessonId)) {
      bookmarks.add(lessonId);
      return await _prefs!.setStringList(_keyPrefix, bookmarks);
    }

    return true; // Already bookmarked
  }

  /// Remove a lesson from bookmarks
  Future<bool> removeBookmark(String lessonId) async {
    if (_prefs == null) await init();

    final bookmarks = await getBookmarks();
    if (bookmarks.contains(lessonId)) {
      bookmarks.remove(lessonId);
      return await _prefs!.setStringList(_keyPrefix, bookmarks);
    }

    return true; // Already not bookmarked
  }

  /// Check if a lesson is bookmarked
  Future<bool> isBookmarked(String lessonId) async {
    final bookmarks = await getBookmarks();
    return bookmarks.contains(lessonId);
  }

  /// Get all bookmarked lesson IDs
  Future<List<String>> getBookmarks() async {
    if (_prefs == null) await init();
    return _prefs!.getStringList(_keyPrefix) ?? [];
  }

  /// Get bookmark count
  Future<int> getBookmarkCount() async {
    final bookmarks = await getBookmarks();
    return bookmarks.length;
  }

  /// Toggle bookmark status
  Future<bool> toggleBookmark(String lessonId) async {
    final isCurrentlyBookmarked = await isBookmarked(lessonId);

    if (isCurrentlyBookmarked) {
      return await removeBookmark(lessonId);
    } else {
      return await addBookmark(lessonId);
    }
  }

  /// Clear all bookmarks
  Future<bool> clearAllBookmarks() async {
    if (_prefs == null) await init();
    return await _prefs!.remove(_keyPrefix);
  }
}
