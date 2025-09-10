/// Divination Technique Enum - Core technique identification system
/// 
/// This enum represents the three divination techniques supported by the
/// Smart Divination platform. Each technique has its own app but shares
/// the same core engine and infrastructure.
library divination_technique;

import 'package:json_annotation/json_annotation.dart';

/// Supported divination techniques in the Smart Divination platform
/// 
/// Each technique represents a separate app with its own:
/// - Visual branding and color scheme
/// - Content (cards, hexagrams, runes)
/// - Specialized prompts and interpretation logic
/// - App store presence and marketing
@JsonEnum(valueField: 'name')
enum DivinationTechnique {
  /// Tarot card divination - 78-card deck with spreads
  /// 
  /// Features:
  /// - Major and Minor Arcana cards
  /// - Multiple spread types (3-card, Celtic Cross)
  /// - Reversed card interpretations
  /// - Rich visual card imagery
  tarot('tarot', 'Tarot', '🃏'),
  
  /// I Ching divination - Ancient Chinese oracle using hexagrams
  /// 
  /// Features:
  /// - 64 hexagrams with trigrams
  /// - Coin toss or yarrow stalk methods
  /// - Changing lines and transformations
  /// - Classical Chinese wisdom texts
  iching('iching', 'I Ching', '☯️'),
  
  /// Nordic Runes divination - Elder Futhark alphabet symbols
  /// 
  /// Features:
  /// - 24 Elder Futhark runes
  /// - Upright and reversed interpretations
  /// - Nordic mythology and historical context
  /// - Casting patterns and spreads
  runes('runes', 'Runes', 'ᚱ');

  /// Creates a divination technique enum value
  const DivinationTechnique(this.name, this.displayName, this.icon);
  
  /// Technical identifier used in API calls and configuration
  final String name;
  
  /// Human-readable display name for UI
  final String displayName;
  
  /// Unicode icon/emoji representing the technique
  final String icon;
  
  /// Get technique from string name - throws if invalid
  /// 
  /// Used for environment-based technique injection:
  /// ```dart
  /// final technique = DivinationTechnique.fromName(
  ///   const String.fromEnvironment('APP_TECHNIQUE')
  /// );
  /// ```
  static DivinationTechnique fromName(String name) {
    return DivinationTechnique.values
        .where((DivinationTechnique technique) => technique.name == name)
        .single;
  }
  
  /// Safe technique parsing with fallback
  /// 
  /// Returns null if name doesn't match any technique
  static DivinationTechnique? fromNameOrNull(String? name) {
    if (name == null) return null;
    try {
      return fromName(name);
    } catch (_) {
      return null;
    }
  }
  
  /// Get all technique names as strings
  static List<String> get allNames => values.map((DivinationTechnique t) => t.name).toList();
  
  /// Check if technique supports reversed interpretations
  bool get supportsReversed {
    switch (this) {
      case DivinationTechnique.tarot:
      case DivinationTechnique.runes:
        return true;
      case DivinationTechnique.iching:
        return false; // I Ching uses changing lines instead
    }
  }
  
  /// Get default number of elements drawn for this technique
  int get defaultDrawCount {
    switch (this) {
      case DivinationTechnique.tarot:
        return 3; // Three-card spread
      case DivinationTechnique.iching:
        return 1; // One hexagram
      case DivinationTechnique.runes:
        return 3; // Three-rune spread
    }
  }
  
  /// Get maximum number of elements supported for premium spreads
  int get maxPremiumCount {
    switch (this) {
      case DivinationTechnique.tarot:
        return 10; // Celtic Cross
      case DivinationTechnique.iching:
        return 1; // Always single hexagram
      case DivinationTechnique.runes:
        return 5; // Extended rune spread
    }
  }
}