import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';
import 'package:flutter/material.dart';

/// Grid de productos.
///
/// Utiliza [DSProductGrid] del sistema de diseño para mantener
/// consistencia visual en toda la aplicación.
class ProductGrid extends StatelessWidget {
  /// Lista de productos a mostrar.
  final List<Product> products;

  /// Callback al seleccionar un producto.
  final void Function(Product product)? onProductTap;

  const ProductGrid({
    super.key,
    required this.products,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return DSProductGrid<Product>(
      products: products,
      onProductTap: onProductTap,
      childAspectRatio: 0.55,
      crossAxisSpacing: DSSpacing.md,
      mainAxisSpacing: DSSpacing.md,
      padding: const EdgeInsets.all(DSSpacing.base),
    );
  }
}
