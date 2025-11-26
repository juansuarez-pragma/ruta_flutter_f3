import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:flutter/material.dart';

import 'product_card.dart';

/// Grid de productos.
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
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => onProductTap?.call(product),
        );
      },
    );
  }
}
