import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'common_strings_ca.dart';
import 'common_strings_en.dart';
import 'common_strings_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of CommonStrings
/// returned by `CommonStrings.of(context)`.
///
/// Applications need to include `CommonStrings.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/common_strings.dart';
///
/// return MaterialApp(
///   localizationsDelegates: CommonStrings.localizationsDelegates,
///   supportedLocales: CommonStrings.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, youÃ¢â‚¬â„¢ll need to edit this
/// file.
///
/// First, open your projectÃ¢â‚¬â„¢s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// projectÃ¢â‚¬â„¢s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the CommonStrings.supportedLocales
/// property.
abstract class CommonStrings {
  CommonStrings(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static CommonStrings of(BuildContext context) {
    return Localizations.of<CommonStrings>(context, CommonStrings)!;
  }

  static const LocalizationsDelegate<CommonStrings> delegate =
      _CommonStringsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ca')
  ];

  /// No description provided for @allowReversed.
  ///
  /// In en, this message translates to:
  /// **'Allow reversed cards'**
  String get allowReversed;

  /// No description provided for @appTitleIching.
  ///
  /// In en, this message translates to:
  /// **'Smart I Ching'**
  String get appTitleIching;

  /// No description provided for @appTitleRunes.
  ///
  /// In en, this message translates to:
  /// **'Smart Runes'**
  String get appTitleRunes;

  /// No description provided for @appTitleTarot.
  ///
  /// In en, this message translates to:
  /// **'Smart Tarot'**
  String get appTitleTarot;

  /// No description provided for @askQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask your question...'**
  String get askQuestion;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authForgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the email associated with your account and we\'ll send reset instructions.'**
  String get authForgotPasswordDescription;

  /// No description provided for @authForgotPasswordLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPasswordLink;

  /// No description provided for @authForgotPasswordMissingEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address to continue.'**
  String get authForgotPasswordMissingEmail;

  /// No description provided for @authForgotPasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send email'**
  String get authForgotPasswordSubmit;

  /// No description provided for @authForgotPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent. Check your inbox.'**
  String get authForgotPasswordSuccess;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authForgotPasswordTitle;

  /// No description provided for @authGenericError.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed.'**
  String get authGenericError;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordLabelWithHint.
  ///
  /// In en, this message translates to:
  /// **'Password (min 6 characters)'**
  String get authPasswordLabelWithHint;

  /// No description provided for @authPasswordResetButton.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get authPasswordResetButton;

  /// No description provided for @authPasswordResetConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authPasswordResetConfirmPasswordLabel;

  /// No description provided for @authPasswordResetDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter a new password to finish resetting your account.'**
  String get authPasswordResetDescription;

  /// No description provided for @authPasswordResetError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update password. Please try again.'**
  String get authPasswordResetError;

  /// No description provided for @authPasswordResetMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords must match and include at least 6 characters.'**
  String get authPasswordResetMismatch;

  /// No description provided for @authPasswordResetNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get authPasswordResetNewPasswordLabel;

  /// No description provided for @authPasswordResetSignOutNotice.
  ///
  /// In en, this message translates to:
  /// **'For security reasons you will be signed out after updating the password.'**
  String get authPasswordResetSignOutNotice;

  /// No description provided for @authPasswordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated. You can sign in with the new password.'**
  String get authPasswordResetSuccess;

  /// No description provided for @authPasswordResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a new password'**
  String get authPasswordResetTitle;

  /// No description provided for @authSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignInButton;

  /// No description provided for @authSignInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully.'**
  String get authSignInSuccess;

  /// No description provided for @authSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to Smart Tarot'**
  String get authSignInTitle;

  /// No description provided for @authSignUpButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authSignUpButton;

  /// No description provided for @authSignUpConfirmationSent.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox to confirm the account before signing in.'**
  String get authSignUpConfirmationSent;

  /// No description provided for @authSignUpSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully.'**
  String get authSignUpSuccess;

  /// No description provided for @authSignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your Smart Tarot account'**
  String get authSignUpTitle;

  /// No description provided for @authToggleToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get authToggleToSignIn;

  /// No description provided for @authToggleToSignUp.
  ///
  /// In en, this message translates to:
  /// **'Need an account? Create one'**
  String get authToggleToSignUp;

  /// No description provided for @authUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error: {error}'**
  String authUnexpectedError(Object error);

  /// No description provided for @authValidationError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email and a password of at least 6 characters.'**
  String get authValidationError;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cardOrientationReversed.
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get cardOrientationReversed;

  /// No description provided for @cardOrientationUpright.
  ///
  /// In en, this message translates to:
  /// **'Upright'**
  String get cardOrientationUpright;

  /// No description provided for @cardPositionLabel.
  ///
  /// In en, this message translates to:
  /// **'{position}. {name}'**
  String cardPositionLabel(Object name, int position);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @continueSession.
  ///
  /// In en, this message translates to:
  /// **'Continue Session'**
  String get continueSession;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @drawPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Draw cards to receive guidance.'**
  String get drawPlaceholder;

  /// No description provided for @drawSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your reading is ready. Latest draw updated below.'**
  String get drawSuccessMessage;

  /// No description provided for @drawingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Drawing...'**
  String get drawingInProgress;

  /// No description provided for @endSession.
  ///
  /// In en, this message translates to:
  /// **'End Session'**
  String get endSession;

  /// No description provided for @generateSeed.
  ///
  /// In en, this message translates to:
  /// **'Generate seed'**
  String get generateSeed;

  /// No description provided for @genericUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericUnexpectedError;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'Session History'**
  String get history;

  /// No description provided for @historyHeading.
  ///
  /// In en, this message translates to:
  /// **'Previous draws'**
  String get historyHeading;

  /// No description provided for @iching.
  ///
  /// In en, this message translates to:
  /// **'I Ching'**
  String get iching;

  /// No description provided for @ichingDescription.
  ///
  /// In en, this message translates to:
  /// **'Ancient Chinese wisdom'**
  String get ichingDescription;

  /// No description provided for @interpretationHeading.
  ///
  /// In en, this message translates to:
  /// **'Interpretation'**
  String get interpretationHeading;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @latestDrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest draw ({count} cards)'**
  String latestDrawTitle(int count);

  /// No description provided for @methodLabel.
  ///
  /// In en, this message translates to:
  /// **'Method: {method}'**
  String methodLabel(Object method);

  /// No description provided for @methodSeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Method: {method} Ã¢â‚¬Â¢ Seed: {seed}'**
  String methodSeedLabel(Object method, Object seed);

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network connection error. Please check your connection.'**
  String get networkError;

  /// No description provided for @nextWindow.
  ///
  /// In en, this message translates to:
  /// **'Next window: {timestamp}'**
  String nextWindow(Object timestamp);

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @remainingToday.
  ///
  /// In en, this message translates to:
  /// **'Remaining today: {remaining}'**
  String remainingToday(int remaining);

  /// No description provided for @runes.
  ///
  /// In en, this message translates to:
  /// **'Runes'**
  String get runes;

  /// No description provided for @runesDescription.
  ///
  /// In en, this message translates to:
  /// **'Nordic symbols of power'**
  String get runesDescription;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @seedLabel.
  ///
  /// In en, this message translates to:
  /// **'Seed: {seed}'**
  String seedLabel(Object seed);

  /// No description provided for @seedOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Seed (optional)'**
  String get seedOptionalLabel;

  /// No description provided for @selectTechnique.
  ///
  /// In en, this message translates to:
  /// **'Which technique would you like to explore today?'**
  String get selectTechnique;

  /// No description provided for @sessionLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Session limit reached. Upgrade to premium for unlimited sessions.'**
  String get sessionLimitReached;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @spreadName.
  ///
  /// In en, this message translates to:
  /// **'{spreadId}'**
  String spreadName(String spreadId);

  /// No description provided for @spreadDescription.
  ///
  /// In en, this message translates to:
  /// **'{spreadId} description'**
  String spreadDescription(String spreadId);

  /// No description provided for @spreadCardCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {1 card} other {{count} cards}}'**
  String spreadCardCount(int count);

  /// No description provided for @spreadLabel.
  ///
  /// In en, this message translates to:
  /// **'Spread: {spread}'**
  String spreadLabel(Object spread);

  /// No description provided for @startSession.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startSession;

  /// No description provided for @revealCards.
  ///
  /// In en, this message translates to:
  /// **'Reveal cards'**
  String get revealCards;

  /// No description provided for @tarot.
  ///
  /// In en, this message translates to:
  /// **'Tarot'**
  String get tarot;

  /// No description provided for @tarotDescription.
  ///
  /// In en, this message translates to:
  /// **'Cards for guidance and reflection'**
  String get tarotDescription;

  /// No description provided for @tierLabel.
  ///
  /// In en, this message translates to:
  /// **'Tier: {tier}'**
  String tierLabel(Object tier);

  /// No description provided for @unknownCardName.
  ///
  /// In en, this message translates to:
  /// **'Unknown card'**
  String get unknownCardName;

  /// No description provided for @unlimitedSessions.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Sessions'**
  String get unlimitedSessions;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @usageMonth.
  ///
  /// In en, this message translates to:
  /// **'This month: {used}/{limit}'**
  String usageMonth(int limit, int used);

  /// No description provided for @usageToday.
  ///
  /// In en, this message translates to:
  /// **'Today: {used}/{limit}'**
  String usageToday(int limit, int used);

  /// No description provided for @usageWeek.
  ///
  /// In en, this message translates to:
  /// **'This week: {used}/{limit}'**
  String usageWeek(int limit, int used);

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;
}

class _CommonStringsDelegate extends LocalizationsDelegate<CommonStrings> {
  const _CommonStringsDelegate();

  @override
  Future<CommonStrings> load(Locale locale) {
    return SynchronousFuture<CommonStrings>(lookupCommonStrings(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ca', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_CommonStringsDelegate old) => false;
}

CommonStrings lookupCommonStrings(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return CommonStringsCa();
    case 'en':
      return CommonStringsEn();
    case 'es':
      return CommonStringsEs();
  }

  throw FlutterError(
      'CommonStrings.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
