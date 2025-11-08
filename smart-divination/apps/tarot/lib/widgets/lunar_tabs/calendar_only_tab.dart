import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../../theme/tarot_theme.dart';
import '../../state/lunar_cycle_controller.dart';
import '../lunar_card_helpers.dart';

class CalendarOnlyTab extends StatefulWidget {
  const CalendarOnlyTab({
    super.key,
    required this.controller,
    required this.strings,
  });

  final LunarCycleController controller;
  final CommonStrings strings;

  @override
  State<CalendarOnlyTab> createState() => _CalendarOnlyTabState();
}

class _CalendarOnlyTabState extends State<CalendarOnlyTab> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMonthNavigation(),
          const SizedBox(height: 16),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    final monthNames = _getMonthNames();
    return LunarCardHelpers.buildWhiteCard(
      context: context,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: TarotTheme.deepNavy),
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
              });
            },
          ),
          Text(
            '${monthNames[_currentMonth.month - 1]} ${_currentMonth.year}',
            style: LunarCardHelpers.cardTitleStyle.copyWith(fontSize: 18),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: TarotTheme.deepNavy),
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday;

    // Day headers
    final dayNames = _getDayNames();
    final dayHeaders = dayNames.map((name) {
      return Expanded(
        child: Center(
          child: Text(
            name,
            style: LunarCardHelpers.cardSmallStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }).toList();

    // Calendar days
    final List<Widget> dayWidgets = [];

    // Add empty cells for days before month starts
    for (int i = 1; i < firstWeekday; i++) {
      dayWidgets.add(const Expanded(child: SizedBox()));
    }

    // Add days of month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isToday = date.year == DateTime.now().year &&
          date.month == DateTime.now().month &&
          date.day == DateTime.now().day;

      dayWidgets.add(
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isToday
                    ? TarotTheme.brightBlue10
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isToday
                    ? Border.all(color: TarotTheme.brightBlue, width: 2)
                    : Border.all(color: TarotTheme.brightBlue20, width: 1),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.toString(),
                      style: TextStyle(
                        color: TarotTheme.deepNavy,
                        fontSize: 14,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getMoonPhaseEmoji(date),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Build grid rows
    final List<Widget> rows = [Row(children: dayHeaders)];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      rows.add(
        Row(
          children: dayWidgets.sublist(
            i,
            i + 7 > dayWidgets.length ? dayWidgets.length : i + 7,
          ),
        ),
      );
    }

    return LunarCardHelpers.buildWhiteCard(
      context: context,
      padding: const EdgeInsets.all(12),
      child: Column(children: rows),
    );
  }

  String _getMoonPhaseEmoji(DateTime date) {
    // Simplified moon phase calculation (approximate)
    final daysSinceNewMoon = (date.millisecondsSinceEpoch / 86400000) % 29.53;
    if (daysSinceNewMoon < 3.7) return '🌑';
    if (daysSinceNewMoon < 7.4) return '🌒';
    if (daysSinceNewMoon < 11.1) return '🌓';
    if (daysSinceNewMoon < 14.8) return '🌔';
    if (daysSinceNewMoon < 18.4) return '🌕';
    if (daysSinceNewMoon < 22.1) return '🌖';
    if (daysSinceNewMoon < 25.8) return '🌗';
    return '🌘';
  }

  List<String> _getMonthNames() {
    final locale = widget.strings.localeName;
    final months = {
      'en': ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
      'es': ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
      'ca': ['Gener', 'Febrer', 'Març', 'Abril', 'Maig', 'Juny', 'Juliol', 'Agost', 'Setembre', 'Octubre', 'Novembre', 'Desembre'],
    };
    return months[locale] ?? months['en']!;
  }

  List<String> _getDayNames() {
    final locale = widget.strings.localeName;
    final days = {
      'en': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      'es': ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
      'ca': ['Dl', 'Dt', 'Dc', 'Dj', 'Dv', 'Ds', 'Dg'],
    };
    return days[locale] ?? days['en']!;
  }
}
