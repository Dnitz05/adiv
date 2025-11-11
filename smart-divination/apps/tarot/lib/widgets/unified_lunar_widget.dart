import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../models/lunar_day.dart';
import '../state/lunar_cycle_controller.dart';
import '../theme/tarot_theme.dart';
import '../l10n/lunar/lunar_translations.dart';
import 'lunar_card_helpers.dart';
import 'lunar_tabs/guide_tab.dart';
import 'lunar_tabs/next_phases_tab.dart';
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
    _tabController = TabController(length: 4, vsync: this);
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
        const SizedBox(width: 10),
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
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: TarotTheme.softBlueGrey.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
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
    final now = DateTime.now();
    final formattedDate = formatFullDate(now, locale);

    switch (locale) {
      case 'es':
        return 'Hoy, $formattedDate';
      case 'ca':
        return 'Avui, $formattedDate';
      default:
        return 'Today, $formattedDate';
    }
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRow1PhaseAndIllumination(lunarInfo, illumination, locale),
              const SizedBox(height: 10),
              _buildRow2AstroProperties(lunarInfo, locale),
              const SizedBox(height: 14),
              _buildCTAButton(locale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow1PhaseAndIllumination(LunarInfoHelper lunarInfo, double illumination, String locale) {
    return Row(
      children: [
        // Moon emoji with night sky background
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [
                Color(0xFF1A1A3E), // Deep night blue at center
                Color(0xFF0D0D1F), // Almost black at edges
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
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Phase name + trend + lunar day
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.day.phaseName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                lunarInfo.trend,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.brightness_3,
                    size: 11,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_getLunarDayLabel(locale)} ${widget.day.age.round()}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Illumination badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            '${illumination.round()}% ${_getLitText(locale)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow2AstroProperties(LunarInfoHelper lunarInfo, String locale) {
    final elementLabel = _getDidacticElement(widget.day.zodiac.element, locale);
    final inLabel = _getInLabel(locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Zodiac + Element
        Row(
          children: [
            Text(
              widget.day.zodiac.symbol,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              widget.day.zodiac.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              ' · ',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
              ),
            ),
            Text(
              elementLabel,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Polarity · Quality · Ruler (més didàctic)
        Text(
          '${_getDidacticPolarity(lunarInfo.polarity, locale)} · ${_getDidacticQuality(lunarInfo.quality, locale)} · ${_getDidacticRuler(lunarInfo.ruler, locale)}',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        // Next phase
        Row(
          children: [
            Icon(
              Icons.arrow_forward,
              size: 11,
              color: Colors.white.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '${lunarInfo.nextPhase} $inLabel ${lunarInfo.daysToNext} ${_getDaysLabel(lunarInfo.daysToNext, locale)}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow3Timeline(LunarInfoHelper lunarInfo, String locale) {
    final dayLabel = _getLunarDayLabel(locale);
    final inLabel = _getInLabel(locale);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Lunar day
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.brightness_3,
              size: 13,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              '$dayLabel ${widget.day.age.round()}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        // Next phase
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_forward,
              size: 13,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              '${lunarInfo.nextPhase} $inLabel ${lunarInfo.daysToNext} ${_getDaysLabel(lunarInfo.daysToNext, locale)}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCTAButton(String locale) {
    return InkWell(
      onTap: () => _onCalendarTap(),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF342B47), // Dark lilac (matching widget background)
              Color(0xFF473D5C), // Medium lilac
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getCalendarButtonText(locale),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
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
              _buildTab(getLunarTabLabel('next', widget.strings.localeName), Icons.arrow_forward),
              _buildTab(getLunarTabLabel('spreads', widget.strings.localeName), Icons.style),
              _buildTab(getLunarTabLabel('rituals', widget.strings.localeName), Icons.wb_twilight),
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
              GuideTab(
                day: widget.day,
                strings: widget.strings,
              ),
              NextPhasesTab(
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
}
