import 'app_exception.dart';

/// Excepción lanzada cuando el servidor responde con un error 5xx.
class ServerException extends AppException {
  /// Mensaje por defecto para errores del servidor.
  static const String defaultMessage = 'Error del servidor';

  /// Crea una nueva instancia de [ServerException].
  const ServerException([super.message = defaultMessage]);
}
