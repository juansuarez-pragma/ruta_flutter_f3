/// Cliente Flutter para la Fake Store API.
///
/// Este paquete proporciona un cliente simple para interactuar con
/// la [Fake Store API](https://fakestoreapi.com/).
///
/// ## Uso
///
/// ```dart
/// import 'package:fake_store_api_client/fake_store_api_client.dart';
///
/// void main() async {
///   // Crear el repositorio (una sola línea)
///   final repository = FakeStoreApi.createRepository();
///
///   // Obtener todos los productos
///   final result = await repository.getAllProducts();
///
///   result.fold(
///     (failure) => print('Error: ${failure.message}'),
///     (products) => print('Productos: ${products.length}'),
///   );
/// }
/// ```
///
/// ## Timeout personalizado
///
/// ```dart
/// final repository = FakeStoreApi.createRepository(
///   timeout: Duration(seconds: 60),
/// );
/// ```
///
/// ## Métodos disponibles
///
/// ```dart
/// repository.getAllProducts();
/// repository.getProductById(1);
/// repository.getAllCategories();
/// repository.getProductsByCategory('electronics');
/// ```
///
/// ## Manejo de errores
///
/// Todos los métodos retornan `Either<FakeStoreFailure, T>`:
///
/// ```dart
/// final result = await repository.getProductById(1);
///
/// // Opción 1: fold
/// result.fold(
///   (failure) => handleError(failure),
///   (product) => showProduct(product),
/// );
///
/// // Opción 2: pattern matching
/// switch (result) {
///   case Left(value: final failure):
///     handleError(failure);
///   case Right(value: final product):
///     showProduct(product);
/// }
/// ```
///
/// ## Tipos de errores
///
/// - [ConnectionFailure]: Sin conexión a internet
/// - [ServerFailure]: Error del servidor (5xx)
/// - [NotFoundFailure]: Recurso no encontrado (404)
/// - [InvalidRequestFailure]: Solicitud inválida (4xx)
library;

// ============================================================================
// API PÚBLICA - Solo se exporta lo necesario para consumir la librería
// ============================================================================

// Punto de entrada principal - Factory para crear el repositorio
export 'src/fake_store_api.dart' show FakeStoreApi;

// Tipo Either para manejo funcional de errores
export 'src/core/either/either.dart' show Either, Left, Right;

// Entidades del dominio (datos que retorna la API)
export 'src/domain/entities/product.dart' show Product;
export 'src/domain/entities/product_rating.dart' show ProductRating;

// Failures (tipos de error que pueden ocurrir)
export 'src/domain/failures/fake_store_failure.dart'
    show
        FakeStoreFailure,
        ConnectionFailure,
        ServerFailure,
        NotFoundFailure,
        InvalidRequestFailure;

// Contrato del repositorio (para tipado e inyección de dependencias)
export 'src/domain/repositories/product_repository.dart' show ProductRepository;
