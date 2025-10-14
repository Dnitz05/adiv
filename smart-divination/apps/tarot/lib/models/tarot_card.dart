import '../api/draw_cards_api.dart';

/// Represents a tarot card for display in spread layouts
class TarotCard {
  final String name;
  final String? suit;
  final int? number;
  final bool upright;
  final int position;
  final String? imageUrl;

  const TarotCard({
    required this.name,
    this.suit,
    this.number,
    required this.upright,
    required this.position,
    this.imageUrl,
  });

  /// Create a TarotCard from a CardResult
  factory TarotCard.fromCardResult(CardResult card, {String? imagePath}) {
    return TarotCard(
      name: card.name,
      suit: card.suit.isNotEmpty ? card.suit : null,
      number: card.number,
      upright: card.upright,
      position: card.position,
      imageUrl: imagePath,
    );
  }
}
