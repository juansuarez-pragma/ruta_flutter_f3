/// Constantes para los endpoints de la Fake Store API.
///
/// Centraliza todas las rutas de la API para facilitar
/// el mantenimiento y evitar strings mágicos.
///
/// ## Uso
///
/// ```dart
/// final url = '${baseUrl}${ApiEndpoints.products}';
/// final productUrl = '${baseUrl}${ApiEndpoints.productById(1)}';
/// ```
class ApiEndpoints {
  // Constructor privado para prevenir instanciación
  ApiEndpoints._();

  /// Endpoint para obtener todos los productos.
  ///
  /// GET /products
  static const String products = '/products';

  /// Endpoint para obtener un producto específico.
  ///
  /// GET /products/{id}
  static String productById(int id) => '/products/$id';

  /// Endpoint para obtener todas las categorías.
  ///
  /// GET /products/categories
  static const String categories = '/products/categories';

  /// Endpoint para obtener productos de una categoría.
  ///
  /// GET /products/category/{category}
  static String productsByCategory(String category) =>
      '/products/category/$category';
}
