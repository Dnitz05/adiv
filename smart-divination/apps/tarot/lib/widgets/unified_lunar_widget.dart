import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../models/lunar_day.dart';
import '../state/lunar_cycle_controller.dart';
import '../theme/tarot_theme.dart';
import '../l10n/lunar/lunar_translations.dart';
import 'lunar_card_helpers.dart';
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
    this.onAskMoon,
  });

  final LunarCycleController controller;
  final CommonStrings strings;
  final String? userId;
  final void Function(String spreadId)? onSelectSpread;
  final VoidCallback? onRefresh;
  final VoidCallback? onAskMoon;

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
        onAskMoon: widget.onAskMoon,
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
    this.onAskMoon,
  });

  final LunarDayModel? day;
  final LunarPanelStatus status;
  final String? errorMessage;
  final CommonStrings strings;
  final LunarCycleController controller;
  final String? userId;
  final void Function(String spreadId)? onSelectSpread;
  final VoidCallback? onRefresh;
  final VoidCallback? onAskMoon;

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
      onAskMoon: onAskMoon,
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
    this.onAskMoon,
  });

  final LunarDayModel day;
  final CommonStrings strings;
  final LunarCycleController controller;
  final String? userId;
  final void Function(String spreadId)? onSelectSpread;
  final VoidCallback? onAskMoon;

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
        color: Colors.white,
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
          _buildTitle(),
          const SizedBox(height: 12),
          _buildCompactUnifiedHeader(),
          const SizedBox(height: 8),
          _buildUnifiedTabsContainer(),
          if (widget.onAskMoon != null) ...[
            const SizedBox(height: 12),
            _buildAskMoonFooter(),
          ],
        ],
      ),
    );
  }

  Widget _buildTitle() {
    final locale = widget.strings.localeName;
    final title = _getTitleText(locale);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                TarotTheme.cosmicBlue,
                TarotTheme.cosmicAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(
            Icons.nightlight_round,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: TarotTheme.deepNavy,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  String _getTitleText(String locale) {
    switch (locale) {
      case 'es':
        return 'LUNA';
      case 'ca':
        return 'LLUNA';
      default:
        return 'MOON';
    }
  }

  Widget _buildCompactUnifiedHeader() {
    final lunarInfo = LunarInfoHelper(widget.day, widget.strings.localeName);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TarotTheme.brightBlue.withValues(alpha: 0.03),
            TarotTheme.brightBlue.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TarotTheme.brightBlue.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildRow1PhaseAndIllumination(lunarInfo),
          const SizedBox(height: 6),
          _buildRow2AstroProperties(lunarInfo),
          const SizedBox(height: 6),
          _buildRow3Timeline(lunarInfo),
        ],
      ),
    );
  }

  Widget _buildRow1PhaseAndIllumination(LunarInfoHelper lunarInfo) {
    return Row(
      children: [
        // Moon emoji with glow
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: TarotTheme.brightBlue.withValues(alpha: 0.2),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            widget.day.phaseEmoji,
            style: const TextStyle(fontSize: 28),
          ),
        ),
        const SizedBox(width: 10),
        // Phase name + trend
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.day.phaseName,
                style: const TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                lunarInfo.trend,
                style: TextStyle(
                  color: TarotTheme.softBlueGrey.withValues(alpha: 0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Illumination badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: TarotTheme.brightBlue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: TarotTheme.brightBlue.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '${widget.day.illumination.toStringAsFixed(0)}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow2AstroProperties(LunarInfoHelper lunarInfo) {
    final elementLabel = getElementLabel(widget.day.zodiac.element.toLowerCase(), widget.strings.localeName);
    
    return Row(
      children: [
        Text(
          widget.day.zodiac.symbol,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(width: 6),
        Text(
          widget.day.zodiac.name,
          style: const TextStyle(
            color: TarotTheme.deepNavy,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '·',
          style: TextStyle(
            color: TarotTheme.softBlueGrey.withValues(alpha: 0.6),
            fontSize: 11,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$elementLabel · ${lunarInfo.polarity} · ${lunarInfo.quality} · ${lunarInfo.ruler}',
          style: TextStyle(
            color: TarotTheme.softBlueGrey.withValues(alpha: 0.9),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRow3Timeline(LunarInfoHelper lunarInfo) {
    final formattedDate = formatShortDate(widget.day.date, widget.strings.localeName);
    final dayLabel = getLunarHeaderLabel('day', widget.strings.localeName);
    final inLabel = getLunarHeaderLabel('in', widget.strings.localeName);
    final dLabel = getLunarHeaderLabel('d', widget.strings.localeName);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Date
        _buildTimelineItem(
          Icons.calendar_today,
          formattedDate,
        ),
        // Lunar day
        _buildTimelineItem(
          Icons.brightness_3,
          '$dayLabel ${widget.day.age.round()}',
        ),
        // Next phase
        _buildTimelineItem(
          Icons.arrow_forward,
          '${lunarInfo.nextPhase} $inLabel ${lunarInfo.daysToNext}$dLabel',
        ),
      ],
    );
  }

  Widget _buildTimelineItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: TarotTheme.brightBlue.withValues(alpha: 0.7)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: TarotTheme.softBlueGrey.withValues(alpha: 0.9),
            fontSize: 10,
            fontWeight: FontWeight.w500,
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

  Widget _buildAskMoonFooter() {
    final locale = widget.strings.localeName;
    final title = _getAskMoonTitle(locale);
    final description = _getAskMoonDescription(locale);

    return GestureDetector(
      onTap: widget.onAskMoon,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              TarotTheme.cosmicBlue.withValues(alpha: 0.08),
              TarotTheme.cosmicAccent.withValues(alpha: 0.12),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: TarotTheme.cosmicAccent.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TarotTheme.brightBlue.withValues(alpha: 0.15),
              ),
              child: const Icon(
                Icons.help_outline,
                color: TarotTheme.brightBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: TarotTheme.deepNavy,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: TarotTheme.softBlueGrey.withValues(alpha: 0.9),
                      fontSize: 13,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: TarotTheme.brightBlue,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  String _getAskMoonTitle(String locale) {
    switch (locale) {
      case 'es':
        return 'Consulta la Luna';
      case 'ca':
        return 'Pregunta a la Lluna';
      default:
        return 'Ask the Moon';
    }
  }

  String _getAskMoonDescription(String locale) {
    switch (locale) {
      case 'es':
        return 'Obtén orientación lunar personalizada para tus intenciones y proyectos';
      case 'ca':
        return 'Obtén orientació lunar personalitzada per a les teves intencions i projectes';
      default:
        return 'Get personalized lunar guidance for your intentions and projects';
    }
  }
}
