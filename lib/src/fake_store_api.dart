import 'package:http/http.dart' as http;

import 'package:fake_store_api_client/src/core/network/http_response_handler.dart';
import 'package:fake_store_api_client/src/data/datasources/api_client_impl.dart';
import 'package:fake_store_api_client/src/data/datasources/fake_store_datasource.dart';
import 'package:fake_store_api_client/src/data/repositories/product_repository_impl.dart';
import 'package:fake_store_api_client/src/domain/repositories/product_repository.dart';

/// Punto de entrada principal para usar la Fake Store API.
///
/// Esta clase proporciona un factory para crear una instancia configurada
/// del repositorio, ocultando los detalles de implementación.
///
/// ## Uso básico
///
/// ```dart
/// import 'package:fake_store_api_client/fake_store_api_client.dart';
///
/// // Obtener el repositorio listo para usar
/// final repository = FakeStoreApi.createRepository();
///
/// // Usar el repositorio
/// final result = await repository.getAllProducts();
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (products) => print('Productos: ${products.length}'),
/// );
/// ```
///
/// ## Con configuración personalizada
///
/// ```dart
/// final repository = FakeStoreApi.createRepository(
///   baseUrl: 'https://mi-api.com',
///   timeout: Duration(seconds: 60),
/// );
/// ```
abstract final class FakeStoreApi {
  /// URL base por defecto de la Fake Store API.
  static const String defaultBaseUrl = 'https://fakestoreapi.com';

  /// Timeout por defecto para las solicitudes HTTP.
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Crea una instancia de [ProductRepository] lista para usar.
  ///
  /// [baseUrl] es la URL base de la API. Por defecto usa la Fake Store API.
  /// [timeout] es el tiempo máximo de espera para las solicitudes HTTP.
  /// [httpClient] permite inyectar un cliente HTTP personalizado (útil para testing).
  ///
  /// ## Ejemplo
  ///
  /// ```dart
  /// final repository = FakeStoreApi.createRepository();
  ///
  /// // Obtener todos los productos
  /// final products = await repository.getAllProducts();
  ///
  /// // Obtener un producto por ID
  /// final product = await repository.getProductById(1);
  ///
  /// // Obtener todas las categorías
  /// final categories = await repository.getAllCategories();
  ///
  /// // Obtener productos por categoría
  /// final electronics = await repository.getProductsByCategory('electronics');
  /// ```
  static ProductRepository createRepository({
    String baseUrl = defaultBaseUrl,
    Duration timeout = defaultTimeout,
    http.Client? httpClient,
  }) {
    final client = httpClient ?? http.Client();
    final responseHandler = HttpResponseHandler();
    final apiClient = ApiClientImpl(
      client: client,
      baseUrl: baseUrl,
      timeout: timeout,
      responseHandler: responseHandler,
    );
    final datasource = FakeStoreDatasource(apiClient: apiClient);
    return ProductRepositoryImpl(datasource: datasource);
  }
}
