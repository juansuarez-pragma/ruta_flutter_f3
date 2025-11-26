import 'package:flutter/material.dart';

/// Chip de categoría para la pantalla principal.
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
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(_formatCategory(category)),
        selected: isSelected,
        onSelected: (_) => onTap?.call(),
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        checkmarkColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  /// Formatea el nombre de la categoría (primera letra mayúscula).
  String _formatCategory(String category) {
    if (category.isEmpty) return category;
    return category[0].toUpperCase() + category.substring(1);
  }
}
