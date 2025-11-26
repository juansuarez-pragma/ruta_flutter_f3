import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../products/products.dart';
import '../widgets/category_chip.dart';

/// Página principal de la aplicación.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Either<FakeStoreFailure, List<String>>> _categoriesFuture;
  late Future<Either<FakeStoreFailure, List<Product>>> _productsFuture;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final client = InjectionContainer.client;
    _categoriesFuture = client.getCategories();
    _loadProducts();
  }

  void _loadProducts() {
    final client = InjectionContainer.client;
    _productsFuture = _selectedCategory != null
        ? client.getProductsByCategory(_selectedCategory!)
        : client.getProducts();
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
      _loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: tokens.colorSurfaceSecondary,
      appBar: DSAppBar(
        title: 'Fake Store',
        actions: [
          DSIconButton(
            icon: Icons.refresh,
            onPressed: () {
              setState(() {
                _selectedCategory = null;
                _loadData();
              });
            },
            tooltip: 'Recargar',
          ),
        ],
      ),
      body: Column(
        children: [
          // Categorías
          _buildCategoriesSection(),
          // Productos
          Expanded(
            child: _buildProductsSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final tokens = context.tokens;

    return FutureBuilder<Either<FakeStoreFailure, List<String>>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 60,
            child: Center(
              child: DSCircularLoader(
                size: DSLoaderSize.small,
                color: tokens.colorBrandPrimary,
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        return snapshot.data!.fold(
          (failure) => Padding(
            padding: const EdgeInsets.all(DSSpacing.base),
            child: DSText(
              'Error cargando categorías',
              variant: DSTextVariant.bodyMedium,
              color: tokens.colorFeedbackError,
            ),
          ),
          (categories) => Container(
            color: tokens.colorSurfacePrimary,
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: DSSpacing.base,
                vertical: DSSpacing.sm,
              ),
              children: [
                // Opción "Todos"
                CategoryChip(
                  category: 'Todos',
                  isSelected: _selectedCategory == null,
                  onTap: () => _onCategorySelected(null),
                ),
                // Categorías de la API
                ...categories.map(
                  (category) => CategoryChip(
                    category: category,
                    isSelected: _selectedCategory == category,
                    onTap: () => _onCategorySelected(category),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductsSection() {
    return FutureBuilder<Either<FakeStoreFailure, List<Product>>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator(
            message: 'Cargando productos...',
          );
        }

        if (snapshot.hasError) {
          return ErrorView(
            message: 'Error: ${snapshot.error}',
            onRetry: () {
              setState(() {
                _loadProducts();
              });
            },
          );
        }

        if (!snapshot.hasData) {
          return const EmptyState(message: 'No hay datos');
        }

        return snapshot.data!.fold(
          (failure) => ErrorView(
            message: failure.message,
            onRetry: () {
              setState(() {
                _loadProducts();
              });
            },
          ),
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
    );
  }
}
