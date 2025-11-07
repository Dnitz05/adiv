import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:smart_tarot/api/journal_api.dart';
import 'package:smart_tarot/models/journal_entry.dart';
import 'package:smart_tarot/models/journal_filters.dart';
import 'package:smart_tarot/widgets/archive_screen.dart';
import 'package:smart_tarot/widgets/journal/journal_entry_card.dart';
import 'package:smart_tarot/widgets/journal/journal_timeline_view.dart';

void main() {
  group('ArchiveScreen Widget Tests', () {
    late FakeJournalApiClient apiClient;

    setUp(() {
      apiClient = FakeJournalApiClient()
        ..queueTimelineResponse(
          JournalTimelineResponse(
            entries: [
              _createEntry('1', 'First Reading', JournalActivityType.tarotReading),
              _createEntry('2', 'Lunar Advice', JournalActivityType.lunarAdvice),
            ],
            hasMore: false,
            nextCursor: null,
          ),
        )
        ..queueStatsResponse(
          JournalStats(
            period: 'month',
            totalActivities: 2,
            totalsByType: {'tarot_reading': 1, 'lunar_advice': 1},
            totalsByPhase: {'full_moon': 1},
            generatedAt: DateTime.now(),
          ),
        )
        ..queueDaySummaryResponse(
          JournalDaySummary(
            date: DateTime.parse('2025-11-07'),
            entries: [],
            totalActivities: 0,
            totalsByType: {},
          ),
        );
    });

    testWidgets('shows empty state when userId is empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ArchiveScreen(userId: '', locale: 'en'),
        ),
      );

      expect(find.text('Sign in to view your journal history.'), findsOneWidget);
    });

    testWidgets('renders archive screen with content areas', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ArchiveScreen(
            userId: 'user-123',
            locale: 'en',
            apiClient: apiClient,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify main UI components are rendered
      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.text('Insights'), findsOneWidget); // Stats card header
      expect(find.text('Calendar'), findsOneWidget); // Calendar header
    }, skip: false);

    testWidgets('shows stats card with correct data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ArchiveScreen(
            userId: 'user-123',
            locale: 'en',
            apiClient: apiClient,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Stats card should show total
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('2'), findsWidgets);
    });

    testWidgets('opens filter panel when filter button pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ArchiveScreen(
            userId: 'user-123',
            locale: 'en',
            apiClient: apiClient,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap filter button
      final filterButton = find.byIcon(Icons.filter_list);
      expect(filterButton, findsOneWidget);

      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      // Filter panel should be visible
      expect(find.text('Filters'), findsOneWidget);
      expect(find.text('Activity Types'), findsOneWidget);
    });

    testWidgets('pull-to-refresh triggers refresh', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ArchiveScreen(
            userId: 'user-123',
            locale: 'en',
            apiClient: apiClient,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify RefreshIndicator exists and is interactive
      expect(find.byType(RefreshIndicator), findsOneWidget);

      // Note: Full pull-to-refresh testing requires more complex setup
      // This smoke test verifies the component exists
    }, skip: false);
  });
}

JournalEntry _createEntry(String id, String title, JournalActivityType type) {
  return JournalEntry(
    id: id,
    activityType: type,
    status: JournalActivityStatus.completed,
    timestamp: DateTime.parse('2025-11-07T12:00:00Z'),
    title: title,
    summary: 'Summary for $title',
  );
}

// Fake API Client with support for all endpoints
class FakeJournalApiClient extends JournalApiClient {
  FakeJournalApiClient() : super(httpClient: _DummyHttpClient());

  final List<JournalTimelineResponse> _timelineQueue = [];
  final List<JournalStats> _statsQueue = [];
  final List<JournalDaySummary> _daySummaryQueue = [];

  FakeJournalApiClient queueTimelineResponse(JournalTimelineResponse response) {
    _timelineQueue.add(response);
    return this;
  }

  FakeJournalApiClient queueStatsResponse(JournalStats stats) {
    _statsQueue.add(stats);
    return this;
  }

  FakeJournalApiClient queueDaySummaryResponse(JournalDaySummary summary) {
    _daySummaryQueue.add(summary);
    return this;
  }

  void replaceTimelineResponses(List<JournalTimelineResponse> responses) {
    _timelineQueue
      ..clear()
      ..addAll(responses);
  }

  @override
  Future<JournalTimelineResponse> fetchTimeline({
    required int limit,
    String? cursor,
    JournalFilters? filters,
    String? locale,
    String? userId,
  }) async {
    if (_timelineQueue.isEmpty) {
      return JournalTimelineResponse(entries: [], hasMore: false, nextCursor: null);
    }
    return _timelineQueue.removeAt(0);
  }

  @override
  Future<JournalStats> fetchStats({
    String period = 'month',
    String? locale,
    String? userId,
  }) async {
    if (_statsQueue.isEmpty) {
      return JournalStats(
        period: period,
        totalActivities: 0,
        totalsByType: {},
        totalsByPhase: {},
        generatedAt: DateTime.now(),
      );
    }
    return _statsQueue.removeAt(0);
  }

  @override
  Future<JournalDaySummary> fetchDaySummary({
    required String date,
    String? locale,
    String? userId,
  }) async {
    if (_daySummaryQueue.isEmpty) {
      return JournalDaySummary(
        date: DateTime.parse(date),
        entries: [],
        totalActivities: 0,
        totalsByType: {},
      );
    }
    return _daySummaryQueue.removeAt(0);
  }
}

class _DummyHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    throw UnimplementedError('This client should not perform HTTP calls.');
  }
}
