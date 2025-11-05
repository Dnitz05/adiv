import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/lunar_day.dart';
import '../models/tarot_spread.dart';
import '../state/lunar_cycle_controller.dart';
import '../theme/tarot_theme.dart';
import 'package:common/l10n/common_strings.dart';

class LunarHomePanel extends StatelessWidget {
  const LunarHomePanel({
    super.key,
    required this.controller,
    required this.strings,
    this.onSelectSpread,
    this.onRefresh,
  });

  final LunarCycleController controller;
  final CommonStrings strings;
  final void Function(String spreadId)? onSelectSpread;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final day = controller.selectedDay;
        final status = controller.status;

        if (status == LunarPanelStatus.loading && day == null) {
          return _buildLoadingState(context);
        }

        if (status == LunarPanelStatus.error && day == null) {
          return _buildErrorState(context, controller.errorMessage);
        }

        if (day == null) {
          return _buildLoadingState(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeroCard(context, day),
            const SizedBox(height: 16),
            _buildCalendarStrip(context),
            const SizedBox(height: 16),
            _buildRecommendedSpreads(context, day),
            const SizedBox(height: 16),
            _buildSessionsSummary(context, day),
          ],
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      decoration: _panelDecoration(context),
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
              strings.lunarPanelLoading,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    return Container(
      decoration: _panelDecoration(context),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.lunarPanelError,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            message ?? strings.lunarPanelFallbackError,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh, color: Colors.white70, size: 18),
            label: Text(
              strings.lunarPanelRetry,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, LunarDayModel day) {
    final theme = Theme.of(context);
    final illumination = NumberFormat('0').format(day.illumination);
    final age = NumberFormat('0.0').format(day.age);
    final isLoading = controller.status == LunarPanelStatus.loading;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isLoading ? 0.8 : 1,
      child: Container(
        decoration: _panelDecoration(context),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  child: Text(
                    day.phaseEmoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.lunarPanelTitle,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white70,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        day.phaseName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        runSpacing: 6,
                        children: [
                          _infoChip(
                            context,
                            strings.lunarPanelIllumination(illumination),
                          ),
                          _infoChip(
                            context,
                            strings.lunarPanelAge(age),
                          ),
                          _infoChip(
                            context,
                            strings.lunarPanelMoonIn(day.zodiac.name),
                          ),
                          _infoChip(
                            context,
                            strings.lunarPanelElement(
                              _localisedElement(day.zodiac.element),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (day.guidance != null && day.guidance!.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                strings.lunarPanelGuidanceTitle,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white70,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                day.guidance!.text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.92),
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarStrip(BuildContext context) {
    final range = controller.rangeDays;
    if (range.isEmpty) {
      return const SizedBox.shrink();
    }

    final dateFormat = DateFormat('E', strings.localeName);
    final selectedDate = _normalizeDate(
      controller.selectedDay?.date ?? controller.focusedDate,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            strings.lunarPanelCalendarTitle,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: TarotTheme.cosmicPurple,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: range.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = range[index];
              final dayDate = _normalizeDate(item.date);
              final isSelected = dayDate == selectedDate;
              final isToday = dayDate == _normalizeDate(DateTime.now());
              final dayLabel = dateFormat.format(dayDate).toUpperCase();
              final dayNumber = dayDate.day.toString().padLeft(2, '0');

              return GestureDetector(
                onTap: () => controller.selectDate(item.date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeInOut,
                  width: 76,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: isSelected ? TarotTheme.cosmicAccent : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        offset: const Offset(0, 6),
                        blurRadius: 12,
                      ),
                    ],
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : TarotTheme.cosmicAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        isToday ? strings.lunarPanelToday : dayLabel,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : TarotTheme.cosmicBlue,
                              letterSpacing: 0.5,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dayNumber,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : TarotTheme.cosmicBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.phaseEmoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 6),
                      _sessionDot(item.sessionCount, isSelected),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _sessionDot(int count, bool selected) {
    if (count <= 0) {
      return const SizedBox(height: 8);
    }
    final text = count.toString();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: selected
            ? Colors.white.withValues(alpha: 0.28)
            : TarotTheme.cosmicAccent.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : TarotTheme.cosmicAccent,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRecommendedSpreads(BuildContext context, LunarDayModel day) {
    final spreads = day.recommendedSpreads
        .map(TarotSpreads.getById)
        .whereType<TarotSpread>()
        .toList(growable: false);

    if (spreads.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 12),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.lunarPanelRecommendedTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: TarotTheme.cosmicPurple,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            strings.lunarPanelRecommendedSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TarotTheme.cosmicBlue,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: spreads.map((spread) {
              final spreadName = _localisedSpreadName(spread);
              return FilledButton.icon(
                onPressed: onSelectSpread == null
                    ? null
                    : () => onSelectSpread!(spread.id),
                style: FilledButton.styleFrom(
                  backgroundColor: TarotTheme.cosmicAccent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: Text(
                  strings.lunarPanelUseSpread(spreadName),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsSummary(BuildContext context, LunarDayModel day) {
    final sessionCount = day.sessionCount;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 12),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.lunarPanelSessionsHeadline,
            style: textTheme.titleMedium?.copyWith(
              color: TarotTheme.cosmicPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          if (sessionCount <= 0)
            Text(
              strings.lunarPanelNoSessions,
              style: textTheme.bodyMedium?.copyWith(
                color: TarotTheme.cosmicBlue,
              ),
            )
          else
            Text(
              strings.lunarPanelSessionsCount(sessionCount),
              style: textTheme.bodyMedium?.copyWith(
                color: TarotTheme.cosmicBlue,
                height: 1.4,
              ),
            ),
        ],
      ),
    );
  }

  BoxDecoration _panelDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          TarotTheme.cosmicAccent,
          TarotTheme.cosmicBlue,
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.25),
          blurRadius: 28,
          offset: const Offset(0, 18),
        ),
      ],
    );
  }

  Widget _infoChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  String _localisedSpreadName(TarotSpread spread) {
    switch (spread.id) {
      case 'single':
        return strings.lunarSpreadSingle;
      case 'two_card':
        return strings.lunarSpreadTwoCard;
      case 'three_card':
        return strings.lunarSpreadThreeCard;
      case 'five_card_cross':
        return strings.lunarSpreadFiveCardCross;
      case 'relationship':
        return strings.lunarSpreadRelationship;
      case 'pyramid':
        return strings.lunarSpreadPyramid;
      case 'horseshoe':
        return strings.lunarSpreadHorseshoe;
      case 'celtic_cross':
        return strings.lunarSpreadCelticCross;
      case 'star':
        return strings.lunarSpreadStar;
      case 'astrological':
        return strings.lunarSpreadAstrological;
      case 'year_ahead':
        return strings.lunarSpreadYearAhead;
      default:
        return spread.name;
    }
  }

  String _localisedElement(String element) {
    switch (element) {
      case 'fire':
        return strings.lunarElementFire;
      case 'earth':
        return strings.lunarElementEarth;
      case 'air':
        return strings.lunarElementAir;
      case 'water':
        return strings.lunarElementWater;
      default:
        return element;
    }
  }

  static DateTime _normalizeDate(DateTime value) =>
      DateTime.utc(value.year, value.month, value.day);
}
