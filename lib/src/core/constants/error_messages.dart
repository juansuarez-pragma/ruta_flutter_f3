/// Constantes de mensajes de error para el paquete.
///
/// Centraliza todos los mensajes de error para facilitar:
/// - Internacionalización (i18n)
/// - Consistencia en mensajes
/// - Mantenibilidad del código
///
/// ## Uso
///
/// ```dart
/// throw ConnectionException(message: ErrorMessages.timeout);
/// ```
abstract class ErrorMessages {
  ErrorMessages._();

  // ============================================
  // Errores de conexión
  // ============================================

  /// Mensaje cuando se agota el tiempo de espera.
  static const String timeout = 'Tiempo de espera agotado';

  /// Mensaje cuando no hay conexión a internet.
  static const String noInternet = 'Sin conexión a internet';

  /// Mensaje cuando hay error de conexión con el servidor.
  static const String connectionError = 'Error de conexión con el servidor';

  // ============================================
  // Errores del cliente (4xx)
  // ============================================

  /// Mensaje genérico para errores del cliente.
  static const String clientError = 'Error en la solicitud';

  /// Mensaje para solicitud incorrecta (400).
  static const String badRequest = 'Solicitud incorrecta';

  /// Mensaje para no autorizado (401).
  static const String unauthorized = 'No autorizado';

  /// Mensaje para acceso prohibido (403).
  static const String forbidden = 'Acceso prohibido';

  /// Mensaje para recurso no encontrado (404).
  static const String notFound = 'Recurso no encontrado';

  /// Mensaje para datos de solicitud inválidos (422).
  static const String unprocessableEntity = 'Datos de solicitud inválidos';

  /// Mensaje para demasiadas solicitudes (429).
  static const String tooManyRequests = 'Demasiadas solicitudes';

  // ============================================
  // Errores del servidor (5xx)
  // ============================================

  /// Mensaje genérico para errores del servidor.
  static const String serverError = 'Error del servidor';

  /// Mensaje para puerta de enlace incorrecta (502).
  static const String badGateway = 'Puerta de enlace incorrecta';

  /// Mensaje para servicio no disponible (503).
  static const String serviceUnavailable = 'Servicio no disponible';

  /// Mensaje para tiempo de espera de gateway (504).
  static const String gatewayTimeout =
      'Tiempo de espera de la puerta de enlace';

  /// Mensaje para respuesta del servidor inválida.
  static const String invalidResponse = 'Respuesta del servidor inválida';

  // ============================================
  // Mensajes con parámetros (funciones)
  // ============================================

  /// Genera mensaje de error del servidor con descripción.
  static String serverErrorWithDescription(String description) =>
      'Error del servidor: $description';

  /// Genera mensaje de error del cliente con descripción.
  static String clientErrorWithDescription(String description) =>
      'Error del cliente: $description';

  /// Genera mensaje de código de respuesta inesperado.
  static String unexpectedStatusCode(int code) =>
      'Código de respuesta inesperado: $code';

  /// Genera mensaje de respuesta inválida con detalle.
  static String invalidResponseWithDetail(String detail) =>
      'Respuesta del servidor inválida: $detail';

  // ============================================
  // Mensajes de Failures (Domain)
  // ============================================

  /// Mensaje por defecto para ConnectionFailure.
  static const String connectionFailure =
      'Error de conexión. Verifica tu conexión a internet.';

  /// Mensaje por defecto para ServerFailure.
  static const String serverFailure = 'Error del servidor. Intenta más tarde.';

  /// Mensaje por defecto para NotFoundFailure.
  static const String notFoundFailure = 'Recurso no encontrado.';

  /// Mensaje por defecto para InvalidRequestFailure.
  static const String invalidRequestFailure =
      'Solicitud inválida. Verifica los parámetros.';

  /// Genera mensaje de error inesperado.
  static String unexpectedError(Object error) => 'Error inesperado: $error';
}
