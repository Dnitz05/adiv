import 'package:flutter/material.dart';

/// Represents the position of a card in a spread
class CardPosition {
  final double x; // Relative position (0.0 to 1.0) from left
  final double y; // Relative position (0.0 to 1.0) from top
  final String? label; // Optional label (e.g., "Past", "Present", "Future")
  final String?
      description; // Optional description of what this position represents
  final double rotation; // Rotation in degrees (0 = upright)

  const CardPosition({
    required this.x,
    required this.y,
    this.label,
    this.description,
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
      CardPosition(
        x: 0.5,
        y: 0.5,
        label: 'Your Answer',
        description: 'Direct guidance for your question',
      ),
    ],
  );

  static const twoCard = TarotSpread(
    id: 'two_card',
    name: 'Two Card',
    description: 'Decision-making spread',
    cardCount: 2,
    aspectRatio: 1.3,
    positions: [
      CardPosition(
        x: 0.35,
        y: 0.5,
        label: 'Option A',
        description: 'Path or consequence of first choice',
      ),
      CardPosition(
        x: 0.65,
        y: 0.5,
        label: 'Option B',
        description: 'Path or consequence of second choice',
      ),
    ],
  );

  static const threeCard = TarotSpread(
    id: 'three_card',
    name: 'Three Card Spread',
    description: 'Past, Present, Future',
    cardCount: 3,
    aspectRatio: 1.8,
    positions: [
      CardPosition(
        x: 0.15,
        y: 0.5,
        label: 'Past',
        description: 'Influences that brought you here',
      ),
      CardPosition(
        x: 0.5,
        y: 0.5,
        label: 'Present',
        description: 'Your current situation',
      ),
      CardPosition(
        x: 0.85,
        y: 0.5,
        label: 'Future',
        description: 'The path opening before you',
      ),
    ],
  );

  static const fiveCardCross = TarotSpread(
    id: 'five_card_cross',
    name: 'Five Card Cross',
    description: 'Comprehensive cross layout',
    cardCount: 5,
    aspectRatio: 1.3,
    positions: [
      CardPosition(
        x: 0.25,
        y: 0.5,
        label: 'Past',
        description: 'Past influences impacting present',
      ),
      CardPosition(
        x: 0.5,
        y: 0.5,
        label: 'Present',
        description: 'Current situation to address',
      ),
      CardPosition(
        x: 0.75,
        y: 0.5,
        label: 'Future',
        description: 'Outcome given current path',
      ),
      CardPosition(
        x: 0.5,
        y: 0.75,
        label: 'What Holds You Back',
        description: 'Past issues needing resolution',
      ),
      CardPosition(
        x: 0.5,
        y: 0.25,
        label: 'Advice',
        description: 'Guidance to push forward',
      ),
    ],
  );

  static const celticCross = TarotSpread(
    id: 'celtic_cross',
    name: 'Celtic Cross',
    description: 'Traditional 10-card spread',
    cardCount: 10,
    aspectRatio: 1.5,
    positions: [
      CardPosition(
        x: 0.3,
        y: 0.5,
        label: 'Present',
        description: 'Your current situation',
      ),
      CardPosition(
        x: 0.38,
        y: 0.5,
        rotation: 90,
        label: 'Challenge',
        description: 'Immediate obstacles',
      ),
      CardPosition(
        x: 0.3,
        y: 0.25,
        label: 'Distant Past',
        description: 'Roots of the situation',
      ),
      CardPosition(
        x: 0.3,
        y: 0.75,
        label: 'Recent Past',
        description: 'Recent events',
      ),
      CardPosition(
        x: 0.1,
        y: 0.5,
        label: 'Goal',
        description: 'Best possible outcome',
      ),
      CardPosition(
        x: 0.5,
        y: 0.5,
        label: 'Near Future',
        description: 'What comes soon',
      ),
      CardPosition(
        x: 0.75,
        y: 0.85,
        label: 'Self',
        description: 'Your attitude',
      ),
      CardPosition(
        x: 0.75,
        y: 0.65,
        label: 'Environment',
        description: 'External influences',
      ),
      CardPosition(
        x: 0.75,
        y: 0.45,
        label: 'Hopes & Fears',
        description: 'Hidden feelings',
      ),
      CardPosition(
        x: 0.75,
        y: 0.25,
        label: 'Outcome',
        description: 'Final result',
      ),
    ],
  );

  static const horseshoe = TarotSpread(
    id: 'horseshoe',
    name: 'Horseshoe',
    description: '7-card guidance spread',
    cardCount: 7,
    aspectRatio: 1.6,
    positions: [
      CardPosition(
        x: 0.15,
        y: 0.7,
        label: 'Past',
        description: 'Past influences on the situation',
      ),
      CardPosition(
        x: 0.25,
        y: 0.45,
        label: 'Present',
        description: 'Current circumstances',
      ),
      CardPosition(
        x: 0.4,
        y: 0.25,
        label: 'Hidden Influences',
        description: 'Unseen factors at play',
      ),
      CardPosition(
        x: 0.5,
        y: 0.2,
        label: 'Obstacles',
        description: 'Challenges to overcome',
      ),
      CardPosition(
        x: 0.6,
        y: 0.25,
        label: 'External Influences',
        description: 'Outside forces affecting you',
      ),
      CardPosition(
        x: 0.75,
        y: 0.45,
        label: 'Advice',
        description: 'Guidance for best action',
      ),
      CardPosition(
        x: 0.85,
        y: 0.7,
        label: 'Outcome',
        description: 'Likely result',
      ),
    ],
  );

  static const relationship = TarotSpread(
    id: 'relationship',
    name: 'Relationship',
    description: '7-card relationship insight',
    cardCount: 7,
    aspectRatio: 1.4,
    positions: [
      CardPosition(
        x: 0.25,
        y: 0.35,
        label: 'You',
        description: 'Your position in the relationship',
      ),
      CardPosition(
        x: 0.75,
        y: 0.35,
        label: 'Partner',
        description: 'Their position in the relationship',
      ),
      CardPosition(
        x: 0.5,
        y: 0.15,
        label: 'Strengths',
        description: 'What binds you together',
      ),
      CardPosition(
        x: 0.5,
        y: 0.55,
        label: 'Challenges',
        description: 'What divides you',
      ),
      CardPosition(
        x: 0.5,
        y: 0.75,
        label: 'Current Dynamic',
        description: 'The present state of connection',
      ),
      CardPosition(
        x: 0.35,
        y: 0.9,
        label: 'Your Needs',
        description: 'What you require',
      ),
      CardPosition(
        x: 0.65,
        y: 0.9,
        label: 'Their Needs',
        description: 'What they require',
      ),
    ],
  );

  static const pyramid = TarotSpread(
    id: 'pyramid',
    name: 'Pyramid',
    description: '6-card pyramid layout',
    cardCount: 6,
    aspectRatio: 1.3,
    positions: [
      CardPosition(
        x: 0.5,
        y: 0.15,
        label: 'Goal',
        description: 'Ultimate aspiration',
      ),
      CardPosition(
        x: 0.35,
        y: 0.45,
        label: 'Mind',
        description: 'Mental approach',
      ),
      CardPosition(
        x: 0.65,
        y: 0.45,
        label: 'Heart',
        description: 'Emotional response',
      ),
      CardPosition(
        x: 0.25,
        y: 0.75,
        label: 'Action',
        description: 'What to do',
      ),
      CardPosition(
        x: 0.5,
        y: 0.75,
        label: 'Resources',
        description: 'Tools available',
      ),
      CardPosition(
        x: 0.75,
        y: 0.75,
        label: 'Foundation',
        description: 'Core support',
      ),
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
      CardPosition(
        x: 0.08,
        y: 0.25,
        label: 'January',
        description: 'New beginnings and fresh starts',
      ),
      CardPosition(
        x: 0.22,
        y: 0.25,
        label: 'February',
        description: 'Love and connections',
      ),
      CardPosition(
        x: 0.36,
        y: 0.25,
        label: 'March',
        description: 'Growth and momentum',
      ),
      CardPosition(
        x: 0.5,
        y: 0.25,
        label: 'April',
        description: 'Action and initiative',
      ),
      CardPosition(
        x: 0.64,
        y: 0.25,
        label: 'May',
        description: 'Blossoming and abundance',
      ),
      CardPosition(
        x: 0.78,
        y: 0.25,
        label: 'June',
        description: 'Balance and harmony',
      ),
      // Bottom row
      CardPosition(
        x: 0.08,
        y: 0.7,
        label: 'July',
        description: 'Reflection and introspection',
      ),
      CardPosition(
        x: 0.22,
        y: 0.7,
        label: 'August',
        description: 'Power and strength',
      ),
      CardPosition(
        x: 0.36,
        y: 0.7,
        label: 'September',
        description: 'Harvest and rewards',
      ),
      CardPosition(
        x: 0.5,
        y: 0.7,
        label: 'October',
        description: 'Transformation and change',
      ),
      CardPosition(
        x: 0.64,
        y: 0.7,
        label: 'November',
        description: 'Gratitude and release',
      ),
      CardPosition(
        x: 0.78,
        y: 0.7,
        label: 'December',
        description: 'Completion and rest',
      ),
    ],
  );

  static const star = TarotSpread(
    id: 'star',
    name: 'Star',
    description: '7-card star pattern',
    cardCount: 7,
    aspectRatio: 1.0,
    positions: [
      CardPosition(
        x: 0.5,
        y: 0.1,
        label: 'Spirit',
        description: 'Higher guidance',
      ),
      CardPosition(
        x: 0.8,
        y: 0.3,
        label: 'Abundance',
        description: 'Prosperity and growth',
      ),
      CardPosition(
        x: 0.85,
        y: 0.7,
        label: 'Love',
        description: 'Emotional fulfillment',
      ),
      CardPosition(
        x: 0.5,
        y: 0.85,
        label: 'Grounding',
        description: 'Stability and roots',
      ),
      CardPosition(
        x: 0.15,
        y: 0.7,
        label: 'Creativity',
        description: 'Expression and passion',
      ),
      CardPosition(
        x: 0.2,
        y: 0.3,
        label: 'Wisdom',
        description: 'Knowledge and insight',
      ),
      CardPosition(
        x: 0.5,
        y: 0.5,
        label: 'Core Self',
        description: 'Your essential truth',
      ),
    ],
  );

  static const astrological = TarotSpread(
    id: 'astrological',
    name: 'Astrological Houses',
    description: '12 houses of astrology',
    cardCount: 12,
    aspectRatio: 1.0,
    positions: [
      // Arranged in a circle like astrological chart
      CardPosition(
        x: 0.82,
        y: 0.5,
        label: '1st House',
        description: 'Self & Identity',
      ),
      CardPosition(
        x: 0.75,
        y: 0.73,
        label: '2nd House',
        description: 'Values & Resources',
      ),
      CardPosition(
        x: 0.6,
        y: 0.87,
        label: '3rd House',
        description: 'Communication',
      ),
      CardPosition(
        x: 0.4,
        y: 0.87,
        label: '4th House',
        description: 'Home & Roots',
      ),
      CardPosition(
        x: 0.25,
        y: 0.73,
        label: '5th House',
        description: 'Creativity & Joy',
      ),
      CardPosition(
        x: 0.18,
        y: 0.5,
        label: '6th House',
        description: 'Health & Service',
      ),
      CardPosition(
        x: 0.25,
        y: 0.27,
        label: '7th House',
        description: 'Partnerships',
      ),
      CardPosition(
        x: 0.4,
        y: 0.13,
        label: '8th House',
        description: 'Transformation',
      ),
      CardPosition(
        x: 0.6,
        y: 0.13,
        label: '9th House',
        description: 'Expansion & Wisdom',
      ),
      CardPosition(
        x: 0.75,
        y: 0.27,
        label: '10th House',
        description: 'Career & Purpose',
      ),
      CardPosition(
        x: 0.82,
        y: 0.5,
        label: '11th House',
        description: 'Community & Dreams',
      ),
      CardPosition(
        x: 0.75,
        y: 0.73,
        label: '12th House',
        description: 'Spirituality & Unconscious',
      ),
    ],
  );

  /// All available spreads
  static const List<TarotSpread> all = [
    single,
    twoCard,
    threeCard,
    fiveCardCross,
    relationship,
    pyramid,
    horseshoe,
    celticCross,
    star,
    astrological,
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

String _languageFromLocale(String locale) {
  final separatorIndex = locale.indexOf('_');
  if (separatorIndex != -1) {
    return locale.substring(0, separatorIndex).toLowerCase();
  }
  return locale.toLowerCase();
}

const Map<String, Map<String, String>> _spreadNameTranslations =
    <String, Map<String, String>>{
  'ca': <String, String>{
    'single': 'Una Carta',
    'two_card': 'Dues Cartes',
    'three_card': 'Tirada de Tres Cartes',
    'five_card_cross': 'Creu de Cinc Cartes',
    'relationship': 'Relació',
    'pyramid': 'Piràmide',
    'horseshoe': 'Ferradura',
    'celtic_cross': 'Creu Celta',
    'star': 'Estrella',
    'astrological': 'Cases Astrològiques',
    'year_ahead': 'Any Endavant',
  },
  'es': <String, String>{
    'single': 'Una Carta',
    'two_card': 'Dos Cartas',
    'three_card': 'Tirada de Tres Cartas',
    'five_card_cross': 'Cruz de Cinco Cartas',
    'relationship': 'Relación',
    'pyramid': 'Pirámide',
    'horseshoe': 'Herradura',
    'celtic_cross': 'Cruz Celta',
    'star': 'Estrella',
    'astrological': 'Casas Astrológicas',
    'year_ahead': 'Año Por Delante',
  },
};

const Map<String, String> _spreadTitlePrefixes = <String, String>{
  'ca': 'Tirada',
  'es': 'Tirada',
  'en': '',
};

const Map<String, Map<String, String>> _spreadDescriptionTranslations =
    <String, Map<String, String>>{
  'ca': <String, String>{
    'single': 'Una carta per orientació diària ràpida i respostes directes',
    'two_card': 'Tirada de decisió per a opcions binàries',
    'three_card': 'Tirada versàtil per a passat, present i futur',
    'five_card_cross': 'Disposició en creu completa amb bloquejos i consells',
    'relationship': 'Set cartes explorant les dinàmiques de relació',
    'pyramid': 'Sis cartes en disposició piramidal holística',
    'horseshoe': 'Set cartes en ferradura per orientació completa',
    'celtic_cross': 'Tirada mestra de deu cartes per situacions complexes',
    'star': 'Set cartes en estrella per a autoconeixement',
    'astrological': 'Dotze cartes representant les cases astrològiques',
    'year_ahead': 'Dotze cartes per a pronòstic mensual',
  },
  'es': <String, String>{
    'single': 'Una carta para orientación diaria rápida y respuestas directas',
    'two_card': 'Tirada de decisión para opciones binarias',
    'three_card': 'Tirada versátil para pasado, presente y futuro',
    'five_card_cross': 'Disposición en cruz completa con bloqueos y consejos',
    'relationship': 'Siete cartas explorando las dinámicas de relación',
    'pyramid': 'Seis cartas en disposición piramidal holística',
    'horseshoe': 'Siete cartas en herradura para orientación completa',
    'celtic_cross': 'Tirada maestra de diez cartas para situaciones complejas',
    'star': 'Siete cartas en estrella para autoconocimiento',
    'astrological': 'Doce cartas representando las casas astrológicas',
    'year_ahead': 'Doce cartas para pronóstico mensual',
  },
};

extension TarotSpreadLocalization on TarotSpread {
  String localizedName(String locale) {
    final language = _languageFromLocale(locale);
    final baseName =
        (_spreadNameTranslations[language]?[id] ?? name).trim();

    final prefix = _spreadTitlePrefixes[language];
    if (prefix != null && prefix.isNotEmpty) {
      final lower = baseName.toLowerCase();
      final prefixLower = prefix.toLowerCase();
      if (lower.startsWith(prefixLower)) {
        return baseName;
      }
      return '$prefix $baseName';
    }

    return baseName;
  }

  String localizedDescription(String locale) {
    final language = _languageFromLocale(locale);
    return _spreadDescriptionTranslations[language]?[id] ?? description;
  }
}
