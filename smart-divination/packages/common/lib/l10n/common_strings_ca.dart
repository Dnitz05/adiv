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
  String get appTitleIching => 'I Ching Intel·ligent';

  @override
  String get appTitleRunes => 'Runes Intel·ligents';

  @override
  String get appTitleTarot => 'Tarot Intel·ligent';

  @override
  String get askQuestion => 'Fes la teva pregunta...';

  @override
  String get authEmailLabel => 'Correu electrònic';

  @override
  String get authForgotPasswordDescription =>
      'Introdueix el correu associat al teu compte i t’enviarem instruccions per restablir-la.';

  @override
  String get authForgotPasswordLink => 'Has oblidat la contrasenya?';

  @override
  String get authForgotPasswordMissingEmail =>
      'Introdueix un correu electrònic vàlid per continuar.';

  @override
  String get authForgotPasswordSubmit => 'Envia el correu';

  @override
  String get authForgotPasswordSuccess =>
      'Hem enviat el correu per restablir la contrasenya. Revisa la safata d’entrada.';

  @override
  String get authForgotPasswordTitle => 'Restableix la contrasenya';

  @override
  String get authGenericError => 'Error d’autenticació.';

  @override
  String get authPasswordLabel => 'Contrasenya';

  @override
  String get authPasswordLabelWithHint => 'Contrasenya (mínim 6 caràcters)';

  @override
  String get authPasswordResetButton => 'Actualitza la contrasenya';

  @override
  String get authPasswordResetConfirmPasswordLabel => 'Confirma la contrasenya';

  @override
  String get authPasswordResetDescription =>
      'Introdueix una contrasenya nova per completar el procés.';

  @override
  String get authPasswordResetError =>
      'No s’ha pogut actualitzar la contrasenya. Torna-ho a provar.';

  @override
  String get authPasswordResetMismatch =>
      'Les contrasenyes han de coincidir i tenir almenys 6 caràcters.';

  @override
  String get authPasswordResetNewPasswordLabel => 'Nova contrasenya';

  @override
  String get authPasswordResetSignOutNotice =>
      'Per seguretat, es tancarà la sessió després d’actualitzar la contrasenya.';

  @override
  String get authPasswordResetSuccess =>
      'Contrasenya actualitzada. Pots iniciar sessió amb la nova contrasenya.';

  @override
  String get authPasswordResetTitle => 'Defineix una contrasenya nova';

  @override
  String get authSignInButton => 'Inicia sessió';

  @override
  String get authSignInSuccess => 'Has iniciat sessió correctament.';

  @override
  String get authSignInTitle => 'Inicia sessió a Smart Tarot';

  @override
  String get authSignUpButton => 'Crea un compte';

  @override
  String get authSignUpConfirmationSent =>
      'Revisa la safata d’entrada per confirmar el compte abans d’iniciar sessió.';

  @override
  String get authSignUpSuccess => 'Compte creat correctament.';

  @override
  String get authSignUpTitle => 'Crea el teu compte de Smart Tarot';

  @override
  String get authToggleToSignIn => 'Ja tens compte? Inicia sessió';

  @override
  String get authToggleToSignUp => 'Necessites un compte? Crea’l';

  @override
  String authUnexpectedError(Object error) {
    return 'Error inesperat: $error';
  }

  @override
  String get authValidationError =>
      'Introdueix un correu vàlid i una contrasenya d’almenys 6 caràcters.';

  @override
  String get cancel => 'Cancel·lar';

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
  String get continueSession => 'Continuar sessió';

  @override
  String get darkMode => 'Mode fosc';

  @override
  String get drawPlaceholder => 'Extreu cartes per rebre orientació.';

  @override
  String get drawSuccessMessage =>
      'Lectura preparada. Revisa l\'última tirada a continuació.';

  @override
  String get drawingInProgress => 'Extraient cartes...';

  @override
  String get endSession => 'Finalitzar sessió';

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
  String get interpretationHeading => 'Interpretació';

  @override
  String get language => 'Idioma';

  @override
  String latestDrawTitle(int count) {
    return 'Darrera tirada ($count cartes)';
  }

  @override
  String methodLabel(Object method) {
    return 'Mètode: $method';
  }

  @override
  String methodSeedLabel(Object method, Object seed) {
    return 'Mètode: $method • Llavor: $seed';
  }

  @override
  String get networkError =>
      'Error de connexió de xarxa. Comprova la teva connexió.';

  @override
  String nextWindow(Object timestamp) {
    return 'Pròxima franja: $timestamp';
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
  String get runesDescription => 'Símbols nòrdics de poder';

  @override
  String get save => 'Desar';

  @override
  String seedLabel(Object seed) {
    return 'Llavor: $seed';
  }

  @override
  String get seedOptionalLabel => 'Llavor (opcional)';

  @override
  String get selectTechnique => 'Quina tècnica t\'agradaria explorar avui?';

  @override
  String get sessionLimitReached =>
      'Límit de sessions assolit. Actualitza a premium per a sessions il·limitades.';

  @override
  String get settings => 'Configuració';

  @override
  String spreadLabel(Object spread) {
    return 'Tirada: $spread';
  }

  @override
  String get startSession => 'Iniciar sessió';

  @override
  String get tarot => 'Tarot';

  @override
  String get tarotDescription => 'Cartes per a orientació i reflexió';

  @override
  String tierLabel(Object tier) {
    return 'Nivell: $tier';
  }

  @override
  String get unknownCardName => 'Carta desconeguda';

  @override
  String get unlimitedSessions => 'Sessions il·limitades';

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

  @override
  String get revealCards => 'Revelar les cartes';
}
