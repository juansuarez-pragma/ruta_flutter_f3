import 'package:fake_store_api_client/src/domain/repositories/product_repository.dart';
import 'package:fake_store_api_client/src/presentation/contracts/contracts.dart';

/// Controlador principal que coordina la interacción entre la UI y el repositorio.
///
/// Esta clase actúa como el punto de entrada de la aplicación, orquestando
/// el flujo sin conocer los detalles de implementación de la UI.
///
/// ## Patrón Ports & Adapters
///
/// El controlador depende de abstracciones ([UserInterface], [ProductRepository]),
/// no de implementaciones concretas. Esto permite:
///
/// - Cambiar la UI sin modificar la lógica
/// - Testear con mocks
/// - Reutilizar en diferentes plataformas
///
/// ## Ejemplo de uso
///
/// ```dart
/// final controller = ApplicationController(
///   ui: FlutterUserInterface(),
///   repository: ProductRepositoryImpl(datasource: datasource),
/// );
///
/// await controller.run();
/// ```
class ApplicationController {
  final UserInterface _ui;
  final ProductRepository _repository;
  final void Function()? _onExit;

  /// Crea una nueva instancia del controlador.
  ///
  /// [ui] es la implementación de la interfaz de usuario.
  /// [repository] es el repositorio para acceder a los datos.
  /// [onExit] es un callback opcional que se ejecuta al salir.
  ApplicationController({
    required UserInterface ui,
    required ProductRepository repository,
    void Function()? onExit,
  }) : _ui = ui,
       _repository = repository,
       _onExit = onExit;

  /// Inicia el bucle principal de la aplicación.
  ///
  /// Muestra el menú y procesa las opciones hasta que el usuario
  /// seleccione salir.
  Future<void> run() async {
    _ui.showWelcome('Bienvenido a Fake Store');

    MenuOption option;
    do {
      option = await _ui.showMainMenu();

      switch (option) {
        case MenuOption.getAllProducts:
          await _handleGetAllProducts();
        case MenuOption.getProductById:
          await _handleGetProductById();
        case MenuOption.getAllCategories:
          await _handleGetAllCategories();
        case MenuOption.getProductsByCategory:
          await _handleGetProductsByCategory();
        case MenuOption.exit:
          break;
        case MenuOption.invalid:
          _ui.showError('Opción inválida. Intenta de nuevo.');
      }
    } while (option != MenuOption.exit);

    _ui.showGoodbye();
    _onExit?.call();
  }

  /// Ejecuta una sola operación sin bucle.
  ///
  /// Útil para interfaces que no usan un menú tradicional (ej: Flutter).
  Future<void> executeOption(MenuOption option) async {
    switch (option) {
      case MenuOption.getAllProducts:
        await _handleGetAllProducts();
      case MenuOption.getProductById:
        await _handleGetProductById();
      case MenuOption.getAllCategories:
        await _handleGetAllCategories();
      case MenuOption.getProductsByCategory:
        await _handleGetProductsByCategory();
      case MenuOption.exit:
        _onExit?.call();
      case MenuOption.invalid:
        _ui.showError('Opción inválida.');
    }
  }

  Future<void> _handleGetAllProducts() async {
    _ui.showLoading('Obteniendo productos...');

    final result = await _repository.getAllProducts();

    result.fold(
      (failure) => _ui.showError(failure.message),
      (products) => _ui.showProducts(products),
    );
  }

  Future<void> _handleGetProductById() async {
    final id = await _ui.promptProductId();

    if (id == null) {
      _ui.showError('ID inválido.');
      return;
    }

    _ui.showLoading('Obteniendo producto #$id...');

    final result = await _repository.getProductById(id);

    result.fold(
      (failure) => _ui.showError(failure.message),
      (product) => _ui.showProduct(product),
    );
  }

  Future<void> _handleGetAllCategories() async {
    _ui.showLoading('Obteniendo categorías...');

    final result = await _repository.getAllCategories();

    result.fold(
      (failure) => _ui.showError(failure.message),
      (categories) => _ui.showCategories(categories),
    );
  }

  Future<void> _handleGetProductsByCategory() async {
    // Primero obtener categorías disponibles
    final categoriesResult = await _repository.getAllCategories();

    final categories = categoriesResult.fold((failure) {
      _ui.showError(failure.message);
      return <String>[];
    }, (cats) => cats);

    if (categories.isEmpty) return;

    final selectedCategory = await _ui.promptCategory(categories);

    if (selectedCategory == null) {
      _ui.showError('Categoría inválida.');
      return;
    }

    _ui.showLoading('Obteniendo productos de "$selectedCategory"...');

    final result = await _repository.getProductsByCategory(selectedCategory);

    result.fold(
      (failure) => _ui.showError(failure.message),
      (products) => _ui.showProducts(products),
    );
  }
}
