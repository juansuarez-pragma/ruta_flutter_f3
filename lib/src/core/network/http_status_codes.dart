/// Códigos de estado HTTP y métodos de utilidad.
abstract class HttpStatusCodes {
  HttpStatusCodes._();

  // 4xx - Errores del cliente
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int requestTimeout = 408;
  static const int unprocessableEntity = 422;
  static const int tooManyRequests = 429;

  // 5xx - Errores del servidor
  static const int internalServerError = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;

  /// Verifica si el código indica éxito (2xx).
  static bool isSuccess(int code) => code >= 200 && code < 300;

  /// Verifica si el código indica error del cliente (4xx).
  static bool isClientError(int code) => code >= 400 && code < 500;

  /// Verifica si el código indica error del servidor (5xx).
  static bool isServerError(int code) => code >= 500 && code < 600;

  /// Obtiene una descripción legible del código de estado.
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
