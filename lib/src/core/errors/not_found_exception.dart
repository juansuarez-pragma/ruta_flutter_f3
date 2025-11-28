import 'package:fake_store_api_client/src/core/constants/constants.dart';
import 'package:fake_store_api_client/src/core/errors/app_exception.dart';

/// Excepción lanzada cuando el recurso solicitado no existe (404).
class NotFoundException extends AppException {
  /// Crea una nueva instancia de [NotFoundException].
  const NotFoundException([super.message = ErrorMessages.notFound]);
}
