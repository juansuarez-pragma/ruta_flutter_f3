import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Implementación de [UserInterface] para Flutter.
///
/// Esta clase actúa como un adapter entre el [ApplicationController]
/// y los widgets de Flutter. Usa callbacks para comunicar eventos
/// a la capa de UI.
///
/// ## Patrón Ports & Adapters
///
/// Este adapter permite que la misma lógica de negocio (ApplicationController)
/// funcione tanto en consola como en Flutter, demostrando la separación
/// de responsabilidades.
///
/// ## Ejemplo de uso
///
/// ```dart
/// final ui = FlutterUserInterface(
///   onShowProducts: (products) => setState(() => _products = products),
///   onShowError: (message) => _showSnackBar(message),
///   onShowLoading: (message) => setState(() => _isLoading = true),
/// );
///
/// final controller = ApplicationController(
///   ui: ui,
///   repository: repository,
/// );
///
/// await controller.executeOption(MenuOption.getAllProducts);
/// ```
class FlutterUserInterface implements UserInterface {
  /// Callback para mostrar mensaje de bienvenida.
  final void Function(String message)? onShowWelcome;

  /// Callback para mostrar mensaje de despedida.
  final void Function()? onShowGoodbye;

  /// Callback para mostrar estado de carga.
  final void Function(String message)? onShowLoading;

  /// Callback para mostrar un error.
  final void Function(String message)? onShowError;

  /// Callback para mostrar un mensaje de éxito.
  final void Function(String message)? onShowSuccess;

  /// Callback para mostrar la lista de productos.
  final void Function(List<Product> products)? onShowProducts;

  /// Callback para mostrar un producto individual.
  final void Function(Product product)? onShowProduct;

  /// Callback para mostrar las categorías.
  final void Function(List<String> categories)? onShowCategories;

  /// Callback para solicitar el menú principal.
  /// Retorna un Future con la opción seleccionada.
  final Future<MenuOption> Function()? onShowMainMenu;

  /// Callback para solicitar un ID de producto.
  /// Retorna un Future con el ID o null si es inválido.
  final Future<int?> Function()? onPromptProductId;

  /// Callback para solicitar selección de categoría.
  /// Retorna un Future con la categoría seleccionada o null.
  final Future<String?> Function(List<String> categories)? onPromptCategory;

  /// Crea una nueva instancia de [FlutterUserInterface].
  ///
  /// Todos los callbacks son opcionales. Si no se proporciona un callback,
  /// la operación correspondiente no tendrá efecto.
  FlutterUserInterface({
    this.onShowWelcome,
    this.onShowGoodbye,
    this.onShowLoading,
    this.onShowError,
    this.onShowSuccess,
    this.onShowProducts,
    this.onShowProduct,
    this.onShowCategories,
    this.onShowMainMenu,
    this.onPromptProductId,
    this.onPromptCategory,
  });

  // ─────────────────────────────────────────────────────────────────────────
  // MessageOutput
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void showWelcome(String message) {
    onShowWelcome?.call(message);
  }

  @override
  void showGoodbye() {
    onShowGoodbye?.call();
  }

  @override
  void showLoading(String message) {
    onShowLoading?.call(message);
  }

  @override
  void showError(String message) {
    onShowError?.call(message);
  }

  /// Muestra un mensaje de éxito (método adicional de Flutter, no del contrato base).
  void showSuccess(String message) {
    onShowSuccess?.call(message);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ProductOutput
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void showProducts(List<Product> products) {
    onShowProducts?.call(products);
  }

  @override
  void showProduct(Product product) {
    onShowProduct?.call(product);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CategoryOutput
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void showCategories(List<String> categories) {
    onShowCategories?.call(categories);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // UserInput
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<MenuOption> showMainMenu() async {
    if (onShowMainMenu != null) {
      return onShowMainMenu!();
    }
    return MenuOption.exit;
  }

  @override
  Future<int?> promptProductId() async {
    if (onPromptProductId != null) {
      return onPromptProductId!();
    }
    return null;
  }

  @override
  Future<String?> promptCategory(List<String> availableCategories) async {
    if (onPromptCategory != null) {
      return onPromptCategory!(availableCategories);
    }
    return null;
  }
}
