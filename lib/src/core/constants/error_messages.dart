/// Mensajes de error centralizados para el paquete.
abstract class ErrorMessages {
  ErrorMessages._();

  // Errores de conexión
  static const String timeout = 'Tiempo de espera agotado';
  static const String noInternet = 'Sin conexión a internet';
  static const String connectionError = 'Error de conexión con el servidor';

  // Errores del cliente (4xx)
  static const String clientError = 'Error en la solicitud';
  static const String badRequest = 'Solicitud incorrecta';
  static const String unauthorized = 'No autorizado';
  static const String forbidden = 'Acceso prohibido';
  static const String notFound = 'Recurso no encontrado';
  static const String unprocessableEntity = 'Datos de solicitud inválidos';
  static const String tooManyRequests = 'Demasiadas solicitudes';

  // Errores del servidor (5xx)
  static const String serverError = 'Error del servidor';
  static const String badGateway = 'Puerta de enlace incorrecta';
  static const String serviceUnavailable = 'Servicio no disponible';
  static const String gatewayTimeout = 'Tiempo de espera de la puerta de enlace';
  static const String invalidResponse = 'Respuesta del servidor inválida';

  // Mensajes con parámetros
  static String serverErrorWithDescription(String description) =>
      'Error del servidor: $description';

  static String clientErrorWithDescription(String description) =>
      'Error del cliente: $description';

  static String unexpectedStatusCode(int code) =>
      'Código de respuesta inesperado: $code';

  static String invalidResponseWithDetail(String detail) =>
      'Respuesta del servidor inválida: $detail';

  // Mensajes de Failures (Domain)
  static const String connectionFailure =
      'Error de conexión. Verifica tu conexión a internet.';
  static const String serverFailure = 'Error del servidor. Intenta más tarde.';
  static const String notFoundFailure = 'Recurso no encontrado.';
  static const String invalidRequestFailure =
      'Solicitud inválida. Verifica los parámetros.';

  static String unexpectedError(Object error) => 'Error inesperado: $error';
}
