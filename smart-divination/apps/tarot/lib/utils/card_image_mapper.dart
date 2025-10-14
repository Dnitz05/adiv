/// Maps tarot card names to their corresponding image file names
class CardImageMapper {
  /// Get the asset path for a card based on its name and suit
  static String getCardImagePath(String cardName, String? suit) {
    final normalized = cardName.toLowerCase().trim();

    // Major Arcana
    if (suit == null || suit.isEmpty) {
      return _getMajorArcanaPath(normalized);
    }

    // Minor Arcana
    return _getMinorArcanaPath(normalized, suit);
  }

  static String _getMajorArcanaPath(String cardName) {
    final majorArcanaMap = {
      'the fool': '00-TheFool',
      'fool': '00-TheFool',
      'the magician': '01-TheMagician',
      'magician': '01-TheMagician',
      'the high priestess': '02-TheHighPriestess',
      'high priestess': '02-TheHighPriestess',
      'the empress': '03-TheEmpress',
      'empress': '03-TheEmpress',
      'the emperor': '04-TheEmperor',
      'emperor': '04-TheEmperor',
      'the hierophant': '05-TheHierophant',
      'hierophant': '05-TheHierophant',
      'the lovers': '06-TheLovers',
      'lovers': '06-TheLovers',
      'the chariot': '07-TheChariot',
      'chariot': '07-TheChariot',
      'strength': '08-Strength',
      'the hermit': '09-TheHermit',
      'hermit': '09-TheHermit',
      'wheel of fortune': '10-WheelOfFortune',
      'the wheel of fortune': '10-WheelOfFortune',
      'justice': '11-Justice',
      'the hanged man': '12-TheHangedMan',
      'hanged man': '12-TheHangedMan',
      'death': '13-Death',
      'temperance': '14-Temperance',
      'the devil': '15-TheDevil',
      'devil': '15-TheDevil',
      'the tower': '16-TheTower',
      'tower': '16-TheTower',
      'the star': '17-TheStar',
      'star': '17-TheStar',
      'the moon': '18-TheMoon',
      'moon': '18-TheMoon',
      'the sun': '19-TheSun',
      'sun': '19-TheSun',
      'judgement': '20-Judgement',
      'judgment': '20-Judgement',
      'the world': '21-TheWorld',
      'world': '21-TheWorld',
    };

    final fileName = majorArcanaMap[cardName];
    if (fileName != null) {
      return 'assets/cards/$fileName.jpg';
    }

    // Fallback: return card backs
    return 'assets/cards/CardBacks.jpg';
  }

  static String _getMinorArcanaPath(String cardName, String suit) {
    // Normalize suit name
    final suitMap = {
      'wands': 'Wands',
      'wand': 'Wands',
      'cups': 'Cups',
      'cup': 'Cups',
      'swords': 'Swords',
      'sword': 'Swords',
      'pentacles': 'Pentacles',
      'pentacle': 'Pentacles',
      'coins': 'Pentacles',
      'coin': 'Pentacles',
    };

    final normalizedSuit = suitMap[suit.toLowerCase().trim()] ?? suit;

    // Extract card number or court card name
    String? cardNumber;

    // Check for court cards
    if (cardName.contains('page')) {
      cardNumber = '11';
    } else if (cardName.contains('knight')) {
      cardNumber = '12';
    } else if (cardName.contains('queen')) {
      cardNumber = '13';
    } else if (cardName.contains('king')) {
      cardNumber = '14';
    } else if (cardName.contains('ace')) {
      cardNumber = '01';
    } else {
      // Try to extract number from card name
      final numbers = {
        'two': '02', 'three': '03', 'four': '04', 'five': '05',
        'six': '06', 'seven': '07', 'eight': '08', 'nine': '09',
        'ten': '10',
      };

      for (final entry in numbers.entries) {
        if (cardName.contains(entry.key)) {
          cardNumber = entry.value;
          break;
        }
      }

      // Try numeric extraction
      if (cardNumber == null) {
        final match = RegExp(r'\d+').firstMatch(cardName);
        if (match != null) {
          final num = int.tryParse(match.group(0)!);
          if (num != null && num >= 1 && num <= 10) {
            cardNumber = num.toString().padLeft(2, '0');
          }
        }
      }
    }

    if (cardNumber != null) {
      return 'assets/cards/$normalizedSuit$cardNumber.jpg';
    }

    // Fallback
    return 'assets/cards/CardBacks.jpg';
  }
}
