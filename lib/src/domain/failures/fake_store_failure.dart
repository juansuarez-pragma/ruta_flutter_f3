import 'package:fake_store_api_client/src/core/constants/constants.dart';

/// Errores posibles al interactuar con la Fake Store API.
///
/// ```dart
/// switch (failure) {
///   case ConnectionFailure(): // Sin conexión
///   case ServerFailure():     // Error 5xx
///   case NotFoundFailure():   // Error 404
///   case InvalidRequestFailure(): // Error 4xx
/// }
/// ```
sealed class FakeStoreFailure {
  final String message;
  const FakeStoreFailure(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FakeStoreFailure &&
        other.runtimeType == runtimeType &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() => '$runtimeType(message: $message)';
}

/// Sin conexión a internet o servidor no disponible.
final class ConnectionFailure extends FakeStoreFailure {
  const ConnectionFailure([super.message = ErrorMessages.connectionFailure]);
}

/// Error del servidor (código 5xx).
final class ServerFailure extends FakeStoreFailure {
  const ServerFailure([super.message = ErrorMessages.serverFailure]);
}

/// Recurso no encontrado (código 404).
final class NotFoundFailure extends FakeStoreFailure {
  const NotFoundFailure([super.message = ErrorMessages.notFoundFailure]);
}

/// Solicitud inválida (código 4xx).
final class InvalidRequestFailure extends FakeStoreFailure {
  const InvalidRequestFailure([
    super.message = ErrorMessages.invalidRequestFailure,
  ]);
}
