/// Contrato para entrada de datos del usuario.
///
/// Define los métodos necesarios para obtener input del usuario,
/// independientemente de la plataforma (consola, GUI, web, etc.).
abstract class UserInput {
  /// Solicita al usuario que ingrese un ID de producto.
  ///
  /// Retorna el ID como [int], o `null` si el usuario cancela
  /// o ingresa un valor inválido.
  Future<int?> promptProductId();

  /// Solicita al usuario que seleccione una categoría de la lista.
  ///
  /// [categories] es la lista de categorías disponibles.
  /// Retorna la categoría seleccionada, o `null` si el usuario
  /// cancela o selecciona una opción inválida.
  Future<String?> promptCategory(List<String> categories);
}
