/// Cliente Flutter para la Fake Store API.
///
/// Este paquete proporciona un cliente completo para interactuar con
/// la [Fake Store API](https://fakestoreapi.com/), incluyendo:
///
/// - Obtener todos los productos
/// - Obtener un producto por ID
/// - Obtener todas las categorías
/// - Obtener productos por categoría
///
/// ## Inicio rápido
///
/// ```dart
/// import 'package:fake_store_api_client/fake_store_api_client.dart';
///
/// void main() async {
///   final client = FakeStoreClient();
///
///   // Obtener productos
///   final result = await client.getProducts();
///   result.fold(
///     (failure) => print('Error: ${failure.message}'),
///     (products) => print('Se encontraron ${products.length} productos'),
///   );
///
///   // Liberar recursos
///   client.dispose();
/// }
/// ```
///
/// ## Configuración personalizada
///
/// ```dart
/// final client = FakeStoreClient(
///   config: FakeStoreConfig(
///     baseUrl: 'https://fakestoreapi.com',
///     timeout: Duration(seconds: 60),
///   ),
/// );
/// ```
///
/// ## Manejo de errores
///
/// Todos los métodos retornan `Either<FakeStoreFailure, T>` del paquete
/// [dartz](https://pub.dev/packages/dartz). Esto permite un manejo
/// funcional de errores:
///
/// ```dart
/// final result = await client.getProductById(1);
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

// Re-exportar dartz para que los usuarios tengan acceso a Either
export 'package:dartz/dartz.dart' show Either, Left, Right;

// API Pública - Cliente
export 'src/client/client.dart';

// API Pública - Entidades del dominio
export 'src/domain/entities/entities.dart';

// API Pública - Failures
export 'src/domain/failures/failures.dart';
