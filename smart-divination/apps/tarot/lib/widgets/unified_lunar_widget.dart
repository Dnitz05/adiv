import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../models/lunar_day.dart';
import '../state/lunar_cycle_controller.dart';
import '../theme/tarot_theme.dart';
import 'lunar_tabs/today_tab.dart';
import 'lunar_tabs/calendar_tab.dart';
import 'lunar_tabs/rituals_tab.dart';
import 'lunar_tabs/spreads_tab.dart';
import 'lunar_tabs/guidance_tab.dart';
import 'lunar_tabs/history_tab.dart';

class UnifiedLunarWidget extends StatefulWidget {
  const UnifiedLunarWidget({
    super.key,
    required this.controller,
    required this.strings,
    this.userId,
    this.onSelectSpread,
    this.onRefresh,
  });

  final LunarCycleController controller;
  final CommonStrings strings;
  final String? userId;
  final void Function(String spreadId)? onSelectSpread;
  final VoidCallback? onRefresh;

  @override
  State<UnifiedLunarWidget> createState() => _UnifiedLunarWidgetState();
}

class _UnifiedLunarWidgetState extends State<UnifiedLunarWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final day = widget.controller.selectedDay;
        final status = widget.controller.status;

        if (status == LunarPanelStatus.loading && day == null) {
          return _buildLoadingState();
        }

        if (status == LunarPanelStatus.error && day == null) {
          return _buildErrorState(widget.controller.errorMessage);
        }

        if (day == null) {
          return _buildLoadingState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLunarHeader(day),
            const SizedBox(height: 16),
            _buildTabBar(),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: _buildTabContent(day),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLunarHeader(LunarDayModel day) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            TarotTheme.cosmicBlue,
            TarotTheme.cosmicPurple,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: TarotTheme.cosmicBlue.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                day.phaseEmoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day.phaseName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(day.date.toIso8601String()),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${day.illumination.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                day.zodiac.symbol,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Text(
                day.zodiac.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getElementColor(day.zodiac.element),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  day.zodiac.element,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = [
      _buildTab(_localisedTab('today'), Icons.today),
      _buildTab(_localisedTab('calendar'), Icons.calendar_month),
      _buildTab(_localisedTab('rituals'), Icons.auto_awesome),
      _buildTab(_localisedTab('spreads'), Icons.style),
      _buildTab(_localisedTab('guidance'), Icons.psychology),
      _buildTab(_localisedTab('history'), Icons.history),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              TarotTheme.cosmicBlue,
              TarotTheme.cosmicAccent,
            ],
          ),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: TarotTheme.stardust,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: tabs,
      ),
    );
  }

  Widget _buildTab(String label, IconData icon) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(LunarDayModel day) {
    return TabBarView(
      controller: _tabController,
      children: [
        TodayTab(
          day: day,
          controller: widget.controller,
          strings: widget.strings,
          userId: widget.userId,
          onSelectSpread: widget.onSelectSpread,
        ),
        CalendarTab(
          controller: widget.controller,
          strings: widget.strings,
        ),
        RitualsTab(
          day: day,
          strings: widget.strings,
          userId: widget.userId,
        ),
        SpreadsTab(
          day: day,
          strings: widget.strings,
          onSelectSpread: widget.onSelectSpread,
        ),
        GuidanceTab(
          day: day,
          strings: widget.strings,
          userId: widget.userId,
        ),
        HistoryTab(
          strings: widget.strings,
          userId: widget.userId,
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: _panelDecoration(),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const SizedBox(
            height: 36,
            width: 36,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              widget.strings.lunarPanelLoading,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String? message) {
    return Container(
      decoration: _panelDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
          const SizedBox(height: 12),
          Text(
            message ?? widget.strings.lunarPanelError,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          if (widget.onRefresh != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: widget.onRefresh,
              icon: const Icon(Icons.refresh),
              label: Text(widget.strings.lunarPanelRetry),
            ),
          ],
        ],
      ),
    );
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        colors: [
          TarotTheme.cosmicBlue.withValues(alpha: 0.15),
          TarotTheme.cosmicPurple.withValues(alpha: 0.15),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
        width: 1,
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final months = _getMonthNames();
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return isoDate;
    }
  }

  List<String> _getMonthNames() {
    switch (widget.strings.localeName) {
      case 'ca':
        return [
          'Gener',
          'Febrer',
          'Març',
          'Abril',
          'Maig',
          'Juny',
          'Juliol',
          'Agost',
          'Setembre',
          'Octubre',
          'Novembre',
          'Desembre'
        ];
      case 'es':
        return [
          'Enero',
          'Febrero',
          'Marzo',
          'Abril',
          'Mayo',
          'Junio',
          'Julio',
          'Agosto',
          'Septiembre',
          'Octubre',
          'Noviembre',
          'Diciembre'
        ];
      default:
        return [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December'
        ];
    }
  }

  Color _getElementColor(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
      case 'foc':
      case 'fuego':
        return Colors.deepOrange.withValues(alpha: 0.7);
      case 'earth':
      case 'terra':
      case 'tierra':
        return Colors.green.withValues(alpha: 0.7);
      case 'air':
      case 'aire':
        return Colors.lightBlue.withValues(alpha: 0.7);
      case 'water':
      case 'aigua':
      case 'agua':
        return Colors.blue.withValues(alpha: 0.7);
      default:
        return TarotTheme.cosmicAccent.withValues(alpha: 0.7);
    }
  }

  String _localisedTab(String key) {
    final locale = widget.strings.localeName;
    final translations = {
      'today': {'en': 'Today', 'es': 'Hoy', 'ca': 'Avui'},
      'calendar': {'en': 'Calendar', 'es': 'Calendario', 'ca': 'Calendari'},
      'rituals': {'en': 'Rituals', 'es': 'Rituales', 'ca': 'Rituals'},
      'spreads': {'en': 'Spreads', 'es': 'Tiradas', 'ca': 'Tirades'},
      'guidance': {'en': 'Guidance', 'es': 'Guía', 'ca': 'Guia'},
      'history': {'en': 'History', 'es': 'Historial', 'ca': 'Historial'},
    };
    return translations[key]?[locale] ?? translations[key]?['en'] ?? key;
  }
}
