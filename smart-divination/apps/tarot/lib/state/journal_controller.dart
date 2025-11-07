import 'package:flutter/foundation.dart';

import '../api/journal_api.dart';
import '../models/journal_entry.dart';
import '../models/journal_filters.dart';

class JournalController extends ChangeNotifier {
  JournalController({
    JournalApiClient? apiClient,
  }) : _apiClient = apiClient ?? JournalApiClient();

  final JournalApiClient _apiClient;

  JournalFilters _filters = const JournalFilters();
  List<JournalEntry> _entries = const [];
  bool _isLoading = false;
  bool _hasMore = true;
  String? _cursor;
  String? _userId;
  String? _locale;

  JournalFilters get filters => _filters;
  List<JournalEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> loadInitial({
    required String userId,
    required String locale,
  }) async {
    if (userId.isEmpty) {
      _entries = const [];
      _cursor = null;
      _hasMore = false;
      notifyListeners();
      return;
    }
    _userId = userId;
    _locale = locale;
    _entries = [];
    _cursor = null;
    _hasMore = true;
    await loadMore(reset: true);
  }

  Future<void> loadMore({
    bool reset = false,
  }) async {
    if (_isLoading || (!_hasMore && !reset)) {
      return;
    }

    final userId = _userId;
    final locale = _locale;
    if (userId == null || locale == null || userId.isEmpty) {
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

  Future<void> refresh() async {
    if (_userId == null || _locale == null) {
      return;
    }
    await loadInitial(userId: _userId!, locale: _locale!);
  }

  Future<void> updateFilters(JournalFilters filters) async {
    _filters = filters;
    notifyListeners();
    if (_userId != null && _locale != null) {
      await loadInitial(userId: _userId!, locale: _locale!);
    }
  }
}
