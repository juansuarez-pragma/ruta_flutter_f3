import 'package:http/http.dart' as http;

import '../errors/errors.dart';

/// Manejador de respuestas HTTP usando el patrón Strategy.
///
/// Mapea códigos de estado HTTP a excepciones tipadas,
/// permitiendo un manejo centralizado y extensible de errores.
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
  final Map<int, void Function(http.Response)> _strategies = {
    400: (response) => throw const ClientException('Solicitud incorrecta'),
    401: (response) => throw const ClientException('No autorizado'),
    403: (response) => throw const ClientException('Acceso prohibido'),
    404: (response) => throw const NotFoundException(),
    408: (response) => throw const ConnectionException('Tiempo de espera agotado'),
    429: (response) => throw const ClientException('Demasiadas solicitudes'),
    500: (response) => throw const ServerException(),
    502: (response) => throw const ServerException('Puerta de enlace incorrecta'),
    503: (response) => throw const ServerException('Servicio no disponible'),
    504: (response) => throw const ServerException('Tiempo de espera de la puerta de enlace'),
  };

  /// Procesa una respuesta HTTP y lanza excepciones según el código de estado.
  ///
  /// Si el código está entre 200-299, no hace nada (éxito).
  /// Si hay un código de error, lanza la excepción correspondiente.
  ///
  /// [response] es la respuesta HTTP a procesar.
  ///
  /// Lanza:
  /// - [ClientException] para errores 4xx
  /// - [ServerException] para errores 5xx
  /// - [NotFoundException] para 404
  void handleResponse(http.Response response) {
    // Respuesta exitosa (2xx)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    // Buscar estrategia específica para el código
    final strategy = _strategies[response.statusCode];
    if (strategy != null) {
      strategy(response);
      return;
    }

    // Fallback para rangos de errores no específicos
    if (response.statusCode >= 400 && response.statusCode < 500) {
      throw ClientException('Error del cliente: ${response.statusCode}');
    }

    if (response.statusCode >= 500) {
      throw ServerException('Error del servidor: ${response.statusCode}');
    }

    // Código desconocido
    throw ServerException('Código de respuesta inesperado: ${response.statusCode}');
  }
}
