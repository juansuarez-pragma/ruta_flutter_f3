/// Constantes de códigos de estado HTTP.
///
/// Referencia: https://developer.mozilla.org/es/docs/Web/HTTP/Status
///
/// Los códigos de estado HTTP se dividen en 5 categorías:
/// - 1xx: Respuestas informativas
/// - 2xx: Respuestas exitosas
/// - 3xx: Redirecciones
/// - 4xx: Errores del cliente
/// - 5xx: Errores del servidor
///
/// ## Uso
///
/// ```dart
/// if (HttpStatusCodes.isSuccess(response.statusCode)) {
///   // Procesar respuesta exitosa
/// }
///
/// if (response.statusCode == HttpStatusCodes.notFound) {
///   throw NotFoundException();
/// }
/// ```
abstract class HttpStatusCodes {
  HttpStatusCodes._();

  // ============================================
  // 4xx - Errores del cliente
  // ============================================

  /// 400 - El servidor no puede procesar la solicitud debido a un error del cliente.
  static const int badRequest = 400;

  /// 401 - El cliente debe autenticarse para obtener la respuesta solicitada.
  static const int unauthorized = 401;

  /// 403 - El cliente no tiene derechos de acceso al contenido.
  static const int forbidden = 403;

  /// 404 - El servidor no puede encontrar el recurso solicitado.
  static const int notFound = 404;

  /// 408 - El servidor agotó el tiempo de espera para la solicitud.
  static const int requestTimeout = 408;

  /// 422 - El servidor entiende el tipo de contenido pero no puede procesar las instrucciones.
  static const int unprocessableEntity = 422;

  /// 429 - El cliente ha enviado demasiadas solicitudes en un tiempo determinado.
  static const int tooManyRequests = 429;

  // ============================================
  // 5xx - Errores del servidor
  // ============================================

  /// 500 - El servidor ha encontrado una situación que no sabe cómo manejar.
  static const int internalServerError = 500;

  /// 502 - El servidor actuando como gateway recibió una respuesta inválida.
  static const int badGateway = 502;

  /// 503 - El servidor no está listo para manejar la solicitud.
  static const int serviceUnavailable = 503;

  /// 504 - El servidor actuando como gateway no recibió respuesta a tiempo.
  static const int gatewayTimeout = 504;

  // ============================================
  // Rangos de códigos - Métodos de utilidad
  // ============================================

  /// Verifica si el código indica éxito (2xx).
  ///
  /// ```dart
  /// if (HttpStatusCodes.isSuccess(200)) // true
  /// if (HttpStatusCodes.isSuccess(404)) // false
  /// ```
  static bool isSuccess(int code) => code >= 200 && code < 300;

  /// Verifica si el código indica error del cliente (4xx).
  ///
  /// ```dart
  /// if (HttpStatusCodes.isClientError(400)) // true
  /// if (HttpStatusCodes.isClientError(500)) // false
  /// ```
  static bool isClientError(int code) => code >= 400 && code < 500;

  /// Verifica si el código indica error del servidor (5xx).
  ///
  /// ```dart
  /// if (HttpStatusCodes.isServerError(500)) // true
  /// if (HttpStatusCodes.isServerError(404)) // false
  /// ```
  static bool isServerError(int code) => code >= 500 && code < 600;

  /// Obtiene una descripción legible del código de estado.
  ///
  /// ```dart
  /// HttpStatusCodes.getDescription(404) // 'Not Found'
  /// HttpStatusCodes.getDescription(500) // 'Internal Server Error'
  /// ```
  static String getDescription(int code) {
    return switch (code) {
      badRequest => 'Bad Request',
      unauthorized => 'Unauthorized',
      forbidden => 'Forbidden',
      notFound => 'Not Found',
      requestTimeout => 'Request Timeout',
      unprocessableEntity => 'Unprocessable Entity',
      tooManyRequests => 'Too Many Requests',
      internalServerError => 'Internal Server Error',
      badGateway => 'Bad Gateway',
      serviceUnavailable => 'Service Unavailable',
      gatewayTimeout => 'Gateway Timeout',
      _ => 'HTTP Error $code',
    };
  }
}
