import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';
import 'package:flutter/material.dart';

/// Tarjeta de producto para mostrar en grid o lista.
///
/// Utiliza [DSProductCard] del sistema de diseño para mantener
/// consistencia visual en toda la aplicación.
class ProductCard extends StatelessWidget {
  /// Producto a mostrar.
  final Product product;

  /// Callback al presionar la tarjeta.
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DSProductCard(
      imageUrl: product.image,
      title: product.title,
      price: product.price,
      rating: product.rating.rate,
      reviewCount: product.rating.count,
      onTap: onTap,
    );
  }
}
