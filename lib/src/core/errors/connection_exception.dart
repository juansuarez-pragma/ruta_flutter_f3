import 'package:fake_store_api_client/src/core/constants/constants.dart';
import 'package:fake_store_api_client/src/core/errors/app_exception.dart';

/// Error de conexión de red.
class ConnectionException extends AppException {
  final Uri? uri;
  final String? originalError;

  const ConnectionException({
    String message = ErrorMessages.connectionError,
    this.uri,
    this.originalError,
  }) : super(message);

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
