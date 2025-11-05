import 'package:flutter/foundation.dart';

import '../models/lunar_day.dart';
import '../services/lunar_cycle_repository.dart';

enum LunarPanelStatus { idle, loading, ready, error }

class LunarCycleController extends ChangeNotifier {
  LunarCycleController({
    LunarCycleRepository? repository,
    this.daysBefore = 3,
    this.daysAfter = 3,
  }) : _repository = repository ?? LunarCycleRepository();

  final LunarCycleRepository _repository;
  final Map<String, LunarDayModel> _dayCache = <String, LunarDayModel>{};

  final int daysBefore;
  final int daysAfter;

  LunarPanelStatus _status = LunarPanelStatus.idle;
  LunarDayModel? _selectedDay;
  List<LunarRangeItemModel> _range = <LunarRangeItemModel>[];
  String? _errorMessage;
  DateTime _focusedDate = _normalizeDate(DateTime.now());
  String _locale = 'en';
  String? _userId;

  LunarPanelStatus get status => _status;
  LunarDayModel? get selectedDay => _selectedDay;
  List<LunarRangeItemModel> get rangeDays => _range;
  String? get errorMessage => _errorMessage;
  DateTime get focusedDate => _focusedDate;
  bool get hasError => _status == LunarPanelStatus.error;

  DateTime get _rangeStart =>
      _range.isEmpty ? _focusedDate : _normalizeDate(_range.first.date);
  DateTime get _rangeEnd =>
      _range.isEmpty ? _focusedDate : _normalizeDate(_range.last.date);

  Future<void> initialise({
    String? locale,
    String? userId,
    bool forceRefresh = false,
  }) async {
    _locale = (locale ?? _locale).toLowerCase();
    _userId = userId;
    await _loadDayAndRange(
      _focusedDate,
      forceRefresh: forceRefresh,
    );
  }

  Future<void> refresh({bool force = true}) async {
    await _loadDayAndRange(_focusedDate, forceRefresh: force);
  }

  Future<void> selectDate(DateTime date, {bool forceRefresh = false}) async {
    final target = _normalizeDate(date);
    final needsNewRange = _range.isEmpty ||
        target.isBefore(_rangeStart) ||
        target.isAfter(_rangeEnd);

    if (needsNewRange || forceRefresh) {
      await _loadDayAndRange(target, forceRefresh: forceRefresh);
      return;
    }

    await _loadDay(target, forceRefresh: forceRefresh);
  }

  Future<void> _loadDayAndRange(
    DateTime date, {
    bool forceRefresh = false,
  }) async {
    _setStatus(LunarPanelStatus.loading);
    final target = _normalizeDate(date);

    try {
      final day = await _repository.getDay(
        date: target,
        locale: _locale,
        userId: _userId,
        forceRefresh: forceRefresh,
      );
      _cacheDay(day);
      _selectedDay = day;
      _focusedDate = target;

      final range = await _repository.getRange(
        from: target.subtract(Duration(days: daysBefore)),
        to: target.add(Duration(days: daysAfter)),
        locale: _locale,
        userId: _userId,
        forceRefresh: forceRefresh,
      );

      _range = range..sort((a, b) => a.date.compareTo(b.date));
      _errorMessage = null;
      _setStatus(LunarPanelStatus.ready);
    } catch (error) {
      _errorMessage = error.toString();
      _setStatus(LunarPanelStatus.error);
    }
  }

  Future<void> _loadDay(DateTime date, {bool forceRefresh = false}) async {
    final target = _normalizeDate(date);

    try {
      final cached = _dayCache[_cacheKey(target)];
      if (cached != null && !forceRefresh) {
        _selectedDay = cached;
        _focusedDate = target;
        _errorMessage = null;
        _setStatus(LunarPanelStatus.ready);
        return;
      }

      _setStatus(LunarPanelStatus.loading);

      final day = await _repository.getDay(
        date: target,
        locale: _locale,
        userId: _userId,
        forceRefresh: forceRefresh,
      );

      _cacheDay(day);
      _selectedDay = day;
      _focusedDate = target;
      _errorMessage = null;
      _setStatus(LunarPanelStatus.ready);
    } catch (error) {
      _errorMessage = error.toString();
      _setStatus(LunarPanelStatus.error);
    }
  }

  void _cacheDay(LunarDayModel day) {
    _dayCache[_cacheKey(day.date)] = day;
  }

  void _setStatus(LunarPanelStatus value) {
    _status = value;
    notifyListeners();
  }

  String _cacheKey(DateTime date) => _formatDate(_normalizeDate(date));

  static DateTime _normalizeDate(DateTime value) =>
      DateTime.utc(value.year, value.month, value.day);

  static String _formatDate(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}
