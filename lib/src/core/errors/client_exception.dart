import 'app_exception.dart';

/// Excepción lanzada cuando hay un error del cliente (4xx).
///
/// Incluye el código de estado HTTP para facilitar diagnóstico.
///
/// ## Ejemplo
///
/// ```dart
/// if (HttpStatusCodes.isClientError(response.statusCode)) {
///   throw ClientException(
///     message: 'Solicitud incorrecta',
///     statusCode: response.statusCode,
///   );
/// }
/// ```
class ClientException extends AppException {
  /// Mensaje por defecto para errores del cliente.
  static const String defaultMessage = 'Error en la solicitud';

  /// Código de estado HTTP que causó el error (opcional).
  ///
  /// Valores típicos: 400, 401, 403, 422, 429.
  final int? statusCode;

  /// Crea una nueva instancia de [ClientException].
  ///
  /// [message] es el mensaje descriptivo del error.
  /// [statusCode] es el código HTTP del error (opcional).
  const ClientException({String message = defaultMessage, this.statusCode})
    : super(message);

  /// Constructor simplificado que solo recibe el mensaje.
  const ClientException.withMessage(super.message) : statusCode = null;

  @override
  String toString() {
    if (statusCode != null) {
      return 'ClientException: $message (HTTP $statusCode)';
    }
    return 'ClientException: $message';
  }
}
