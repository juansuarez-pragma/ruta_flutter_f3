import 'package:fake_store_api_client/src/core/constants/constants.dart';
import 'package:fake_store_api_client/src/core/errors/app_exception.dart';

/// Recurso no encontrado (código 404).
class NotFoundException extends AppException {
  const NotFoundException([super.message = ErrorMessages.notFound]);
}
