import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/tarot_spread.dart';
import '../models/tarot_card.dart';
import '../utils/card_image_mapper.dart';
import '../utils/card_name_localizer.dart';
import '../theme/tarot_theme.dart';

class SpreadLayout extends StatelessWidget {
  final TarotSpread spread;
  final List<TarotCard> cards;
  final double maxWidth;
  final double maxHeight;
  final int? dealtCardCount;
  final int? revealedCardCount;
  final Duration flipDuration;
  final String locale;
  final bool hasInterpretation;

  const SpreadLayout({
    super.key,
    required this.spread,
    required this.cards,
    required this.maxWidth,
    required this.maxHeight,
    this.dealtCardCount,
    this.revealedCardCount,
    this.flipDuration = const Duration(milliseconds: 450),
    this.locale = 'es',
    this.hasInterpretation = false,
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
    final bool hasCards = cards.isNotEmpty;

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: Stack(
        children: [
          // ALWAYS show placeholders as background for positions that haven't been dealt yet
          for (int i = 0; i < spread.positions.length; i++)
            if (!hasCards || i >= dealtCards)
              _buildPositionedPlaceholder(
                cardNumber: i + 1,
                position: spread.positions[i],
                containerWidth: effectiveWidth,
                containerHeight: effectiveHeight,
                cardWidth: cardWidth,
                cardHeight: cardHeight,
              ),
          // Show actual cards on top
          if (hasCards)
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

    // Get localized card name
    final String localizedName = CardNameLocalizer.localize(card.name, locale);

    // Wrap card with column to add name label below when revealed
    final Widget cardWithLabel = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _AnimatedTarotCard(
          key: ValueKey('tarot-card-$index-${card.name}'),
          width: cardWidth,
          height: cardHeight,
          front: frontFace,
          back: backFace,
          isFaceUp: isFaceUp,
          duration: flipDuration,
        ),
        // Show card name only when revealed (face up) AND interpretation has been requested
        if (isFaceUp && hasInterpretation) ...[
          const SizedBox(height: 6),
          SizedBox(
            width: cardWidth,
            child: Text(
              localizedName.toUpperCase(),
              style: TextStyle(
                fontSize: math.min(cardWidth * 0.11, 10),
                fontWeight: FontWeight.w600,
                color: TarotTheme.moonlight.withOpacity(0.9),
                letterSpacing: 0.5,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      left: left,
      top: top,
      child: Transform.rotate(
        angle: baseRotation * math.pi / 180,
        child: cardWithLabel,
      ),
    );
  }

  Widget _buildPositionedPlaceholder({
    required int cardNumber,
    required CardPosition position,
    required double containerWidth,
    required double containerHeight,
    required double cardWidth,
    required double cardHeight,
  }) {
    final double left = (position.x * containerWidth) - (cardWidth / 2);
    final double top = (position.y * containerHeight) - (cardHeight / 2);

    return Positioned(
      left: left,
      top: top,
      child: Transform.rotate(
        angle: position.rotation * math.pi / 180,
        child: _buildPlaceholderCard(
          cardNumber: cardNumber,
          position: position,
          width: cardWidth,
          height: cardHeight,
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

  Widget _buildPlaceholderCard({
    required int cardNumber,
    required CardPosition position,
    required double width,
    required double height,
  }) {
    final placeholderWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: TarotTheme.deepNight.withOpacity(0.3),
        border: Border.all(
          color: TarotTheme.twilightPurple.withOpacity(0.6),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: TarotTheme.cosmicAccent.withOpacity(0.7),
          strokeWidth: 2,
          dashWidth: 8,
          dashSpace: 4,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Card number
            Text(
              cardNumber.toString(),
              style: TextStyle(
                fontSize: math.min(width * 0.4, 48),
                fontWeight: FontWeight.w300,
                color: TarotTheme.stardust.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            // Position label
            if (position.label != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  position.label!,
                  style: TextStyle(
                    fontSize: math.min(width * 0.12, 14),
                    fontWeight: FontWeight.w500,
                    color: TarotTheme.cosmicAccent.withOpacity(0.9),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );

    // Wrap with tooltip if there's a description
    if (position.description != null) {
      return Tooltip(
        message: position.description!,
        preferBelow: false,
        verticalOffset: 10,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: TarotTheme.midnightBlue.withOpacity(0.95),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: TarotTheme.cosmicAccent.withOpacity(0.3),
            width: 1,
          ),
        ),
        textStyle: TextStyle(
          fontSize: 12,
          color: TarotTheme.moonlight,
          height: 1.4,
        ),
        child: placeholderWidget,
      );
    }

    return placeholderWidget;
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

/// Custom painter for dashed border
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(4),
      ),
    );

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = math.min(distance + dashWidth, metric.length);
        final segment = metric.extractPath(distance, nextDistance);
        canvas.drawPath(segment, paint);
        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
