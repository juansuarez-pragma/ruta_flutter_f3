import 'package:fake_store_api_client/src/core/constants/constants.dart';
import 'package:fake_store_api_client/src/core/errors/app_exception.dart';

/// Error del cliente (código 4xx).
class ClientException extends AppException {
  final int? statusCode;

  const ClientException({
    String message = ErrorMessages.clientError,
    this.statusCode,
  }) : super(message);

  const ClientException.withMessage(super.message) : statusCode = null;

  @override
  String toString() {
    if (statusCode != null) {
      return 'ClientException: $message (HTTP $statusCode)';
    }
    return 'ClientException: $message';
  }
}
