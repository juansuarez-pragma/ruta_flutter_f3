/// Contrato para mostrar mensajes al usuario.
///
/// Define los métodos para comunicar información general,
/// errores y estados de la aplicación.
abstract class MessageOutput {
  /// Muestra un mensaje de bienvenida al usuario.
  ///
  /// [message] es el texto de bienvenida a mostrar.
  void showWelcome(String message);

  /// Muestra un mensaje de error al usuario.
  ///
  /// [message] es la descripción del error.
  void showError(String message);

  /// Muestra un mensaje de despedida.
  void showGoodbye();

  /// Muestra información sobre la operación en curso.
  ///
  /// [operationName] es el nombre de la operación que se está ejecutando.
  void showLoading(String operationName);
}
