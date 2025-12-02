import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'adapters/flutter_user_interface.dart';

void main() {
  runApp(const MyApp());
}

/// Aplicación de ejemplo que demuestra el uso del paquete fake_store_api_client
/// con el patrón Ports & Adapters.
///
/// ## Patrón Ports & Adapters (Hexagonal Architecture)
///
/// Esta aplicación demuestra cómo la misma lógica de negocio puede funcionar
/// con diferentes interfaces de usuario (consola, Flutter, web, etc.).
///
/// El [ApplicationController] no conoce los detalles de la UI, solo
/// interactúa a través de la abstracción [UserInterface].
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
///
/// Utiliza el patrón Ports & Adapters para separar la lógica de negocio
/// de la interfaz de usuario.
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  /// Controlador de la aplicación (Ports & Adapters).
  late final ApplicationController _controller;

  /// Adapter de UI para Flutter.
  late final FlutterUserInterface _userInterface;

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
    _initializeController();
    _loadInitialData();
  }

  /// Inicializa el controlador con el adapter de Flutter.
  ///
  /// Aquí se demuestra la inyección de dependencias y el patrón
  /// Ports & Adapters en acción.
  void _initializeController() {
    // Crear el adapter de Flutter con callbacks
    _userInterface = FlutterUserInterface(
      onShowLoading: (message) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      },
      onShowError: (message) {
        setState(() {
          _isLoading = false;
          _errorMessage = message;
        });
        _showSnackBar(message, isError: true);
      },
      onShowSuccess: (message) {
        setState(() => _isLoading = false);
        _showSnackBar(message);
      },
      onShowProducts: (products) {
        setState(() {
          _isLoading = false;
          _products = products;
          _errorMessage = null;
        });
      },
      onShowCategories: (categories) {
        setState(() {
          _categories = categories;
        });
      },
      onPromptCategory: (availableCategories) async {
        // En Flutter, la selección se hace via FilterChips
        // Este callback se usa cuando el controller necesita una categoría
        return _selectedCategory;
      },
    );

    // Crear el repositorio (implementación concreta)
    final datasource = FakeStoreDatasource(
      apiClient: ApiClientImpl(
        client: http.Client(),
        baseUrl: 'https://fakestoreapi.com',
        timeout: const Duration(seconds: 30),
        responseHandler: HttpResponseHandler(),
      ),
    );
    final repository = ProductRepositoryImpl(datasource: datasource);

    // Crear el controlador con inyección de dependencias
    _controller = ApplicationController(
      ui: _userInterface,
      repository: repository,
    );
  }

  /// Carga los datos iniciales usando el controller.
  Future<void> _loadInitialData() async {
    // Cargar categorías
    await _controller.executeOption(MenuOption.getAllCategories);

    // Cargar todos los productos
    await _controller.executeOption(MenuOption.getAllProducts);
  }

  /// Carga productos por categoría usando el controller.
  Future<void> _loadProductsByCategory(String category) async {
    setState(() => _selectedCategory = category);

    // El controller usará el callback onPromptCategory que retorna _selectedCategory
    await _controller.executeOption(MenuOption.getProductsByCategory);
  }

  /// Carga todos los productos.
  Future<void> _loadAllProducts() async {
    setState(() => _selectedCategory = null);
    await _controller.executeOption(MenuOption.getAllProducts);
  }

  /// Muestra un SnackBar con un mensaje.
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Store'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showArchitectureInfo,
            tooltip: 'Ver arquitectura',
          ),
        ],
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

  /// Muestra información sobre la arquitectura.
  void _showArchitectureInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Patrón Ports & Adapters'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Esta app demuestra el patrón Hexagonal Architecture:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('• Port: UserInterface (contrato)'),
              Text('• Adapter: FlutterUserInterface'),
              Text('• Core: ApplicationController'),
              SizedBox(height: 12),
              Text(
                'La misma lógica de negocio puede funcionar con:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Aplicaciones de consola'),
              Text('• Aplicaciones Flutter'),
              Text('• Aplicaciones web'),
              SizedBox(height: 12),
              Text(
                'El controller no conoce Flutter, solo interactúa '
                'con la abstracción UserInterface.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
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
    // Estado de carga
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error
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

    // Sin productos
    if (_products.isEmpty) {
      return const Center(child: Text('No hay productos'));
    }

    // Lista de productos
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
            // Imagen
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
