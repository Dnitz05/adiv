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
  String get authEmailLabel => 'Correo electrónico';

  @override
  String get authForgotPasswordDescription =>
      'Introduce el correo asociado a tu cuenta y te enviaremos instrucciones para restablecerla.';

  @override
  String get authForgotPasswordLink => '¿Has olvidado la contraseña?';

  @override
  String get authForgotPasswordMissingEmail =>
      'Introduce un correo electrónico válido para continuar.';

  @override
  String get authForgotPasswordSubmit => 'Enviar correo';

  @override
  String get authForgotPasswordSuccess =>
      'Hemos enviado un correo para restablecer la contraseña. Revisa tu bandeja de entrada.';

  @override
  String get authForgotPasswordTitle => 'Restablecer contraseña';

  @override
  String get authGenericError => 'Error de autenticación.';

  @override
  String get authPasswordLabel => 'Contraseña';

  @override
  String get authPasswordLabelWithHint => 'Contraseña (mínimo 6 caracteres)';

  @override
  String get authPasswordResetButton => 'Actualizar contraseña';

  @override
  String get authPasswordResetConfirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get authPasswordResetDescription =>
      'Introduce una nueva contraseña para completar el proceso.';

  @override
  String get authPasswordResetError =>
      'No se pudo actualizar la contraseña. Inténtalo de nuevo.';

  @override
  String get authPasswordResetMismatch =>
      'Las contraseñas deben coincidir y tener al menos 6 caracteres.';

  @override
  String get authPasswordResetNewPasswordLabel => 'Nueva contraseña';

  @override
  String get authPasswordResetSignOutNotice =>
      'Por seguridad, se cerrará la sesión después de actualizar la contraseña.';

  @override
  String get authPasswordResetSuccess =>
      'Contraseña actualizada. Puedes iniciar sesión con la nueva contraseña.';

  @override
  String get authPasswordResetTitle => 'Define una nueva contraseña';

  @override
  String get authSignInButton => 'Iniciar sesión';

  @override
  String get authSignInSuccess => 'Sesión iniciada correctamente.';

  @override
  String get authSignInTitle => 'Inicia sesión en Smart Tarot';

  @override
  String get authSignUpButton => 'Crear cuenta';

  @override
  String get authSignUpConfirmationSent =>
      'Revisa tu bandeja de entrada para confirmar la cuenta antes de iniciar sesión.';

  @override
  String get authSignUpSuccess => 'Cuenta creada correctamente.';

  @override
  String get authSignUpTitle => 'Crea tu cuenta de Smart Tarot';

  @override
  String get authToggleToSignIn => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get authToggleToSignUp => '¿Necesitas una cuenta? Créala';

  @override
  String authUnexpectedError(Object error) {
    return 'Error inesperado: $error';
  }

  @override
  String get authValidationError =>
      'Introduce un correo válido y una contraseña de al menos 6 caracteres.';

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
  String get continueSession => 'Continuar sesión';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get drawPlaceholder => 'Saca cartas para recibir orientación.';

  @override
  String get drawSuccessMessage =>
      'Lectura lista. Consulta la última tirada a continuación.';

  @override
  String get drawingInProgress => 'Sacando cartas...';

  @override
  String get endSession => 'Finalizar sesión';

  @override
  String get generateSeed => 'Generar semilla';

  @override
  String get genericUnexpectedError => 'Algo ha fallado. Inténtalo de nuevo.';

  @override
  String get history => 'Historial de sesiones';

  @override
  String get historyHeading => 'Tiradas anteriores';

  @override
  String get iching => 'I Ching';

  @override
  String get ichingDescription => 'Sabiduría ancestral china';

  @override
  String get interpretationHeading => 'Interpretación';

  @override
  String get language => 'Idioma';

  @override
  String latestDrawTitle(int count) {
    return 'Última tirada ($count cartas)';
  }

  @override
  String get lunarElementAir => 'aire';

  @override
  String get lunarElementEarth => 'tierra';

  @override
  String get lunarElementFire => 'fuego';

  @override
  String get lunarElementWater => 'agua';

  @override
  String lunarPanelAge(Object days) {
    return 'Edad $days d';
  }

  @override
  String get lunarPanelCalendarTitle => 'Calendario lunar';

  @override
  String lunarPanelElement(Object element) {
    return 'Elemento ? $element';
  }

  @override
  String get lunarPanelError => 'No se pudo conectar con la luna';

  @override
  String get lunarPanelFallbackError =>
      'Revisa tu conexi?n e int?ntalo de nuevo.';

  @override
  String get lunarPanelGuidanceTitle => 'Gu?a';

  @override
  String lunarPanelIllumination(Object percent) {
    return 'Iluminaci?n $percent%';
  }

  @override
  String get lunarPanelLoading => 'Sintonizando con la luna...';

  @override
  String lunarPanelMoonIn(Object sign) {
    return 'Luna en $sign';
  }

  @override
  String get lunarPanelNoSessions => 'A?n no hay lecturas registradas.';

  @override
  String get lunarPanelRecommendedSubtitle =>
      'Alinea tu lectura con la energ?a lunar presente.';

  @override
  String get lunarPanelRecommendedTitle => 'Tiradas para esta fase';

  @override
  String get lunarPanelRetry => 'Reintentar';

  @override
  String lunarPanelSessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# lecturas registradas',
      one: '# lectura registrada',
    );
    return '$_temp0';
  }

  @override
  String get lunarPanelSessionsHeadline => 'Lecturas en este d?a';

  @override
  String lunarPanelSpreadSelected(Object spread) {
    return 'Tirada $spread seleccionada.';
  }

  @override
  String get lunarPanelTitle => 'Ritmo lunar';

  @override
  String get lunarPanelToday => 'Hoy';

  @override
  String lunarPanelUseSpread(Object spread) {
    return 'Usar tirada $spread';
  }

  @override
  String get lunarSpreadAstrological => 'Astrol?gica';

  @override
  String get lunarSpreadCelticCross => 'Cruz celta';

  @override
  String get lunarSpreadFiveCardCross => 'Cruz de cinco cartas';

  @override
  String get lunarSpreadHorseshoe => 'Herradura';

  @override
  String get lunarSpreadPyramid => 'Pir?mide';

  @override
  String get lunarSpreadRelationship => 'Relaci?n';

  @override
  String get lunarSpreadSingle => 'Carta ?nica';

  @override
  String get lunarSpreadStar => 'Estrella';

  @override
  String get lunarSpreadThreeCard => 'Tres cartas';

  @override
  String get lunarSpreadTwoCard => 'Dos cartas';

  @override
  String get lunarSpreadYearAhead => 'A?o por delante';

  @override
  String methodLabel(Object method) {
    return 'Método: $method';
  }

  @override
  String methodSeedLabel(Object method, Object seed) {
    return 'Método: $method • Semilla: $seed';
  }

  @override
  String get networkError =>
      'Error de conexión de red. Por favor verifica tu conexión.';

  @override
  String nextWindow(Object timestamp) {
    return 'Próxima ventana: $timestamp';
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
  String get revealCards => 'Revelar las cartas';

  @override
  String get runes => 'Runas';

  @override
  String get runesDescription => 'Símbolos nórdicos de poder';

  @override
  String get save => 'Guardar';

  @override
  String seedLabel(Object seed) {
    return 'Semilla: $seed';
  }

  @override
  String get seedOptionalLabel => 'Semilla (opcional)';

  @override
  String get selectTechnique => '¿Qué técnica te gustaría explorar hoy?';

  @override
  String get sessionLimitReached =>
      'Límite de sesiones alcanzado. Mejora a premium para sesiones ilimitadas.';

  @override
  String get settings => 'Configuración';

  @override
  String get smartDrawsChooseByTheme => 'O elige por temática:';

  @override
  String get smartDrawsSelectionCTA => 'Pruébalo ahora';

  @override
  String get smartDrawsSelectionDescription =>
      'Describe tu situación y la IA te recomienda la mejor tirada';

  @override
  String get smartDrawsSelectionTitle => 'Selección Inteligente';

  @override
  String get smartDrawsSubtitle => 'Encuentra la tirada perfecta para ti';

  @override
  String get smartDrawsThemeCareer => 'Carrera';

  @override
  String get smartDrawsThemeDecisions => 'Decisiones';

  @override
  String get smartDrawsThemeGeneral => 'General';

  @override
  String get smartDrawsThemeLove => 'Amor';

  @override
  String get smartDrawsThemeMoney => 'Dinero';

  @override
  String get smartDrawsThemePersonal => 'Personal';

  @override
  String get smartDrawsTitle => 'Tiradas Inteligentes';

  @override
  String spreadLabel(Object spread) {
    return 'Tirada: $spread';
  }

  @override
  String get startSession => 'Iniciar sesión';

  @override
  String get tarot => 'Tarot';

  @override
  String get tarotDescription => 'Cartas para orientación y reflexión';

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
  String get welcome => '¡Bienvenido/a!';
}
