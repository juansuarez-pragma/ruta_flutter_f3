import 'package:fake_store_api_client/src/presentation/contracts/menu_option.dart';

/// Contrato para entrada de datos del usuario.
///
/// Define los métodos necesarios para obtener input del usuario,
/// independientemente de la plataforma (consola, GUI, web, etc.).
abstract class UserInput {
  /// Muestra el menú principal y retorna la opción seleccionada.
  ///
  /// Retorna un [MenuOption] que representa la acción elegida.
  Future<MenuOption> showMainMenu();

  /// Solicita al usuario que ingrese un ID de producto.
  ///
  /// Retorna el ID como [int], o `null` si el usuario cancela
  /// o ingresa un valor inválido.
  Future<int?> promptProductId();

  /// Solicita al usuario que seleccione una categoría de la lista.
  ///
  /// [categories] es la lista de categorías disponibles.
  /// Retorna la categoría seleccionada, o `null` si el usuario
  /// cancela o selecciona una opción inválida.
  Future<String?> promptCategory(List<String> categories);
}
