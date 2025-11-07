import 'package:flutter/material.dart';

import '../../models/journal_entry.dart';
import '../../models/journal_filters.dart';

class JournalFilterPanel extends StatefulWidget {
  const JournalFilterPanel({
    super.key,
    required this.initialFilters,
  });

  final JournalFilters initialFilters;

  static Future<JournalFilters?> show(
    BuildContext context, {
    required JournalFilters initialFilters,
  }) {
    return showModalBottomSheet<JournalFilters>(
      context: context,
      isScrollControlled: true,
      builder: (_) => JournalFilterPanel(initialFilters: initialFilters),
    );
  }

  @override
  State<JournalFilterPanel> createState() => _JournalFilterPanelState();
}

class _JournalFilterPanelState extends State<JournalFilterPanel> {
  late Set<JournalActivityType> _selectedTypes;
  late String _phase;
  late JournalFilterPeriod _period;
  late TextEditingController _searchController;

  static const _phases = <String>[
    'any',
    'new_moon',
    'waxing_crescent',
    'first_quarter',
    'waxing_gibbous',
    'full_moon',
    'waning_gibbous',
    'last_quarter',
    'waning_crescent',
  ];

  @override
  void initState() {
    super.initState();
    _selectedTypes = {...widget.initialFilters.types};
    _phase = widget.initialFilters.phase;
    _period = widget.initialFilters.period;
    _searchController = TextEditingController(text: widget.initialFilters.searchTerm);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeChips = JournalActivityType.values
        .map(
          (type) => FilterChip(
            label: Text(type.value.replaceAll('_', ' ')),
            selected: _selectedTypes.contains(type),
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _selectedTypes.add(type);
                } else {
                  _selectedTypes.remove(type);
                }
              });
            },
          ),
        )
        .toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: theme.textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 16),
              Text('Activity Types', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 4, children: typeChips),
              const SizedBox(height: 16),
              Text('Lunar Phase', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                child: DropdownButton<String>(
                  value: _phase,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  items: _phases
                      .map(
                        (phase) => DropdownMenuItem(
                          value: phase,
                          child: Text(
                            phase == 'any' ? 'Any phase' : phase.replaceAll('_', ' '),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _phase = value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text('Period', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: JournalFilterPeriod.values
                    .map(
                      (period) => ChoiceChip(
                        label: Text(_labelForPeriod(period)),
                        selected: _period == period,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _period = period;
                            });
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Apply filters'),
                  onPressed: () {
                    Navigator.of(context).pop(
                      JournalFilters(
                        types: _selectedTypes,
                        phase: _phase,
                        period: _period,
                        searchTerm: _searchController.text.trim().isEmpty
                            ? null
                            : _searchController.text.trim(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _labelForPeriod(JournalFilterPeriod period) {
    switch (period) {
      case JournalFilterPeriod.today:
        return 'Today';
      case JournalFilterPeriod.week:
        return 'This week';
      case JournalFilterPeriod.month:
        return 'This month';
      case JournalFilterPeriod.all:
        return 'All time';
    }
  }
}
