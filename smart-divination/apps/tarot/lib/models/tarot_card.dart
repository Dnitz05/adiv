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
      suit: _normaliseSuit(card.suit),
      number: card.number,
      upright: card.upright,
      position: card.position,
      imageUrl: imagePath,
    );
  }
  static String? _normaliseSuit(String rawSuit) {
    final trimmed = rawSuit.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final lower = trimmed.toLowerCase();
    if (lower == 'major arcana' || lower == 'major-arcana' || lower == 'major') {
      return null;
    }
    return trimmed;
  }
}
