import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:common/l10n/common_strings.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import '../models/lunar_day.dart';
import '../models/tarot_spread.dart';
import '../screens/chat_screen.dart';
import '../state/lunar_cycle_controller.dart';
import '../theme/tarot_theme.dart';
import 'lunar_ai_advisor.dart';
import 'lunar_advice_history_panel.dart';
import 'lunar_calendar_dialog.dart';

class LunarHomePanel extends StatelessWidget {
  const LunarHomePanel({
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
            const SizedBox(height: 12),
            _buildAskTheMoonPrompt(context),
            const SizedBox(height: 16),
            _buildCalendarStrip(context),
            const SizedBox(height: 16),
            _buildSessionsSummary(context, day),
            const SizedBox(height: 16),
            LunarAdviceHistoryPanel(
              strings: strings,
              userId: userId,
              locale: strings.localeName,
              onShareAdvice: (message) => _openAdviceInChat(context, message),
            ),
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
            // Recommended spreads integradas aquí
            if (day.recommendedSpreads.isNotEmpty) ...[
              const SizedBox(height: 20),
              Divider(
                color: Colors.white.withValues(alpha: 0.2),
                thickness: 1,
              ),
              const SizedBox(height: 16),
              Text(
                strings.lunarPanelRecommendedTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                strings.lunarPanelRecommendedSubtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: day.recommendedSpreads
                    .map(TarotSpreads.getById)
                    .whereType<TarotSpread>()
                    .map((spread) {
                  final spreadName = _localisedSpreadName(spread);
                  return FilledButton.icon(
                    onPressed: onSelectSpread == null
                        ? null
                        : () => onSelectSpread!(spread.id),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.auto_awesome, size: 16),
                    label: Text(
                      strings.lunarPanelUseSpread(spreadName),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  );
                }).toList(),
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
        // Header row con título y botón
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  strings.lunarPanelCalendarTitle,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: TarotTheme.cosmicPurple,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => LunarCalendarDialog(
                      controller: controller,
                      strings: strings,
                      userId: userId,
                      locale: strings.localeName,
                      onShareAdvice: (message) => _openAdviceInChat(context, message),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: TarotTheme.cosmicAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.calendar_month, size: 16),
                label: Text(
                  _getCalendarButtonText(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: range.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            physics: const PageScrollPhysics(), // Swipe por páginas
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

  Widget _buildAskTheMoonPrompt(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
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
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _askMoonTitle(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: TarotTheme.midnightBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _askMoonSubtitle(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: TarotTheme.midnightBlue.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 120),
            child: FilledButton(
              onPressed: () => _showAskTheMoonSheet(context),
              style: FilledButton.styleFrom(
                backgroundColor: TarotTheme.cosmicAccent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: Text(
                _askMoonButtonLabel(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAskTheMoonSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
        return FractionallySizedBox(
          heightFactor: 0.92,
          child: Container(
            decoration: BoxDecoration(
              color: TarotTheme.midnightBlue,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + bottomInset),
                      child: SingleChildScrollView(
                        child: LunarAiAdvisor(
                          strings: strings,
                          userId: userId,
                          locale: strings.localeName,
                          onShareAdvice: (message) {
                            Navigator.of(sheetContext).pop();
                            _openAdviceInChat(context, message);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openAdviceInChat(BuildContext context, String message) {
    final activeUserId = userId;
    if (activeUserId == null || activeUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_localisedLoginPrompt()),
          backgroundColor: Colors.black87,
        ),
      );
      return;
    }

    final chatMessage = ChatMessage.text(
      id: const Uuid().v4(),
      isUser: false,
      timestamp: DateTime.now(),
      text: message,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          userId: activeUserId,
          strings: strings,
          initialMessages: [chatMessage],
        ),
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

  String _getCalendarButtonText() {
    switch (strings.localeName) {
      case 'ca':
        return 'Veure calendari mensual';
      case 'es':
        return 'Ver calendario mensual';
      default:
        return 'View monthly calendar';
    }
  }

  static DateTime _normalizeDate(DateTime value) =>
      DateTime.utc(value.year, value.month, value.day);

  String _localisedLoginPrompt() {
    switch (strings.localeName) {
      case 'es':
        return 'Inicia sesión para compartir tu consejo lunar en el chat.';
      case 'ca':
        return 'Inicia sessió per compartir el teu consell lunar al xat.';
      default:
        return 'Sign in to share your lunar guidance in the chat.';
    }
  }

  String _askMoonTitle() {
    switch (strings.localeName) {
      case 'es':
        return 'Preguntar a la luna';
      case 'ca':
        return 'Pregunta a la lluna';
      default:
        return 'Ask the moon';
    }
  }

  String _askMoonSubtitle() {
    switch (strings.localeName) {
      case 'es':
        return 'Descubre en qué fase apoyar rituales, proyectos o cuidados.';
      case 'ca':
        return 'Descobreix en quina fase potenciar rituals, projectes o cures.';
      default:
        return 'Find the phase that boosts your rituals, projects or self-care.';
    }
  }

  String _askMoonButtonLabel() {
    switch (strings.localeName) {
      case 'es':
        return 'Abrir guia';
      case 'ca':
        return 'Obrir guia';
      default:
        return 'Open guide';
    }
  }
}
