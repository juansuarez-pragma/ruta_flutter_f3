import 'package:fake_store_api_client/src/core/constants/constants.dart';

/// Clase base sellada para errores del cliente Fake Store.
///
/// Proporciona un mensaje descriptivo del error ocurrido.
/// Las subclases representan tipos específicos de errores.
///
/// Al ser una clase sellada (sealed), el compilador puede verificar
/// que todos los casos de error sean manejados en un switch/case.
///
/// ## Ejemplo de uso
///
/// ```dart
/// void handleFailure(FakeStoreFailure failure) {
///   switch (failure) {
///     case ConnectionFailure():
///       print('Sin conexión: ${failure.message}');
///     case ServerFailure():
///       print('Error del servidor: ${failure.message}');
///     case NotFoundFailure():
///       print('No encontrado: ${failure.message}');
///     case InvalidRequestFailure():
///       print('Solicitud inválida: ${failure.message}');
///   }
/// }
/// ```
sealed class FakeStoreFailure {
  /// Mensaje descriptivo del error.
  final String message;

  /// Crea una nueva instancia de [FakeStoreFailure].
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

/// Error de conexión de red.
///
/// Ocurre cuando no hay conexión a internet o el servidor
/// no está disponible.
///
/// ## Ejemplo
///
/// ```dart
/// if (!hasInternet) {
///   return Left(ConnectionFailure());
/// }
/// ```
final class ConnectionFailure extends FakeStoreFailure {
  /// Crea una nueva instancia de [ConnectionFailure].
  ///
  /// [message] es opcional. Si no se proporciona, se usa
  /// [ErrorMessages.connectionFailure].
  const ConnectionFailure([super.message = ErrorMessages.connectionFailure]);
}

/// Error del servidor.
///
/// Ocurre cuando el servidor responde con un código 5xx
/// indicando un problema interno.
///
/// ## Ejemplo
///
/// ```dart
/// if (response.statusCode >= 500) {
///   throw ServerException();
/// }
/// // En el repositorio se convierte a:
/// return Left(ServerFailure());
/// ```
final class ServerFailure extends FakeStoreFailure {
  /// Crea una nueva instancia de [ServerFailure].
  ///
  /// [message] es opcional. Si no se proporciona, se usa
  /// [ErrorMessages.serverFailure].
  const ServerFailure([super.message = ErrorMessages.serverFailure]);
}

/// Recurso no encontrado.
///
/// Ocurre cuando el producto o categoría solicitada no existe
/// (código HTTP 404).
///
/// ## Ejemplo
///
/// ```dart
/// final result = await client.getProductById(999999);
/// result.fold(
///   (failure) {
///     if (failure is NotFoundFailure) {
///       print('El producto no existe');
///     }
///   },
///   (product) => print(product),
/// );
/// ```
final class NotFoundFailure extends FakeStoreFailure {
  /// Crea una nueva instancia de [NotFoundFailure].
  ///
  /// [message] es opcional. Si no se proporciona, se usa
  /// [ErrorMessages.notFoundFailure].
  const NotFoundFailure([super.message = ErrorMessages.notFoundFailure]);
}

/// Error de solicitud inválida.
///
/// Ocurre cuando los parámetros de la solicitud son incorrectos
/// o el formato de la petición no es válido (códigos HTTP 4xx).
///
/// ## Ejemplo
///
/// ```dart
/// // Si se intenta obtener un producto con ID negativo
/// final result = await client.getProductById(-1);
/// // Podría retornar InvalidRequestFailure
/// ```
final class InvalidRequestFailure extends FakeStoreFailure {
  /// Crea una nueva instancia de [InvalidRequestFailure].
  ///
  /// [message] es opcional. Si no se proporciona, se usa
  /// [ErrorMessages.invalidRequestFailure].
  const InvalidRequestFailure([
    super.message = ErrorMessages.invalidRequestFailure,
  ]);
}
