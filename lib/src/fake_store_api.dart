import 'package:http/http.dart' as http;

import 'package:fake_store_api_client/src/core/network/http_response_handler.dart';
import 'package:fake_store_api_client/src/data/datasources/api_client_impl.dart';
import 'package:fake_store_api_client/src/data/datasources/fake_store_datasource.dart';
import 'package:fake_store_api_client/src/data/repositories/product_repository_impl.dart';
import 'package:fake_store_api_client/src/domain/repositories/product_repository.dart';

/// Esta librería está diseñada para conectarse a
/// [Fake Store API](https://fakestoreapi.com/).
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
/// ## Con timeout personalizado
///
/// ```dart
/// final repository = FakeStoreApi.createRepository(
///   timeout: Duration(seconds: 60),
/// );
/// ```
abstract final class FakeStoreApi {
  /// URL de la Fake Store API.
  static const String _baseUrl = 'https://fakestoreapi.com';

  /// Timeout por defecto para las solicitudes HTTP.
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Crea una instancia de [ProductRepository] lista para usar.
  ///
  /// [timeout] es el tiempo máximo de espera para las solicitudes HTTP.
  /// [httpClient] permite inyectar un cliente HTTP personalizado
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
    Duration timeout = defaultTimeout,
    http.Client? httpClient,
  }) {
    final client = httpClient ?? http.Client();
    final responseHandler = HttpResponseHandler();
    final apiClient = ApiClientImpl(
      client: client,
      baseUrl: _baseUrl,
      timeout: timeout,
      responseHandler: responseHandler,
    );
    final datasource = FakeStoreDatasource(apiClient: apiClient);
    return ProductRepositoryImpl(datasource: datasource);
  }
}
