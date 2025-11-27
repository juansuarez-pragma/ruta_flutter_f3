import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Aplicación de ejemplo que demuestra el uso del paquete fake_store_api_client.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fake Store API Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ProductsPage(),
    );
  }
}

/// Página principal que muestra los productos de la API.
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  /// Cliente del paquete fake_store_api_client.
  final _client = FakeStoreClient();

  /// Future que contiene los productos.
  late Future<Either<FakeStoreFailure, List<Product>>> _productsFuture;

  /// Categorías disponibles.
  List<String> _categories = [];

  /// Categoría seleccionada (null = todas).
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProducts();
  }

  @override
  void dispose() {
    _client.dispose();
    super.dispose();
  }

  /// Carga las categorías usando el cliente.
  Future<void> _loadCategories() async {
    final result = await _client.getCategories();
    result.fold(
      (failure) => debugPrint('Error cargando categorías: ${failure.message}'),
      (categories) => setState(() => _categories = categories),
    );
  }

  /// Carga los productos usando el cliente.
  void _loadProducts() {
    setState(() {
      _productsFuture = _selectedCategory != null
          ? _client.getProductsByCategory(_selectedCategory!)
          : _client.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Store'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Filtro de categorías
          _buildCategoryFilter(),
          // Lista de productos
          Expanded(child: _buildProductList()),
        ],
      ),
    );
  }

  /// Construye el filtro de categorías.
  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          FilterChip(
            label: const Text('Todos'),
            selected: _selectedCategory == null,
            onSelected: (_) {
              setState(() => _selectedCategory = null);
              _loadProducts();
            },
          ),
          const SizedBox(width: 8),
          ..._categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: _selectedCategory == category,
                onSelected: (_) {
                  setState(() => _selectedCategory = category);
                  _loadProducts();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la lista de productos usando FutureBuilder.
  Widget _buildProductList() {
    return FutureBuilder<Either<FakeStoreFailure, List<Product>>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        // Estado de carga
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error de conexión
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Sin datos
        if (!snapshot.hasData) {
          return const Center(child: Text('No hay datos'));
        }

        // Procesar resultado Either
        return snapshot.data!.fold(
          // Error del API (Left)
          (failure) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${failure.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadProducts,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
          // Éxito (Right)
          (products) => GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) => _ProductCard(
              product: products[index],
              onTap: () => _showProductDetail(products[index]),
            ),
          ),
        );
      },
    );
  }

  /// Muestra el detalle de un producto.
  void _showProductDetail(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }
}

/// Tarjeta de producto.
class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 48),
                ),
              ),
            ),
            // Información
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
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

/// Página de detalle de producto.
class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Image.network(product.image, fit: BoxFit.contain),
            ),
            // Contenido
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoría
                  Chip(label: Text(product.category)),
                  const SizedBox(height: 8),
                  // Título
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  // Precio y rating
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text('${product.rating.rate} (${product.rating.count})'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Descripción
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(product.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
