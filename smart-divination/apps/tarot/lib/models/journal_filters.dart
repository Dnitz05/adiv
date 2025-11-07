import 'package:equatable/equatable.dart';

import 'journal_entry.dart';

class JournalFilters extends Equatable {
  const JournalFilters({
    this.types = const <JournalActivityType>{},
    this.phase = 'any',
    this.period = JournalFilterPeriod.today,
    this.searchTerm,
  });

  final Set<JournalActivityType> types;
  final String phase;
  final JournalFilterPeriod period;
  final String? searchTerm;

  JournalFilters copyWith({
    Set<JournalActivityType>? types,
    String? phase,
    JournalFilterPeriod? period,
    String? searchTerm,
  }) {
    return JournalFilters(
      types: types ?? this.types,
      phase: phase ?? this.phase,
      period: period ?? this.period,
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }

  @override
  List<Object?> get props => [types, phase, period, searchTerm];
}

enum JournalFilterPeriod {
  today,
  week,
  month,
  all,
}
