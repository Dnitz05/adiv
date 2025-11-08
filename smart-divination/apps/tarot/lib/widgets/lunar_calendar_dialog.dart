import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:common/l10n/common_strings.dart';

import '../theme/tarot_theme.dart';
import '../state/lunar_cycle_controller.dart';
import '../models/lunar_day.dart';
import '../models/lunar_advice.dart';
import '../models/lunar_reminder.dart';
import '../api/lunar_api.dart';
import 'lunar_card_helpers.dart';

class LunarCalendarDialog extends StatefulWidget {
  const LunarCalendarDialog({
    super.key,
    required this.controller,
    required this.strings,
    this.userId,
    this.locale,
    this.onShareAdvice,
  });

  final LunarCycleController controller;
  final CommonStrings strings;
  final String? userId;
  final String? locale;
  final ValueChanged<String>? onShareAdvice;

  @override
  State<LunarCalendarDialog> createState() => _LunarCalendarDialogState();
}

class _LunarCalendarDialogState extends State<LunarCalendarDialog> {
  final LunarApiClient _api = const LunarApiClient();

  late DateTime _selectedMonth;
  late DateTime _selectedDate;
  late LunarAdviceTopic _selectedTopic;
  LunarAdvice? _advice;
  bool _isLoadingAdvice = false;
  String? _adviceError;
  List<LunarReminder> _reminders = <LunarReminder>[];
  bool _isLoadingReminders = false;
  String? _reminderError;
  bool _isSavingReminder = false;
  final TextEditingController _reminderTimeController = TextEditingController();
  final TextEditingController _reminderIntentionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _selectedDate = DateTime.now();
    _selectedTopic = LunarAdviceTopic.intentions;
    _loadAdviceForDate(_selectedDate);
    _loadReminders();
  }

  @override
  void dispose() {
    _reminderTimeController.dispose();
    _reminderIntentionController.dispose();
    super.dispose();
  }

  Future<void> _loadAdviceForDate(DateTime date) async {
    if (widget.userId == null || widget.userId!.isEmpty) {
      setState(() {
        _advice = null;
        _adviceError = null;
        _isLoadingAdvice = false;
      });
      return;
    }

    setState(() {
      _isLoadingAdvice = true;
      _adviceError = null;
    });

    try {
      final response = await _api.fetchAdvice(
        topic: _selectedTopic,
        date: date,
        locale: widget.locale ?? widget.strings.localeName,
        userId: widget.userId,
      );
      if (!mounted) return;
      setState(() {
        _advice = response.advice;
        _isLoadingAdvice = false;
      });
    } on LunarApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _adviceError = error.message;
        _advice = null;
        _isLoadingAdvice = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _adviceError = error.toString();
        _advice = null;
        _isLoadingAdvice = false;
      });
    }
  }

  Future<void> _loadReminders() async {
    if (widget.userId == null || widget.userId!.isEmpty) {
      setState(() {
        _reminders = <LunarReminder>[];
        _isLoadingReminders = false;
        _reminderError = null;
      });
      return;
    }

    setState(() {
      _isLoadingReminders = true;
      _reminderError = null;
    });

    try {
      final reminders = await _api.fetchReminders(
        userId: widget.userId,
        locale: widget.locale ?? widget.strings.localeName,
      );
      if (!mounted) return;
      setState(() {
        _reminders = reminders;
        _isLoadingReminders = false;
      });
    } on LunarApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _reminderError = error.message;
        _reminders = <LunarReminder>[];
        _isLoadingReminders = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _reminderError = error.toString();
        _reminders = <LunarReminder>[];
        _isLoadingReminders = false;
      });
    }
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
            const SizedBox(height: 12),
            _buildAdviceSection(theme),
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
        _loadAdviceForDate(date);
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

  Widget _buildAdviceSection(ThemeData theme) {
    if (widget.userId == null || widget.userId!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text(
          _localisedSignInPrompt(),
          style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: LunarAdviceTopic.values
                .map(
                  (topic) => ChoiceChip(
                    label: Text(_localisedTopic(topic)),
                    selected: _selectedTopic == topic,
                    onSelected: (value) {
                      if (!value || _selectedTopic == topic) return;
                      setState(() {
                        _selectedTopic = topic;
                      });
                      _loadAdviceForDate(_selectedDate);
                    },
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                    selectedColor: Colors.white.withValues(alpha: 0.2),
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    side: BorderSide.none,
                    showCheckmark: false,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: _buildAdviceBody(theme),
          ),
          const SizedBox(height: 16),
          _buildReminderSection(theme),
        ],
      ),
    );
  }

  Widget _buildAdviceBody(ThemeData theme) {
    if (_isLoadingAdvice) {
      return Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _localisedLoadingAdvice(),
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ),
        ],
      );
    }

    if (_adviceError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _adviceError!,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.red[200]),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _loadAdviceForDate(_selectedDate),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: Text(_localisedRetryText()),
          ),
        ],
      );
    }

    if (_advice == null) {
      return Text(
        _localisedNoAdvice(),
        style: theme.textTheme.bodySmall?.copyWith(color: Colors.white60),
      );
    }

    final advice = _advice!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          advice.focus,
          style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 10),
        ...advice.today.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: Colors.white70)),
                Expanded(
                  child: Text(
                    item,
                    style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                          height: 1.4,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                '${advice.next.name} • ${advice.next.date}',
                style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white60,
                    ),
              ),
            ),
            TextButton(
              onPressed: widget.onShareAdvice == null
                  ? null
                  : () => widget.onShareAdvice!(_composeShareMessage(advice)),
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: Text(_localisedShareText()),
            ),
          ],
        ),
      ],
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

  String _localisedTopic(LunarAdviceTopic topic) {
    switch (widget.strings.localeName) {
      case 'es':
        switch (topic) {
          case LunarAdviceTopic.intentions:
            return 'Intenciones';
          case LunarAdviceTopic.projects:
            return 'Proyectos';
          case LunarAdviceTopic.relationships:
            return 'Relaciones';
          case LunarAdviceTopic.wellbeing:
            return 'Bienestar';
          case LunarAdviceTopic.creativity:
            return 'Creatividad';
        }
      case 'ca':
        switch (topic) {
          case LunarAdviceTopic.intentions:
            return 'Intencions';
          case LunarAdviceTopic.projects:
            return 'Projectes';
          case LunarAdviceTopic.relationships:
            return 'Relacions';
          case LunarAdviceTopic.wellbeing:
            return 'Benestar';
          case LunarAdviceTopic.creativity:
            return 'Creativitat';
        }
      default:
        switch (topic) {
          case LunarAdviceTopic.intentions:
            return 'Intentions';
          case LunarAdviceTopic.projects:
            return 'Projects';
          case LunarAdviceTopic.relationships:
            return 'Relationships';
          case LunarAdviceTopic.wellbeing:
            return 'Wellbeing';
          case LunarAdviceTopic.creativity:
            return 'Creativity';
        }
    }
  }

  String _localisedLoadingAdvice() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'La luna prepara tu mensaje...';
      case 'ca':
        return 'La lluna prepara el teu missatge...';
      default:
        return 'The moon is preparing your message...';
    }
  }

  String _localisedRetryText() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Intentar de nuevo';
      case 'ca':
        return 'Tornar a intentar';
      default:
        return 'Try again';
    }
  }

  String _localisedNoAdvice() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'No hay consejo disponible por ahora.';
      case 'ca':
        return 'No hi ha cap consell disponible ara mateix.';
      default:
        return 'No guidance available right now.';
    }
  }

  String _localisedShareText() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Abrir en el chat';
      case 'ca':
        return 'Obrir al xat';
      default:
        return 'Open in chat';
    }
  }

  String _localisedSignInPrompt() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Inicia sesion para guardar y revisar tus consejos lunares.';
      case 'ca':
        return 'Inicia sessio per guardar i revisar els teus consells lunars.';
      default:
        return 'Sign in to save and revisit your lunar guidance.';
    }
  }

  String _composeShareMessage(LunarAdvice advice) {
    final buffer = StringBuffer()
      ..writeln(advice.focus)
      ..writeln();

    for (final item in advice.today.take(3)) {
      buffer.writeln('• $item');
    }

    buffer
      ..writeln()
      ..writeln('${advice.next.name} (${advice.next.date}) → ${advice.next.advice}');
    return buffer.toString().trim();
  }

  Future<void> _createReminder() async {
    if (widget.userId == null || widget.userId!.isEmpty) {
      setState(() {
        _reminderError = _localisedSignInPrompt();
      });
      return;
    }

    final time = _reminderTimeController.text.trim();
    if (time.isNotEmpty && !_timeRegex.hasMatch(time)) {
      setState(() {
        _reminderError = _localisedInvalidTime();
      });
      return;
    }

    setState(() {
      _isSavingReminder = true;
      _reminderError = null;
    });

    try {
      await _api.createReminder(
        topic: _selectedTopic,
        date: _selectedDate,
        time: time.isEmpty ? null : time,
        intention: _reminderIntentionController.text.trim().isEmpty
            ? null
            : _reminderIntentionController.text.trim(),
        locale: widget.locale ?? widget.strings.localeName,
        userId: widget.userId,
      );
      if (!mounted) return;
      _reminderTimeController.clear();
      _reminderIntentionController.clear();
      await _loadReminders();
    } on LunarApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _reminderError = error.message;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _reminderError = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSavingReminder = false;
        });
      }
    }
  }

  Future<void> _deleteReminder(String id) async {
    if (widget.userId == null || widget.userId!.isEmpty) {
      return;
    }
    try {
      await _api.deleteReminder(
        id: id,
        userId: widget.userId!,
        locale: widget.locale ?? widget.strings.localeName,
      );
      await _loadReminders();
    } catch (error) {
      setState(() {
        _reminderError = error.toString();
      });
    }
  }

  static final RegExp _timeRegex = RegExp(r'^\d{2}:\d{2}$');

  Widget _buildReminderSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _localisedRemindersTitle(),
          style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _reminderTimeController,
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            hintText: 'HH:MM',
            hintStyle: const TextStyle(color: Colors.white60),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.08),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _reminderIntentionController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: _localisedReminderIntentionHint(),
            hintStyle: const TextStyle(color: Colors.white60),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.08),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        if (_reminderError != null) ...[
          const SizedBox(height: 6),
          Text(
            _reminderError!,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.red[200]),
          ),
        ],
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: _isSavingReminder ? null : _createReminder,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: TarotTheme.cosmicPurple,
            ),
            icon: _isSavingReminder
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add),
            label: Text(_localisedAddReminderText()),
          ),
        ),
        const SizedBox(height: 12),
        if (_isLoadingReminders)
          const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
          )
        else if (_reminders.isEmpty)
          Text(
            _localisedNoReminders(),
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
          )
        else
          Column(
            children: _reminders.map((reminder) {
              return Card(
                color: Colors.white.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    '${_formatReminderDate(reminder.date)} ${reminder.time ?? ''}',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                  subtitle: reminder.intention != null
                      ? Text(
                          reminder.intention!,
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                        )
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white70),
                    tooltip: _localisedDeleteReminderText(),
                    onPressed: _isSavingReminder ? null : () => _deleteReminder(reminder.id),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  String _localisedRemindersTitle() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Recordatorios lunares';
      case 'ca':
        return 'Recordatoris lunars';
      default:
        return 'Lunar reminders';
    }
  }

  String _localisedReminderIntentionHint() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Intencion o nota (opcional)';
      case 'ca':
        return 'Intencio o nota (opcional)';
      default:
        return 'Intention or note (optional)';
    }
  }

  String _localisedAddReminderText() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Guardar recordatorio';
      case 'ca':
        return 'Desar recordatori';
      default:
        return 'Save reminder';
    }
  }

  String _localisedNoReminders() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Aun no tienes recordatorios guardados.';
      case 'ca':
        return 'Encara no tens recordatoris guardats.';
      default:
        return 'No reminders saved yet.';
    }
  }

  String _localisedDeleteReminderText() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Eliminar recordatorio';
      case 'ca':
        return 'Eliminar recordatori';
      default:
        return 'Delete reminder';
    }
  }

  String _localisedInvalidTime() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Introduce la hora en formato HH:MM.';
      case 'ca':
        return 'Introdueix l\'hora en format HH:MM.';
      default:
        return 'Enter time as HH:MM.';
    }
  }

  String _formatReminderDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
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

// Reusable calendar content for the Unified Lunar Widget
class LunarCalendarContent extends StatefulWidget {
  const LunarCalendarContent({
    super.key,
    required this.controller,
    required this.strings,
  });

  final LunarCycleController controller;
  final CommonStrings strings;

  @override
  State<LunarCalendarContent> createState() => _LunarCalendarContentState();
}

class _LunarCalendarContentState extends State<LunarCalendarContent> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMonthNavigation(),
        const SizedBox(height: 16),
        _buildCalendarGrid(),
        const SizedBox(height: 20),
        _buildUpcomingPhases(),
      ],
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

  Widget _buildUpcomingPhases() {
    return LunarCardHelpers.buildCardWithHeader(
      context: context,
      icon: Icons.calendar_month,
      title: _localisedLabel('upcoming_phases'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPhaseItem('🌑', _localisedLabel('new_moon'), 'Nov 13'),
          _buildPhaseItem('🌓', _localisedLabel('first_quarter'), 'Nov 20'),
          _buildPhaseItem('🌕', _localisedLabel('full_moon'), 'Nov 27'),
          _buildPhaseItem('🌗', _localisedLabel('last_quarter'), 'Dec 5'),
        ],
      ),
    );
  }

  Widget _buildPhaseItem(String emoji, String label, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: LunarCardHelpers.cardBodyStyle,
            ),
          ),
          Text(
            date,
            style: LunarCardHelpers.cardSubtitleStyle,
          ),
        ],
      ),
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

  String _localisedLabel(String key) {
    final locale = widget.strings.localeName;
    final labels = {
      'upcoming_phases': {'en': 'Upcoming Phases', 'es': 'Próximas Fases', 'ca': 'Properes Fases'},
      'new_moon': {'en': 'New Moon', 'es': 'Luna Nueva', 'ca': 'Lluna Nova'},
      'first_quarter': {'en': 'First Quarter', 'es': 'Cuarto Creciente', 'ca': 'Quart Creixent'},
      'full_moon': {'en': 'Full Moon', 'es': 'Luna Llena', 'ca': 'Lluna Plena'},
      'last_quarter': {'en': 'Last Quarter', 'es': 'Cuarto Menguante', 'ca': 'Quart Minvant'},
    };
    return labels[key]?[locale] ?? labels[key]?['en'] ?? key;
  }
}
