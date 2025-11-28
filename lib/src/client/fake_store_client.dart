import 'package:http/http.dart' as http;

import '../core/either/either.dart';

import '../core/network/network.dart';
import '../data/data.dart';
import '../domain/domain.dart';
import 'fake_store_config.dart';

/// Cliente para interactuar con la Fake Store API.
///
/// Proporciona métodos para obtener productos y categorías
/// de la tienda ficticia con manejo funcional de errores.
///
/// ## Uso básico
///
/// ```dart
/// final client = FakeStoreClient();
///
/// // Obtener todos los productos
/// final result = await client.getProducts();
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (products) => products.forEach(print),
/// );
///
/// // No olvides liberar recursos
/// client.dispose();
/// ```
///
/// ## Configuración personalizada
///
/// ```dart
/// final client = FakeStoreClient(
///   config: FakeStoreConfig(
///     baseUrl: 'https://fakestoreapi.com',
///     timeout: Duration(seconds: 30),
///   ),
/// );
/// ```
///
/// ## Manejo de errores
///
/// Todos los métodos retornan [Either<FakeStoreFailure, T>]:
/// - [Left] contiene el error ([FakeStoreFailure])
/// - [Right] contiene el resultado exitoso
///
/// Los tipos de errores posibles son:
/// - [ConnectionFailure]: Error de conexión de red
/// - [ServerFailure]: Error del servidor (5xx)
/// - [NotFoundFailure]: Recurso no encontrado (404)
/// - [InvalidRequestFailure]: Solicitud inválida (4xx)
class FakeStoreClient {
  final ProductRepository _repository;
  final http.Client _httpClient;

  /// Crea una nueva instancia del cliente.
  ///
  /// [config] permite personalizar la URL base y timeout.
  /// Si no se proporciona, usa valores por defecto.
  ///
  /// [httpClient] permite inyectar un cliente HTTP personalizado,
  /// útil para testing.
  FakeStoreClient({
    FakeStoreConfig? config,
    http.Client? httpClient,
  })  : _httpClient = httpClient ?? http.Client(),
        _repository = _createRepository(
          config ?? const FakeStoreConfig(),
          httpClient ?? http.Client(),
        );

  /// Crea el repositorio interno con todas sus dependencias.
  static ProductRepository _createRepository(
    FakeStoreConfig config,
    http.Client httpClient,
  ) {
    final responseHandler = HttpResponseHandler();
    final apiClient = ApiClientImpl(
      client: httpClient,
      baseUrl: config.baseUrl,
      timeout: config.timeout,
      responseHandler: responseHandler,
    );
    final datasource = FakeStoreDatasource(apiClient: apiClient);
    return ProductRepositoryImpl(datasource: datasource);
  }

  /// Obtiene todos los productos de la tienda.
  ///
  /// Retorna [Right] con lista de [Product] si es exitoso.
  /// Retorna [Left] con [FakeStoreFailure] si hay error.
  ///
  /// ## Ejemplo
  ///
  /// ```dart
  /// final result = await client.getProducts();
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (products) {
  ///     for (final product in products) {
  ///       print('${product.title}: \$${product.price}');
  ///     }
  ///   },
  /// );
  /// ```
  Future<Either<FakeStoreFailure, List<Product>>> getProducts() {
    return _repository.getAllProducts();
  }

  /// Obtiene un producto específico por su ID.
  ///
  /// [id] debe ser un entero positivo.
  ///
  /// Retorna [Right] con [Product] si es exitoso.
  /// Retorna [Left] con [NotFoundFailure] si el producto no existe.
  /// Retorna [Left] con otro [FakeStoreFailure] si hay otro error.
  ///
  /// ## Ejemplo
  ///
  /// ```dart
  /// final result = await client.getProductById(1);
  /// result.fold(
  ///   (failure) {
  ///     if (failure is NotFoundFailure) {
  ///       print('El producto no existe');
  ///     } else {
  ///       print('Error: ${failure.message}');
  ///     }
  ///   },
  ///   (product) => print('Encontrado: ${product.title}'),
  /// );
  /// ```
  Future<Either<FakeStoreFailure, Product>> getProductById(int id) {
    return _repository.getProductById(id);
  }

  /// Obtiene todas las categorías disponibles.
  ///
  /// Retorna [Right] con lista de nombres de categorías.
  /// Retorna [Left] con [FakeStoreFailure] si hay error.
  ///
  /// ## Ejemplo
  ///
  /// ```dart
  /// final result = await client.getCategories();
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (categories) {
  ///     print('Categorías disponibles:');
  ///     for (final category in categories) {
  ///       print('- $category');
  ///     }
  ///   },
  /// );
  /// ```
  Future<Either<FakeStoreFailure, List<String>>> getCategories() {
    return _repository.getAllCategories();
  }

  /// Obtiene productos de una categoría específica.
  ///
  /// [category] es el nombre exacto de la categoría.
  /// Los nombres de categoría son case-sensitive.
  ///
  /// Retorna [Right] con lista de [Product] filtrados.
  /// Retorna [Left] con [FakeStoreFailure] si hay error.
  ///
  /// ## Ejemplo
  ///
  /// ```dart
  /// final result = await client.getProductsByCategory('electronics');
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (products) {
  ///     print('Productos en electronics:');
  ///     for (final product in products) {
  ///       print('- ${product.title}');
  ///     }
  ///   },
  /// );
  /// ```
  Future<Either<FakeStoreFailure, List<Product>>> getProductsByCategory(
    String category,
  ) {
    return _repository.getProductsByCategory(category);
  }

  /// Libera recursos del cliente.
  ///
  /// Debe llamarse cuando ya no se necesite el cliente
  /// para liberar conexiones HTTP.
  ///
  /// ## Ejemplo
  ///
  /// ```dart
  /// final client = FakeStoreClient();
  /// try {
  ///   // usar el cliente...
  /// } finally {
  ///   client.dispose();
  /// }
  /// ```
  void dispose() {
    _httpClient.close();
  }
}
