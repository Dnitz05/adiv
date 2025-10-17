// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'common_strings.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class CommonStringsEs extends CommonStrings {
  CommonStringsEs([String locale = 'es']) : super(locale);

  @override
  String get allowReversed => 'Permitir cartas invertidas';

  @override
  String get appTitleIching => 'I Ching Inteligente';

  @override
  String get appTitleRunes => 'Runas Inteligentes';

  @override
  String get appTitleTarot => 'Tarot Inteligente';

  @override
  String get askQuestion => 'Formula tu pregunta...';

  @override
  String get authEmailLabel => 'Correo electrÃƒÂ³nico';

  @override
  String get authForgotPasswordDescription =>
      'Introduce el correo asociado a tu cuenta y te enviaremos instrucciones para restablecerla.';

  @override
  String get authForgotPasswordLink => 'Ã‚Â¿Has olvidado la contraseÃƒÂ±a?';

  @override
  String get authForgotPasswordMissingEmail =>
      'Introduce un correo electrÃƒÂ³nico vÃƒÂ¡lido para continuar.';

  @override
  String get authForgotPasswordSubmit => 'Enviar correo';

  @override
  String get authForgotPasswordSuccess =>
      'Hemos enviado un correo para restablecer la contraseÃƒÂ±a. Revisa tu bandeja de entrada.';

  @override
  String get authForgotPasswordTitle => 'Restablecer contraseÃƒÂ±a';

  @override
  String get authGenericError => 'Error de autenticaciÃƒÂ³n.';

  @override
  String get authPasswordLabel => 'ContraseÃƒÂ±a';

  @override
  String get authPasswordLabelWithHint =>
      'ContraseÃƒÂ±a (mÃƒÂ­nimo 6 caracteres)';

  @override
  String get authPasswordResetButton => 'Actualizar contraseÃƒÂ±a';

  @override
  String get authPasswordResetConfirmPasswordLabel => 'Confirmar contraseÃƒÂ±a';

  @override
  String get authPasswordResetDescription =>
      'Introduce una nueva contraseÃƒÂ±a para completar el proceso.';

  @override
  String get authPasswordResetError =>
      'No se pudo actualizar la contraseÃƒÂ±a. IntÃƒÂ©ntalo de nuevo.';

  @override
  String get authPasswordResetMismatch =>
      'Las contraseÃƒÂ±as deben coincidir y tener al menos 6 caracteres.';

  @override
  String get authPasswordResetNewPasswordLabel => 'Nueva contraseÃƒÂ±a';

  @override
  String get authPasswordResetSignOutNotice =>
      'Por seguridad, se cerrarÃƒÂ¡ la sesiÃƒÂ³n despuÃƒÂ©s de actualizar la contraseÃƒÂ±a.';

  @override
  String get authPasswordResetSuccess =>
      'ContraseÃƒÂ±a actualizada. Puedes iniciar sesiÃƒÂ³n con la nueva contraseÃƒÂ±a.';

  @override
  String get authPasswordResetTitle => 'Define una nueva contraseÃƒÂ±a';

  @override
  String get authSignInButton => 'Iniciar sesiÃƒÂ³n';

  @override
  String get authSignInSuccess => 'SesiÃƒÂ³n iniciada correctamente.';

  @override
  String get authSignInTitle => 'Inicia sesiÃƒÂ³n en Smart Tarot';

  @override
  String get authSignUpButton => 'Crear cuenta';

  @override
  String get authSignUpConfirmationSent =>
      'Revisa tu bandeja de entrada para confirmar la cuenta antes de iniciar sesiÃƒÂ³n.';

  @override
  String get authSignUpSuccess => 'Cuenta creada correctamente.';

  @override
  String get authSignUpTitle => 'Crea tu cuenta de Smart Tarot';

  @override
  String get authToggleToSignIn => 'Ã‚Â¿Ya tienes cuenta? Inicia sesiÃƒÂ³n';

  @override
  String get authToggleToSignUp => 'Ã‚Â¿Necesitas una cuenta? CrÃƒÂ©ala';

  @override
  String authUnexpectedError(Object error) {
    return 'Error inesperado: $error';
  }

  @override
  String get authValidationError =>
      'Introduce un correo vÃƒÂ¡lido y una contraseÃƒÂ±a de al menos 6 caracteres.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cardOrientationReversed => 'Invertida';

  @override
  String get cardOrientationUpright => 'Al derecho';

  @override
  String cardPositionLabel(Object name, int position) {
    return '$position. $name';
  }

  @override
  String get close => 'Cerrar';

  @override
  String get continueSession => 'Continuar sesiÃƒÂ³n';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get drawPlaceholder => 'Saca cartas para recibir orientaciÃƒÂ³n.';

  @override
  String get drawSuccessMessage =>
      'Lectura lista. Consulta la ÃƒÂºltima tirada a continuaciÃƒÂ³n.';

  @override
  String get drawingInProgress => 'Sacando cartas...';

  @override
  String get endSession => 'Finalizar sesiÃƒÂ³n';

  @override
  String get generateSeed => 'Generar semilla';

  @override
  String get genericUnexpectedError =>
      'Algo ha fallado. IntÃƒÂ©ntalo de nuevo.';

  @override
  String get history => 'Historial de sesiones';

  @override
  String get historyHeading => 'Tiradas anteriores';

  @override
  String get iching => 'I Ching';

  @override
  String get ichingDescription => 'SabidurÃƒÂ­a ancestral china';

  @override
  String get interpretationHeading => 'Consulta';

  @override
  String get language => 'Idioma';

  @override
  String latestDrawTitle(int count) {
    return 'ÃƒÅ¡ltima tirada ($count cartas)';
  }

  @override
  String methodLabel(Object method) {
    return 'MÃƒÂ©todo: $method';
  }

  @override
  String methodSeedLabel(Object method, Object seed) {
    return 'MÃƒÂ©todo: $method Ã¢â‚¬Â¢ Semilla: $seed';
  }

  @override
  String get networkError =>
      'Error de conexiÃƒÂ³n de red. Por favor verifica tu conexiÃƒÂ³n.';

  @override
  String nextWindow(Object timestamp) {
    return 'PrÃƒÂ³xima ventana: $timestamp';
  }

  @override
  String get ok => 'OK';

  @override
  String get premium => 'Premium';

  @override
  String remainingToday(int remaining) {
    return 'Restantes hoy: $remaining';
  }

  @override
  String get runes => 'Runas';

  @override
  String get runesDescription => 'SÃƒÂ­mbolos nÃƒÂ³rdicos de poder';

  @override
  String get save => 'Guardar';

  @override
  String seedLabel(Object seed) {
    return 'Semilla: $seed';
  }

  @override
  String get seedOptionalLabel => 'Semilla (opcional)';

  @override
  String get selectTechnique =>
      'Ã‚Â¿QuÃƒÂ© tÃƒÂ©cnica te gustarÃƒÂ­a explorar hoy?';

  @override
  String get sessionLimitReached =>
      'LÃƒÂ­mite de sesiones alcanzado. Mejora a premium para sesiones ilimitadas.';

  @override
  String get settings => 'ConfiguraciÃƒÂ³n';

  @override
  String spreadName(String spreadId) {
    switch (spreadId) {
      case 'single':
        return 'Carta \u00fanica';
      case 'three_card':
        return 'Tirada de tres cartas';
      case 'celtic_cross':
        return 'Cruz Celta';
      case 'horseshoe':
        return 'Tirada Herradura';
      case 'relationship':
        return 'Relaci\u00f3n';
      case 'pyramid':
        return 'Pir\u00e1mide';
      case 'star':
        return 'Estrella';
      case 'year_ahead':
        return 'A\u00f1o por delante';
      default:
        return spreadId;
    }
  }

  @override
  String spreadDescription(String spreadId) {
    switch (spreadId) {
      case 'single':
        return 'Una carta para una visi\u00f3n r\u00e1pida';
      case 'three_card':
        return 'Pasado, Presente, Futuro';
      case 'celtic_cross':
        return 'Tirada tradicional de 10 cartas';
      case 'horseshoe':
        return 'Tirada orientativa de 7 cartas';
      case 'relationship':
        return 'Visi\u00f3n de relaci\u00f3n en 7 cartas';
      case 'pyramid':
        return 'Disposici\u00f3n piramidal de 6 cartas';
      case 'star':
        return 'Patr\u00f3n estelar de 7 cartas';
      case 'year_ahead':
        return '12 cartas para cada mes';
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
      other: '$count cartas',
    );
  }

  @override
  String spreadLabel(Object spread) {
    return 'Tirada: $spread';
  }

  @override
  String get startSession => 'Consulta';

  @override
  String get revealCards => 'Revelar cartas';

  @override
  String get tarot => 'Tarot';

  @override
  String get tarotDescription => 'Cartas para orientaciÃƒÂ³n y reflexiÃƒÂ³n';

  @override
  String tierLabel(Object tier) {
    return 'Nivel: $tier';
  }

  @override
  String get unknownCardName => 'Carta desconocida';

  @override
  String get unlimitedSessions => 'Sesiones ilimitadas';

  @override
  String get upgradeToPremium => 'Actualizar a Premium';

  @override
  String usageMonth(int limit, int used) {
    return 'Este mes: $used/$limit';
  }

  @override
  String usageToday(int limit, int used) {
    return 'Hoy: $used/$limit';
  }

  @override
  String usageWeek(int limit, int used) {
    return 'Esta semana: $used/$limit';
  }

  @override
  String get welcome => 'Ã‚Â¡Bienvenido/a!';
}
