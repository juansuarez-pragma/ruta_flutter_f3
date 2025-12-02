import 'package:fake_store_api_client/src/presentation/contracts/category_output.dart';
import 'package:fake_store_api_client/src/presentation/contracts/message_output.dart';
import 'package:fake_store_api_client/src/presentation/contracts/product_output.dart';
import 'package:fake_store_api_client/src/presentation/contracts/user_input.dart';

/// Interfaz compuesta que define el contrato completo de UI.
///
/// Combina todas las interfaces de entrada/salida aplicando el
/// Interface Segregation Principle (ISP). Esto permite:
///
/// - Intercambiar implementaciones de UI (consola, Flutter, web)
/// - Testear con mocks sin implementación real
/// - Que cada componente implemente solo lo que necesita
///
/// ## Ejemplo de implementación
///
/// ```dart
/// class FlutterUserInterface implements UserInterface {
///   @override
///   Future<MenuOption> showMainMenu() async {
///     // Mostrar menú con widgets Flutter
///   }
///
///   @override
///   void showProducts(List<Product> products) {
///     // Mostrar en ListView
///   }
///   // ... implementar demás métodos
/// }
/// ```
///
/// ## Patrón Ports & Adapters
///
/// Esta interfaz actúa como un "Port" en la arquitectura hexagonal.
/// Las implementaciones concretas (ConsoleUI, FlutterUI, WebUI) son
/// los "Adapters" que conectan el core de la aplicación con el mundo exterior.
abstract class UserInterface
    implements UserInput, MessageOutput, ProductOutput, CategoryOutput {}
