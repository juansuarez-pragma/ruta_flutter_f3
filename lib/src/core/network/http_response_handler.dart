import 'package:http/http.dart' as http;

import '../errors/errors.dart';
import 'http_status_codes.dart';

/// Manejador de respuestas HTTP usando el patrón Strategy.
///
/// Mapea códigos de estado HTTP a excepciones tipadas,
/// permitiendo un manejo centralizado y extensible de errores.
///
/// Implementa el patrón Strategy para mapear códigos HTTP específicos
/// a excepciones tipadas. Los códigos no mapeados explícitamente
/// se manejan por rangos (4xx → ClientException, 5xx → ServerException).
///
/// Referencia de códigos HTTP:
/// - 2xx: Éxito (no lanza excepción)
/// - 4xx: Error del cliente (la solicitud es incorrecta)
/// - 5xx: Error del servidor (el servidor falló al procesar)
///
/// ## Uso
///
/// ```dart
/// final handler = HttpResponseHandler();
/// handler.handleResponse(response); // Lanza excepción si hay error
/// ```
class HttpResponseHandler {
  /// Mapa de estrategias para códigos HTTP específicos.
  ///
  /// Cada código tiene asociada una función que lanza la excepción apropiada.
  /// Los códigos no listados aquí se manejan por rangos en [handleResponse].
  static final Map<int, void Function(http.Response)> _strategies = {
    // 400 Bad Request: solicitud mal formada o inválida
    HttpStatusCodes.badRequest: (response) => throw const ClientException(
      message: 'Solicitud incorrecta',
      statusCode: HttpStatusCodes.badRequest,
    ),

    // 401 Unauthorized: requiere autenticación
    HttpStatusCodes.unauthorized: (response) => throw const ClientException(
      message: 'No autorizado',
      statusCode: HttpStatusCodes.unauthorized,
    ),

    // 403 Forbidden: autenticado pero sin permisos
    HttpStatusCodes.forbidden: (response) => throw const ClientException(
      message: 'Acceso prohibido',
      statusCode: HttpStatusCodes.forbidden,
    ),

    // 404 Not Found: recurso no existe
    HttpStatusCodes.notFound: (response) => throw const NotFoundException(),

    // 408 Request Timeout: tiempo de espera agotado
    HttpStatusCodes.requestTimeout: (response) =>
        throw const ConnectionException(message: 'Tiempo de espera agotado'),

    // 422 Unprocessable Entity: datos inválidos
    HttpStatusCodes.unprocessableEntity: (response) =>
        throw const ClientException(
          message: 'Datos de solicitud inválidos',
          statusCode: HttpStatusCodes.unprocessableEntity,
        ),

    // 429 Too Many Requests: rate limiting
    HttpStatusCodes.tooManyRequests: (response) => throw const ClientException(
      message: 'Demasiadas solicitudes',
      statusCode: HttpStatusCodes.tooManyRequests,
    ),

    // 500 Internal Server Error: error genérico del servidor
    HttpStatusCodes.internalServerError: (response) =>
        throw const ServerException(
          statusCode: HttpStatusCodes.internalServerError,
        ),

    // 502 Bad Gateway: puerta de enlace incorrecta
    HttpStatusCodes.badGateway: (response) => throw const ServerException(
      message: 'Puerta de enlace incorrecta',
      statusCode: HttpStatusCodes.badGateway,
    ),

    // 503 Service Unavailable: servicio no disponible
    HttpStatusCodes.serviceUnavailable: (response) =>
        throw const ServerException(
          message: 'Servicio no disponible',
          statusCode: HttpStatusCodes.serviceUnavailable,
        ),

    // 504 Gateway Timeout: tiempo de espera de gateway
    HttpStatusCodes.gatewayTimeout: (response) => throw const ServerException(
      message: 'Tiempo de espera de la puerta de enlace',
      statusCode: HttpStatusCodes.gatewayTimeout,
    ),
  };

  /// Procesa una respuesta HTTP y lanza excepciones según el código de estado.
  ///
  /// No hace nada si el código de estado indica éxito (2xx).
  /// Para códigos de error, busca primero una estrategia específica
  /// y luego aplica manejo por rangos.
  ///
  /// [response] es la respuesta HTTP a procesar.
  ///
  /// Lanza:
  /// - [NotFoundException] para 404
  /// - [ClientException] para otros errores 4xx
  /// - [ServerException] para errores 5xx
  /// - [ConnectionException] para timeouts (408)
  void handleResponse(http.Response response) {
    final int statusCode = response.statusCode;

    // 2xx - Respuestas exitosas: no hacemos nada
    if (HttpStatusCodes.isSuccess(statusCode)) {
      return;
    }

    // Buscar estrategia específica para el código
    final strategy = _strategies[statusCode];
    if (strategy != null) {
      strategy(response);
      return;
    }

    // 5xx - Errores del servidor
    if (HttpStatusCodes.isServerError(statusCode)) {
      throw ServerException(
        message:
            'Error del servidor: ${HttpStatusCodes.getDescription(statusCode)}',
        statusCode: statusCode,
      );
    }

    // 4xx - Errores del cliente
    if (HttpStatusCodes.isClientError(statusCode)) {
      throw ClientException(
        message:
            'Error del cliente: ${HttpStatusCodes.getDescription(statusCode)}',
        statusCode: statusCode,
      );
    }

    // Fallback para cualquier otro código no esperado
    throw ServerException(
      message: 'Código de respuesta inesperado: $statusCode',
      statusCode: statusCode,
    );
  }
}
