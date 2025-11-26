import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../widgets/product_grid.dart';
import 'product_detail_page.dart';

/// Página de listado de productos.
class ProductsPage extends StatefulWidget {
  /// Categoría a filtrar (opcional).
  final String? category;

  const ProductsPage({super.key, this.category});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<Either<FakeStoreFailure, List<Product>>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    final client = InjectionContainer.client;
    _productsFuture = widget.category != null
        ? client.getProductsByCategory(widget.category!)
        : client.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category ?? 'Todos los Productos'),
      ),
      body: FutureBuilder<Either<FakeStoreFailure, List<Product>>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator(
              message: 'Cargando productos...',
            );
          }

          // Error de conexión
          if (snapshot.hasError) {
            return ErrorView(
              message: 'Error inesperado: ${snapshot.error}',
              onRetry: () {
                setState(() {
                  _loadProducts();
                });
              },
            );
          }

          // Sin datos
          if (!snapshot.hasData) {
            return const EmptyState(
              message: 'No hay datos disponibles',
            );
          }

          // Procesar resultado Either
          return snapshot.data!.fold(
            // Error del API
            (failure) => ErrorView(
              message: failure.message,
              onRetry: () {
                setState(() {
                  _loadProducts();
                });
              },
            ),
            // Éxito
            (products) {
              if (products.isEmpty) {
                return const EmptyState(
                  message: 'No se encontraron productos',
                  icon: Icons.shopping_bag_outlined,
                );
              }

              return ProductGrid(
                products: products,
                onProductTap: (product) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: product),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
