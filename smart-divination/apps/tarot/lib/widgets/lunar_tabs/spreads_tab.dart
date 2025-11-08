import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/lunar_day.dart';
import '../../models/lunar_spread.dart';
import '../../theme/tarot_theme.dart';
import '../lunar_card_helpers.dart';

class SpreadsTab extends StatefulWidget {
  const SpreadsTab({
    super.key,
    required this.day,
    required this.strings,
    this.onSelectSpread,
  });

  final LunarDayModel day;
  final CommonStrings strings;
  final void Function(String spreadId)? onSelectSpread;

  @override
  State<SpreadsTab> createState() => _SpreadsTabState();
}

class _SpreadsTabState extends State<SpreadsTab> {
  String _selectedFilter = 'phase'; // 'phase' or 'all'

  @override
  Widget build(BuildContext context) {
    final spreads = _selectedFilter == 'phase'
        ? LunarSpreadRepository.getSpreadsForPhase(widget.day.phaseId)
        : LunarSpreadRepository.getAllSpreads();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildFilters(),
          const SizedBox(height: 16),
          if (spreads.isEmpty)
            _buildNoSpreads()
          else
            ...spreads.map((spread) => _buildSpreadCard(spread, context)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return LunarCardHelpers.buildCardWithHeader(
      context: context,
      icon: Icons.style,
      title: _localisedLabel('header_title'),
      subtitle: _localisedLabel('header_subtitle'),
      content: const SizedBox.shrink(),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: _buildFilterChip(
            'phase',
            _localisedLabel('filter_phase'),
            _selectedFilter == 'phase',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildFilterChip(
            'all',
            _localisedLabel('filter_all'),
            _selectedFilter == 'all',
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? TarotTheme.brightBlue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? TarotTheme.brightBlue : TarotTheme.brightBlue20,
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : TarotTheme.deepNavy,
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNoSpreads() {
    return LunarCardHelpers.buildWhiteCard(
      context: context,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(
            Icons.info_outline,
            color: TarotTheme.softBlueGrey,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            _localisedLabel('no_spreads'),
            style: LunarCardHelpers.cardBodyStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSpreadCard(LunarSpread spread, BuildContext context) {
    final locale = widget.strings.localeName;
    return LunarCardHelpers.buildWhiteCard(
      context: context,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showSpreadDetails(spread, context),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      spread.iconEmoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            spread.getName(locale),
                            style: LunarCardHelpers.cardTitleStyle,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${spread.numberOfCards} ${_localisedLabel('cards')}',
                            style: LunarCardHelpers.cardSmallStyle.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: TarotTheme.softBlueGrey,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  spread.getDescription(locale),
                  style: LunarCardHelpers.cardBodyStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  spread.getSource(locale),
                  style: LunarCardHelpers.cardSmallStyle.copyWith(
                    color: TarotTheme.brightBlue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSpreadDetails(LunarSpread spread, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SpreadDetailsSheet(
        spread: spread,
        locale: widget.strings.localeName,
      ),
    );
  }

  String _localisedLabel(String key) {
    final locale = widget.strings.localeName;
    final labels = {
      'header_title': {
        'en': 'Tarot Spreads',
        'es': 'Tiradas de Tarot',
        'ca': 'Tirades de Tarot'
      },
      'header_subtitle': {
        'en': 'Authentic lunar spreads from established traditions',
        'es': 'Tiradas lunares auténticas de tradiciones establecidas',
        'ca': 'Tirades lunars autèntiques de tradicions establertes'
      },
      'filter_phase': {
        'en': 'For This Phase',
        'es': 'Para Esta Fase',
        'ca': 'Per Aquesta Fase'
      },
      'filter_all': {'en': 'All Spreads', 'es': 'Todas', 'ca': 'Totes'},
      'cards': {'en': 'cards', 'es': 'cartas', 'ca': 'cartes'},
      'no_spreads': {
        'en': 'No spreads available for this moon phase. Try "All Spreads".',
        'es': 'No hay tiradas disponibles para esta fase lunar. Prueba "Todas".',
        'ca': 'No hi ha tirades disponibles per aquesta fase lunar. Prova "Totes".'
      },
    };
    return labels[key]?[locale] ?? labels[key]?['en'] ?? key;
  }
}

// Spread Details Bottom Sheet
class _SpreadDetailsSheet extends StatelessWidget {
  const _SpreadDetailsSheet({
    required this.spread,
    required this.locale,
  });

  final LunarSpread spread;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              _buildHandle(),
              const SizedBox(height: 8),
              _buildHeader(),
              const SizedBox(height: 24),
              _buildDescription(),
              const SizedBox(height: 24),
              _buildPositions(),
              const SizedBox(height: 24),
              _buildSource(context),
              const SizedBox(height: 32),
              _buildUseButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                TarotTheme.cosmicPurple.withValues(alpha: 0.4),
                TarotTheme.cosmicBlue.withValues(alpha: 0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            spread.iconEmoji,
            style: const TextStyle(fontSize: 40),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                spread.getName(locale),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${spread.numberOfCards} ${_localisedLabel('cards')}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      spread.getDescription(locale),
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.85),
        fontSize: 15,
        height: 1.5,
      ),
    );
  }

  Widget _buildPositions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.map,
              color: TarotTheme.cosmicAccent,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              _localisedLabel('positions'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...spread.positions.map((position) => _buildPosition(position)),
      ],
    );
  }

  Widget _buildPosition(SpreadPosition position) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TarotTheme.midnightBlue.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  TarotTheme.cosmicPurple,
                  TarotTheme.cosmicBlue,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${position.order}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              position.getQuestion(locale),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSource(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TarotTheme.cosmicAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.book,
                color: TarotTheme.cosmicAccent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                spread.getSource(locale),
                style: TextStyle(
                  color: TarotTheme.cosmicAccent.withValues(alpha: 0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final uri = Uri.parse(spread.sourceUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: Text(
              spread.sourceUrl,
              style: TextStyle(
                color: TarotTheme.cosmicBlue.withValues(alpha: 0.8),
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUseButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        // TODO: Navigate to tarot reading with this spread
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: TarotTheme.cosmicPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        _localisedLabel('use_spread'),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _localisedLabel(String key) {
    final labels = {
      'cards': {'en': 'cards', 'es': 'cartas', 'ca': 'cartes'},
      'positions': {
        'en': 'Card Positions',
        'es': 'Posiciones de Cartas',
        'ca': 'Posicions de Cartes'
      },
      'use_spread': {
        'en': 'Use This Spread',
        'es': 'Usar Esta Tirada',
        'ca': 'Usar Aquesta Tirada'
      },
    };
    return labels[key]?[locale] ?? labels[key]?['en'] ?? key;
  }
}
