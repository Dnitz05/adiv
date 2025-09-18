class Environment {
  // Backend configuration
  static const String _defaultBackendUrl = 'https://your-app.vercel.app';
  static const String backendUrl = String.fromEnvironment(
    'BACKEND_URL', 
    defaultValue: _defaultBackendUrl,
  );
  
  // Feature flags
  static const bool enableDemoMode = bool.fromEnvironment('DEMO_MODE', defaultValue: false);
  static const bool enableDebugLogging = bool.fromEnvironment('DEBUG_LOGGING', defaultValue: false);
  static const bool enablePremiumFeatures = bool.fromEnvironment('PREMIUM_FEATURES', defaultValue: true);
  
  // Pack configuration
  static const String defaultPack = String.fromEnvironment('DEFAULT_PACK', defaultValue: 'tarot');
  
  // Rate limiting (for free users)
  static const int freeSessionsPerWeek = int.fromEnvironment('FREE_SESSIONS_PER_WEEK', defaultValue: 7);
  static const int maxHistorySessionsFree = int.fromEnvironment('MAX_HISTORY_FREE', defaultValue: 3);
  
  // API timeouts
  static const int apiTimeoutSeconds = int.fromEnvironment('API_TIMEOUT', defaultValue: 30);
  static const int interpretationTimeoutSeconds = int.fromEnvironment('INTERPRETATION_TIMEOUT', defaultValue: 60);
  
  // Cache configuration
  static const int sessionCacheDurationMinutes = int.fromEnvironment('SESSION_CACHE_MINUTES', defaultValue: 30);
  
  // Validation
  static void validate() {
    assert(backendUrl.isNotEmpty, 'Backend URL cannot be empty');
    assert(freeSessionsPerWeek > 0, 'Free sessions per week must be positive');
    assert(apiTimeoutSeconds > 0, 'API timeout must be positive');
  }
  
  // Debug info
  static Map<String, dynamic> getDebugInfo() {
    return {
      'backend_url': backendUrl,
      'demo_mode': enableDemoMode,
      'debug_logging': enableDebugLogging,
      'premium_features': enablePremiumFeatures,
      'default_pack': defaultPack,
      'free_sessions_per_week': freeSessionsPerWeek,
      'max_history_sessions_free': maxHistorySessionsFree,
      'api_timeout_seconds': apiTimeoutSeconds,
      'interpretation_timeout_seconds': interpretationTimeoutSeconds,
    };
  }
}