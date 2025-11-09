// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'common_strings.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class CommonStringsEn extends CommonStrings {
  CommonStringsEn([String locale = 'en']) : super(locale);

  @override
  String get allowReversed => 'Allow reversed cards';

  @override
  String get appTitleIching => 'Smart I Ching';

  @override
  String get appTitleRunes => 'Smart Runes';

  @override
  String get appTitleTarot => 'Smart Tarot';

  @override
  String get askQuestion => 'Ask your question...';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authForgotPasswordDescription =>
      'Enter the email associated with your account and we\'ll send reset instructions.';

  @override
  String get authForgotPasswordLink => 'Forgot password?';

  @override
  String get authForgotPasswordMissingEmail =>
      'Enter a valid email address to continue.';

  @override
  String get authForgotPasswordSubmit => 'Send email';

  @override
  String get authForgotPasswordSuccess =>
      'Password reset email sent. Check your inbox.';

  @override
  String get authForgotPasswordTitle => 'Reset password';

  @override
  String get authGenericError => 'Authentication failed.';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordLabelWithHint => 'Password (min 6 characters)';

  @override
  String get authPasswordResetButton => 'Update password';

  @override
  String get authPasswordResetConfirmPasswordLabel => 'Confirm password';

  @override
  String get authPasswordResetDescription =>
      'Enter a new password to finish resetting your account.';

  @override
  String get authPasswordResetError =>
      'Failed to update password. Please try again.';

  @override
  String get authPasswordResetMismatch =>
      'Passwords must match and include at least 6 characters.';

  @override
  String get authPasswordResetNewPasswordLabel => 'New password';

  @override
  String get authPasswordResetSignOutNotice =>
      'For security reasons you will be signed out after updating the password.';

  @override
  String get authPasswordResetSuccess =>
      'Password updated. You can sign in with the new password.';

  @override
  String get authPasswordResetTitle => 'Set a new password';

  @override
  String get authSignInButton => 'Sign in';

  @override
  String get authSignInSuccess => 'Signed in successfully.';

  @override
  String get authSignInTitle => 'Sign in to Smart Tarot';

  @override
  String get authSignUpButton => 'Create account';

  @override
  String get authSignUpConfirmationSent =>
      'Check your inbox to confirm the account before signing in.';

  @override
  String get authSignUpSuccess => 'Account created successfully.';

  @override
  String get authSignUpTitle => 'Create your Smart Tarot account';

  @override
  String get authToggleToSignIn => 'Already have an account? Sign in';

  @override
  String get authToggleToSignUp => 'Need an account? Create one';

  @override
  String authUnexpectedError(Object error) {
    return 'Unexpected error: $error';
  }

  @override
  String get authValidationError =>
      'Enter a valid email and a password of at least 6 characters.';

  @override
  String get cancel => 'Cancel';

  @override
  String get cardOrientationReversed => 'Reversed';

  @override
  String get cardOrientationUpright => 'Upright';

  @override
  String cardPositionLabel(Object name, int position) {
    return '$position. $name';
  }

  @override
  String get close => 'Close';

  @override
  String get continueSession => 'Continue Session';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get drawPlaceholder => 'Draw cards to receive guidance.';

  @override
  String get drawSuccessMessage =>
      'Your reading is ready. Latest draw updated below.';

  @override
  String get drawingInProgress => 'Drawing...';

  @override
  String get endSession => 'End Session';

  @override
  String get generateSeed => 'Generate seed';

  @override
  String get genericUnexpectedError =>
      'Something went wrong. Please try again.';

  @override
  String get history => 'Session History';

  @override
  String get historyHeading => 'Previous draws';

  @override
  String get iching => 'I Ching';

  @override
  String get ichingDescription => 'Ancient Chinese wisdom';

  @override
  String get interpretationHeading => 'Interpretation';

  @override
  String get language => 'Language';

  @override
  String latestDrawTitle(int count) {
    return 'Latest draw ($count cards)';
  }

  @override
  String get lunarElementAir => 'air';

  @override
  String get lunarElementEarth => 'earth';

  @override
  String get lunarElementFire => 'fire';

  @override
  String get lunarElementWater => 'water';

  @override
  String lunarPanelAge(Object days) {
    return 'Age $days d';
  }

  @override
  String get lunarPanelCalendarTitle => 'Lunar calendar';

  @override
  String lunarPanelElement(Object element) {
    return 'Element ? $element';
  }

  @override
  String get lunarPanelError => 'Unable to reach the moon';

  @override
  String get lunarPanelFallbackError => 'Check your connection and try again.';

  @override
  String get lunarPanelGuidanceTitle => 'Guidance';

  @override
  String lunarPanelIllumination(Object percent) {
    return 'Illumination $percent%';
  }

  @override
  String get lunarPanelLoading => 'Tuning into the moon...';

  @override
  String lunarPanelMoonIn(Object sign) {
    return 'Moon in $sign';
  }

  @override
  String get lunarPanelNoSessions => 'No readings logged yet.';

  @override
  String get lunarPanelRecommendedSubtitle =>
      'Align your reading with the current lunar energy.';

  @override
  String get lunarPanelRecommendedTitle => 'Spreads for this phase';

  @override
  String get lunarPanelRetry => 'Try again';

  @override
  String lunarPanelSessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# readings logged',
      one: '# reading logged',
    );
    return '$_temp0';
  }

  @override
  String get lunarPanelSessionsHeadline => 'Readings on this day';

  @override
  String lunarPanelSpreadSelected(Object spread) {
    return 'Selected $spread spread.';
  }

  @override
  String get lunarPanelTitle => 'Moon Rhythm';

  @override
  String get lunarPanelToday => 'Today';

  @override
  String lunarPanelUseSpread(Object spread) {
    return 'Use $spread spread';
  }

  @override
  String get lunarSpreadAstrological => 'Astrological';

  @override
  String get lunarSpreadCelticCross => 'Celtic Cross';

  @override
  String get lunarSpreadFiveCardCross => 'Five Card Cross';

  @override
  String get lunarSpreadHorseshoe => 'Horseshoe';

  @override
  String get lunarSpreadPyramid => 'Pyramid';

  @override
  String get lunarSpreadRelationship => 'Relationship';

  @override
  String get lunarSpreadSingle => 'Single Card';

  @override
  String get lunarSpreadStar => 'Star';

  @override
  String get lunarSpreadThreeCard => 'Three Card';

  @override
  String get lunarSpreadTwoCard => 'Two Card';

  @override
  String get lunarSpreadYearAhead => 'Year Ahead';

  @override
  String methodLabel(Object method) {
    return 'Method: $method';
  }

  @override
  String methodSeedLabel(Object method, Object seed) {
    return 'Method: $method • Seed: $seed';
  }

  @override
  String get networkError =>
      'Network connection error. Please check your connection.';

  @override
  String nextWindow(Object timestamp) {
    return 'Next window: $timestamp';
  }

  @override
  String get ok => 'OK';

  @override
  String get premium => 'Premium';

  @override
  String remainingToday(int remaining) {
    return 'Remaining today: $remaining';
  }

  @override
  String get revealCards => 'Reveal the cards';

  @override
  String get runes => 'Runes';

  @override
  String get runesDescription => 'Nordic symbols of power';

  @override
  String get save => 'Save';

  @override
  String seedLabel(Object seed) {
    return 'Seed: $seed';
  }

  @override
  String get seedOptionalLabel => 'Seed (optional)';

  @override
  String get selectTechnique =>
      'Which technique would you like to explore today?';

  @override
  String get sessionLimitReached =>
      'Session limit reached. Upgrade to premium for unlimited sessions.';

  @override
  String get settings => 'Settings';

  @override
  String get smartDrawsChooseByTheme => 'Or choose by theme:';

  @override
  String get smartDrawsSelectionCTA => 'Try it now';

  @override
  String get smartDrawsSelectionDescription =>
      'Describe your situation and AI recommends the best spread';

  @override
  String get smartDrawsSelectionTitle => 'Smart Selection';

  @override
  String get smartDrawsSubtitle => 'Find the perfect spread for you';

  @override
  String get smartDrawsThemeCareer => 'Career';

  @override
  String get smartDrawsThemeDecisions => 'Decisions';

  @override
  String get smartDrawsThemeGeneral => 'General';

  @override
  String get smartDrawsThemeLove => 'Love';

  @override
  String get smartDrawsThemeMoney => 'Money';

  @override
  String get smartDrawsThemePersonal => 'Personal';

  @override
  String get smartDrawsTitle => 'Smart Draws';

  @override
  String spreadLabel(Object spread) {
    return 'Spread: $spread';
  }

  @override
  String get startSession => 'Start Session';

  @override
  String get tarot => 'Tarot';

  @override
  String get tarotDescription => 'Cards for guidance and reflection';

  @override
  String tierLabel(Object tier) {
    return 'Tier: $tier';
  }

  @override
  String get unknownCardName => 'Unknown card';

  @override
  String get unlimitedSessions => 'Unlimited Sessions';

  @override
  String get upgradeToPremium => 'Upgrade to Premium';

  @override
  String usageMonth(int limit, int used) {
    return 'This month: $used/$limit';
  }

  @override
  String usageToday(int limit, int used) {
    return 'Today: $used/$limit';
  }

  @override
  String usageWeek(int limit, int used) {
    return 'This week: $used/$limit';
  }

  @override
  String get welcome => 'Welcome!';
}
