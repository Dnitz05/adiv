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

class _UnifiedLunarWidgetState extends State<UnifiedLunarWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) => _LunarContent(
        day: widget.controller.selectedDay,
        status: widget.controller.status,
        errorMessage: widget.controller.errorMessage,
        strings: widget.strings,
        controller: widget.controller,
        userId: widget.userId,
        onSelectSpread: widget.onSelectSpread,
        onRefresh: widget.onRefresh,
      ),
    );
  }
}

/// Separated content widget for optimized rebuilds
class _LunarContent extends StatelessWidget {
  const _LunarContent({
    required this.day,
    required this.status,
    required this.errorMessage,
    required this.strings,
    required this.controller,
    this.userId,
    this.onSelectSpread,
    this.onRefresh,
  });

  final LunarDayModel? day;
  final LunarPanelStatus status;
  final String? errorMessage;
  final CommonStrings strings;
  final LunarCycleController controller;
  final String? userId;
  final void Function(String spreadId)? onSelectSpread;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    // Loading state
    if (status == LunarPanelStatus.loading && day == null) {
      return _buildLoadingState();
    }

    // Error state
    if (status == LunarPanelStatus.error && day == null) {
      return _buildErrorState();
    }

    // Fallback loading if day is still null
    if (day == null) {
      return _buildLoadingState();
    }

    // Main content - single white container
    return _LunarMainContent(
      day: day!,
      strings: strings,
      controller: controller,
      userId: userId,
      onSelectSpread: onSelectSpread,
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
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(TarotTheme.brightBlue),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              strings.lunarPanelLoading,
              style: const TextStyle(
                color: TarotTheme.deepNavy,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      decoration: _panelDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
          const SizedBox(height: 12),
          Text(
            errorMessage ?? strings.lunarPanelError,
            style: const TextStyle(color: TarotTheme.deepNavy),
            textAlign: TextAlign.center,
          ),
          if (onRefresh != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: Text(strings.lunarPanelRetry),
            ),
          ],
        ],
      ),
    );
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      border: Border.all(
        color: TarotTheme.brightBlue.withValues(alpha: 0.15),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
    );
  }
}

/// Main content widget with TabController for lunar phases
class _LunarMainContent extends StatefulWidget {
  const _LunarMainContent({
    required this.day,
    required this.strings,
    required this.controller,
    this.userId,
    this.onSelectSpread,
  });

  final LunarDayModel day;
  final CommonStrings strings;
  final LunarCycleController controller;
  final String? userId;
  final void Function(String spreadId)? onSelectSpread;

  @override
  State<_LunarMainContent> createState() => _LunarMainContentState();
}

class _LunarMainContentState extends State<_LunarMainContent>
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            TarotTheme.brightBlue.withValues(alpha: 0.02),
          ],
        ),
        border: Border.all(
          color: TarotTheme.brightBlue.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: TarotTheme.brightBlue.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCompactHeader(),
          const SizedBox(height: 8),
          _buildUnifiedTabsContainer(),
        ],
      ),
    );
  }

  Widget _buildCompactHeader() {
    // Format date (e.g., "9 Nov")
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final formattedDate = '${widget.day.date.day} ${months[widget.day.date.month - 1]}';
    final lunarDay = 'Day ${widget.day.age.round()}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main row with emoji, phase, zodiac, illumination
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: TarotTheme.brightBlue.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: TarotTheme.cosmicAccent.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Text(
                widget.day.phaseEmoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.day.phaseName,
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
                        widget.day.zodiac.symbol,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.day.zodiac.name,
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
                          color: TarotTheme.getElementColor(widget.day.zodiac.element),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.day.zodiac.element,
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
                boxShadow: const [
                  BoxShadow(
                    color: TarotTheme.brightBlue20,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${widget.day.illumination.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        // Date + Lunar Day row (compact)
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: TarotTheme.brightBlue.withValues(alpha: 0.06),
            border: Border.all(
              color: TarotTheme.brightBlue.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: TarotTheme.brightBlue),
              const SizedBox(width: 6),
              Text(
                formattedDate,
                style: const TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 1,
                height: 14,
                color: TarotTheme.brightBlue.withValues(alpha: 0.2),
              ),
              const SizedBox(width: 16),
              Icon(Icons.brightness_3, size: 14, color: TarotTheme.cosmicAccent),
              const SizedBox(width: 6),
              Text(
                lunarDay,
                style: const TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnifiedTabsContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // TabBar amb pills
        Container(
          padding: const EdgeInsets.all(2),
          child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                gradient: const LinearGradient(
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
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
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
          const SizedBox(height: 4),
          // TabBarView content - optimized compact constraints
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 200,
              maxHeight: 280,
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                TodayTab(
                  day: widget.day,
                  strings: widget.strings,
                ),
                CalendarOnlyTab(
                  controller: widget.controller,
                  strings: widget.strings,
                ),
                PhasesTab(
                  day: widget.day,
                  strings: widget.strings,
                ),
                RitualsTab(
                  day: widget.day,
                  strings: widget.strings,
                  userId: widget.userId,
                ),
                SpreadsTab(
                  day: widget.day,
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 5),
            Text(label),
          ],
        ),
      ),
    );
  }
}
