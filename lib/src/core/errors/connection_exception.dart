import 'package:fake_store_api_client/src/core/constants/constants.dart';
import 'package:fake_store_api_client/src/core/errors/app_exception.dart';

/// Excepción lanzada cuando hay un error de conexión de red.
///
/// Puede contener información de diagnóstico como la URI que falló
/// y el mensaje del error original para facilitar debugging.
///
/// ## Ejemplo
///
/// ```dart
/// try {
///   await httpClient.get(uri);
/// } on SocketException catch (e) {
///   throw ConnectionException(
///     message: 'Sin conexión a internet',
///     uri: uri,
///     originalError: e.message,
///   );
/// }
/// ```
class ConnectionException extends AppException {
  /// URI que causó el error de conexión (opcional).
  ///
  /// Útil para diagnóstico y logging.
  final Uri? uri;

  /// Mensaje del error original que causó esta excepción (opcional).
  ///
  /// Preserva el contexto del error subyacente.
  final String? originalError;

  /// Crea una nueva instancia de [ConnectionException].
  ///
  /// [message] es el mensaje descriptivo del error.
  /// [uri] es la URI que causó el error (opcional).
  /// [originalError] es el mensaje del error original (opcional).
  const ConnectionException({
    String message = ErrorMessages.connectionError,
    this.uri,
    this.originalError,
  }) : super(message);

  /// Constructor simplificado que solo recibe el mensaje.
  ///
  /// Útil cuando no se necesita información de diagnóstico adicional.
  const ConnectionException.withMessage(super.message)
    : uri = null,
      originalError = null;

  @override
  String toString() {
    final buffer = StringBuffer('ConnectionException: $message');
    if (uri != null) {
      buffer.write(' [URI: $uri]');
    }
    if (originalError != null) {
      buffer.write(' (Original: $originalError)');
    }
    return buffer.toString();
  }
}
