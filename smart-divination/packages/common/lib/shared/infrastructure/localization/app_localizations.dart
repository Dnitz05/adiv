/// App Localizations adapter (gen-l10n)
///
/// Wraps generated `CommonStrings` to preserve the existing
/// `AppLocalizations` API across apps and packages.
library app_localizations;

import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

class AppLocalizations {
  final CommonStrings _s;
  const AppLocalizations(this._s);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(CommonStrings(const Locale('en')));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static List<Locale> get supportedLocales => CommonStrings.supportedLocales;

  String appTitle(String technique) {
    switch (technique) {
      case 'tarot':
        return _s.appTitleTarot;
      case 'iching':
        return _s.appTitleIching;
      case 'runes':
        return _s.appTitleRunes;
      default:
        return technique;
    }
  }

  // Exposed getters mapped from generated keys
  String get welcome => _s.welcome;
  String get selectTechnique => _s.selectTechnique;
  String get tarot => _s.tarot;
  String get iching => _s.iching;
  String get runes => _s.runes;
  String get tarotDescription => _s.tarotDescription;
  String get ichingDescription => _s.ichingDescription;
  String get runesDescription => _s.runesDescription;
  String get startSession => _s.startSession;
  String get continueSession => _s.continueSession;
  String get endSession => _s.endSession;
  String get history => _s.history;
  String get askQuestion => _s.askQuestion;
  String get networkError => _s.networkError;
  String get sessionLimitReached => _s.sessionLimitReached;
  String get premium => _s.premium;
  String get upgradeToPremium => _s.upgradeToPremium;
  String get unlimitedSessions => _s.unlimitedSessions;
  String get settings => _s.settings;
  String get language => _s.language;
  String get darkMode => _s.darkMode;
  String get ok => _s.ok;
  String get cancel => _s.cancel;
  String get save => _s.save;
  String get close => _s.close;

  String getTechniqueName(String technique) {
    switch (technique) {
      case 'tarot':
        return tarot;
      case 'iching':
        return iching;
      case 'runes':
        return runes;
      default:
        return technique;
    }
  }

  String getTechniqueDescription(String technique) {
    switch (technique) {
      case 'tarot':
        return tarotDescription;
      case 'iching':
        return ichingDescription;
      case 'runes':
        return runesDescription;
      default:
        return '';
    }
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return CommonStrings.supportedLocales
        .any((l) => l.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final strings = await CommonStrings.delegate.load(locale);
    return AppLocalizations(strings);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}

