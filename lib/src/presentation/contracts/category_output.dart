/// Contrato para mostrar datos de categorías.
///
/// Define los métodos para visualizar categorías,
/// independientemente de la plataforma.
abstract class CategoryOutput {
  /// Muestra una lista de categorías.
  ///
  /// [categories] es la lista de nombres de categorías a visualizar.
  void showCategories(List<String> categories);
}
