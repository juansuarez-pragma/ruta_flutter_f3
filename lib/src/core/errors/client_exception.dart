import 'app_exception.dart';

/// Excepción lanzada cuando hay un error del cliente (4xx).
class ClientException extends AppException {
  /// Mensaje por defecto para errores del cliente.
  static const String defaultMessage = 'Error en la solicitud';

  /// Crea una nueva instancia de [ClientException].
  const ClientException([super.message = defaultMessage]);
}
