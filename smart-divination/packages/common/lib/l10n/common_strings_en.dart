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
  String methodLabel(Object method) {
    return 'Method: $method';
  }

  @override
  String methodSeedLabel(Object method, Object seed) {
    return 'Method: $method Ã¢â‚¬Â¢ Seed: $seed';
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
  String spreadName(String spreadId) {
    switch (spreadId) {
      case 'single':
        return 'Single Card';
      case 'three_card':
        return 'Three Card Spread';
      case 'celtic_cross':
        return 'Celtic Cross';
      case 'horseshoe':
        return 'Horseshoe';
      case 'relationship':
        return 'Relationship';
      case 'pyramid':
        return 'Pyramid';
      case 'star':
        return 'Star';
      case 'year_ahead':
        return 'Year Ahead';
      default:
        return spreadId;
    }
  }

  @override
  String spreadDescription(String spreadId) {
    switch (spreadId) {
      case 'single':
        return 'One card for quick insight';
      case 'three_card':
        return 'Past, Present, Future';
      case 'celtic_cross':
        return 'Traditional 10-card spread';
      case 'horseshoe':
        return '7-card guidance spread';
      case 'relationship':
        return '7-card relationship insight';
      case 'pyramid':
        return '6-card pyramid layout';
      case 'star':
        return '7-card star pattern';
      case 'year_ahead':
        return '12 cards for each month';
      default:
        return 'Tarot spread';
    }
  }

  @override
  String spreadCardCount(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '1 card',
      other: '$count cards',
    );
  }

  @override
  String spreadLabel(Object spread) {
    return 'Spread: $spread';
  }

  @override
  String get startSession => 'Reading';

  @override
  String get revealCards => 'Reveal cards';

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
