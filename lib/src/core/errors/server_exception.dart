import 'package:fake_store_api_client/src/core/constants/constants.dart';
import 'package:fake_store_api_client/src/core/errors/app_exception.dart';

/// Error del servidor (código 5xx).
class ServerException extends AppException {
  const ServerException({
    String message = ErrorMessages.serverError,
  }) : super(message);
}
