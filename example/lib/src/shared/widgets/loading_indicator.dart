import 'package:fake_store_design_system/fake_store_design_system.dart';
import 'package:flutter/material.dart';

/// Indicador de carga centrado.
///
/// Utiliza [DSLoadingState] del sistema de diseño para mantener
/// consistencia visual en toda la aplicación.
class LoadingIndicator extends StatelessWidget {
  /// Mensaje opcional a mostrar debajo del indicador.
  final String? message;

  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return DSLoadingState(
      message: message,
    );
  }
}
