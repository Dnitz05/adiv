// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'common_strings.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class CommonStringsEs extends CommonStrings {
  CommonStringsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitleTarot => 'Tarot Inteligente';

  @override
  String get appTitleIching => 'I Ching Inteligente';

  @override
  String get appTitleRunes => 'Runas Inteligentes';

  @override
  String get welcome => '¡Bienvenido/a!';

  @override
  String get selectTechnique => '¿Qué técnica te gustaría explorar hoy?';

  @override
  String get tarot => 'Tarot';

  @override
  String get iching => 'I Ching';

  @override
  String get runes => 'Runas';

  @override
  String get tarotDescription => 'Cartas para orientación y reflexión';

  @override
  String get ichingDescription => 'Sabiduría ancestral china';

  @override
  String get runesDescription => 'Símbolos nórdicos de poder';

  @override
  String get startSession => 'Iniciar sesión';

  @override
  String get continueSession => 'Continuar sesión';

  @override
  String get endSession => 'Finalizar sesión';

  @override
  String get history => 'Historial de sesiones';

  @override
  String get askQuestion => 'Formula tu pregunta...';

  @override
  String get networkError =>
      'Error de conexión de red. Por favor verifica tu conexión.';

  @override
  String get sessionLimitReached =>
      'Límite de sesiones alcanzado. Mejora a premium para sesiones ilimitadas.';

  @override
  String get premium => 'Premium';

  @override
  String get upgradeToPremium => 'Actualizar a Premium';

  @override
  String get unlimitedSessions => 'Sesiones ilimitadas';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get close => 'Cerrar';

  @override
  String get allowReversed => 'Permitir cartas invertidas';

  @override
  String get drawingInProgress => 'Sacando cartas...';

  @override
  String get seedOptionalLabel => 'Semilla (opcional)';

  @override
  String get generateSeed => 'Generar semilla';

  @override
  String latestDrawTitle(int count) {
    return 'Última tirada ($count cartas)';
  }

  @override
  String spreadLabel(Object spread) {
    return 'Tirada: $spread';
  }

  @override
  String methodSeedLabel(Object method, Object seed) {
    return 'Método: $method • Semilla: $seed';
  }

  @override
  String methodLabel(Object method) {
    return 'Método: $method';
  }

  @override
  String seedLabel(Object seed) {
    return 'Semilla: $seed';
  }

  @override
  String get interpretationHeading => 'Interpretación';

  @override
  String get historyHeading => 'Tiradas anteriores';

  @override
  String get drawPlaceholder => 'Saca cartas para recibir orientación.';

  @override
  String get cardOrientationUpright => 'Al derecho';

  @override
  String get cardOrientationReversed => 'Invertida';

  @override
  String tierLabel(Object tier) {
    return 'Nivel: $tier';
  }

  @override
  String usageToday(int used, int limit) {
    return 'Hoy: $used/$limit';
  }

  @override
  String usageWeek(int used, int limit) {
    return 'Esta semana: $used/$limit';
  }

  @override
  String usageMonth(int used, int limit) {
    return 'Este mes: $used/$limit';
  }

  @override
  String remainingToday(int remaining) {
    return 'Restantes hoy: $remaining';
  }

  @override
  String nextWindow(Object timestamp) {
    return 'Próxima ventana: $timestamp';
  }

  @override
  String get authSignInTitle => 'Inicia sesión en Smart Tarot';

  @override
  String get authSignUpTitle => 'Crea tu cuenta de Smart Tarot';

  @override
  String get authEmailLabel => 'Correo electrónico';

  @override
  String get authPasswordLabel => 'Contraseña';

  @override
  String get authPasswordLabelWithHint => 'Contraseña (mínimo 6 caracteres)';

  @override
  String get authSignInButton => 'Iniciar sesión';

  @override
  String get authSignUpButton => 'Crear cuenta';

  @override
  String get authToggleToSignIn => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get authToggleToSignUp => '¿Necesitas una cuenta? Créala';

  @override
  String get authValidationError =>
      'Introduce un correo válido y una contraseña de al menos 6 caracteres.';

  @override
  String get authSignInSuccess => 'Sesión iniciada correctamente.';

  @override
  String get authSignUpConfirmationSent =>
      'Revisa tu bandeja de entrada para confirmar la cuenta antes de iniciar sesión.';

  @override
  String get authSignUpSuccess => 'Cuenta creada correctamente.';

  @override
  String get authForgotPasswordLink => '¿Has olvidado la contraseña?';

  @override
  String get authForgotPasswordTitle => 'Restablecer contraseña';

  @override
  String get authForgotPasswordDescription =>
      'Introduce el correo asociado a tu cuenta y te enviaremos instrucciones para restablecerla.';

  @override
  String get authForgotPasswordSubmit => 'Enviar correo';

  @override
  String get authForgotPasswordSuccess =>
      'Hemos enviado un correo para restablecer la contraseña. Revisa tu bandeja de entrada.';

  @override
  String get authForgotPasswordMissingEmail =>
      'Introduce un correo electrónico válido para continuar.';

  @override
  String get authPasswordResetTitle => 'Define una nueva contraseña';

  @override
  String get authPasswordResetDescription =>
      'Introduce una nueva contraseña para completar el proceso.';

  @override
  String get authPasswordResetNewPasswordLabel => 'Nueva contraseña';

  @override
  String get authPasswordResetConfirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get authPasswordResetButton => 'Actualizar contraseña';

  @override
  String get authPasswordResetSuccess =>
      'Contraseña actualizada. Puedes iniciar sesión con la nueva contraseña.';

  @override
  String get authPasswordResetMismatch =>
      'Las contraseñas deben coincidir y tener al menos 6 caracteres.';

  @override
  String get authPasswordResetError =>
      'No se pudo actualizar la contraseña. Inténtalo de nuevo.';

  @override
  String get authPasswordResetSignOutNotice =>
      'Por seguridad, se cerrará la sesión después de actualizar la contraseña.';

  @override
  String get authGenericError => 'Error de autenticación.';

  @override
  String authUnexpectedError(Object error) {
    return 'Error inesperado: $error';
  }
}
