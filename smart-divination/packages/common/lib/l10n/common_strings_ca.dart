// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'common_strings.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class CommonStringsCa extends CommonStrings {
  CommonStringsCa([String locale = 'ca']) : super(locale);

  @override
  String get allowReversed => 'Permet cartes invertides';

  @override
  String get appTitleIching => 'I Ching IntelÃ‚Â·ligent';

  @override
  String get appTitleRunes => 'Runes IntelÃ‚Â·ligents';

  @override
  String get appTitleTarot => 'Tarot IntelÃ‚Â·ligent';

  @override
  String get askQuestion => 'Fes la teva pregunta...';

  @override
  String get authEmailLabel => 'Correu electrÃƒÂ²nic';

  @override
  String get authForgotPasswordDescription =>
      'Introdueix el correu associat al teu compte i tÃ¢â‚¬â„¢enviarem instruccions per restablir-la.';

  @override
  String get authForgotPasswordLink => 'Has oblidat la contrasenya?';

  @override
  String get authForgotPasswordMissingEmail =>
      'Introdueix un correu electrÃƒÂ²nic vÃƒÂ lid per continuar.';

  @override
  String get authForgotPasswordSubmit => 'Envia el correu';

  @override
  String get authForgotPasswordSuccess =>
      'Hem enviat el correu per restablir la contrasenya. Revisa la safata dÃ¢â‚¬â„¢entrada.';

  @override
  String get authForgotPasswordTitle => 'Restableix la contrasenya';

  @override
  String get authGenericError => 'Error dÃ¢â‚¬â„¢autenticaciÃƒÂ³.';

  @override
  String get authPasswordLabel => 'Contrasenya';

  @override
  String get authPasswordLabelWithHint =>
      'Contrasenya (mÃƒÂ­nim 6 carÃƒÂ cters)';

  @override
  String get authPasswordResetButton => 'Actualitza la contrasenya';

  @override
  String get authPasswordResetConfirmPasswordLabel => 'Confirma la contrasenya';

  @override
  String get authPasswordResetDescription =>
      'Introdueix una contrasenya nova per completar el procÃƒÂ©s.';

  @override
  String get authPasswordResetError =>
      'No sÃ¢â‚¬â„¢ha pogut actualitzar la contrasenya. Torna-ho a provar.';

  @override
  String get authPasswordResetMismatch =>
      'Les contrasenyes han de coincidir i tenir almenys 6 carÃƒÂ cters.';

  @override
  String get authPasswordResetNewPasswordLabel => 'Nova contrasenya';

  @override
  String get authPasswordResetSignOutNotice =>
      'Per seguretat, es tancarÃƒÂ  la sessiÃƒÂ³ desprÃƒÂ©s dÃ¢â‚¬â„¢actualitzar la contrasenya.';

  @override
  String get authPasswordResetSuccess =>
      'Contrasenya actualitzada. Pots iniciar sessiÃƒÂ³ amb la nova contrasenya.';

  @override
  String get authPasswordResetTitle => 'Defineix una contrasenya nova';

  @override
  String get authSignInButton => 'Inicia sessiÃƒÂ³';

  @override
  String get authSignInSuccess => 'Has iniciat sessiÃƒÂ³ correctament.';

  @override
  String get authSignInTitle => 'Inicia sessiÃƒÂ³ a Smart Tarot';

  @override
  String get authSignUpButton => 'Crea un compte';

  @override
  String get authSignUpConfirmationSent =>
      'Revisa la safata dÃ¢â‚¬â„¢entrada per confirmar el compte abans dÃ¢â‚¬â„¢iniciar sessiÃƒÂ³.';

  @override
  String get authSignUpSuccess => 'Compte creat correctament.';

  @override
  String get authSignUpTitle => 'Crea el teu compte de Smart Tarot';

  @override
  String get authToggleToSignIn => 'Ja tens compte? Inicia sessiÃƒÂ³';

  @override
  String get authToggleToSignUp => 'Necessites un compte? CreaÃ¢â‚¬â„¢l';

  @override
  String authUnexpectedError(Object error) {
    return 'Error inesperat: $error';
  }

  @override
  String get authValidationError =>
      'Introdueix un correu vÃƒÂ lid i una contrasenya dÃ¢â‚¬â„¢almenys 6 carÃƒÂ cters.';

  @override
  String get cancel => 'CancelÃ‚Â·lar';

  @override
  String get cardOrientationReversed => 'Invertida';

  @override
  String get cardOrientationUpright => 'Dreta';

  @override
  String cardPositionLabel(Object name, int position) {
    return '$position. $name';
  }

  @override
  String get close => 'Tancar';

  @override
  String get continueSession => 'Continuar sessiÃƒÂ³';

  @override
  String get darkMode => 'Mode fosc';

  @override
  String get drawPlaceholder => 'Extreu cartes per rebre orientaciÃƒÂ³.';

  @override
  String get drawSuccessMessage =>
      'Lectura preparada. Revisa l\'ÃƒÂºltima tirada a continuaciÃƒÂ³.';

  @override
  String get drawingInProgress => 'Extraient cartes...';

  @override
  String get endSession => 'Finalitzar sessiÃƒÂ³';

  @override
  String get generateSeed => 'Genera una llavor';

  @override
  String get genericUnexpectedError =>
      'Hi ha hagut un problema. Torna-ho a intentar.';

  @override
  String get history => 'Historial de sessions';

  @override
  String get historyHeading => 'Tirades anteriors';

  @override
  String get iching => 'I Ching';

  @override
  String get ichingDescription => 'Saviesa ancestral xinesa';

  @override
  String get interpretationHeading => 'Consulta';

  @override
  String get language => 'Idioma';

  @override
  String latestDrawTitle(int count) {
    return 'Darrera tirada ($count cartes)';
  }

  @override
  String methodLabel(Object method) {
    return 'MÃƒÂ¨tode: $method';
  }

  @override
  String methodSeedLabel(Object method, Object seed) {
    return 'MÃƒÂ¨tode: $method Ã¢â‚¬Â¢ Llavor: $seed';
  }

  @override
  String get networkError =>
      'Error de connexiÃƒÂ³ de xarxa. Comprova la teva connexiÃƒÂ³.';

  @override
  String nextWindow(Object timestamp) {
    return 'PrÃƒÂ²xima franja: $timestamp';
  }

  @override
  String get ok => 'D\'acord';

  @override
  String get premium => 'Premium';

  @override
  String remainingToday(int remaining) {
    return 'Restants avui: $remaining';
  }

  @override
  String get runes => 'Runes';

  @override
  String get runesDescription => 'SÃƒÂ­mbols nÃƒÂ²rdics de poder';

  @override
  String get save => 'Desar';

  @override
  String seedLabel(Object seed) {
    return 'Llavor: $seed';
  }

  @override
  String get seedOptionalLabel => 'Llavor (opcional)';

  @override
  String get selectTechnique => 'Quina tÃƒÂ¨cnica t\'agradaria explorar avui?';

  @override
  String get sessionLimitReached =>
      'LÃƒÂ­mit de sessions assolit. Actualitza a premium per a sessions ilÃ‚Â·limitades.';

  @override
  String get settings => 'ConfiguraciÃƒÂ³';

  @override
  String spreadName(String spreadId) {
    switch (spreadId) {
      case 'single':
        return 'Carta \u00fanica';
      case 'three_card':
        return 'Tirada de tres cartes';
      case 'celtic_cross':
        return 'Creu Celta';
      case 'horseshoe':
        return 'Tirada Ferradura';
      case 'relationship':
        return 'Relaci\u00f3';
      case 'pyramid':
        return 'Pir\u00e0mide';
      case 'star':
        return 'Estrella';
      case 'year_ahead':
        return 'Any per davant';
      default:
        return spreadId;
    }
  }

  @override
  String spreadDescription(String spreadId) {
    switch (spreadId) {
      case 'single':
        return 'Una carta per a una visi\u00f3 r\u00e0pida';
      case 'three_card':
        return 'Passat, Present, Futur';
      case 'celtic_cross':
        return 'Tirada tradicional de 10 cartes';
      case 'horseshoe':
        return 'Tirada orientativa de 7 cartes';
      case 'relationship':
        return 'Visi\u00f3 de relaci\u00f3 en 7 cartes';
      case 'pyramid':
        return 'Disposici\u00f3 piramidal de 6 cartes';
      case 'star':
        return 'Patr\u00f3 estel\u00b7lar de 7 cartes';
      case 'year_ahead':
        return '12 cartes per a cada mes';
      default:
        return 'Tirada de tarot';
    }
  }

  @override
  String spreadCardCount(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '1 carta',
      other: '$count cartes',
    );
  }

  @override
  String spreadLabel(Object spread) {
    return 'Tirada: $spread';
  }

  @override
  String get startSession => 'Consulta';

  @override
  String get revealCards => 'Revelar cartes';

  @override
  String get tarot => 'Tarot';

  @override
  String get tarotDescription => 'Cartes per a orientaciÃƒÂ³ i reflexiÃƒÂ³';

  @override
  String tierLabel(Object tier) {
    return 'Nivell: $tier';
  }

  @override
  String get unknownCardName => 'Carta desconeguda';

  @override
  String get unlimitedSessions => 'Sessions ilÃ‚Â·limitades';

  @override
  String get upgradeToPremium => 'Actualitza a Premium';

  @override
  String usageMonth(int limit, int used) {
    return 'Aquest mes: $used/$limit';
  }

  @override
  String usageToday(int limit, int used) {
    return 'Avui: $used/$limit';
  }

  @override
  String usageWeek(int limit, int used) {
    return 'Aquesta setmana: $used/$limit';
  }

  @override
  String get welcome => 'Benvingut/da!';
}
