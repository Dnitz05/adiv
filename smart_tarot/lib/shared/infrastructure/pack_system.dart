/// Pack System - Configuration-driven app identity and content management
/// 
/// This system enables one codebase to build three distinct applications by
/// loading technique-specific configuration packs. Each pack defines colors,
/// content, assets, and features for its respective technique.
library pack_system;

import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../contracts/divination_technique.dart';

/// Provider for the pack system singleton
final Provider<PackSystem> packSystemProvider = Provider<PackSystem>((ProviderRef<PackSystem> ref) {
  return PackSystem();
});

/// Provider for the current app pack configuration
final FutureProvider<AppPack> currentPackProvider = FutureProvider<AppPack>((FutureProviderRef<AppPack> ref) async {
  final PackSystem packSystem = ref.read(packSystemProvider);
  
  // Get technique from environment or default to tarot
  const String techniqueName = String.fromEnvironment('APP_TECHNIQUE', defaultValue: 'tarot');
  final DivinationTechnique technique = DivinationTechnique.fromName(techniqueName);
  
  return packSystem.loadPack(technique);
});

/// Color palette for a specific technique
@immutable
class TechniqueColorPalette {
  /// Creates a technique color palette
  const TechniqueColorPalette({
    required this.primary,
    required this.primaryContainer,
    required this.secondary,
    required this.secondaryContainer,
    required this.tertiary,
    required this.tertiaryContainer,
    required this.surface,
    required this.surfaceVariant,
    required this.background,
    required this.error,
    required this.onPrimary,
    required this.onPrimaryContainer,
    required this.onSecondary,
    required this.onSecondaryContainer,
    required this.onTertiary,
    required this.onTertiaryContainer,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.onBackground,
    required this.onError,
    required this.outline,
    required this.shadow,
    this.gradientColors,
    this.accentColors,
  });
  
  // Material Design 3 Color System
  final Color primary;
  final Color primaryContainer;
  final Color secondary;
  final Color secondaryContainer;
  final Color tertiary;
  final Color tertiaryContainer;
  final Color surface;
  final Color surfaceVariant;
  final Color background;
  final Color error;
  final Color onPrimary;
  final Color onPrimaryContainer;
  final Color onSecondary;
  final Color onSecondaryContainer;
  final Color onTertiary;
  final Color onTertiaryContainer;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color onBackground;
  final Color onError;
  final Color outline;
  final Color shadow;
  
  // Technique-specific extensions
  final List<Color>? gradientColors;
  final Map<String, Color>? accentColors;
  
  /// Create from JSON configuration
  factory TechniqueColorPalette.fromJson(Map<String, dynamic> json) {
    return TechniqueColorPalette(
      primary: _parseColor(json['primary'] as String),
      primaryContainer: _parseColor(json['primaryContainer'] as String),
      secondary: _parseColor(json['secondary'] as String),
      secondaryContainer: _parseColor(json['secondaryContainer'] as String),
      tertiary: _parseColor(json['tertiary'] as String),
      tertiaryContainer: _parseColor(json['tertiaryContainer'] as String),
      surface: _parseColor(json['surface'] as String),
      surfaceVariant: _parseColor(json['surfaceVariant'] as String),
      background: _parseColor(json['background'] as String),
      error: _parseColor(json['error'] as String),
      onPrimary: _parseColor(json['onPrimary'] as String),
      onPrimaryContainer: _parseColor(json['onPrimaryContainer'] as String),
      onSecondary: _parseColor(json['onSecondary'] as String),
      onSecondaryContainer: _parseColor(json['onSecondaryContainer'] as String),
      onTertiary: _parseColor(json['onTertiary'] as String),
      onTertiaryContainer: _parseColor(json['onTertiaryContainer'] as String),
      onSurface: _parseColor(json['onSurface'] as String),
      onSurfaceVariant: _parseColor(json['onSurfaceVariant'] as String),
      onBackground: _parseColor(json['onBackground'] as String),
      onError: _parseColor(json['onError'] as String),
      outline: _parseColor(json['outline'] as String),
      shadow: _parseColor(json['shadow'] as String),
      gradientColors: (json['gradientColors'] as List<dynamic>?)
          ?.map((dynamic color) => _parseColor(color as String))
          .toList(),
      accentColors: (json['accentColors'] as Map<String, dynamic>?)
          ?.map((String key, dynamic value) => MapEntry<String, Color>(key, _parseColor(value as String))),
    );
  }
  
  /// Convert to Material Design ColorScheme
  ColorScheme toColorScheme({Brightness brightness = Brightness.light}) {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: error.withOpacity(0.1),
      onErrorContainer: onError,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outline.withOpacity(0.5),
      shadow: shadow,
      scrim: Colors.black,
      inverseSurface: brightness == Brightness.light ? Colors.grey.shade800 : Colors.grey.shade200,
      onInverseSurface: brightness == Brightness.light ? Colors.white : Colors.black,
      inversePrimary: brightness == Brightness.light ? primary.withOpacity(0.8) : primary.withOpacity(0.6),
      surfaceTint: primary,
    );
  }
  
  /// Create primary gradient for backgrounds and cards
  LinearGradient get primaryGradient {
    final List<Color> colors = gradientColors ?? <Color>[
      primary,
      primary.withOpacity(0.7),
    ];
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  /// Parse color from hex string
  static Color _parseColor(String hexColor) {
    final String hex = hexColor.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    } else if (hex.length == 8) {
      return Color(int.parse(hex, radix: 16));
    } else {
      throw ArgumentError('Invalid hex color: $hexColor');
    }
  }
}

/// Asset configuration for a technique pack
@immutable
class PackAssets {
  /// Creates pack assets configuration
  const PackAssets({
    required this.basePath,
    required this.cardImages,
    required this.backgroundImages,
    required this.iconImages,
    required this.lottieAnimations,
    this.audioAssets,
    this.fontAssets,
  });
  
  /// Base path for all assets in this pack
  final String basePath;
  
  /// Card/element images (tarot cards, runes, hexagram symbols)
  final List<String> cardImages;
  
  /// Background and decorative images
  final List<String> backgroundImages;
  
  /// Icons and small graphics
  final List<String> iconImages;
  
  /// Lottie animation files
  final List<String> lottieAnimations;
  
  /// Optional audio assets (ambient sounds, effects)
  final List<String>? audioAssets;
  
  /// Optional custom fonts
  final List<String>? fontAssets;
  
  /// Create from JSON configuration
  factory PackAssets.fromJson(String basePath, Map<String, dynamic> json) {
    return PackAssets(
      basePath: basePath,
      cardImages: List<String>.from(json['cardImages'] as List<dynamic>),
      backgroundImages: List<String>.from(json['backgroundImages'] as List<dynamic>),
      iconImages: List<String>.from(json['iconImages'] as List<dynamic>),
      lottieAnimations: List<String>.from(json['lottieAnimations'] as List<dynamic>),
      audioAssets: (json['audioAssets'] as List<dynamic>?)?.cast<String>(),
      fontAssets: (json['fontAssets'] as List<dynamic>?)?.cast<String>(),
    );
  }
  
  /// Get full asset path for a card image
  String getCardImagePath(int index) {
    if (index < 0 || index >= cardImages.length) {
      throw ArgumentError('Card image index $index out of range');
    }
    return '$basePath/${cardImages[index]}';
  }
  
  /// Get background image path
  String getBackgroundPath(String name) {
    final String imagePath = backgroundImages
        .firstWhere((String path) => path.contains(name), orElse: () => backgroundImages.first);
    return '$basePath/$imagePath';
  }
  
  /// Get Lottie animation path
  String getLottiePath(String name) {
    final String animationPath = lottieAnimations
        .firstWhere((String path) => path.contains(name), orElse: () => lottieAnimations.first);
    return '$basePath/$animationPath';
  }
}

/// Content configuration for technique-specific text and prompts
@immutable
class PackContent {
  /// Creates pack content configuration
  const PackContent({
    required this.displayName,
    required this.description,
    required this.welcomeMessages,
    required this.ritualMessages,
    required this.interpretationPrompts,
    required this.followUpQuestions,
    required this.errorMessages,
    required this.featureDescriptions,
    this.cardData,
    this.specialContent,
  });
  
  /// Display name for the technique
  final Map<String, String> displayName;
  
  /// Brief description of the technique
  final Map<String, String> description;
  
  /// Welcome messages by locale
  final Map<String, String> welcomeMessages;
  
  /// Ritual/ceremony messages during divination
  final Map<String, String> ritualMessages;
  
  /// AI interpretation prompt templates
  final Map<String, String> interpretationPrompts;
  
  /// Follow-up question templates
  final Map<String, List<String>> followUpQuestions;
  
  /// Error and fallback messages
  final Map<String, String> errorMessages;
  
  /// Feature descriptions for premium upsell
  final Map<String, Map<String, String>> featureDescriptions;
  
  /// Technique-specific card/element data
  final Map<String, dynamic>? cardData;
  
  /// Any other special content
  final Map<String, dynamic>? specialContent;
  
  /// Create from JSON configuration
  factory PackContent.fromJson(Map<String, dynamic> json) {
    return PackContent(
      displayName: Map<String, String>.from(json['displayName'] as Map<dynamic, dynamic>),
      description: Map<String, String>.from(json['description'] as Map<dynamic, dynamic>),
      welcomeMessages: Map<String, String>.from(json['welcomeMessages'] as Map<dynamic, dynamic>),
      ritualMessages: Map<String, String>.from(json['ritualMessages'] as Map<dynamic, dynamic>),
      interpretationPrompts: Map<String, String>.from(json['interpretationPrompts'] as Map<dynamic, dynamic>),
      followUpQuestions: (json['followUpQuestions'] as Map<dynamic, dynamic>).map(
        (dynamic key, dynamic value) => MapEntry<String, List<String>>(
          key as String,
          List<String>.from(value as List<dynamic>),
        ),
      ),
      errorMessages: Map<String, String>.from(json['errorMessages'] as Map<dynamic, dynamic>),
      featureDescriptions: (json['featureDescriptions'] as Map<dynamic, dynamic>).map(
        (dynamic key, dynamic value) => MapEntry<String, Map<String, String>>(
          key as String,
          Map<String, String>.from(value as Map<dynamic, dynamic>),
        ),
      ),
      cardData: json['cardData'] as Map<String, dynamic>?,
      specialContent: json['specialContent'] as Map<String, dynamic>?,
    );
  }
  
  /// Get localized text with fallback to English
  String getLocalizedText(Map<String, String> textMap, String locale) {
    return textMap[locale] ?? textMap['en'] ?? textMap.values.first;
  }
  
  /// Get display name for locale
  String getDisplayName(String locale) => getLocalizedText(displayName, locale);
  
  /// Get description for locale
  String getDescription(String locale) => getLocalizedText(description, locale);
  
  /// Get welcome message for locale
  String getWelcomeMessage(String locale) => getLocalizedText(welcomeMessages, locale);
  
  /// Get ritual message for locale
  String getRitualMessage(String locale) => getLocalizedText(ritualMessages, locale);
  
  /// Get interpretation prompt for locale
  String getInterpretationPrompt(String locale) => getLocalizedText(interpretationPrompts, locale);
  
  /// Get follow-up questions for locale
  List<String> getFollowUpQuestions(String locale) {
    return followUpQuestions[locale] ?? followUpQuestions['en'] ?? <String>[];
  }
  
  /// Get error message for locale
  String getErrorMessage(String locale) => getLocalizedText(errorMessages, locale);
}

/// Feature configuration for premium tiers
@immutable
class PackFeatures {
  /// Creates pack features configuration
  const PackFeatures({
    required this.freeFeatures,
    required this.premiumFeatures,
    required this.premiumAnnualFeatures,
    required this.maxSessionsFree,
    required this.maxHistoryFree,
    required this.spreadsAvailable,
    this.specialFeatures,
  });
  
  /// Features available for free users
  final List<String> freeFeatures;
  
  /// Additional features for premium monthly
  final List<String> premiumFeatures;
  
  /// Additional features for premium annual
  final List<String> premiumAnnualFeatures;
  
  /// Maximum sessions per week for free users
  final int maxSessionsFree;
  
  /// Maximum history retention for free users (days)
  final int maxHistoryFree;
  
  /// Spread types available per tier
  final Map<String, List<String>> spreadsAvailable;
  
  /// Special technique-specific features
  final Map<String, dynamic>? specialFeatures;
  
  /// Create from JSON configuration
  factory PackFeatures.fromJson(Map<String, dynamic> json) {
    return PackFeatures(
      freeFeatures: List<String>.from(json['freeFeatures'] as List<dynamic>),
      premiumFeatures: List<String>.from(json['premiumFeatures'] as List<dynamic>),
      premiumAnnualFeatures: List<String>.from(json['premiumAnnualFeatures'] as List<dynamic>),
      maxSessionsFree: json['maxSessionsFree'] as int,
      maxHistoryFree: json['maxHistoryFree'] as int,
      spreadsAvailable: (json['spreadsAvailable'] as Map<dynamic, dynamic>).map(
        (dynamic key, dynamic value) => MapEntry<String, List<String>>(
          key as String,
          List<String>.from(value as List<dynamic>),
        ),
      ),
      specialFeatures: json['specialFeatures'] as Map<String, dynamic>?,
    );
  }
  
  /// Get all features for a specific tier
  List<String> getFeaturesForTier(String tier) {
    switch (tier.toLowerCase()) {
      case 'free':
        return freeFeatures;
      case 'premium':
        return <String>[...freeFeatures, ...premiumFeatures];
      case 'premium_annual':
        return <String>[...freeFeatures, ...premiumFeatures, ...premiumAnnualFeatures];
      default:
        return freeFeatures;
    }
  }
  
  /// Check if a feature is available for a tier
  bool isFeatureAvailable(String feature, String tier) {
    return getFeaturesForTier(tier).contains(feature);
  }
  
  /// Get available spreads for a tier
  List<String> getSpreadsForTier(String tier) {
    return spreadsAvailable[tier] ?? spreadsAvailable['free'] ?? <String>[];
  }
}

/// Complete app pack configuration
@immutable
class AppPack {
  /// Creates an app pack
  const AppPack({
    required this.technique,
    required this.version,
    required this.colorPalette,
    required this.assets,
    required this.content,
    required this.features,
    required this.metadata,
  });
  
  /// Divination technique for this pack
  final DivinationTechnique technique;
  
  /// Pack version for compatibility checking
  final String version;
  
  /// Color scheme and theming
  final TechniqueColorPalette colorPalette;
  
  /// Asset paths and resources
  final PackAssets assets;
  
  /// Localized content and text
  final PackContent content;
  
  /// Feature configuration by tier
  final PackFeatures features;
  
  /// Additional metadata
  final Map<String, dynamic> metadata;
  
  /// Create from JSON configuration
  factory AppPack.fromJson(DivinationTechnique technique, Map<String, dynamic> json) {
    final String basePath = 'assets/packs/${technique.name}';
    
    return AppPack(
      technique: technique,
      version: json['version'] as String,
      colorPalette: TechniqueColorPalette.fromJson(json['colorPalette'] as Map<String, dynamic>),
      assets: PackAssets.fromJson(basePath, json['assets'] as Map<String, dynamic>),
      content: PackContent.fromJson(json['content'] as Map<String, dynamic>),
      features: PackFeatures.fromJson(json['features'] as Map<String, dynamic>),
      metadata: json['metadata'] as Map<String, dynamic>? ?? <String, dynamic>{},
    );
  }
  
  /// Get app display name for locale
  String getAppName(String locale) => content.getDisplayName(locale);
  
  /// Get app icon
  String get appIcon => technique.icon;
  
  /// Create Material Theme from pack colors
  ThemeData createTheme({
    Brightness brightness = Brightness.light,
    String? fontFamily,
  }) {
    final ColorScheme colorScheme = colorPalette.toColorScheme(brightness: brightness);
    
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      brightness: brightness,
      fontFamily: fontFamily,
      
      // Custom component themes
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
      ),
    );
  }
  
  /// Get technique-specific configuration value
  T? getConfigValue<T>(String key, [T? defaultValue]) {
    return metadata[key] as T? ?? defaultValue;
  }
}

/// Pack system for loading and managing technique configurations
class PackSystem {
  /// Creates a pack system instance
  PackSystem();
  
  final Map<DivinationTechnique, AppPack> _loadedPacks = <DivinationTechnique, AppPack>{};
  
  /// Load pack configuration for a technique
  Future<AppPack> loadPack(DivinationTechnique technique) async {
    // Return cached pack if already loaded
    if (_loadedPacks.containsKey(technique)) {
      return _loadedPacks[technique]!;
    }
    
    // Load pack manifest from assets
    final String manifestPath = 'assets/packs/${technique.name}/manifest.json';
    
    try {
      final String jsonString = await rootBundle.loadString(manifestPath);
      final Map<String, dynamic> json = jsonDecode(jsonString) as Map<String, dynamic>;
      
      final AppPack pack = AppPack.fromJson(technique, json);
      
      // Cache loaded pack
      _loadedPacks[technique] = pack;
      
      return pack;
      
    } catch (e) {
      throw Exception('Failed to load pack for ${technique.name}: $e');
    }
  }
  
  /// Get cached pack (throws if not loaded)
  AppPack getCachedPack(DivinationTechnique technique) {
    final AppPack? pack = _loadedPacks[technique];
    if (pack == null) {
      throw StateError('Pack for ${technique.name} not loaded. Call loadPack() first.');
    }
    return pack;
  }
  
  /// Check if pack is loaded
  bool isPackLoaded(DivinationTechnique technique) {
    return _loadedPacks.containsKey(technique);
  }
  
  /// Preload all packs for better performance
  Future<void> preloadAllPacks() async {
    for (final DivinationTechnique technique in DivinationTechnique.values) {
      await loadPack(technique);
    }
  }
  
  /// Clear all cached packs
  void clearCache() {
    _loadedPacks.clear();
  }
  
  /// Get loading statistics
  Map<String, dynamic> getStats() {
    return <String, dynamic>{
      'loaded_packs': _loadedPacks.length,
      'total_packs': DivinationTechnique.values.length,
      'loaded_techniques': _loadedPacks.keys.map((DivinationTechnique t) => t.name).toList(),
    };
  }
}