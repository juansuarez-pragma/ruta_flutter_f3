import 'app_exception.dart';

/// Excepción lanzada cuando el recurso solicitado no existe (404).
class NotFoundException extends AppException {
  /// Mensaje por defecto para recursos no encontrados.
  static const String defaultMessage = 'Recurso no encontrado';

  /// Crea una nueva instancia de [NotFoundException].
  const NotFoundException([super.message = defaultMessage]);
}
