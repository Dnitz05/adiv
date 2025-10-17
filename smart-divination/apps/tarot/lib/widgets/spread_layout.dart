import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/tarot_spread.dart';
import '../models/tarot_card.dart';
import '../utils/card_image_mapper.dart';
import '../theme/tarot_theme.dart';

class SpreadLayout extends StatelessWidget {
  final TarotSpread spread;
  final List<TarotCard> cards;
  final double maxWidth;
  final double maxHeight;
  final bool showCardBacks; // When true, show the card backs

  const SpreadLayout({
    super.key,
    required this.spread,
    required this.cards,
    required this.maxWidth,
    required this.maxHeight,
    this.showCardBacks = false, // Per defecte mostra les cartes
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

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: Stack(
        children: [
          for (int i = 0; i < cards.length && i < spread.positions.length; i++)
            _buildPositionedCard(
              cards[i],
              spread.positions[i],
              effectiveWidth,
              effectiveHeight,
              cardWidth,
              cardHeight,
              showCardBacks, // Pass the parameter through
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

  Widget _buildPositionedCard(
    TarotCard card,
    CardPosition position,
    double containerWidth,
    double containerHeight,
    double cardWidth,
    double cardHeight,
    bool showCardBack,
  ) {
    final double left = (position.x * containerWidth) - (cardWidth / 2);
    final double top = (position.y * containerHeight) - (cardHeight / 2);

    final bool isReversed = card.upright == false;
    final double baseRotation = position.rotation;

    return Positioned(
      left: left,
      top: top,
      child: Transform.rotate(
        angle: baseRotation * math.pi / 180,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: 0,
            end: showCardBack ? math.pi : 0,
          ),
          duration: showCardBack
              ? Duration.zero
              : const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          builder: (context, angle, child) {
            final bool showFrontFace = angle <= math.pi / 2;
            final Widget cardFace = showFrontFace
                ? _buildCardWidget(card, cardWidth, cardHeight, false)
                : _buildCardWidget(card, cardWidth, cardHeight, true);

            final Widget rotatedFace = showFrontFace && isReversed
                ? Transform.rotate(
                    angle: math.pi,
                    child: cardFace,
                  )
                : cardFace;

            final Widget visibleFace = showFrontFace
                ? rotatedFace
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: rotatedFace,
                  );

            return SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: visibleFace,
                  ),
                  if (showFrontFace && isReversed)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: _buildReversedIcon(),
                    ),
                ],
              ),
            );
          },
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
    final String imagePath = showCardBack
        ? 'assets/cards/CardBacks.jpg'
        : (card.imageUrl ??
            CardImageMapper.getCardImagePath(card.name, card.suit));

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
          // If the back image fails, display a dark fallback container
          if (showCardBack) {
            return Container(
              color: TarotTheme.midnightBlue,
              child: Center(
                child: Icon(Icons.back_hand,
                    color: TarotTheme.cosmicAccent, size: width * 0.3),
              ),
            );
          }
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

