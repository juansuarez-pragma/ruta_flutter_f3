# Fake Store API Client - Example

Aplicación Flutter de ejemplo que demuestra el uso del paquete `fake_store_api_client` con el patrón Ports & Adapters.

## Funcionalidades demostradas

- Patrón Ports & Adapters (Arquitectura Hexagonal)
- Lectura de productos desde la Fake Store API
- Lectura de categorías
- Filtrado de productos por categoría
- Visualización de datos en grid
- Manejo de errores con Either
- Navegación a detalle de producto

## Ejecutar el ejemplo

```bash
cd example
flutter pub get
flutter run
```

## Uso del paquete

### Con Patrón Ports & Adapters (recomendado para UI)

```dart
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:http/http.dart' as http;

// Crear infraestructura
final datasource = FakeStoreDatasource(
  apiClient: ApiClientImpl(
    client: http.Client(),
    baseUrl: 'https://fakestoreapi.com',
    timeout: Duration(seconds: 30),
    responseHandler: HttpResponseHandler(),
  ),
);
final repository = ProductRepositoryImpl(datasource: datasource);

// Crear controlador con tu adapter de UI
final controller = ApplicationController(
  ui: MiFlutterUserInterface(),
  repository: repository,
);

// Ejecutar operaciones
await controller.executeOption(MenuOption.getAllProducts);
```

### Uso directo del repositorio

```dart
final result = await repository.getAllProducts();

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (products) => print('Productos: ${products.length}'),
);
```

## Métodos del repositorio

| Método | Descripción |
|--------|-------------|
| `getAllProducts()` | Obtiene todos los productos |
| `getProductById(int id)` | Obtiene un producto por ID |
| `getAllCategories()` | Obtiene todas las categorías |
| `getProductsByCategory(String category)` | Obtiene productos por categoría |
