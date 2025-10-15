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
  final bool showCardBacks; // Si és true, mostra el dors de les cartes

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
    // Tarot card ratio: width/height ≈ 0.67 (2:3 ratio)
    final double cardWidth = cardHeight * 0.67;

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
              showCardBacks, // Passar el paràmetre
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
    bool showCardBack, // Nou paràmetre
  ) {
    // Convert relative position (0.0-1.0) to absolute position
    final double left = (position.x * containerWidth) - (cardWidth / 2);
    final double top = (position.y * containerHeight) - (cardHeight / 2);

    final bool isReversed = card.upright == false;
    final double baseRotation = position.rotation;
    // Reversed cards should be shown upside-down (180° rotation)
    // Però si es mostra el dors, no aplicar rotació de carta invertida
    final double cardRotation = (showCardBack || !isReversed) ? 0 : 180;


    final cardStack = SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Transform.rotate(
            angle: cardRotation * math.pi / 180,
            child: _buildCardWidget(card, cardWidth, cardHeight, showCardBack),
          ),
          // Només mostrar badge d'invertida si la carta està revelada
          if (!showCardBack && isReversed)
            Positioned(
              top: 6,
              right: 6,
              child: _buildReversedIcon(),
            ),
        ],
      ),
    );

    return Positioned(
      left: left,
      top: top,
      child: Transform.rotate(
        angle: baseRotation * math.pi / 180,
        child: cardStack,
      ),
    );
  }

  Widget _buildReversedIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: TarotTheme.deepPurple.withOpacity(0.85),
        shape: BoxShape.circle,
        border: Border.all(
          color: TarotTheme.moonGold.withOpacity(0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: TarotTheme.moonGold.withOpacity(0.3),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        Icons.sync,
        size: 14,
        color: TarotTheme.moonGold,
      ),
    );
  }

  Widget _buildCardWidget(TarotCard card, double width, double height, bool showCardBack) {
    // Si volem mostrar el dors, usar la imatge del dors
    final String imagePath = showCardBack
        ? 'assets/cards/CardBacks.jpg'
        : (card.imageUrl ?? CardImageMapper.getCardImagePath(card.name, card.suit));

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TarotTheme.moonGold.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: TarotTheme.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Si és el dors i hi ha error, mostrar contenidor fosc
            if (showCardBack) {
              return Container(
                color: TarotTheme.deepPurple,
                child: Center(
                  child: Icon(Icons.back_hand, color: TarotTheme.moonGold, size: width * 0.3),
                ),
              );
            }
            return _buildCardFallback(card, width, height);
          },
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


