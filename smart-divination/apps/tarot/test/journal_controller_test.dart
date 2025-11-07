import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:smart_tarot/api/journal_api.dart';
import 'package:smart_tarot/models/journal_entry.dart';
import 'package:smart_tarot/models/journal_filters.dart';
import 'package:smart_tarot/state/journal_controller.dart';

void main() {
  group('JournalController', () {
    late FakeJournalApiClient apiClient;

    setUp(() {
      apiClient = FakeJournalApiClient()
        ..queueTimelineResponse(
          JournalTimelineResponse(
            entries: [_entry('entry-1')],
            hasMore: true,
            nextCursor: 'cursor-1',
          ),
        )
        ..queueTimelineResponse(
          JournalTimelineResponse(
            entries: [_entry('entry-2')],
            hasMore: false,
            nextCursor: null,
          ),
        );
    });

    test('loadInitial loads first page and loadMore appends results', () async {
      final controller = JournalController(apiClient: apiClient);

      await controller.loadInitial(userId: 'user-123', locale: 'en');
      expect(controller.entries, hasLength(1));
      expect(controller.entries.first.id, 'entry-1');
      expect(controller.hasMore, isTrue);

      await controller.loadMore();
      expect(controller.entries, hasLength(2));
      expect(controller.entries[1].id, 'entry-2');
      expect(controller.hasMore, isFalse);
    });

    test('updateFilters reloads entries when user is initialized', () async {
      final controller = JournalController(apiClient: apiClient);
      await controller.loadInitial(userId: 'user-123', locale: 'en');
      expect(controller.entries.first.id, 'entry-1');

      apiClient.replaceTimelineResponses([
        JournalTimelineResponse(
          entries: [_entry('entry-filtered')],
          hasMore: false,
          nextCursor: null,
        ),
      ]);

      await controller.updateFilters(
        const JournalFilters(searchTerm: 'moon'),
      );

      expect(controller.entries, hasLength(1));
      expect(controller.entries.first.id, 'entry-filtered');
    });

    test('loadMore before initialization does nothing', () async {
      final controller = JournalController(apiClient: apiClient);
      await controller.loadMore();
      expect(controller.entries, isEmpty);
      expect(controller.hasMore, isTrue);
    });
  });
}

JournalEntry _entry(String id) => JournalEntry(
      id: id,
      activityType: JournalActivityType.note,
      status: JournalActivityStatus.completed,
      timestamp: DateTime.parse('2025-11-07T12:00:00Z'),
      title: 'Entry $id',
      summary: 'Summary $id',
    );

class FakeJournalApiClient extends JournalApiClient {
  FakeJournalApiClient() : super(httpClient: _DummyHttpClient());

  final List<JournalTimelineResponse> _timelineQueue = [];

  FakeJournalApiClient queueTimelineResponse(JournalTimelineResponse response) {
    _timelineQueue.add(response);
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
      throw StateError('No timeline response queued');
    }
    return _timelineQueue.removeAt(0);
  }
}

class _DummyHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    throw UnimplementedError('This client should not perform HTTP calls.');
  }
}
