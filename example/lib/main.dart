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
  /// Repositorio para acceder a la API.
  late final ProductRepository _repository;

  /// Lista de productos cargados.
  List<Product> _products = [];

  /// Categorías disponibles.
  List<String> _categories = [];

  /// Categoría seleccionada (null = todas).
  String? _selectedCategory;

  /// Indica si está cargando.
  bool _isLoading = false;

  /// Mensaje de error actual.
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Crear el repositorio (una sola línea)
    _repository = FakeStoreApi.createRepository();
    _loadInitialData();
  }

  /// Carga los datos iniciales.
  Future<void> _loadInitialData() async {
    await _loadCategories();
    await _loadAllProducts();
  }

  /// Carga las categorías.
  Future<void> _loadCategories() async {
    final result = await _repository.getAllCategories();
    result.fold(
      (failure) => _showError(failure.message),
      (categories) => setState(() => _categories = categories),
    );
  }

  /// Carga todos los productos.
  Future<void> _loadAllProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedCategory = null;
    });

    final result = await _repository.getAllProducts();

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.message;
        });
        _showError(failure.message);
      },
      (products) {
        setState(() {
          _isLoading = false;
          _products = products;
        });
      },
    );
  }

  /// Carga productos por categoría.
  Future<void> _loadProductsByCategory(String category) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedCategory = category;
    });

    final result = await _repository.getProductsByCategory(category);

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.message;
        });
        _showError(failure.message);
      },
      (products) {
        setState(() {
          _isLoading = false;
          _products = products;
        });
      },
    );
  }

  /// Muestra un error en un SnackBar.
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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
          _buildCategoryFilter(),
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
            onSelected: (_) => _loadAllProducts(),
          ),
          const SizedBox(width: 8),
          ..._categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: _selectedCategory == category,
                onSelected: (_) => _loadProductsByCategory(category),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la lista de productos.
  Widget _buildProductList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_errorMessage'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAllProducts,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
      return const Center(child: Text('No hay productos'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) => _ProductCard(
        product: _products[index],
        onTap: () => _showProductDetail(_products[index]),
      ),
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
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image, size: 48),
                ),
              ),
            ),
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
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Image.network(product.image, fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(label: Text(product.category)),
                  const SizedBox(height: 8),
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
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
