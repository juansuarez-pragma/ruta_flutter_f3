/// Centralización de todos los textos de la aplicación.
///
/// Esta clase proporciona acceso a todos los strings utilizados en el paquete,
/// facilitando el mantenimiento y futuras traducciones.
///
/// ## Uso
///
/// ```dart
/// import 'package:fake_store_api_client/fake_store_api_client.dart';
///
/// print(AppStrings.welcomeMessage);
/// print(AppStrings.menuOptionGetAllProducts);
/// ```
///
/// ## Personalización
///
/// Si necesitas personalizar los mensajes, puedes crear tu propia clase
/// que implemente los mismos campos o usar los mensajes directamente
/// en tu implementación de [UserInterface].
class AppStrings {
  // Constructor privado para prevenir instanciación
  AppStrings._();

  // ─────────────────────────────────────────────────────────────────────────
  // General
  // ─────────────────────────────────────────────────────────────────────────

  /// Mensaje de bienvenida de la aplicación.
  static const String welcomeMessage = 'Bienvenido a Fake Store';

  /// Mensaje de despedida de la aplicación.
  static const String goodbyeMessage = 'Hasta pronto';

  /// Separador visual para la consola.
  static const String separator =
      '--------------------------------------------------';

  // ─────────────────────────────────────────────────────────────────────────
  // Menú
  // ─────────────────────────────────────────────────────────────────────────

  /// Título del menú principal.
  static const String menuTitle = 'Por favor, elige una opción:';

  /// Opción de menú: obtener todos los productos.
  static const String menuOptionGetAllProducts = 'Obtener todos los productos';

  /// Opción de menú: obtener producto por ID.
  static const String menuOptionGetProductById = 'Obtener un producto por ID';

  /// Opción de menú: obtener todas las categorías.
  static const String menuOptionGetAllCategories =
      'Obtener todas las categorías';

  /// Opción de menú: obtener productos por categoría.
  static const String menuOptionGetProductsByCategory =
      'Obtener productos por categoría';

  /// Opción de menú: salir.
  static const String menuOptionExit = 'Salir';

  /// Prompt para selección de opción.
  static const String menuPrompt = 'Ingresa el número de la opción: ';

  // ─────────────────────────────────────────────────────────────────────────
  // Solicitudes al usuario
  // ─────────────────────────────────────────────────────────────────────────

  /// Prompt para solicitar ID de producto.
  static const String promptProductId = 'Ingresa el ID del producto: ';

  /// Prompt para solicitar categoría.
  static const String promptCategory = 'Selecciona una categoría: ';

  // ─────────────────────────────────────────────────────────────────────────
  // Mensajes de carga
  // ─────────────────────────────────────────────────────────────────────────

  /// Mensaje de carga: obteniendo productos.
  static const String loadingProducts = 'Obteniendo productos...';

  /// Mensaje de carga: obteniendo producto por ID.
  static String loadingProductById(int id) => 'Obteniendo producto #$id...';

  /// Mensaje de carga: obteniendo categorías.
  static const String loadingCategories = 'Obteniendo categorías...';

  /// Mensaje de carga: obteniendo productos por categoría.
  static String loadingProductsByCategory(String category) =>
      'Obteniendo productos de "$category"...';

  // ─────────────────────────────────────────────────────────────────────────
  // Mensajes de error
  // ─────────────────────────────────────────────────────────────────────────

  /// Prefijo para mensajes de error.
  static const String errorPrefix = 'Error:';

  /// Error: opción inválida.
  static const String invalidOptionError = 'Opción inválida. Intenta de nuevo.';

  /// Error: opción inválida (versión corta).
  static const String invalidOptionErrorShort = 'Opción inválida.';

  /// Error: ID inválido.
  static const String invalidIdError = 'ID inválido.';

  /// Error: categoría inválida.
  static const String invalidCategoryError = 'Categoría inválida.';

  /// Error: servidor.
  static const String serverFailureMessage = 'Error en el servidor.';

  /// Error: recurso no encontrado.
  static const String notFoundFailureMessage = 'Recurso no encontrado.';

  /// Error: producto no encontrado.
  static const String notFoundProductFailureMessage = 'Producto no encontrado.';

  /// Error: categorías no encontradas.
  static const String notFoundCategoriesFailureMessage =
      'Categorías no encontradas.';

  /// Error: solicitud inválida.
  static const String clientFailureMessage = 'Error en la solicitud.';

  /// Error: conexión.
  static const String connectionFailureMessage =
      'Error de conexión. Verifica tu conexión a internet.';

  /// Prefijo para error inesperado.
  static const String unexpectedFailureMessage = 'Error inesperado:';

  // ─────────────────────────────────────────────────────────────────────────
  // Etiquetas
  // ─────────────────────────────────────────────────────────────────────────

  /// Etiqueta: productos.
  static const String productsLabel = 'Productos';

  /// Etiqueta: categorías.
  static const String categoriesLabel = 'Categorías';

  /// Etiqueta: producto.
  static const String productLabel = 'Producto';

  // ─────────────────────────────────────────────────────────────────────────
  // Detalles del producto
  // ─────────────────────────────────────────────────────────────────────────

  /// Etiqueta: ID del producto.
  static const String productId = 'ID';

  /// Etiqueta: título del producto.
  static const String productTitle = 'Título';

  /// Etiqueta: categoría del producto.
  static const String productCategory = 'Categoría';

  /// Etiqueta: precio del producto.
  static const String productPrice = 'Precio';

  /// Etiqueta: descripción del producto.
  static const String productDescription = 'Descripción';

  /// Etiqueta: imagen del producto.
  static const String productImage = 'Imagen';

  /// Etiqueta: calificación del producto.
  static const String productRating = 'Calificación';

  /// Etiqueta: cantidad de reseñas.
  static const String productReviewCount = 'Reseñas';
}
