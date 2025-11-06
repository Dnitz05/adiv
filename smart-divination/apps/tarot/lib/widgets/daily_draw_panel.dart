import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../models/tarot_card.dart';
import '../theme/tarot_theme.dart';

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allFlipped = _flippedCards.length == widget.cards.length;

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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
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
                child: Icon(
                  Icons.auto_awesome,
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
                        color: TarotTheme.midnightBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getDailyDrawSubtitle(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: widget.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: TarotTheme.cosmicAccent,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < widget.cards.length; i++)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
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
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          if (allFlipped && !widget.isLoading) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: widget.onInterpret,
              style: FilledButton.styleFrom(
                backgroundColor: TarotTheme.cosmicBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.psychology, size: 20),
              label: Text(
                _getInterpretButtonText(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ],
      ),
    );
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
    switch (widget.strings.localeName) {
      case 'ca':
        return 'Toca les cartes per revelar-les';
      case 'es':
        return 'Toca las cartas para revelarlas';
      default:
        return 'Tap cards to reveal them';
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
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TarotTheme.cosmicBlue.withValues(alpha: 0.8),
            TarotTheme.cosmicPurple.withValues(alpha: 0.8),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome,
          color: Colors.white.withValues(alpha: 0.5),
          size: 32,
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
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(
            color: TarotTheme.cosmicAccent.withValues(alpha: 0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: widget.card.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  widget.card.imageUrl!,
                  fit: BoxFit.cover,
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
