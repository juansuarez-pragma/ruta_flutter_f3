import 'app_exception.dart';

/// Excepción lanzada cuando hay un error de conexión de red.
class ConnectionException extends AppException {
  /// Mensaje por defecto para errores de conexión.
  static const String defaultMessage = 'Error de conexión';

  /// Crea una nueva instancia de [ConnectionException].
  const ConnectionException([super.message = defaultMessage]);
}
