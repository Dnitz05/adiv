import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../models/lunar_day.dart';
import '../state/lunar_cycle_controller.dart';
import '../theme/tarot_theme.dart';
import '../l10n/lunar/lunar_translations.dart';
import 'lunar_card_helpers.dart';
import 'lunar_tabs/guide_tab.dart';
import 'lunar_tabs/spreads_tab.dart';
import 'lunar_tabs/rituals_tab.dart';

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
        color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
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
    _tabController = TabController(length: 3, vsync: this);
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
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
        ],
      ),
    );
  }

  Widget _buildTitle() {
    final locale = widget.strings.localeName;
    final title = _getTitleText(locale);
    final subtitle = _getTodaySubtitle(locale);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
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
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: TarotTheme.softBlueGrey.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        _buildCTAButton(locale),
      ],
    );
  }

  String _getTitleText(String locale) {
    switch (locale) {
      case 'es':
        return 'Luna';
      case 'ca':
        return 'Lluna';
      default:
        return 'Moon';
    }
  }

  String _getTodaySubtitle(String locale) {
    final lunarInfo = LunarInfoHelper(widget.day, locale);
    final lunarDay = widget.day.age.round();

    // Day label
    final dayLabel = locale == 'ca' ? 'Dia lunar' : (locale == 'es' ? 'Día lunar' : 'Lunar day');

    // In label
    final inLabel = locale == 'ca' ? 'en' : (locale == 'es' ? 'en' : 'in');

    // Days label
    final daysLabel = _getDaysLabel(lunarInfo.daysToNext, locale);

    return '$dayLabel $lunarDay • ${lunarInfo.nextPhase} $inLabel ${lunarInfo.daysToNext} $daysLabel';
  }

  Widget _buildCompactUnifiedHeader() {
    final locale = widget.strings.localeName;
    final lunarInfo = LunarInfoHelper(widget.day, widget.strings.localeName);
    final illumination = widget.day.illumination;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onCalendarTap(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF342B47), // Dark lilac
                Color(0xFF473D5C), // Medium lilac
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF342B47).withValues(alpha: 0.5),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRow1PhaseAndIllumination(lunarInfo, illumination, locale),
              _buildLunarTimeline(locale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow1PhaseAndIllumination(LunarInfoHelper lunarInfo, double illumination, String locale) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMoonWithOverlaidPercentage(illumination, locale),
        const SizedBox(width: 14),
        Expanded(
          child: _buildStackedPhaseInfo(lunarInfo, locale),
        ),
      ],
    );
  }

  Widget _buildMoonWithOverlaidPercentage(double illumination, String locale) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [
                Color(0xFF1A1A3E),
                Color(0xFF0D0D1F),
              ],
              center: Alignment.center,
              radius: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.15),
                blurRadius: 20,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.day.phaseEmoji,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${illumination.round()}% ${_getLitText(locale)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildStackedPhaseInfo(LunarInfoHelper lunarInfo, String locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.day.phaseName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          lunarInfo.trend,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 11,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        _buildZodiacElementLine(locale),
        const SizedBox(height: 3),
        _buildPropertiesLine(lunarInfo, locale),
      ],
    );
  }

  Widget _buildZodiacElementLine(String locale) {
    final elementLabel = _getDidacticElement(widget.day.zodiac.element, locale);

    return Row(
      children: [
        Text(
          widget.day.zodiac.symbol,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 6),
        Text(
          widget.day.zodiac.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        Text(
          ' · ',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
        Expanded(
          child: Text(
            elementLabel,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertiesLine(LunarInfoHelper lunarInfo, String locale) {
    return Text(
      '${_getDidacticPolarity(lunarInfo.polarity, locale)} · ${_getDidacticQuality(lunarInfo.quality, locale)} · ${_getDidacticRuler(lunarInfo.ruler, locale)}',
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.8),
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.2,
      ),
    );
  }

  Widget _buildCTAButton(String locale) {
    return GestureDetector(
      onTap: () => _onCalendarTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              TarotTheme.cosmicBlue,
              TarotTheme.cosmicAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today,
              size: 12,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              _getCalendarButtonText(locale),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for didactic translations

  String _getLitText(String locale) {
    switch (locale) {
      case 'ca':
        return 'il·lum.';
      case 'es':
        return 'ilum.';
      default:
        return 'lit';
    }
  }

  String _getDidacticElement(String element, String locale) {
    final lower = element.toLowerCase();
    switch (locale) {
      case 'ca':
        if (lower == 'fire') return 'Element foc';
        if (lower == 'earth') return 'Element terra';
        if (lower == 'air') return 'Element aire';
        if (lower == 'water') return 'Element aigua';
        return 'Element $element';
      case 'es':
        if (lower == 'fire') return 'Elemento fuego';
        if (lower == 'earth') return 'Elemento tierra';
        if (lower == 'air') return 'Elemento aire';
        if (lower == 'water') return 'Elemento agua';
        return 'Elemento $element';
      default:
        if (lower == 'fire') return 'Fire element';
        if (lower == 'earth') return 'Earth element';
        if (lower == 'air') return 'Air element';
        if (lower == 'water') return 'Water element';
        return '$element element';
    }
  }

  String _getDidacticPolarity(String polarity, String locale) {
    final lower = polarity.toLowerCase();
    switch (locale) {
      case 'ca':
        if (lower.contains('masc')) return 'Masculí';
        if (lower.contains('fem')) return 'Femení';
        return polarity;
      case 'es':
        if (lower.contains('masc')) return 'Masculino';
        if (lower.contains('fem')) return 'Femenino';
        return polarity;
      default:
        if (lower.contains('masc')) return 'Masculine';
        if (lower.contains('fem')) return 'Feminine';
        return polarity;
    }
  }

  String _getDidacticQuality(String quality, String locale) {
    final lower = quality.toLowerCase();
    switch (locale) {
      case 'ca':
        if (lower.contains('card')) return 'Qualitat cardinal';
        if (lower.contains('fix')) return 'Qualitat fixa';
        if (lower.contains('mut')) return 'Qualitat mutable';
        return quality;
      case 'es':
        if (lower.contains('card')) return 'Cualidad cardinal';
        if (lower.contains('fij') || lower.contains('fix')) return 'Cualidad fija';
        if (lower.contains('mut')) return 'Cualidad mutable';
        return quality;
      default:
        if (lower.contains('card')) return 'Cardinal quality';
        if (lower.contains('fix')) return 'Fixed quality';
        if (lower.contains('mut')) return 'Mutable quality';
        return quality;
    }
  }

  String _getDidacticRuler(String ruler, String locale) {
    switch (locale) {
      case 'ca':
        return 'Regit per $ruler';
      case 'es':
        return 'Regido por $ruler';
      default:
        return 'Ruled by $ruler';
    }
  }

  String _getLunarDayLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Dia lunar';
      case 'es':
        return 'Día lunar';
      default:
        return 'Lunar day';
    }
  }

  String _getInLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'en';
      case 'es':
        return 'en';
      default:
        return 'in';
    }
  }

  String _getDaysLabel(int days, String locale) {
    switch (locale) {
      case 'ca':
        return days == 1 ? 'dia' : 'dies';
      case 'es':
        return days == 1 ? 'día' : 'días';
      default:
        return days == 1 ? 'day' : 'days';
    }
  }

  String _getPhaseSubtitle(String phaseName, String locale) {
    final lowerName = phaseName.toLowerCase();

    if (locale == 'ca') {
      if (lowerName.contains('nova')) return 'Començament del cicle lunar';
      if (lowerName.contains('creixent') && !lowerName.contains('quart')) return 'Creixent cap a la plenitud';
      if (lowerName.contains('quart creixent') || lowerName.contains('primer quart')) return 'A mig camí cap a la lluna plena';
      if (lowerName.contains('plena')) return 'Màxima il·luminació';
      if (lowerName.contains('minvant') && !lowerName.contains('quart')) return 'Disminuint cap a la foscor';
      if (lowerName.contains('quart minvant') || lowerName.contains('últim quart')) return 'A mig camí cap a la lluna nova';
      return 'Fase lunar actual';
    }

    if (locale == 'es') {
      if (lowerName.contains('nueva')) return 'Comienzo del ciclo lunar';
      if (lowerName.contains('creciente') && !lowerName.contains('cuarto')) return 'Creciendo hacia la plenitud';
      if (lowerName.contains('cuarto creciente') || lowerName.contains('primer cuarto')) return 'A mitad de camino hacia la luna llena';
      if (lowerName.contains('llena')) return 'Máxima iluminación';
      if (lowerName.contains('menguante') && !lowerName.contains('cuarto')) return 'Disminuyendo hacia la oscuridad';
      if (lowerName.contains('cuarto menguante') || lowerName.contains('último cuarto')) return 'A mitad de camino hacia la luna nueva';
      return 'Fase lunar actual';
    }

    if (lowerName.contains('new')) return 'Beginning of lunar cycle';
    if (lowerName.contains('waxing') && !lowerName.contains('first')) return 'Growing toward fullness';
    if (lowerName.contains('first quarter')) return 'Halfway to full moon';
    if (lowerName.contains('full')) return 'Maximum illumination';
    if (lowerName.contains('waning') && !lowerName.contains('last')) return 'Decreasing toward darkness';
    if (lowerName.contains('last quarter')) return 'Halfway to new moon';
    return 'Current lunar phase';
  }

  String _getSimpleElement(String element, String locale) {
    final lowerElement = element.toLowerCase();

    if (locale == 'ca') {
      if (lowerElement.contains('fire') || lowerElement.contains('foc')) return 'Foc';
      if (lowerElement.contains('earth') || lowerElement.contains('terra')) return 'Terra';
      if (lowerElement.contains('air') || lowerElement.contains('aire')) return 'Aire';
      if (lowerElement.contains('water') || lowerElement.contains('aigua')) return 'Aigua';
      return element;
    }

    if (locale == 'es') {
      if (lowerElement.contains('fire') || lowerElement.contains('fuego')) return 'Fuego';
      if (lowerElement.contains('earth') || lowerElement.contains('tierra')) return 'Tierra';
      if (lowerElement.contains('air') || lowerElement.contains('aire')) return 'Aire';
      if (lowerElement.contains('water') || lowerElement.contains('agua')) return 'Agua';
      return element;
    }

    if (lowerElement.contains('foc') || lowerElement.contains('fuego')) return 'Fire';
    if (lowerElement.contains('terra') || lowerElement.contains('tierra')) return 'Earth';
    if (lowerElement.contains('aire')) return 'Air';
    if (lowerElement.contains('aigua') || lowerElement.contains('agua')) return 'Water';
    return element;
  }

  String _getIlluminatedText(String locale) {
    switch (locale) {
      case 'ca':
        return 'il·luminada';
      case 'es':
        return 'iluminada';
      default:
        return 'illuminated';
    }
  }

  String _getElementLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Element';
      case 'es':
        return 'Elemento';
      default:
        return 'Element';
    }
  }

  String _getPhaseEnergy(String phaseName, String locale) {
    final lowerName = phaseName.toLowerCase();

    if (locale == 'ca') {
      if (lowerName.contains('nova')) return '⚡ Moment per començar i plantar llavors';
      if (lowerName.contains('creixent') && !lowerName.contains('quart')) return '⚡ Moment per créixer i expandir projectes';
      if (lowerName.contains('quart creixent') || lowerName.contains('primer quart')) return '⚡ Moment per superar obstacles i actuar';
      if (lowerName.contains('plena')) return '⚡ Moment de culminació i celebració';
      if (lowerName.contains('gibosa minvant')) return '⚡ Moment per compartir i transmetre';
      if (lowerName.contains('quart minvant') || lowerName.contains('últim quart')) return '⚡ Moment per deixar anar i alliberar';
      if (lowerName.contains('minvant')) return '⚡ Moment per descansar i reflexionar';
      return '⚡ Energia lunar activa';
    }

    if (locale == 'es') {
      if (lowerName.contains('nueva')) return '⚡ Momento para empezar y plantar semillas';
      if (lowerName.contains('creciente') && !lowerName.contains('cuarto')) return '⚡ Momento para crecer y expandir proyectos';
      if (lowerName.contains('cuarto creciente') || lowerName.contains('primer cuarto')) return '⚡ Momento para superar obstáculos y actuar';
      if (lowerName.contains('llena')) return '⚡ Momento de culminación y celebración';
      if (lowerName.contains('gibosa menguante')) return '⚡ Momento para compartir y transmitir';
      if (lowerName.contains('cuarto menguante') || lowerName.contains('último cuarto')) return '⚡ Momento para soltar y liberar';
      if (lowerName.contains('menguante')) return '⚡ Momento para descansar y reflexionar';
      return '⚡ Energía lunar activa';
    }

    if (lowerName.contains('new')) return '⚡ Time to begin and plant seeds';
    if (lowerName.contains('waxing') && !lowerName.contains('first')) return '⚡ Time to grow and expand projects';
    if (lowerName.contains('first quarter')) return '⚡ Time to overcome obstacles and act';
    if (lowerName.contains('full')) return '⚡ Time of culmination and celebration';
    if (lowerName.contains('waning gibbous')) return '⚡ Time to share and transmit';
    if (lowerName.contains('last quarter')) return '⚡ Time to release and let go';
    if (lowerName.contains('waning')) return '⚡ Time to rest and reflect';
    return '⚡ Active lunar energy';
  }

  String _getNextMajorPhase(LunarInfoHelper lunarInfo, String locale) {
    final nextPhase = lunarInfo.nextPhase;
    final daysToNext = lunarInfo.daysToNext;

    if (locale == 'ca') {
      return '🔜 $nextPhase en $daysToNext dies';
    } else if (locale == 'es') {
      return '🔜 $nextPhase en $daysToNext días';
    } else {
      return '🔜 $nextPhase in $daysToNext days';
    }
  }

  String _getCalendarButtonText(String locale) {
    switch (locale) {
      case 'ca':
        return 'Calendari';
      case 'es':
        return 'Calendario';
      default:
        return 'Calendar';
    }
  }

  void _onCalendarTap() {
    // Canviar al tab "Next Phases" (index 1)
    _tabController.animateTo(1);
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
              _buildTab(getLunarTabLabel('guide', widget.strings.localeName), Icons.auto_awesome),
              _buildTab(getLunarTabLabel('spreads', widget.strings.localeName), Icons.style),
              _buildTab(getLunarTabLabel('rituals', widget.strings.localeName), Icons.wb_twilight),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // TabBarView content - matched to lunar phase container height
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 150,
            maxHeight: 190,
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              GuideTab(
                day: widget.day,
                strings: widget.strings,
              ),
              SpreadsTab(
                day: widget.day,
                strings: widget.strings,
              ),
              RitualsTab(
                day: widget.day,
                strings: widget.strings,
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

  Widget _buildLunarTimeline(String locale) {
    final milestones = _calculateTimelineMilestones(locale);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < milestones.length; i++)
            _buildTimelineMilestone(
              milestones[i],
              isFirst: i == 0,
              isLast: i == milestones.length - 1,
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineMilestone(
    Map<String, dynamic> milestone, {
    required bool isFirst,
    required bool isLast,
  }) {
    final isCurrent = milestone['isCurrent'] as bool;
    final emoji = milestone['emoji'] as String;
    final phaseName = milestone['phaseName'] as String;
    final dateLabel = milestone['dateLabel'] as String;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Emoji with halo
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.25),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 6),
          // Phase name
          Text(
            phaseName,
            style: TextStyle(
              color: isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.7),
              fontSize: 10,
              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3),
          // Date
          Text(
            dateLabel,
            style: TextStyle(
              color: isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.6),
              fontSize: 9,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _calculateTimelineMilestones(String locale) {
    final currentAge = widget.day.age;
    final currentDate = widget.day.date;
    final lunarCycle = 29.53;

    // Phase definitions
    final phases = [
      {'id': 'new_moon', 'emoji': '🌑', 'age': 0.0},
      {'id': 'first_quarter', 'emoji': '🌓', 'age': 7.4},
      {'id': 'full_moon', 'emoji': '🌕', 'age': 14.8},
      {'id': 'last_quarter', 'emoji': '🌗', 'age': 22.1},
    ];

    final milestones = <Map<String, dynamic>>[];

    // For each of the next 4 phases
    for (int i = 0; i < 4; i++) {
      // Which phase in the sequence (0-3)
      final phaseIndex = ((currentAge / 7.4).floor() + 1 + i) % 4;
      final phase = phases[phaseIndex];
      final phaseAge = phase['age'] as double;

      // Calculate target age in cycle
      final cycleNumber = ((currentAge / 7.4).floor() + 1 + i) ~/ 4;
      final targetAge = phaseAge + (cycleNumber * lunarCycle);

      // Days until this phase
      final daysUntil = targetAge - currentAge;
      final phaseDate = currentDate.add(Duration(days: daysUntil.round()));

      milestones.add({
        'phaseId': phase['id'] as String,
        'phaseName': _getPhaseNameLocalized(phase['id'] as String, locale),
        'emoji': phase['emoji'] as String,
        'date': phaseDate,
        'dateLabel': _formatDateLabel(phaseDate, locale),
        'isCurrent': i == 0,
      });
    }

    return milestones;
  }

  bool _isCurrentPhase(double age, int phaseIndex) {
    final ranges = [
      [0.0, 3.7],
      [3.7, 11.1],
      [11.1, 18.4],
      [18.4, 25.8],
    ];

    if (phaseIndex < ranges.length) {
      return age >= ranges[phaseIndex][0] && age < ranges[phaseIndex][1];
    }

    return age >= 25.8 && phaseIndex == 0;
  }

  String _getPhaseNameLocalized(String phaseId, String locale) {
    final names = {
      'new_moon': {'en': 'New', 'es': 'Nueva', 'ca': 'Nova'},
      'first_quarter': {'en': 'First', 'es': 'Crec.', 'ca': 'Creix.'},
      'full_moon': {'en': 'Full', 'es': 'Llena', 'ca': 'Plena'},
      'last_quarter': {'en': 'Last', 'es': 'Meng.', 'ca': 'Minv.'},
    };

    return names[phaseId]?[locale] ?? names[phaseId]?['en'] ?? phaseId;
  }

  String _formatDateLabel(DateTime date, String locale) {
    final months = {
      'en': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
      'es': ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
      'ca': ['Gen', 'Feb', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Oct', 'Nov', 'Des'],
    };

    final monthList = months[locale] ?? months['en']!;
    return '${monthList[date.month - 1]} ${date.day}';
  }
}
