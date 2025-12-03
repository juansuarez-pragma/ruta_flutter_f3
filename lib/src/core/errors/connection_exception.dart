import 'package:fake_store_api_client/src/core/constants/constants.dart';
import 'package:fake_store_api_client/src/core/errors/app_exception.dart';

/// Error de conexión de red.
class ConnectionException extends AppException {
  const ConnectionException({String message = ErrorMessages.connectionError})
    : super(message);
}
