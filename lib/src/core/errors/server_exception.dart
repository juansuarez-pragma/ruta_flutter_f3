import 'package:fake_store_api_client/src/core/constants/constants.dart';
import 'package:fake_store_api_client/src/core/errors/app_exception.dart';

/// Excepción lanzada cuando el servidor responde con un error 5xx.
///
/// Incluye el código de estado HTTP para facilitar diagnóstico.
///
/// ## Ejemplo
///
/// ```dart
/// if (HttpStatusCodes.isServerError(response.statusCode)) {
///   throw ServerException(
///     message: 'Error interno del servidor',
///     statusCode: response.statusCode,
///   );
/// }
/// ```
class ServerException extends AppException {
  /// Código de estado HTTP que causó el error (opcional).
  ///
  /// Valores típicos: 500, 502, 503, 504.
  final int? statusCode;

  /// Crea una nueva instancia de [ServerException].
  ///
  /// [message] es el mensaje descriptivo del error.
  /// [statusCode] es el código HTTP del error (opcional).
  const ServerException({
    String message = ErrorMessages.serverError,
    this.statusCode,
  }) : super(message);

  /// Constructor simplificado que solo recibe el mensaje.
  const ServerException.withMessage(super.message) : statusCode = null;

  @override
  String toString() {
    if (statusCode != null) {
      return 'ServerException: $message (HTTP $statusCode)';
    }
    return 'ServerException: $message';
  }
}
