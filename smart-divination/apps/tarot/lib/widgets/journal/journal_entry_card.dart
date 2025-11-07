import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/journal_entry.dart';

class JournalEntryCard extends StatelessWidget {
  const JournalEntryCard({
    super.key,
    required this.entry,
    this.onTap,
  });

  final JournalEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timestamp = DateFormat('MMM d · HH:mm').format(entry.timestamp.toLocal());
    final icon = _iconForType(entry.activityType);
    final color = _colorForType(entry.activityType, theme);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.15),
                foregroundColor: color,
                radius: 24,
                child: Icon(icon),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title ?? entry.activityType.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    if (entry.summary?.isNotEmpty == true)
                      Text(
                        entry.summary!,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            _labelForType(entry.activityType),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          side: BorderSide(color: color.withValues(alpha: 0.4)),
                          backgroundColor: color.withValues(alpha: 0.08),
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.access_time, size: 16, color: theme.hintColor),
                        const SizedBox(width: 4),
                        Text(
                          timestamp,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForType(JournalActivityType type) {
    switch (type) {
      case JournalActivityType.tarotReading:
        return Icons.auto_awesome;
      case JournalActivityType.ichingCast:
        return Icons.hexagon_outlined;
      case JournalActivityType.runeCast:
        return Icons.splitscreen;
      case JournalActivityType.chat:
        return Icons.chat_bubble_outline;
      case JournalActivityType.lunarAdvice:
        return Icons.nightlight_round;
      case JournalActivityType.ritual:
        return Icons.brightness_5_outlined;
      case JournalActivityType.meditation:
        return Icons.self_improvement;
      case JournalActivityType.note:
        return Icons.edit_note;
      case JournalActivityType.reminder:
        return Icons.alarm;
      case JournalActivityType.insight:
        return Icons.data_usage;
      case JournalActivityType.custom:
        return Icons.bookmark_border;
    }
  }

  Color _colorForType(JournalActivityType type, ThemeData theme) {
    switch (type) {
      case JournalActivityType.tarotReading:
        return theme.colorScheme.primary;
      case JournalActivityType.ichingCast:
        return Colors.deepOrange;
      case JournalActivityType.runeCast:
        return Colors.teal;
      case JournalActivityType.chat:
        return Colors.blueAccent;
      case JournalActivityType.lunarAdvice:
        return Colors.indigo;
      case JournalActivityType.ritual:
        return Colors.pinkAccent;
      case JournalActivityType.meditation:
        return Colors.green;
      case JournalActivityType.note:
        return Colors.amber;
      case JournalActivityType.reminder:
        return Colors.deepPurple;
      case JournalActivityType.insight:
        return Colors.cyan;
      case JournalActivityType.custom:
        return theme.colorScheme.secondary;
    }
  }

  String _labelForType(JournalActivityType type) {
    final label = type.value.replaceAll('_', ' ');
    return '${label[0].toUpperCase()}${label.substring(1)}';
  }
}
