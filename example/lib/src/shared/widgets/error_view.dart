import 'package:fake_store_design_system/fake_store_design_system.dart';
import 'package:flutter/material.dart';

/// Vista de error con opción de reintentar.
///
/// Utiliza [DSErrorState] del sistema de diseño para mantener
/// consistencia visual en toda la aplicación.
class ErrorView extends StatelessWidget {
  /// Mensaje de error a mostrar.
  final String message;

  /// Callback al presionar el botón de reintentar.
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return DSErrorState(
      message: 'Ocurrió un error',
      details: message,
      onRetry: onRetry,
      retryText: 'Reintentar',
    );
  }
}
