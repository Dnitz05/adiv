import 'package:flutter/foundation.dart';

import '../api/journal_api.dart';
import '../models/journal_entry.dart';
import '../models/journal_filters.dart';

class JournalController extends ChangeNotifier {
  JournalController({
    JournalApiClient? apiClient,
  }) : _apiClient = apiClient ?? const JournalApiClient();

  final JournalApiClient _apiClient;

  JournalFilters _filters = const JournalFilters();
  List<JournalEntry> _entries = const [];
  bool _isLoading = false;
  bool _hasMore = true;
  String? _cursor;

  JournalFilters get filters => _filters;
  List<JournalEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> loadInitial({
    required String userId,
    required String locale,
  }) async {
    _entries = [];
    _cursor = null;
    _hasMore = true;
    await loadMore(userId: userId, locale: locale, reset: true);
  }

  Future<void> loadMore({
    required String userId,
    required String locale,
    bool reset = false,
  }) async {
    if (_isLoading || (!_hasMore && !reset)) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.fetchTimeline(
        limit: 20,
        cursor: reset ? null : _cursor,
        filters: _filters,
        userId: userId,
        locale: locale,
      );

      if (reset) {
        _entries = response.entries;
      } else {
        _entries = [..._entries, ...response.entries];
      }
      _cursor = response.nextCursor;
      _hasMore = response.hasMore;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateFilters(JournalFilters filters) {
    _filters = filters;
    notifyListeners();
  }
}
