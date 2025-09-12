/// App Configuration - Environment-based application setup
/// 
/// This system manages application configuration based on build-time environment
/// variables, enabling one codebase to build three distinct applications.
library app_config;

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../contracts/divination_technique.dart';

/// Provider for app configuration singleton
final Provider<AppConfig> appConfigProvider = Provider<AppConfig>((ProviderRef<AppConfig> ref) {
  return AppConfig._();
});

/// Provider for package information
final FutureProvider<PackageInfo> packageInfoProvider = FutureProvider<PackageInfo>((FutureProviderRef<PackageInfo> ref) async {
  return PackageInfo.fromPlatform();
});

/// Environment types for different build configurations
enum BuildEnvironment {
  /// Development environment
  development('development'),
  
  /// Staging environment for testing
  staging('staging'),
  
  /// Production environment for app stores
  production('production');
  
  const BuildEnvironment(this.name);
  
  /// Environment name
  final String name;
  
  /// Get environment from string
  static BuildEnvironment fromString(String env) {
    return values.firstWhere(
      (BuildEnvironment e) => e.name == env,
      orElse: () => BuildEnvironment.development,
    );
  }
}

/// Application configuration based on environment variables
class AppConfig {
  /// Private constructor - use provider for access
  AppConfig._() {
    _loadConfiguration();
  }
  
  // Environment Variables (set at build time)
  static const String _appTechnique = String.fromEnvironment('APP_TECHNIQUE', defaultValue: 'tarot');
  static const String _appName = String.fromEnvironment('APP_NAME', defaultValue: 'Smart Tarot');
  static const String _primaryColor = String.fromEnvironment('PRIMARY_COLOR', defaultValue: '0xFF4C1D95');
  static const String _buildEnvironment = String.fromEnvironment('BUILD_ENV', defaultValue: 'development');
  static const String _apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'https://smart-divination.vercel.app');
  static const String _randomOrgApiKey = String.fromEnvironment('RANDOM_ORG_API_KEY', defaultValue: '');
  static const String _deepseekApiKey = String.fromEnvironment('DEEPSEEK_API_KEY', defaultValue: '');
  static const bool _enableAnalytics = bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: false);
  static const bool _enableCrashlytics = bool.fromEnvironment('ENABLE_CRASHLYTICS', defaultValue: false);
  static const bool _enableDebugLogging = bool.fromEnvironment('DEBUG_LOGGING', defaultValue: false);
  
  // Computed Configuration
  late final DivinationTechnique _technique;
  late final BuildEnvironment _environment;
  late final Color _primaryColorValue;
  
  /// Load and validate configuration
  void _loadConfiguration() {
    // Parse technique
    try {
      _technique = DivinationTechnique.fromName(_appTechnique);
    } catch (e) {
      throw ConfigurationException('Invalid APP_TECHNIQUE: $_appTechnique. Must be one of: ${DivinationTechnique.allNames}');
    }
    
    // Parse environment
    _environment = BuildEnvironment.fromString(_buildEnvironment);
    
    // Parse primary color
    try {
      final int colorValue = int.parse(_primaryColor);
      _primaryColorValue = Color(colorValue);
    } catch (e) {
      throw ConfigurationException('Invalid PRIMARY_COLOR: $_primaryColor. Must be a valid hex color code.');
    }
    
    // Validate required API keys for production
    if (_environment == BuildEnvironment.production) {
      if (_randomOrgApiKey.isEmpty) {
        throw ConfigurationException('RANDOM_ORG_API_KEY is required for production builds');
      }
      if (_deepseekApiKey.isEmpty) {
        throw ConfigurationException('DEEPSEEK_API_KEY is required for production builds');
      }
    }
    
    // Log configuration in debug mode
    if (kDebugMode && _enableDebugLogging) {
      debugPrint('🔧 AppConfig loaded:');
      debugPrint('  • Technique: ${_technique.name}');
      debugPrint('  • App Name: $_appName');
      debugPrint('  • Environment: ${_environment.name}');
      debugPrint('  • Primary Color: $_primaryColor');
      debugPrint('  • API Base URL: $_apiBaseUrl');
      debugPrint('  • Analytics: $_enableAnalytics');
      debugPrint('  • Debug Logging: $_enableDebugLogging');
    }
  }
  
  // Public Getters
  
  /// Current app's divination technique
  DivinationTechnique get technique => _technique;
  
  /// App display name
  String get appName => _appName;
  
  /// Primary theme color
  Color get primaryColor => _primaryColorValue;
  
  /// Build environment
  BuildEnvironment get environment => _environment;
  
  /// API base URL for backend services
  String get apiBaseUrl => _apiBaseUrl;
  
  /// Random.org API key for cryptographic randomness
  String get randomOrgApiKey => _randomOrgApiKey;
  
  /// DeepSeek API key for AI interpretations
  String get deepseekApiKey => _deepseekApiKey;
  
  /// Whether analytics is enabled
  bool get analyticsEnabled => _enableAnalytics;
  
  /// Whether crashlytics is enabled
  bool get crashlyticsEnabled => _enableCrashlytics;
  
  /// Whether debug logging is enabled
  bool get debugLoggingEnabled => _enableDebugLogging;
  
  // Environment Checks
  
  /// Check if this is a development build
  bool get isDevelopment => _environment == BuildEnvironment.development;
  
  /// Check if this is a staging build
  bool get isStaging => _environment == BuildEnvironment.staging;
  
  /// Check if this is a production build
  bool get isProduction => _environment == BuildEnvironment.production;
  
  /// Check if this is a debug build (Flutter debug mode)
  bool get isDebugMode => kDebugMode;
  
  /// Check if this is a release build (Flutter release mode)
  bool get isReleaseMode => kReleaseMode;
  
  /// Check if this is a profile build (Flutter profile mode)
  bool get isProfileMode => kProfileMode;
  
  // App-Specific Configuration
  
  /// Get app icon based on technique
  String get appIcon => _technique.icon;
  
  /// Get app bundle/package identifier base
  String get bundleIdBase => 'com.smartdivination';
  
  /// Get full bundle identifier
  String get bundleId => '$bundleIdBase.${_technique.name}';
  
  /// Get app display name with technique
  String get fullAppName => 'Smart ${_technique.displayName}';
  
  /// Get app store category
  String get appStoreCategory => 'Lifestyle';
  
  /// Get content rating
  String get contentRating => _technique == DivinationTechnique.tarot ? '12+' : '4+';
  
  // Feature Flags
  
  /// Whether Random.org integration is enabled
  bool get randomOrgEnabled => _randomOrgApiKey.isNotEmpty;
  
  /// Whether AI interpretation is enabled  
  bool get aiInterpretationEnabled => _deepseekApiKey.isNotEmpty;
  
  /// Whether offline mode is supported
  bool get offlineModeSupported => true;
  
  /// Whether in-app purchases are enabled
  bool get inAppPurchasesEnabled => isProduction;
  
  /// Whether push notifications are enabled
  bool get pushNotificationsEnabled => isProduction && analyticsEnabled;
  
  // Localization
  
  /// Supported locales
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'), // English
    Locale('es'), // Spanish
    Locale('ca'), // Catalan
  ];
  
  /// Default locale
  static const Locale defaultLocale = Locale('en');
  
  /// Fallback locale for missing translations
  static const Locale fallbackLocale = Locale('en');
  
  // API Configuration
  
  /// API timeout duration
  Duration get apiTimeout => const Duration(seconds: 30);
  
  /// AI interpretation timeout
  Duration get aiTimeout => const Duration(seconds: 60);
  
  /// Maximum retry attempts for API calls
  int get maxRetryAttempts => 3;
  
  /// Retry delay for API calls
  Duration get retryDelay => const Duration(seconds: 2);
  
  // Storage Configuration
  
  /// Maximum sessions to cache locally
  int get maxCachedSessions => 100;
  
  /// Session cache expiry duration
  Duration get sessionCacheExpiry => const Duration(days: 30);
  
  /// Maximum database size in MB
  int get maxDatabaseSizeMB => 50;
  
  // Rate Limiting (Free Users)
  
  /// Maximum sessions per week for free users
  int get freeSessionsPerWeek => 7;
  
  /// Maximum history retention for free users (days)
  int get freeHistoryRetentionDays => 7;
  
  /// Maximum concurrent sessions
  int get maxConcurrentSessions => 1;
  
  // Debug & Analytics
  
  /// Analytics events to track
  List<String> get analyticsEvents => <String>[
    'app_opened',
    'session_started',
    'divination_performed',
    'interpretation_received',
    'session_completed',
    'premium_upgrade_prompted',
    'premium_purchased',
    'error_occurred',
  ];
  
  /// Debug information for support
  Map<String, dynamic> getDebugInfo() => <String, dynamic>{
    'app_name': appName,
    'technique': technique.name,
    'environment': environment.name,
    'build_mode': kDebugMode ? 'debug' : kReleaseMode ? 'release' : 'profile',
    'api_base_url': apiBaseUrl,
    'random_org_enabled': randomOrgEnabled,
    'ai_enabled': aiInterpretationEnabled,
    'analytics_enabled': analyticsEnabled,
    'crashlytics_enabled': crashlyticsEnabled,
    'in_app_purchases_enabled': inAppPurchasesEnabled,
    'supported_locales': supportedLocales.map((Locale l) => l.languageCode).toList(),
  };
  
  /// Validate current configuration
  void validate() {
    // Check technique is valid
    if (!DivinationTechnique.values.contains(_technique)) {
      throw ConfigurationException('Invalid technique: ${_technique.name}');
    }
    
    // Check required URLs are valid
    if (!_apiBaseUrl.startsWith('http')) {
      throw ConfigurationException('Invalid API base URL: $_apiBaseUrl');
    }
    
    // Check production requirements
    if (isProduction) {
      if (_randomOrgApiKey.isEmpty || _deepseekApiKey.isEmpty) {
        throw ConfigurationException('Production builds require both RANDOM_ORG_API_KEY and DEEPSEEK_API_KEY');
      }
    }
    
    // Check color is valid
    if (_primaryColorValue == const Color(0x00000000)) {
      throw ConfigurationException('Primary color cannot be transparent');
    }
  }
  
  /// Create app-specific theme data
  ThemeData createTheme({Brightness brightness = Brightness.light}) {
    final ColorScheme baseColorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: brightness,
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: baseColorScheme,
      brightness: brightness,
      
      // App-specific customizations
      appBarTheme: AppBarTheme(
        backgroundColor: baseColorScheme.surface,
        foregroundColor: baseColorScheme.onSurface,
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
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: baseColorScheme.surfaceVariant.withOpacity(0.3),
      ),
    );
  }
}

/// Exception thrown for configuration errors
class ConfigurationException implements Exception {
  /// Creates a configuration exception
  const ConfigurationException(this.message);
  
  /// Error message
  final String message;
  
  @override
  String toString() => 'ConfigurationException: $message';
}