import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/journal_entry.dart';

class JournalCalendarView extends StatelessWidget {
  const JournalCalendarView({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.activityCounts,
    required this.onDaySelected,
    this.summary,
    this.isLoadingSummary = false,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;
  final Map<DateTime, int> activityCounts;
  final ValueChanged<DateTime> onDaySelected;
  final JournalDaySummary? summary;
  final bool isLoadingSummary;

  Map<DateTime, List<int>> get _events {
    final map = <DateTime, List<int>>{};
    activityCounts.forEach((date, count) {
      map[date] = List<int>.filled(count, 0);
    });
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final events = _events;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calendar',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  _formatDisplayDate(selectedDay),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            TableCalendar<int>(
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: focusedDay,
              selectedDayPredicate: (day) => isSameDay(day, selectedDay),
              eventLoader: (day) => events[_normalize(day)] ?? const [],
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (selected, focused) {
                onDaySelected(_normalize(selected));
              },
              calendarStyle: const CalendarStyle(
                markersMaxCount: 4,
                markerDecoration: BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (isLoadingSummary)
              const LinearProgressIndicator()
            else
              _SummarySection(summary: summary),
          ],
        ),
      ),
    );
  }

  static DateTime _normalize(DateTime day) =>
      DateTime.utc(day.year, day.month, day.day);

  String _formatDisplayDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({this.summary});

  final JournalDaySummary? summary;

  @override
  Widget build(BuildContext context) {
    if (summary == null) {
      return Text(
        'Select a date to view details.',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${summary!.totalActivities} activities',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: summary!.totalsByType.entries
              .map(
                (entry) => Chip(
                  label: Text('${entry.key}: ${entry.value}'),
                  visualDensity: VisualDensity.compact,
                ),
              )
              .toList(),
        ),
        if (summary!.lunar?.guidance != null) ...[
          const SizedBox(height: 8),
          Text(
            summary!.lunar!.guidance!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
