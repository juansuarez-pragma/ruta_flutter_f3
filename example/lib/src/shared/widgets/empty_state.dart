import 'package:fake_store_design_system/fake_store_design_system.dart';
import 'package:flutter/material.dart';

/// Vista de estado vacío.
///
/// Utiliza [DSEmptyState] del sistema de diseño para mantener
/// consistencia visual en toda la aplicación.
class EmptyState extends StatelessWidget {
  /// Mensaje a mostrar.
  final String message;

  /// Ícono a mostrar.
  final IconData icon;

  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return DSEmptyState(
      icon: icon,
      title: message,
    );
  }
}
