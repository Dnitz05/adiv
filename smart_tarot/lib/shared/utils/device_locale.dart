import 'dart:ui';

class DeviceLocaleDetector {
  static const List<String> supportedLanguages = ['en', 'es', 'ca'];
  
  static String detectLanguage() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    final languageCode = deviceLocale.languageCode.toLowerCase();
    
    // Check if we support the device language
    if (supportedLanguages.contains(languageCode)) {
      return languageCode;
    }
    
    // Fallback to English
    return 'en';
  }
  
  static bool isSupported(String languageCode) {
    return supportedLanguages.contains(languageCode.toLowerCase());
  }
  
  static String getLanguageName(String languageCode) {
    const names = {
      'en': 'English',
      'es': 'Español', 
      'ca': 'Català',
    };
    
    return names[languageCode.toLowerCase()] ?? languageCode.toUpperCase();
  }
  
  static String getLanguageNativeName(String languageCode) {
    const nativeNames = {
      'en': 'English',
      'es': 'Español',
      'ca': 'Català',
    };
    
    return nativeNames[languageCode.toLowerCase()] ?? languageCode.toUpperCase();
  }
}