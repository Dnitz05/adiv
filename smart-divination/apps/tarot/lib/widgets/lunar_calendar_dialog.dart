import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:common/l10n/common_strings.dart';

import '../theme/tarot_theme.dart';
import '../state/lunar_cycle_controller.dart';
import '../models/lunar_day.dart';

class LunarCalendarDialog extends StatefulWidget {
  const LunarCalendarDialog({
    super.key,
    required this.controller,
    required this.strings,
  });

  final LunarCycleController controller;
  final CommonStrings strings;

  @override
  State<LunarCalendarDialog> createState() => _LunarCalendarDialogState();
}

class _LunarCalendarDialogState extends State<LunarCalendarDialog> {
  late DateTime _selectedMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TarotTheme.cosmicPurple.withValues(alpha: 0.95),
              TarotTheme.cosmicBlue.withValues(alpha: 0.95),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(theme),
            _buildMonthSelector(theme),
            Expanded(
              child: _buildCalendar(theme),
            ),
            _buildCloseButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
            ),
            child: const Icon(
              Icons.nightlight_round,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getCalendarTitle(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getCalendarSubtitle(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(ThemeData theme) {
    final monthName = DateFormat.yMMMM(widget.strings.localeName).format(_selectedMonth);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month - 1,
                );
              });
            },
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          Text(
            monthName,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month + 1,
                );
              });
            },
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildWeekdayHeaders(theme),
          const SizedBox(height: 8),
          Expanded(
            child: _buildDaysGrid(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders(ThemeData theme) {
    final weekdays = _getWeekdayNames();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDaysGrid(ThemeData theme) {
    final firstDayOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDayOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // Get the weekday of the first day (1 = Monday, 7 = Sunday)
    int firstWeekday = firstDayOfMonth.weekday;
    // Adjust to start on Monday (0 = Monday, 6 = Sunday)
    final startOffset = firstWeekday - 1;

    final totalCells = ((daysInMonth + startOffset) / 7).ceil() * 7;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNumber = index - startOffset + 1;

        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final date = DateTime(_selectedMonth.year, _selectedMonth.month, dayNumber);
        final isToday = _isSameDay(date, DateTime.now());
        final isSelected = _isSameDay(date, _selectedDate);

        return _buildDayCell(theme, date, dayNumber, isToday, isSelected);
      },
    );
  }

  Widget _buildDayCell(ThemeData theme, DateTime date, int dayNumber, bool isToday, bool isSelected) {
    // Calculate moon phase for this day (0 = new moon, 0.5 = full moon)
    final moonPhase = _calculateMoonPhase(date);
    final phaseIcon = _getMoonPhaseIcon(moonPhase);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Colors.white.withValues(alpha: 0.3)
              : isToday
                  ? Colors.white.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: isToday
                ? Colors.white.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.1),
            width: isToday ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$dayNumber',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 2),
            Icon(
              phaseIcon,
              size: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FilledButton(
        onPressed: () => Navigator.of(context).pop(),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: TarotTheme.cosmicPurple,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          _getCloseButtonText(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // Helper methods
  String _getCalendarTitle() {
    switch (widget.strings.localeName) {
      case 'ca':
        return 'Calendari Lunar';
      case 'es':
        return 'Calendario Lunar';
      default:
        return 'Lunar Calendar';
    }
  }

  String _getCalendarSubtitle() {
    switch (widget.strings.localeName) {
      case 'ca':
        return 'Fases de la lluna mensuals';
      case 'es':
        return 'Fases lunares mensuales';
      default:
        return 'Monthly moon phases';
    }
  }

  String _getCloseButtonText() {
    switch (widget.strings.localeName) {
      case 'ca':
        return 'Tancar';
      case 'es':
        return 'Cerrar';
      default:
        return 'Close';
    }
  }

  List<String> _getWeekdayNames() {
    switch (widget.strings.localeName) {
      case 'ca':
        return ['Dl', 'Dt', 'Dc', 'Dj', 'Dv', 'Ds', 'Dg'];
      case 'es':
        return ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sá', 'Do'];
      default:
        return ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Calculate moon phase (simplified algorithm)
  // Returns a value between 0 and 1 (0 = new moon, 0.5 = full moon)
  double _calculateMoonPhase(DateTime date) {
    // Reference new moon: January 6, 2000
    final referenceNewMoon = DateTime(2000, 1, 6, 18, 14);
    final daysSinceReference = date.difference(referenceNewMoon).inDays;

    // Lunar cycle is approximately 29.53 days
    const lunarCycle = 29.53;
    final phase = (daysSinceReference % lunarCycle) / lunarCycle;

    return phase;
  }

  IconData _getMoonPhaseIcon(double phase) {
    if (phase < 0.03 || phase > 0.97) {
      return Icons.circle_outlined; // New moon
    } else if (phase < 0.22) {
      return Icons.brightness_2; // Waxing crescent
    } else if (phase < 0.28) {
      return Icons.brightness_3; // First quarter
    } else if (phase < 0.47) {
      return Icons.brightness_4; // Waxing gibbous
    } else if (phase < 0.53) {
      return Icons.circle; // Full moon
    } else if (phase < 0.72) {
      return Icons.brightness_5; // Waning gibbous
    } else if (phase < 0.78) {
      return Icons.brightness_6; // Last quarter
    } else {
      return Icons.brightness_7; // Waning crescent
    }
  }
}
