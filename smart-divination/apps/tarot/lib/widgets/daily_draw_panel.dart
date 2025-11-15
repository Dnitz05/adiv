import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../models/tarot_card.dart';
import '../theme/tarot_theme.dart';
import '../l10n/lunar/lunar_translations.dart';

class DailyDrawPanel extends StatefulWidget {
  const DailyDrawPanel({
    super.key,
    required this.cards,
    required this.strings,
    this.onInterpret,
    this.isLoading = false,
  });

  final List<TarotCard> cards;
  final CommonStrings strings;
  final VoidCallback? onInterpret;
  final bool isLoading;

  @override
  State<DailyDrawPanel> createState() => _DailyDrawPanelState();
}

class _DailyDrawPanelState extends State<DailyDrawPanel> {
  final Set<int> _flippedCards = {};

  @override
  void initState() {
    super.initState();
    _loadFlippedCards();
  }

  Future<void> _loadFlippedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final key = 'daily_draw_flipped_$today';
    final savedCards = prefs.getStringList(key);
    if (savedCards != null) {
      setState(() {
        _flippedCards.addAll(savedCards.map((s) => int.parse(s)));
      });
    }
  }

  Future<void> _saveFlippedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final key = 'daily_draw_flipped_$today';
    await prefs.setStringList(key, _flippedCards.map((i) => i.toString()).toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allFlipped = _flippedCards.length == widget.cards.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
              children: [
                Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      TarotTheme.cosmicBlue,
                      TarotTheme.cosmicAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.sunny,
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
                      _getDailyDrawTitle(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: TarotTheme.deepNavy,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getDailyDrawSubtitle(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: TarotTheme.softBlueGrey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < widget.cards.length; i++) ...[
                        if (i > 0) const SizedBox(width: 4),
                        Expanded(
                          child: widget.isLoading
                              ? const SizedBox.shrink()
                              : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 2 / 3,
                                    child: _FlippableCard(
                                      card: widget.cards[i],
                                      isFlipped: _flippedCards.contains(i),
                                      onTap: () {
                                        setState(() {
                                          if (_flippedCards.contains(i)) {
                                            _flippedCards.remove(i);
                                          } else {
                                            _flippedCards.add(i);
                                          }
                                        });
                                        _saveFlippedCards();
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Text(
                                      _flippedCards.contains(i)
                                          ? widget.cards[i].name
                                          : _getPositionLabel(i),
                                      key: ValueKey(_flippedCards.contains(i)),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontSize: 11,
                                        color: TarotTheme.softBlueGrey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                        ),
                      ],
                    ],
                  ),
                  if (widget.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                          color: TarotTheme.brightBlue,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          if (!allFlipped && !widget.isLoading) ...[
            const SizedBox(height: 4),
            InkWell(
                onTap: _revealAllCards,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
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
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.visibility, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      _getRevealButtonText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (allFlipped && !widget.isLoading) ...[
            const SizedBox(height: 4),
            InkWell(
                onTap: widget.onInterpret,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      TarotTheme.brightBlue,
                      TarotTheme.cosmicAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.psychology, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      _getInterpretButtonText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _revealAllCards() {
    setState(() {
      for (int i = 0; i < widget.cards.length; i++) {
        _flippedCards.add(i);
      }
    });
    _saveFlippedCards();
  }

  String _getDailyDrawTitle() {
    switch (widget.strings.localeName) {
      case 'ca':
        return 'Tirada del Dia';
      case 'es':
        return 'Tirada del Día';
      default:
        return 'Daily Draw';
    }
  }

  String _getDailyDrawSubtitle() {
    final now = DateTime.now();
    final formattedDate = formatFullDate(now, widget.strings.localeName);

    switch (widget.strings.localeName) {
      case 'ca':
        return 'Avui, $formattedDate';
      case 'es':
        return 'Hoy, $formattedDate';
      default:
        return 'Today, $formattedDate';
    }
  }

  String _getInterpretButtonText() {
    switch (widget.strings.localeName) {
      case 'ca':
        return 'Interpretació';
      case 'es':
        return 'Interpretación';
      default:
        return 'Interpretation';
    }
  }
  String _getRevealButtonText() {
    switch (widget.strings.localeName) {
      case 'ca':
        return 'Revelar Cartes';
      case 'es':
        return 'Revelar Cartas';
      default:
        return 'Reveal Cards';
    }
  }

  String _getPositionLabel(int index) {
    final positions = {
      'en': ['Past', 'Present', 'Future'],
      'es': ['Pasado', 'Presente', 'Futuro'],
      'ca': ['Passat', 'Present', 'Futur'],
    };
    final locale = widget.strings.localeName;
    final labels = positions[locale] ?? positions['en']!;
    return index < labels.length ? labels[index] : '';
  }

}

class _FlippableCard extends StatefulWidget {
  const _FlippableCard({
    required this.card,
    required this.isFlipped,
    required this.onTap,
  });

  final TarotCard card;
  final bool isFlipped;
  final VoidCallback onTap;

  @override
  State<_FlippableCard> createState() => _FlippableCardState();
}

class _FlippableCardState extends State<_FlippableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(_FlippableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
          final isFront = angle < math.pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront ? _buildCardBack() : _buildCardFront(),
          );
        },
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          // Main shadow for depth
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          // Secondary shadow for volume
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
          // Ambient shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: -8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Image.asset(
          'assets/cards/tarot_back_card.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Container(
            color: TarotTheme.cosmicBlue,
            child: Center(
              child: Icon(
                Icons.auto_awesome,
                color: Colors.white.withValues(alpha: 0.5),
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(math.pi),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          boxShadow: [
            // Main shadow for depth
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            // Secondary shadow for volume
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
              spreadRadius: -2,
            ),
            // Ambient shadow
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
              spreadRadius: -8,
            ),
          ],
        ),
        child: widget.card.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.asset(
                  widget.card.imageUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildCardPlaceholder(),
                ),
              )
            : _buildCardPlaceholder(),
      ),
    );
  }

  Widget _buildCardPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            !widget.card.upright ? Icons.swap_vert : Icons.auto_awesome,
            color: TarotTheme.cosmicPurple,
            size: 24,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.card.name,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: TarotTheme.cosmicPurple,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
