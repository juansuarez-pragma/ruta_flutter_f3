/// Cliente Flutter para la Fake Store API.
///
/// Este paquete proporciona un cliente completo para interactuar con
/// la [Fake Store API](https://fakestoreapi.com/), implementando el
/// patrón Ports & Adapters (Arquitectura Hexagonal).
///
/// ## Características
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
/// import 'package:http/http.dart' as http;
///
/// void main() async {
///   // Crear infraestructura
///   final datasource = FakeStoreDatasource(
///     apiClient: ApiClientImpl(
///       client: http.Client(),
///       baseUrl: 'https://fakestoreapi.com',
///       timeout: Duration(seconds: 30),
///       responseHandler: HttpResponseHandler(),
///     ),
///   );
///   final repository = ProductRepositoryImpl(datasource: datasource);
///
///   // Usar el repositorio directamente
///   final result = await repository.getAllProducts();
///   result.fold(
///     (failure) => print('Error: ${failure.message}'),
///     (products) => print('Se encontraron ${products.length} productos'),
///   );
/// }
/// ```
///
/// ## Patrón Ports & Adapters
///
/// Para aplicaciones con UI, use [ApplicationController] con una
/// implementación de [UserInterface]:
///
/// ```dart
/// final controller = ApplicationController(
///   ui: MiUserInterface(), // Tu implementación
///   repository: repository,
/// );
///
/// await controller.executeOption(MenuOption.getAllProducts);
/// ```
///
/// ## Manejo de errores
///
/// Todos los métodos retornan `Either<FakeStoreFailure, T>`.
/// Esto permite un manejo funcional de errores:
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

// API Pública - Either (tipo propio)
export 'src/core/either/either.dart';

// API Pública - Entidades del dominio
export 'src/domain/entities/entities.dart';

// API Pública - Failures
export 'src/domain/failures/failures.dart';

// API Pública - Presentación (Ports & Adapters)
export 'src/presentation/presentation.dart';

// API Pública - Repositorio (para inyección)
export 'src/domain/repositories/repositories.dart';

// API Pública - Data sources (para inyección de dependencias)
export 'src/data/datasources/datasources.dart';

// API Pública - Implementaciones de repositorios (para inyección)
export 'src/data/repositories/repositories.dart';

// API Pública - Network (para inyección de dependencias avanzada)
export 'src/core/network/network.dart';

// API Pública - Constantes y strings
export 'src/core/constants/app_strings.dart';
