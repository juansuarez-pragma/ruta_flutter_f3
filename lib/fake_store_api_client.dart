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
///
/// void main() async {
///   // Crear el repositorio (única línea necesaria)
///   final repository = FakeStoreApi.createRepository();
///
///   // Usar el repositorio
///   final result = await repository.getAllProducts();
///   result.fold(
///     (failure) => print('Error: ${failure.message}'),
///     (products) => print('Se encontraron ${products.length} productos'),
///   );
/// }
/// ```
///
/// ## Configuración personalizada
///
/// ```dart
/// final repository = FakeStoreApi.createRepository(
///   baseUrl: 'https://mi-api.com',
///   timeout: Duration(seconds: 60),
/// );
/// ```
///
/// ## Patrón Ports & Adapters
///
/// Para aplicaciones con UI, use [FakeStoreApi.createController]:
///
/// ```dart
/// final controller = FakeStoreApi.createController(
///   ui: MiUserInterface(), // Tu implementación de UserInterface
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

// ============================================================================
// API PÚBLICA - Solo se exporta lo necesario para consumir la librería
// ============================================================================

// Punto de entrada principal - Factory para crear repositorio y controlador
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

// Patrón Ports & Adapters (para aplicaciones con UI)
export 'src/presentation/controller/application_controller.dart'
    show ApplicationController;
export 'src/presentation/contracts/user_interface.dart' show UserInterface;
export 'src/presentation/contracts/menu_option.dart' show MenuOption;

// Textos centralizados para UI
export 'src/core/constants/app_strings.dart' show AppStrings;
