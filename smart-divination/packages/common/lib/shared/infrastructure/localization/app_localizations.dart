/// App Localizations adapter (gen-l10n)
///
/// Wraps generated `CommonStrings` to preserve the existing
/// `AppLocalizations` API across apps and packages.
library app_localizations;

import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import 'package:common/l10n/common_strings_en.dart';

class AppLocalizations {
  final CommonStrings _s;
  const AppLocalizations(this._s);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(CommonStringsEn());
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  String get allowReversed => _s.allowReversed;
  String get drawingInProgress => _s.drawingInProgress;
  String get seedOptionalLabel => _s.seedOptionalLabel;
  String get generateSeed => _s.generateSeed;
  String get interpretationHeading => _s.interpretationHeading;
  String get historyHeading => _s.historyHeading;
  String get drawPlaceholder => _s.drawPlaceholder;
  String get cardOrientationUpright => _s.cardOrientationUpright;
  String get cardOrientationReversed => _s.cardOrientationReversed;
  String get authSignInTitle => _s.authSignInTitle;
  String get authSignUpTitle => _s.authSignUpTitle;
  String get authEmailLabel => _s.authEmailLabel;
  String get authPasswordLabel => _s.authPasswordLabel;
  String get authPasswordLabelWithHint => _s.authPasswordLabelWithHint;
  String get authSignInButton => _s.authSignInButton;
  String get authSignUpButton => _s.authSignUpButton;
  String get authToggleToSignIn => _s.authToggleToSignIn;
  String get authToggleToSignUp => _s.authToggleToSignUp;
  String get authValidationError => _s.authValidationError;
  String get authSignInSuccess => _s.authSignInSuccess;
  String get authSignUpConfirmationSent => _s.authSignUpConfirmationSent;
  String get authSignUpSuccess => _s.authSignUpSuccess;
  String get authForgotPasswordLink => _s.authForgotPasswordLink;
  String get authForgotPasswordTitle => _s.authForgotPasswordTitle;
  String get authForgotPasswordDescription => _s.authForgotPasswordDescription;
  String get authForgotPasswordSubmit => _s.authForgotPasswordSubmit;
  String get authForgotPasswordSuccess => _s.authForgotPasswordSuccess;
  String get authForgotPasswordMissingEmail =>
      _s.authForgotPasswordMissingEmail;
  String get authPasswordResetTitle => _s.authPasswordResetTitle;
  String get authPasswordResetDescription => _s.authPasswordResetDescription;
  String get authPasswordResetNewPasswordLabel =>
      _s.authPasswordResetNewPasswordLabel;
  String get authPasswordResetConfirmPasswordLabel =>
      _s.authPasswordResetConfirmPasswordLabel;
  String get authPasswordResetButton => _s.authPasswordResetButton;
  String get authPasswordResetSuccess => _s.authPasswordResetSuccess;
  String get authPasswordResetMismatch => _s.authPasswordResetMismatch;
  String get authPasswordResetError => _s.authPasswordResetError;
  String get authPasswordResetSignOutNotice =>
      _s.authPasswordResetSignOutNotice;
  String get authGenericError => _s.authGenericError;
  String authUnexpectedError(String error) => _s.authUnexpectedError(error);
  String latestDrawTitle(int count) => _s.latestDrawTitle(count);
  String spreadLabel(String spread) => _s.spreadLabel(spread);
  String methodSeedLabel(String method, String seed) =>
      _s.methodSeedLabel(method, seed);
  String methodLabel(String method) => _s.methodLabel(method);
  String seedLabel(String seed) => _s.seedLabel(seed);
  String tierLabel(String tier) => _s.tierLabel(tier);
  String usageToday(int used, int limit) => _s.usageToday(used, limit);
  String usageWeek(int used, int limit) => _s.usageWeek(used, limit);
  String usageMonth(int used, int limit) => _s.usageMonth(used, limit);
  String remainingToday(int remaining) => _s.remainingToday(remaining);
  String nextWindow(String timestamp) => _s.nextWindow(timestamp);

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

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
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
