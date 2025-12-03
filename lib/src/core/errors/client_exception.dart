import 'package:fake_store_api_client/src/core/constants/constants.dart';
import 'package:fake_store_api_client/src/core/errors/app_exception.dart';

/// Error del cliente (código 4xx).
class ClientException extends AppException {
  const ClientException({
    String message = ErrorMessages.clientError,
  }) : super(message);
}
