import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// Cryptographically secure RNG service with reproducible seeds
class RngService {
  static final Random _secureRandom = Random.secure();
  
  /// Generate a new cryptographic seed
  static String generateSeed() {
    final bytes = Uint8List(32);
    for (int i = 0; i < 32; i++) {
      bytes[i] = _secureRandom.nextInt(256);
    }
    return base64Encode(bytes);
  }
  
  /// Create seeded random generator from string seed
  static SeededRandom fromSeed(String seed) {
    return SeededRandom(seed);
  }
  
  /// Get random.org signed random numbers (for backend use)
  static Future<RandomOrgResponse> getRandomOrgNumbers({
    required String apiKey,
    required int n,
    required int min,
    required int max,
    bool replacement = false,
  }) async {
    // This would be implemented in backend
    throw UnimplementedError('Use backend API endpoint');
  }
}

/// Seeded random generator for reproducible results
class SeededRandom {
  final String seed;
  late final Random _generator;
  
  SeededRandom(this.seed) {
    // Convert seed to integer for reproducible Random
    final hash = sha256.convert(utf8.encode(seed));
    final seedInt = hash.bytes.fold<int>(0, (prev, byte) => prev * 256 + byte);
    _generator = Random(seedInt);
  }
  
  /// Generate random integers in range [min, max) inclusive
  List<int> integers(int count, int min, int max) {
    final range = max - min + 1;
    return List.generate(count, (_) => min + _generator.nextInt(range));
  }
  
  /// Generate unique integers (no replacement) in range [min, max)
  List<int> uniqueIntegers(int count, int min, int max) {
    final range = max - min + 1;
    if (count > range) {
      throw ArgumentError('Cannot generate $count unique numbers from range of $range');
    }
    
    final available = List.generate(range, (i) => min + i);
    final result = <int>[];
    
    for (int i = 0; i < count; i++) {
      final index = _generator.nextInt(available.length);
      result.add(available.removeAt(index));
    }
    
    return result;
  }
  
  /// Shuffle a list in-place
  void shuffle<T>(List<T> list) {
    for (int i = list.length - 1; i > 0; i--) {
      final j = _generator.nextInt(i + 1);
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }
  
  /// Generate random boolean
  bool boolean() => _generator.nextBool();
  
  /// Generate random double [0.0, 1.0)
  double double() => _generator.nextDouble();
  
  /// Pick random element from list
  T choice<T>(List<T> list) {
    if (list.isEmpty) throw ArgumentError('Cannot choose from empty list');
    return list[_generator.nextInt(list.length)];
  }
  
  /// Pick multiple random elements from list
  List<T> choices<T>(List<T> list, int count, {bool replacement = true}) {
    if (list.isEmpty) throw ArgumentError('Cannot choose from empty list');
    
    if (replacement) {
      return List.generate(count, (_) => choice(list));
    } else {
      if (count > list.length) {
        throw ArgumentError('Cannot choose $count items from list of ${list.length} without replacement');
      }
      final shuffled = List<T>.from(list);
      shuffle(shuffled);
      return shuffled.take(count).toList();
    }
  }
}

/// Divination-specific RNG methods
extension DivinationRng on SeededRandom {
  /// Draw tarot cards
  List<Map<String, dynamic>> drawTarotCards(int count, bool allowReversed) {
    final indices = uniqueIntegers(count, 0, 77); // 78 cards: 0-77
    return indices.asMap().entries.map((entry) {
      return {
        'id': _getCardId(entry.value),
        'upright': allowReversed ? boolean() : true,
        'position': entry.key + 1,
      };
    }).toList();
  }
  
  /// Toss I Ching coins
  Map<String, dynamic> tossIChingCoins({int rounds = 6}) {
    final lines = <int>[];
    
    for (int i = 0; i < rounds; i++) {
      // Toss 3 coins, count heads (yang)
      int heads = 0;
      for (int j = 0; j < 3; j++) {
        if (boolean()) heads++;
      }
      
      // Convert to line value: 6,7,8,9 (old yin, young yang, young yin, old yang)
      final lineValue = switch (heads) {
        0 => 6,  // old yin (changing)
        1 => 8,  // young yin
        2 => 7,  // young yang  
        3 => 9,  // old yang (changing)
        _ => throw StateError('Invalid heads count: $heads'),
      };
      
      lines.add(lineValue);
    }
    
    final changingLines = <int>[];
    for (int i = 0; i < lines.length; i++) {
      if (lines[i] == 6 || lines[i] == 9) {
        changingLines.add(i + 1); // 1-indexed
      }
    }
    
    final primaryHex = _linesToHexagram(lines);
    final resultHex = changingLines.isNotEmpty 
        ? _linesToHexagram(_applyChanges(lines))
        : null;
    
    return {
      'lines': lines,
      'primary_hex': primaryHex,
      'changing_lines': changingLines,
      'result_hex': resultHex,
    };
  }
  
  /// Draw runes
  List<Map<String, dynamic>> drawRunes(int count, bool allowReversed) {
    final runeIds = _getRuneIds();
    final selectedRunes = choices(runeIds, count, replacement: false);
    final slots = ['situation', 'challenge', 'result'];
    
    return selectedRunes.asMap().entries.map((entry) {
      return {
        'id': entry.value,
        'upright': allowReversed ? boolean() : true,
        'slot': entry.key < slots.length ? slots[entry.key] : 'position_${entry.key + 1}',
      };
    }).toList();
  }
  
  // Helper methods
  String _getCardId(int index) {
    // Major Arcana (0-21)
    if (index <= 21) {
      final names = [
        'THE_FOOL', 'THE_MAGICIAN', 'THE_HIGH_PRIESTESS', 'THE_EMPRESS',
        'THE_EMPEROR', 'THE_HIEROPHANT', 'THE_LOVERS', 'THE_CHARIOT',
        'STRENGTH', 'THE_HERMIT', 'WHEEL_OF_FORTUNE', 'JUSTICE',
        'THE_HANGED_MAN', 'DEATH', 'TEMPERANCE', 'THE_DEVIL',
        'THE_TOWER', 'THE_STAR', 'THE_MOON', 'THE_SUN',
        'JUDGEMENT', 'THE_WORLD'
      ];
      return names[index];
    }
    
    // Minor Arcana (22-77)
    final minorIndex = index - 22;
    final suits = ['WANDS', 'CUPS', 'SWORDS', 'PENTACLES'];
    final ranks = ['ACE', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'PAGE', 'KNIGHT', 'QUEEN', 'KING'];
    
    final suit = suits[minorIndex ~/ 14];
    final rank = ranks[minorIndex % 14];
    
    return '${rank}_OF_${suit}';
  }
  
  List<String> _getRuneIds() {
    return [
      'FEHU', 'URUZ', 'THURISAZ', 'ANSUZ', 'RAIDHO', 'KENAZ',
      'GEBO', 'WUNJO', 'HAGALAZ', 'NAUTHIZ', 'ISA', 'JERA',
      'EIHWAZ', 'PERTHRO', 'ALGIZ', 'SOWILO', 'TIWAZ', 'BERKANO',
      'EHWAZ', 'MANNAZ', 'LAGUZ', 'INGWAZ', 'DAGAZ', 'OTHALA'
    ];
  }
  
  int _linesToHexagram(List<int> lines) {
    // Convert lines to binary (odd=1, even=0) and calculate hexagram number
    int value = 0;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i] % 2 == 1) { // 7,9 are yang (odd)
        value |= (1 << i);
      }
    }
    return value + 1; // Hexagrams are 1-indexed
  }
  
  List<int> _applyChanges(List<int> lines) {
    return lines.map((line) => switch (line) {
      6 => 7,  // old yin becomes young yang
      9 => 8,  // old yang becomes young yin
      _ => line, // no change
    }).toList();
  }
}

/// Response from Random.org (for verification)
class RandomOrgResponse {
  final List<int> data;
  final String signature;
  final String completionTime;
  final int bitsUsed;
  final int bitsLeft;
  
  const RandomOrgResponse({
    required this.data,
    required this.signature,
    required this.completionTime,
    required this.bitsUsed,
    required this.bitsLeft,
  });
  
  factory RandomOrgResponse.fromJson(Map<String, dynamic> json) {
    return RandomOrgResponse(
      data: List<int>.from(json['random']['data']),
      signature: json['signature'],
      completionTime: json['random']['completionTime'],
      bitsUsed: json['bitsUsed'],
      bitsLeft: json['bitsLeft'],
    );
  }
  
  Map<String, dynamic> toJson() => {
    'data': data,
    'signature': signature,
    'completionTime': completionTime,
    'bitsUsed': bitsUsed,
    'bitsLeft': bitsLeft,
  };
}