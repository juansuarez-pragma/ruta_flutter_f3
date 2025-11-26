import 'package:fake_store_design_system/fake_store_design_system.dart';
import 'package:flutter/material.dart';

/// Tema de la aplicación.
///
/// Esta clase actúa como puente entre la aplicación y el sistema de diseño,
/// delegando la configuración de temas a [FakeStoreTheme].
class AppTheme {
  AppTheme._();

  /// Tema claro de la aplicación.
  static ThemeData get lightTheme => FakeStoreTheme.light();

  /// Tema oscuro de la aplicación.
  static ThemeData get darkTheme => FakeStoreTheme.dark();

  /// Obtiene los tokens del sistema de diseño desde el contexto.
  static DSThemeData tokens(BuildContext context) => FakeStoreTheme.of(context);
}
