import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/journal_api.dart';
import '../models/journal_entry.dart';
import '../state/journal_controller.dart';
import 'journal/journal_calendar_view.dart';
import 'journal/journal_filter_panel.dart';
import 'journal/journal_stats_card.dart';
import 'journal/journal_timeline_view.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({
    super.key,
    required this.userId,
    this.locale,
  });

  final String userId;
  final String? locale;

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  late final JournalController _controller;
  final JournalApiClient _apiClient = JournalApiClient();
  JournalStats? _stats;
  bool _loadingStats = false;
  JournalDaySummary? _selectedDaySummary;
  bool _loadingDaySummary = false;
  DateTime _selectedDate = _normalizeDate(DateTime.now());

  @override
  void initState() {
    super.initState();
    _controller = JournalController(apiClient: _apiClient);
    if (widget.userId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
    }
  }

  @override
  void didUpdateWidget(covariant ArchiveScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId && widget.userId.isNotEmpty) {
      _initializeData();
    }
  }

  Future<void> _initializeData() async {
    final locale = widget.locale ?? 'en';
    await _controller.loadInitial(userId: widget.userId, locale: locale);
    await Future.wait([
      _fetchStats(),
      _fetchDaySummary(_selectedDate),
    ]);
  }

  Future<void> _fetchStats() async {
    if (widget.userId.isEmpty) return;
    setState(() => _loadingStats = true);
    try {
      final stats = await _apiClient.fetchStats(
        userId: widget.userId,
        locale: widget.locale,
      );
      setState(() => _stats = stats);
    } finally {
      if (mounted) {
        setState(() => _loadingStats = false);
      }
    }
  }

  Future<void> _fetchDaySummary(DateTime date) async {
    if (widget.userId.isEmpty) return;
    final formatted = _formatDate(date);
    setState(() {
      _selectedDate = date;
      _loadingDaySummary = true;
    });
    try {
      final summary = await _apiClient.fetchDaySummary(
        date: formatted,
        userId: widget.userId,
        locale: widget.locale,
      );
      setState(() => _selectedDaySummary = summary);
    } finally {
      if (mounted) {
        setState(() => _loadingDaySummary = false);
      }
    }
  }

  Future<void> _openFilters() async {
    final filters = await JournalFilterPanel.show(
      context,
      initialFilters: _controller.filters,
    );
    if (filters != null) {
      await _controller.updateFilters(filters);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Archive')),
        body: const Center(
          child: Text('Sign in to view your journal history.'),
        ),
      );
    }

    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Archive'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _openFilters,
            ),
          ],
        ),
        body: Consumer<JournalController>(
          builder: (context, controller, _) {
            if (controller.entries.isEmpty && controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () => _controller.refresh(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: JournalStatsCard(
                      stats: _stats,
                      isLoading: _loadingStats,
                      onRefresh: _fetchStats,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: JournalCalendarView(
                      focusedDay: _selectedDate,
                      selectedDay: _selectedDate,
                      activityCounts: _buildActivityCounts(controller.entries),
                      onDaySelected: (day) => _fetchDaySummary(day),
                      summary: _selectedDaySummary,
                      isLoadingSummary: _loadingDaySummary,
                    ),
                  ),
                  if (controller.entries.isEmpty && !controller.isLoading)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No entries yet.\nStart a reading or add a note!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  else
                    JournalTimelineView(
                      entries: controller.entries,
                      isLoading: controller.isLoading,
                      hasMore: controller.hasMore,
                      onLoadMore: () => _controller.loadMore(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Map<DateTime, int> _buildActivityCounts(List<JournalEntry> entries) {
    final map = <DateTime, int>{};
    for (final entry in entries) {
      final day = _normalizeDate(entry.timestamp);
      map[day] = (map[day] ?? 0) + 1;
    }
    return map;
  }

  static DateTime _normalizeDate(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
