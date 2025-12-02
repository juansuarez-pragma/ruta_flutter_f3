/// Enumeración que representa las opciones del menú principal.
///
/// Define las acciones disponibles para el usuario en la aplicación.
/// Incluye operaciones CRUD de productos y categorías.
enum MenuOption {
  /// Obtener todos los productos.
  getAllProducts,

  /// Obtener un producto por su ID.
  getProductById,

  /// Obtener todas las categorías disponibles.
  getAllCategories,

  /// Obtener productos filtrados por categoría.
  getProductsByCategory,

  /// Salir de la aplicación.
  exit,

  /// Opción inválida (usado para errores de entrada).
  invalid,
}
