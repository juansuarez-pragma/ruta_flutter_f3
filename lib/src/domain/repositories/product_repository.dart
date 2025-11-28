import '../../core/either/either.dart';
import '../entities/entities.dart';
import '../failures/failures.dart';

/// Contrato para el repositorio de productos.
///
/// Define las operaciones disponibles para acceder a los productos
/// de la Fake Store API.
///
/// Esta interfaz sigue el principio de inversión de dependencias (DIP):
/// la capa de dominio define el contrato, y la capa de datos lo implementa.
///
/// Todas las operaciones retornan [Either] para manejo funcional de errores:
/// - [Left] contiene un [FakeStoreFailure] si ocurre un error
/// - [Right] contiene el resultado exitoso
abstract class ProductRepository {
  /// Obtiene todos los productos de la tienda.
  ///
  /// Retorna una lista de [Product] si es exitoso.
  /// Retorna [FakeStoreFailure] si hay un error.
  Future<Either<FakeStoreFailure, List<Product>>> getAllProducts();

  /// Obtiene un producto específico por su ID.
  ///
  /// [id] es el identificador único del producto (entero positivo).
  ///
  /// Retorna el [Product] si es encontrado.
  /// Retorna [NotFoundFailure] si el producto no existe.
  /// Retorna otro [FakeStoreFailure] si hay otro tipo de error.
  Future<Either<FakeStoreFailure, Product>> getProductById(int id);

  /// Obtiene todas las categorías disponibles.
  ///
  /// Retorna una lista de nombres de categorías como [String].
  /// Retorna [FakeStoreFailure] si hay un error.
  Future<Either<FakeStoreFailure, List<String>>> getAllCategories();

  /// Obtiene productos de una categoría específica.
  ///
  /// [category] es el nombre exacto de la categoría (case-sensitive).
  ///
  /// Retorna una lista de [Product] filtrados por categoría.
  /// Retorna [FakeStoreFailure] si hay un error.
  Future<Either<FakeStoreFailure, List<Product>>> getProductsByCategory(
    String category,
  );
}
