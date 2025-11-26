import 'package:fake_store_design_system/fake_store_design_system.dart';
import 'package:flutter/material.dart';

/// Chip de categoría para la pantalla principal.
///
/// Utiliza [DSFilterChip] del sistema de diseño para mantener
/// consistencia visual en toda la aplicación.
class CategoryChip extends StatelessWidget {
  /// Nombre de la categoría.
  final String category;

  /// Si está seleccionada.
  final bool isSelected;

  /// Callback al presionar.
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: DSSpacing.sm),
      child: DSFilterChip(
        label: _formatCategory(category),
        isSelected: isSelected,
        onTap: onTap,
      ),
    );
  }

  /// Formatea el nombre de la categoría (primera letra mayúscula).
  String _formatCategory(String category) {
    if (category.isEmpty) return category;
    return category[0].toUpperCase() + category.substring(1);
  }
}
