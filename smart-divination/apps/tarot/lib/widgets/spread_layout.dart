import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/tarot_spread.dart';
import '../models/tarot_card.dart';
import '../utils/card_image_mapper.dart';
import '../theme/tarot_theme.dart';

class SpreadLayout extends StatelessWidget {
  final TarotSpread spread;
  final List<TarotCard> cards;
  final double maxWidth;
  final double maxHeight;
  final int? dealtCardCount;
  final int? revealedCardCount;
  final Duration flipDuration;

  const SpreadLayout({
    super.key,
    required this.spread,
    required this.cards,
    required this.maxWidth,
    required this.maxHeight,
    this.dealtCardCount,
    this.revealedCardCount,
    this.flipDuration = const Duration(milliseconds: 450),
  });

  @override
  Widget build(BuildContext context) {
    const double cardAspectRatio = 0.58;
    // Calculate container dimensions based on aspect ratio and available space
    // Try both width-constrained and height-constrained approaches and pick the larger one
    final double widthBasedHeight = maxWidth / spread.aspectRatio;
    final double heightBasedWidth = maxHeight * spread.aspectRatio;

    // Choose the dimension strategy that maximizes space utilization
    final double effectiveWidth;
    final double effectiveHeight;

    if (widthBasedHeight <= maxHeight) {
      // Width-constrained: use full width
      effectiveWidth = maxWidth;
      effectiveHeight = widthBasedHeight;
    } else {
      // Height-constrained: use full height
      effectiveHeight = maxHeight;
      effectiveWidth = heightBasedWidth;
    }

    final Size cardSize = _calculateCardSize(
      spread,
      effectiveWidth,
      effectiveHeight,
      cardAspectRatio,
    );
    final double cardWidth = cardSize.width;
    final double cardHeight = cardSize.height;

        final int dealtCards = dealtCardCount ?? cards.length;
    final int visibleCards = revealedCardCount ?? cards.length;

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: Stack(
        children: [
          for (int i = 0; i < cards.length && i < spread.positions.length; i++)
            _buildPositionedCard(
              card: cards[i],
              index: i,
              position: spread.positions[i],
              containerWidth: effectiveWidth,
              containerHeight: effectiveHeight,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
              isDealt: i < dealtCards,
              isFaceUp: i < visibleCards,
            ),
        ],
      ),
    );
  }

  Size _calculateCardSize(
    TarotSpread spread,
    double containerWidth,
    double containerHeight,
    double cardAspectRatio,
  ) {
    final double verticalCardHeight =
        _calculateCardHeight(spread, containerHeight);
    final double widthFromHeight = verticalCardHeight * cardAspectRatio;
    final double widthFromSpacing =
        _maxCardWidthFromSpacing(spread, containerWidth);

    double cardWidth = math.min(widthFromHeight, widthFromSpacing);

    if (spread.cardCount == 3) {
      final double targetWidth = containerWidth / 1.8;
      cardWidth = math.min(cardWidth, targetWidth);
    }

    final double cardHeight = cardWidth / cardAspectRatio;
    return Size(cardWidth, cardHeight);
  }

  double _calculateCardHeight(TarotSpread spread, double containerHeight) {
    // Calculate optimal card height based on number of cards and layout
    // Maximized for better visual impact and space utilization
    if (spread.cardCount == 1) {
      // Single card: Make it very prominent and visually striking
      return containerHeight * 0.90;
    } else if (spread.cardCount == 3) {
      // Three cards: Make them large and prominent to appreciate details
      return containerHeight * 0.92;
    } else if (spread.cardCount <= 5) {
      // Small spreads (4-5 cards): Large and comfortable viewing size
      return containerHeight * 0.58;
    } else if (spread.cardCount <= 7) {
      // Medium spreads (6-7 cards): Balanced and well-sized
      return containerHeight * 0.45;
    } else if (spread.cardCount <= 10) {
      // Large spreads (8-10 cards): Still readable and detailed
      return containerHeight * 0.35;
    } else {
      // Very large spreads (11+ cards): Compact but ensure everything fits
      return containerHeight * 0.28;
    }
  }

  double _maxCardWidthFromSpacing(TarotSpread spread, double containerWidth) {
    if (spread.positions.isEmpty) {
      return containerWidth;
    }

    final double spacingFactor = spread.cardCount <= 3 ? 1.0 : 0.90;
    double limit = containerWidth;

    for (final position in spread.positions) {
      final double availableLeft = position.x * containerWidth * 2;
      final double availableRight = (1 - position.x) * containerWidth * 2;
      limit = math.min(limit, availableLeft);
      limit = math.min(limit, availableRight);
    }

    for (int i = 0; i < spread.positions.length - 1; i++) {
      for (int j = i + 1; j < spread.positions.length; j++) {
        final double centerDistance =
            (spread.positions[i].x - spread.positions[j].x).abs() *
                containerWidth;
        if (centerDistance > 0) {
          limit = math.min(limit, centerDistance * spacingFactor);
        }
      }
    }

    return limit.clamp(0.0, containerWidth).toDouble();
  }

  Widget _buildPositionedCard({
    required TarotCard card,
    required int index,
    required CardPosition position,
    required double containerWidth,
    required double containerHeight,
    required double cardWidth,
    required double cardHeight,
    required bool isDealt,
    required bool isFaceUp,
  }) {
    final double left = (position.x * containerWidth) - (cardWidth / 2);
    final double finalTop = (position.y * containerHeight) - (cardHeight / 2);
    final double top = isDealt ? finalTop : -(cardHeight + 100);

    final bool isReversed = card.upright == false;
    final double baseRotation = position.rotation;

    final Widget frontSurface =
        _buildCardWidget(card, cardWidth, cardHeight, false);
    final Widget orientedFront = isReversed
        ? Transform.rotate(angle: math.pi, child: frontSurface)
        : frontSurface;

    final Widget frontFace = Stack(
      clipBehavior: Clip.none,
      children: [
        orientedFront,
        if (isReversed)
          Positioned(
            top: 6,
            right: 6,
            child: _buildReversedIcon(),
          ),
      ],
    );

    final Widget backFace =
        _buildCardWidget(card, cardWidth, cardHeight, true);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      left: left,
      top: top,
      child: Transform.rotate(
        angle: baseRotation * math.pi / 180,
        child: _AnimatedTarotCard(
          key: ValueKey('tarot-card-$index-${card.name}'),
          width: cardWidth,
          height: cardHeight,
          front: frontFace,
          back: backFace,
          isFaceUp: isFaceUp,
          duration: flipDuration,
        ),
      ),
    );
  }

  Widget _buildReversedIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: TarotTheme.cosmicAccent.withOpacity(0.9),
        shape: BoxShape.circle,
        border: Border.all(
          color: TarotTheme.twilightPurple,
          width: 1.5,
        ),
        boxShadow: TarotTheme.subtleShadow,
      ),
      child: Icon(
        Icons.sync,
        size: 14,
        color: TarotTheme.deepNight,
      ),
    );
  }

  Widget _buildCardWidget(
      TarotCard card, double width, double height, bool showCardBack) {
    // Use the back artwork when showing card backs
    if (showCardBack) {
      // Use SVG for card back
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: TarotTheme.twilightPurple.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: TarotTheme.elevatedShadow,
        ),
        clipBehavior: Clip.hardEdge,
        child: SvgPicture.asset(
          'assets/cards/card-back.svg',
          fit: BoxFit.cover,
          placeholderBuilder: (context) => Container(
            color: TarotTheme.midnightBlue,
            child: Center(
              child: Icon(Icons.back_hand,
                  color: TarotTheme.cosmicAccent, size: width * 0.3),
            ),
          ),
        ),
      );
    }

    // Use JPG for card fronts
    final String imagePath = card.imageUrl ??
        CardImageMapper.getCardImagePath(card.name, card.suit);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: TarotTheme.twilightPurple.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: TarotTheme.elevatedShadow,
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildCardFallback(card, width, height);
        },
      ),
    );
  }

  Widget _buildCardFallback(TarotCard card, double width, double height) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            card.name,
            style: TextStyle(
              fontSize: width * 0.1,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (card.suit != null) ...[
            const SizedBox(height: 4),
            Text(
              card.suit!,
              style: TextStyle(
                fontSize: width * 0.08,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (card.upright == false) ...[
            const SizedBox(height: 4),
            Text(
              'Reversed',
              style: TextStyle(
                fontSize: width * 0.08,
                fontStyle: FontStyle.italic,
                color: Colors.red.shade700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AnimatedTarotCard extends StatefulWidget {
  const _AnimatedTarotCard({
    super.key,
    required this.width,
    required this.height,
    required this.front,
    required this.back,
    required this.isFaceUp,
    required this.duration,
  });

  final double width;
  final double height;
  final Widget front;
  final Widget back;
  final bool isFaceUp;
  final Duration duration;

  @override
  State<_AnimatedTarotCard> createState() => _AnimatedTarotCardState();
}

class _AnimatedTarotCardState extends State<_AnimatedTarotCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    if (widget.isFaceUp) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant _AnimatedTarotCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFaceUp != widget.isFaceUp) {
      if (widget.isFaceUp) {
        _controller.forward(from: 0);
      } else {
        _controller.reverse(from: 1);
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double angle = math.pi * (1 - _animation.value);
        final bool showFront = angle <= math.pi / 2;

        Widget display = showFront ? widget.front : widget.back;
        if (!showFront) {
          display = Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(math.pi),
            child: display,
          );
        }

        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: display,
          ),
        );
      },
    );
  }
}
