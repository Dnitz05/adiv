class CardNameLocalizer {
  static String localize(String rawName, String localeName) {
    final trimmed = rawName.trim();
    if (trimmed.isEmpty) {
      return rawName;
    }

    final languageCode = _normalizeLocale(localeName);
    if (languageCode == 'en') {
      return trimmed;
    }

    final lower = trimmed.toLowerCase();
    final majorTranslation = _majorArcana[lower];
    if (majorTranslation != null) {
      final localized = majorTranslation[languageCode];
      if (localized != null) {
        return localized;
      }
    }

    final minorMatch = _minorPattern.firstMatch(lower);
    if (minorMatch != null) {
      final rankKey = minorMatch.group(1)!.toLowerCase();
      final suitKey = _normalizeSuit(minorMatch.group(2)!);
      final rankTranslation = _minorRanks[rankKey];
      final suitTranslation = _minorSuits[suitKey];
      final rank = rankTranslation?[languageCode] ?? _capitalize(rankKey);
      final suit = suitTranslation?[languageCode] ?? _capitalizeWords(suitKey);
      return '$rank de $suit';
    }

    return trimmed;
  }

  static String _normalizeLocale(String localeName) {
    if (localeName.isEmpty) {
      return 'en';
    }
    final separatorIndex = localeName.indexOf(RegExp(r'[_-]'));
    if (separatorIndex == -1) {
      return localeName.toLowerCase();
    }
    return localeName.substring(0, separatorIndex).toLowerCase();
  }

  static String _normalizeSuit(String suit) {
    final normalized =
        suit.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();
    return _suitAliases[normalized] ?? normalized;
  }

  static String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }

  static String _capitalizeWords(String value) {
    return value
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((part) => _capitalize(part))
        .join(' ');
  }

  static final RegExp _minorPattern = RegExp(
    r'^(ace|two|three|four|five|six|seven|eight|nine|ten|page|knight|queen|king) of ([a-z\s]+)$',
    caseSensitive: false,
  );

  static const Map<String, Map<String, String>> _majorArcana = {
    'the fool': {'es': 'El Loco', 'ca': 'El Boig'},
    'fool': {'es': 'El Loco', 'ca': 'El Boig'},
    'the magician': {'es': 'El Mago', 'ca': 'El Mag'},
    'magician': {'es': 'El Mago', 'ca': 'El Mag'},
    'the high priestess': {'es': 'La Sacerdotisa', 'ca': 'La Sacerdotessa'},
    'high priestess': {'es': 'La Sacerdotisa', 'ca': 'La Sacerdotessa'},
    'the empress': {'es': 'La Emperatriz', 'ca': "L'Emperadriu"},
    'empress': {'es': 'La Emperatriz', 'ca': "L'Emperadriu"},
    'the emperor': {'es': 'El Emperador', 'ca': "L'Emperador"},
    'emperor': {'es': 'El Emperador', 'ca': "L'Emperador"},
    'the hierophant': {'es': 'El Hierofante', 'ca': 'El Hierofant'},
    'hierophant': {'es': 'El Hierofante', 'ca': 'El Hierofant'},
    'the lovers': {'es': 'Los Enamorados', 'ca': 'Els Enamorats'},
    'lovers': {'es': 'Los Enamorados', 'ca': 'Els Enamorats'},
    'the chariot': {'es': 'El Carro', 'ca': 'El Carro'},
    'chariot': {'es': 'El Carro', 'ca': 'El Carro'},
    'strength': {'es': 'La Fuerza', 'ca': 'La For\u00e7a'},
    'the hermit': {'es': 'El Ermita\u00f1o', 'ca': "L'Ermit\u00e0"},
    'hermit': {'es': 'El Ermita\u00f1o', 'ca': "L'Ermit\u00e0"},
    'wheel of fortune': {
      'es': 'La Rueda de la Fortuna',
      'ca': 'La Roda de la Fortuna'
    },
    'the wheel of fortune': {
      'es': 'La Rueda de la Fortuna',
      'ca': 'La Roda de la Fortuna'
    },
    'justice': {'es': 'La Justicia', 'ca': 'La Just\u00edcia'},
    'the hanged man': {'es': 'El Colgado', 'ca': 'El Penjat'},
    'hanged man': {'es': 'El Colgado', 'ca': 'El Penjat'},
    'death': {'es': 'La Muerte', 'ca': 'La Mort'},
    'temperance': {'es': 'La Templanza', 'ca': 'La Temper\u00e0ncia'},
    'the devil': {'es': 'El Diablo', 'ca': 'El Dimoni'},
    'devil': {'es': 'El Diablo', 'ca': 'El Dimoni'},
    'the tower': {'es': 'La Torre', 'ca': 'La Torre'},
    'tower': {'es': 'La Torre', 'ca': 'La Torre'},
    'the star': {'es': 'La Estrella', 'ca': "L'Estrella"},
    'star': {'es': 'La Estrella', 'ca': "L'Estrella"},
    'the moon': {'es': 'La Luna', 'ca': 'La Lluna'},
    'moon': {'es': 'La Luna', 'ca': 'La Lluna'},
    'the sun': {'es': 'El Sol', 'ca': 'El Sol'},
    'sun': {'es': 'El Sol', 'ca': 'El Sol'},
    'judgement': {'es': 'El Juicio', 'ca': 'El Judici'},
    'judgment': {'es': 'El Juicio', 'ca': 'El Judici'},
    'the world': {'es': 'El Mundo', 'ca': 'El M\u00f3n'},
    'world': {'es': 'El Mundo', 'ca': 'El M\u00f3n'},
  };

  static const Map<String, Map<String, String>> _minorRanks = {
    'ace': {'es': 'As', 'ca': 'As'},
    'two': {'es': 'Dos', 'ca': 'Dos'},
    'three': {'es': 'Tres', 'ca': 'Tres'},
    'four': {'es': 'Cuatro', 'ca': 'Quatre'},
    'five': {'es': 'Cinco', 'ca': 'Cinc'},
    'six': {'es': 'Seis', 'ca': 'Sis'},
    'seven': {'es': 'Siete', 'ca': 'Set'},
    'eight': {'es': 'Ocho', 'ca': 'Vuit'},
    'nine': {'es': 'Nueve', 'ca': 'Nou'},
    'ten': {'es': 'Diez', 'ca': 'Deu'},
    'page': {'es': 'Sota', 'ca': 'Sota'},
    'knight': {'es': 'Caballero', 'ca': 'Cavaller'},
    'queen': {'es': 'Reina', 'ca': 'Reina'},
    'king': {'es': 'Rey', 'ca': 'Rei'},
  };

  static const Map<String, Map<String, String>> _minorSuits = {
    'wands': {'es': 'Bastos', 'ca': 'Bastons'},
    'cups': {'es': 'Copas', 'ca': 'Copes'},
    'swords': {'es': 'Espadas', 'ca': 'Espases'},
    'pentacles': {'es': 'Oros', 'ca': 'Ors'},
  };

  static const Map<String, String> _suitAliases = {
    'wand': 'wands',
    'wands': 'wands',
    'rods': 'wands',
    'staves': 'wands',
    'staffs': 'wands',
    'clubs': 'wands',
    'cup': 'cups',
    'cups': 'cups',
    'chalice': 'cups',
    'chalices': 'cups',
    'sword': 'swords',
    'swords': 'swords',
    'blade': 'swords',
    'blades': 'swords',
    'pentacle': 'pentacles',
    'pentacles': 'pentacles',
    'coin': 'pentacles',
    'coins': 'pentacles',
    'disk': 'pentacles',
    'disks': 'pentacles',
    'disc': 'pentacles',
    'discs': 'pentacles',
  };
}
