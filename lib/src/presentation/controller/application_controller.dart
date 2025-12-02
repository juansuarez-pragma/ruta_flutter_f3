import 'package:fake_store_api_client/src/core/constants/app_strings.dart';
import 'package:fake_store_api_client/src/domain/repositories/product_repository.dart';
import 'package:fake_store_api_client/src/presentation/contracts/contracts.dart';

/// Controlador principal que coordina la interacción entre la UI y el repositorio.
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
/// await controller.executeOption(MenuOption.getAllProducts);
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

  /// Ejecuta una operación específica.
  ///
  /// Este método permite ejecutar operaciones individuales sin necesidad
  /// de un bucle de menú, ideal para interfaces gráficas como Flutter.
  ///
  /// ```dart
  /// // Obtener todos los productos
  /// await controller.executeOption(MenuOption.getAllProducts);
  ///
  /// // Obtener producto por ID (requiere implementar promptProductId)
  /// await controller.executeOption(MenuOption.getProductById);
  /// ```
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
    }
  }

  Future<void> _handleGetAllProducts() async {
    _ui.showLoading(AppStrings.loadingProducts);

    final result = await _repository.getAllProducts();

    result.fold(
      (failure) => _ui.showError(failure.message),
      (products) => _ui.showProducts(products),
    );
  }

  Future<void> _handleGetProductById() async {
    final id = await _ui.promptProductId();

    if (id == null) {
      _ui.showError(AppStrings.invalidIdError);
      return;
    }

    _ui.showLoading(AppStrings.loadingProductById(id));

    final result = await _repository.getProductById(id);

    result.fold(
      (failure) => _ui.showError(failure.message),
      (product) => _ui.showProduct(product),
    );
  }

  Future<void> _handleGetAllCategories() async {
    _ui.showLoading(AppStrings.loadingCategories);

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
      _ui.showError(AppStrings.invalidCategoryError);
      return;
    }

    _ui.showLoading(AppStrings.loadingProductsByCategory(selectedCategory));

    final result = await _repository.getProductsByCategory(selectedCategory);

    result.fold(
      (failure) => _ui.showError(failure.message),
      (products) => _ui.showProducts(products),
    );
  }
}
