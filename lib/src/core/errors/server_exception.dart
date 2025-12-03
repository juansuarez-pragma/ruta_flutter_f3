import 'package:fake_store_api_client/src/core/constants/constants.dart';
import 'package:fake_store_api_client/src/core/errors/app_exception.dart';

/// Error del servidor (código 5xx).
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    String message = ErrorMessages.serverError,
    this.statusCode,
  }) : super(message);

  const ServerException.withMessage(super.message) : statusCode = null;

  @override
  String toString() {
    if (statusCode != null) {
      return 'ServerException: $message (HTTP $statusCode)';
    }
    return 'ServerException: $message';
  }
}
