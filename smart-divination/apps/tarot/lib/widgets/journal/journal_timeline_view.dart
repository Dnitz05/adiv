import 'package:flutter/material.dart';

import '../../models/journal_entry.dart';
import 'journal_entry_card.dart';

class JournalTimelineView extends StatelessWidget {
  const JournalTimelineView({
    super.key,
    required this.entries,
    required this.isLoading,
    required this.hasMore,
    required this.onLoadMore,
  });

  final List<JournalEntry> entries;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final totalItems = entries.length + ((hasMore || isLoading) ? 1 : 0);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= entries.length) {
            _scheduleLoadMore();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        'No more entries',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
              ),
            );
          }

          final entry = entries[index];
          return JournalEntryCard(entry: entry);
        },
        childCount: totalItems,
      ),
    );
  }

  void _scheduleLoadMore() {
    if (!hasMore || isLoading) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => onLoadMore());
  }
}
