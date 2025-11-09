import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../models/lunar_day.dart';
import '../state/lunar_cycle_controller.dart';
import '../theme/tarot_theme.dart';
import '../l10n/lunar/lunar_translations.dart';
import 'lunar_tabs/today_tab.dart';
import 'lunar_tabs/calendar_only_tab.dart';
import 'lunar_tabs/phases_tab.dart';
import 'lunar_tabs/rituals_tab.dart';
import 'lunar_tabs/spreads_tab.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TarotTheme.lunarLavenderLight,
                TarotTheme.lunarLavenderSoft,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: TarotTheme.lunarMysticShadow,
                blurRadius: 16,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: TarotTheme.lunarMysticShadow,
                blurRadius: 32,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCompactHeader(day),
              const SizedBox(height: 10),
              _buildUnifiedTabsContainer(day),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompactHeader(LunarDayModel day) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: TarotTheme.brightBlue20,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Text(
            day.phaseEmoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day.phaseName,
                style: const TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    day.zodiac.symbol,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    day.zodiac.name,
                    style: const TextStyle(
                      color: TarotTheme.softBlueGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: TarotTheme.getElementColor(day.zodiac.element),
                      borderRadius: BorderRadius.circular(6),
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
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: TarotTheme.brightBlue,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: TarotTheme.brightBlue20,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
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
    );
  }

  // ✅ Contenidor unificat amb TabBar i TabBarView en un sol container blanc
  Widget _buildUnifiedTabsContainer(LunarDayModel day) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // TabBar amb pills
          Container(
            padding: const EdgeInsets.all(4),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [TarotTheme.brightBlue, TarotTheme.cosmicAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: TarotTheme.brightBlue.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: TarotTheme.softBlueGrey,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                _buildTab(getLunarTabLabel('today', widget.strings.localeName), Icons.today),
                _buildTab(getLunarTabLabel('calendar', widget.strings.localeName), Icons.calendar_month),
                _buildTab(getLunarTabLabel('phases', widget.strings.localeName), Icons.brightness_3),
                _buildTab(getLunarTabLabel('rituals', widget.strings.localeName), Icons.auto_awesome),
                _buildTab(getLunarTabLabel('spreads', widget.strings.localeName), Icons.style),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // TabBarView content - flexible height constraints
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 240,
              maxHeight: 350,
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                TodayTab(
                  day: day,
                  strings: widget.strings,
                ),
                CalendarOnlyTab(
                  controller: widget.controller,
                  strings: widget.strings,
                ),
                PhasesTab(
                  day: day,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, IconData icon) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17),
            const SizedBox(width: 5),
            Text(label),
          ],
        ),
      ),
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
          TarotTheme.lunarLavenderLight,
          TarotTheme.lunarLavenderSoft,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: TarotTheme.lunarMysticShadow,
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
    );
  }

}
