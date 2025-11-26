import 'package:cached_network_image/cached_network_image.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';
import 'package:flutter/material.dart';

/// Página de detalle de producto.
class ProductDetailPage extends StatelessWidget {
  /// Producto a mostrar.
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: tokens.colorSurfaceSecondary,
      appBar: const DSAppBar(
        title: 'Detalle del Producto',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Container(
              width: double.infinity,
              height: 300,
              color: tokens.colorSurfacePrimary,
              child: Hero(
                tag: 'product-${product.id}',
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Center(
                    child: DSCircularLoader(
                      color: tokens.colorBrandPrimary,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.image_not_supported_outlined,
                    size: DSSizes.iconXl,
                    color: tokens.colorIconSecondary,
                  ),
                ),
              ),
            ),
            // Contenido
            Padding(
              padding: const EdgeInsets.all(DSSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoría
                  DSBadge.info(
                    text: product.category.toUpperCase(),
                  ),
                  const SizedBox(height: DSSpacing.md),
                  // Título
                  DSText(
                    product.title,
                    variant: DSTextVariant.headingMedium,
                  ),
                  const SizedBox(height: DSSpacing.md),
                  // Rating y precio
                  Row(
                    children: [
                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DSSpacing.md,
                          vertical: DSSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: DSColors.warning100.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(DSBorderRadius.full),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: DSSizes.iconSm,
                              color: DSColors.warning500,
                            ),
                            const SizedBox(width: DSSpacing.xs),
                            DSText(
                              product.rating.rate.toStringAsFixed(1),
                              variant: DSTextVariant.labelLarge,
                            ),
                            DSText(
                              ' (${product.rating.count} reseñas)',
                              variant: DSTextVariant.labelSmall,
                              color: tokens.colorTextSecondary,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Precio
                      DSText(
                        '\$${product.price.toStringAsFixed(2)}',
                        variant: DSTextVariant.headingLarge,
                        color: tokens.colorBrandPrimary,
                      ),
                    ],
                  ),
                  const SizedBox(height: DSSpacing.xl),
                  // Descripción
                  DSText(
                    'Descripción',
                    variant: DSTextVariant.titleMedium,
                  ),
                  const SizedBox(height: DSSpacing.sm),
                  DSText(
                    product.description,
                    variant: DSTextVariant.bodyLarge,
                    color: tokens.colorTextSecondary,
                  ),
                  const SizedBox(height: DSSpacing.xxl),
                  // Botón de agregar al carrito
                  SizedBox(
                    width: double.infinity,
                    child: DSButton.primary(
                      text: 'Agregar al carrito',
                      icon: Icons.shopping_cart_outlined,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product.title} agregado al carrito',
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: tokens.colorFeedbackSuccess,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
