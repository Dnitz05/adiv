import 'package:flutter/material.dart';

/// Represents the position of a card in a spread
class CardPosition {
  final double x; // Relative position (0.0 to 1.0) from left
  final double y; // Relative position (0.0 to 1.0) from top
  final String? label; // Optional label (e.g., "Past", "Present", "Future")
  final double rotation; // Rotation in degrees (0 = upright)

  const CardPosition({
    required this.x,
    required this.y,
    this.label,
    this.rotation = 0.0,
  });
}

/// Defines a tarot spread layout
class TarotSpread {
  final String id;
  final String name;
  final String description;
  final int cardCount;
  final List<CardPosition> positions;
  final double aspectRatio; // Width/height ratio for the layout container

  const TarotSpread({
    required this.id,
    required this.name,
    required this.description,
    required this.cardCount,
    required this.positions,
    this.aspectRatio = 1.0,
  });
}

/// Predefined tarot spreads
class TarotSpreads {
  static const single = TarotSpread(
    id: 'single',
    name: 'Single Card',
    description: 'One card for quick insight',
    cardCount: 1,
    aspectRatio: 0.8,
    positions: [
      CardPosition(x: 0.5, y: 0.5),
    ],
  );

  static const threeCard = TarotSpread(
    id: 'three_card',
    name: 'Three Card Spread',
    description: 'Past, Present, Future',
    cardCount: 3,
    aspectRatio: 1.8,
    positions: [
      CardPosition(x: 0.15, y: 0.5),
      CardPosition(x: 0.5, y: 0.5),
      CardPosition(x: 0.85, y: 0.5),
    ],
  );

  static const celticCross = TarotSpread(
    id: 'celtic_cross',
    name: 'Celtic Cross',
    description: 'Traditional 10-card spread',
    cardCount: 10,
    aspectRatio: 1.5,
    positions: [
      CardPosition(x: 0.3, y: 0.5),
      CardPosition(x: 0.38, y: 0.5, rotation: 90),
      CardPosition(x: 0.3, y: 0.25),
      CardPosition(x: 0.3, y: 0.75),
      CardPosition(x: 0.1, y: 0.5),
      CardPosition(x: 0.5, y: 0.5),
      CardPosition(x: 0.75, y: 0.85),
      CardPosition(x: 0.75, y: 0.65),
      CardPosition(x: 0.75, y: 0.45),
      CardPosition(x: 0.75, y: 0.25),
    ],
  );

  static const horseshoe = TarotSpread(
    id: 'horseshoe',
    name: 'Horseshoe',
    description: '7-card guidance spread',
    cardCount: 7,
    aspectRatio: 1.6,
    positions: [
      CardPosition(x: 0.15, y: 0.7),
      CardPosition(x: 0.25, y: 0.45),
      CardPosition(x: 0.4, y: 0.25),
      CardPosition(x: 0.5, y: 0.2),
      CardPosition(x: 0.6, y: 0.25),
      CardPosition(x: 0.75, y: 0.45),
      CardPosition(x: 0.85, y: 0.7),
    ],
  );

  static const relationship = TarotSpread(
    id: 'relationship',
    name: 'Relationship',
    description: '7-card relationship insight',
    cardCount: 7,
    aspectRatio: 1.4,
    positions: [
      CardPosition(x: 0.25, y: 0.35),
      CardPosition(x: 0.75, y: 0.35),
      CardPosition(x: 0.5, y: 0.15),
      CardPosition(x: 0.5, y: 0.55),
      CardPosition(x: 0.5, y: 0.75),
      CardPosition(x: 0.35, y: 0.9),
      CardPosition(x: 0.65, y: 0.9),
    ],
  );

  static const pyramid = TarotSpread(
    id: 'pyramid',
    name: 'Pyramid',
    description: '6-card pyramid layout',
    cardCount: 6,
    aspectRatio: 1.3,
    positions: [
      CardPosition(x: 0.5, y: 0.15),
      CardPosition(x: 0.35, y: 0.45),
      CardPosition(x: 0.65, y: 0.45),
      CardPosition(x: 0.25, y: 0.75),
      CardPosition(x: 0.5, y: 0.75),
      CardPosition(x: 0.75, y: 0.75),
    ],
  );

  static const yearAhead = TarotSpread(
    id: 'year_ahead',
    name: 'Year Ahead',
    description: '12 cards for each month',
    cardCount: 12,
    aspectRatio: 2.0,
    positions: [
      // Top row
      CardPosition(x: 0.08, y: 0.25),
      CardPosition(x: 0.22, y: 0.25),
      CardPosition(x: 0.36, y: 0.25),
      CardPosition(x: 0.5, y: 0.25),
      CardPosition(x: 0.64, y: 0.25),
      CardPosition(x: 0.78, y: 0.25),
      // Bottom row
      CardPosition(x: 0.08, y: 0.7),
      CardPosition(x: 0.22, y: 0.7),
      CardPosition(x: 0.36, y: 0.7),
      CardPosition(x: 0.5, y: 0.7),
      CardPosition(x: 0.64, y: 0.7),
      CardPosition(x: 0.78, y: 0.7),
    ],
  );

  static const star = TarotSpread(
    id: 'star',
    name: 'Star',
    description: '7-card star pattern',
    cardCount: 7,
    aspectRatio: 1.0,
    positions: [
      CardPosition(x: 0.5, y: 0.1),
      CardPosition(x: 0.8, y: 0.3),
      CardPosition(x: 0.85, y: 0.7),
      CardPosition(x: 0.5, y: 0.85),
      CardPosition(x: 0.15, y: 0.7),
      CardPosition(x: 0.2, y: 0.3),
      CardPosition(x: 0.5, y: 0.5),
    ],
  );

  /// All available spreads
  static const List<TarotSpread> all = [
    single,
    threeCard,
    relationship,
    pyramid,
    horseshoe,
    celticCross,
    star,
    yearAhead,
  ];

  /// Get a spread by ID
  static TarotSpread? getById(String id) {
    try {
      return all.firstWhere((spread) => spread.id == id);
    } catch (_) {
      return null;
    }
  }
}
