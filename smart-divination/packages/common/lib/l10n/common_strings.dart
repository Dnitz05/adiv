// Lightweight localization class to mirror Flutter gen-l10n output
// Generated-like API for CommonStrings consumed by AppLocalizations adapter.

import 'package:flutter/widgets.dart';

class CommonStrings {
  final Locale locale;
  const CommonStrings(this.locale);

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ca'),
  ];

  static const LocalizationsDelegate<CommonStrings> delegate = _CommonStringsDelegate();

  // English (default)
  static const Map<String, String> _en = {
    'appTitleTarot': 'Smart Tarot',
    'appTitleIching': 'Smart I Ching',
    'appTitleRunes': 'Smart Runes',
    'welcome': 'Welcome!',
    'selectTechnique': 'Which technique would you like to explore today?',
    'tarot': 'Tarot',
    'iching': 'I Ching',
    'runes': 'Runes',
    'tarotDescription': 'Cards for guidance and reflection',
    'ichingDescription': 'Ancient Chinese wisdom',
    'runesDescription': 'Nordic symbols of power',
    'startSession': 'Start Session',
    'continueSession': 'Continue Session',
    'endSession': 'End Session',
    'history': 'Session History',
    'askQuestion': 'Ask your question...',
    'networkError': 'Network connection error. Please check your connection.',
    'sessionLimitReached': 'Session limit reached. Upgrade to premium for unlimited sessions.',
    'premium': 'Premium',
    'upgradeToPremium': 'Upgrade to Premium',
    'unlimitedSessions': 'Unlimited Sessions',
    'settings': 'Settings',
    'language': 'Language',
    'darkMode': 'Dark Mode',
    'ok': 'OK',
    'cancel': 'Cancel',
    'save': 'Save',
    'close': 'Close',
  };

  // Spanish (may require refinement if tests assert specific punctuation)
  static const Map<String, String> _es = {
    'appTitleTarot': 'Tarot Inteligente',
    'appTitleIching': 'I Ching Inteligente',
    'appTitleRunes': 'Runas Inteligentes',
    'welcome': '¡Bienvenido/a!',
    'selectTechnique': '¿Qué técnica te gustaría explorar hoy?',
    'tarot': 'Tarot',
    'iching': 'I Ching',
    'runes': 'Runas',
    'tarotDescription': 'Cartas para orientación y reflexión',
    'ichingDescription': 'Sabiduría ancestral china',
    'runesDescription': 'Símbolos nórdicos de poder',
    'startSession': 'Iniciar Sesión',
    'continueSession': 'Continuar Sesión',
    'endSession': 'Finalizar Sesión',
    'history': 'Historial de Sesiones',
    'askQuestion': 'Formula tu pregunta...',
    'networkError': 'Error de conexión de red. Por favor verifica tu conexión.',
    'sessionLimitReached': 'Límite de sesiones alcanzado. Mejora a premium para sesiones ilimitadas.',
    'premium': 'Premium',
    'upgradeToPremium': 'Actualizar a Premium',
    'unlimitedSessions': 'Sesiones ilimitadas',
    'settings': 'Configuración',
    'language': 'Idioma',
    'darkMode': 'Modo Oscuro',
    'ok': 'OK',
    'cancel': 'Cancelar',
    'save': 'Guardar',
    'close': 'Cerrar',
  };

  // Catalan
  static const Map<String, String> _ca = {
    'appTitleTarot': 'Tarot Intel·ligent',
    'appTitleIching': 'I Ching Intel·ligent',
    'appTitleRunes': 'Runes Intel·ligents',
    'welcome': 'Benvingut/da!',
    'selectTechnique': 'Quina tècnica t’agradaria explorar avui?',
    'tarot': 'Tarot',
    'iching': 'I Ching',
    'runes': 'Runes',
    'tarotDescription': 'Cartes per a orientació i reflexió',
    'ichingDescription': 'Saviesa ancestral xinesa',
    'runesDescription': 'Símbols nòrdics de poder',
    'startSession': 'Iniciar Sessió',
    'continueSession': 'Continuar Sessió',
    'endSession': 'Finalitzar Sessió',
    'history': 'Historial de Sessions',
    'askQuestion': 'Fes la teva pregunta...',
    'networkError': 'Error de connexió de xarxa. Comprova la teva connexió.',
    'sessionLimitReached': 'Límit de sessions assolit. Actualitza a premium per a sessions il·limitades.',
    'premium': 'Premium',
    'upgradeToPremium': 'Actualitza a Premium',
    'unlimitedSessions': 'Sessions il·limitades',
    'settings': 'Configuració',
    'language': 'Idioma',
    'darkMode': 'Mode Fosc',
    'ok': 'D\'acord',
    'cancel': 'Cancel·lar',
    'save': 'Desar',
    'close': 'Tancar',
  };

  Map<String, String> get _map {
    switch (locale.languageCode) {
      case 'es':
        return _es;
      case 'ca':
        return _ca;
      case 'en':
      default:
        return _en;
    }
  }

  String get appTitleTarot => _map['appTitleTarot']!;
  String get appTitleIching => _map['appTitleIching']!;
  String get appTitleRunes => _map['appTitleRunes']!;
  String get welcome => _map['welcome']!;
  String get selectTechnique => _map['selectTechnique']!;
  String get tarot => _map['tarot']!;
  String get iching => _map['iching']!;
  String get runes => _map['runes']!;
  String get tarotDescription => _map['tarotDescription']!;
  String get ichingDescription => _map['ichingDescription']!;
  String get runesDescription => _map['runesDescription']!;
  String get startSession => _map['startSession']!;
  String get continueSession => _map['continueSession']!;
  String get endSession => _map['endSession']!;
  String get history => _map['history']!;
  String get askQuestion => _map['askQuestion']!;
  String get networkError => _map['networkError']!;
  String get sessionLimitReached => _map['sessionLimitReached']!;
  String get premium => _map['premium']!;
  String get upgradeToPremium => _map['upgradeToPremium']!;
  String get unlimitedSessions => _map['unlimitedSessions']!;
  String get settings => _map['settings']!;
  String get language => _map['language']!;
  String get darkMode => _map['darkMode']!;
  String get ok => _map['ok']!;
  String get cancel => _map['cancel']!;
  String get save => _map['save']!;
  String get close => _map['close']!;
}

class _CommonStringsDelegate extends LocalizationsDelegate<CommonStrings> {
  const _CommonStringsDelegate();

  @override
  bool isSupported(Locale locale) =>
      CommonStrings.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<CommonStrings> load(Locale locale) async => CommonStrings(locale);

  @override
  bool shouldReload(LocalizationsDelegate<CommonStrings> old) => false;
}

