/// Clase base para excepciones de la aplicación.
///
/// Las excepciones se lanzan en la capa de datos y se convierten
/// a [FakeStoreFailure] en la capa de repositorio.
abstract class AppException implements Exception {
  /// Mensaje descriptivo del error.
  final String message;

  /// Crea una nueva instancia de [AppException].
  const AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}
