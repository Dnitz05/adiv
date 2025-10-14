import 'package:flutter/material.dart';
import '../models/tarot_spread.dart';
import '../models/tarot_card.dart';

class SpreadLayout extends StatelessWidget {
  final TarotSpread spread;
  final List<TarotCard> cards;
  final double maxWidth;
  final double maxHeight;

  const SpreadLayout({
    super.key,
    required this.spread,
    required this.cards,
    required this.maxWidth,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
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

    // Calculate card size based on spread
    final double cardHeight = _calculateCardHeight(spread, effectiveHeight);
    final double cardWidth = cardHeight * 0.7; // Standard tarot card ratio

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
            ),
        ],
      ),
    );
  }

  double _calculateCardHeight(TarotSpread spread, double containerHeight) {
    // Calculate optimal card height based on number of cards and layout
    // Maximized for better visual impact and space utilization
    if (spread.cardCount == 1) {
      // Single card: Make it very prominent and visually striking
      return containerHeight * 0.90;
    } else if (spread.cardCount == 3) {
      // Three cards: Make them large and prominent to appreciate details
      return containerHeight * 0.80;
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

  Widget _buildPositionedCard(
    TarotCard card,
    CardPosition position,
    double containerWidth,
    double containerHeight,
    double cardWidth,
    double cardHeight,
  ) {
    // Convert relative position (0.0-1.0) to absolute position
    final double left = (position.x * containerWidth) - (cardWidth / 2);
    final double top = (position.y * containerHeight) - (cardHeight / 2);

    return Positioned(
      left: left,
      top: top,
      child: Transform.rotate(
        angle: position.rotation * 3.14159 / 180, // Convert degrees to radians
        child: _buildCardWidget(card, cardWidth, cardHeight),
      ),
    );
  }

  Widget _buildCardWidget(TarotCard card, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (card.imageUrl != null && card.imageUrl!.isNotEmpty)
              Expanded(
                child: Image.network(
                  card.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildCardFallback(card, width, height);
                  },
                ),
              )
            else
              _buildCardFallback(card, width, height),
          ],
        ),
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
