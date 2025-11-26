import '../../core/constants/constants.dart';
import '../models/models.dart';
import 'api_client.dart';

/// DataSource para la Fake Store API.
///
/// Encapsula las llamadas HTTP específicas para los endpoints
/// de la Fake Store API.
class FakeStoreDatasource {
  final ApiClient _apiClient;

  /// Crea una nueva instancia de [FakeStoreDatasource].
  ///
  /// [apiClient] es el cliente HTTP genérico a usar.
  FakeStoreDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Obtiene todos los productos de la API.
  ///
  /// Retorna una lista de [ProductModel].
  /// Lanza excepciones si hay errores de red o del servidor.
  Future<List<ProductModel>> getProducts() {
    return _apiClient.getList(
      endpoint: ApiEndpoints.products,
      fromJsonList: ProductModel.fromJson,
    );
  }

  /// Obtiene un producto específico por su ID.
  ///
  /// [id] es el identificador único del producto.
  ///
  /// Retorna un [ProductModel].
  /// Lanza [NotFoundException] si el producto no existe.
  Future<ProductModel> getProductById(int id) {
    return _apiClient.get(
      endpoint: ApiEndpoints.productById(id),
      fromJson: (json) => ProductModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Obtiene todas las categorías disponibles.
  ///
  /// Retorna una lista de nombres de categorías.
  Future<List<String>> getCategories() {
    return _apiClient.getPrimitiveList<String>(
      endpoint: ApiEndpoints.categories,
    );
  }

  /// Obtiene productos de una categoría específica.
  ///
  /// [category] es el nombre exacto de la categoría.
  ///
  /// Retorna una lista de [ProductModel] filtrados.
  Future<List<ProductModel>> getProductsByCategory(String category) {
    return _apiClient.getList(
      endpoint: ApiEndpoints.productsByCategory(category),
      fromJsonList: ProductModel.fromJson,
    );
  }
}
