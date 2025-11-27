# Fake Store API Client - Example

Aplicación Flutter de ejemplo que demuestra el uso del paquete `fake_store_api_client`.

## Funcionalidades demostradas

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

```dart
import 'package:fake_store_api_client/fake_store_api_client.dart';

// Crear cliente
final client = FakeStoreClient();

// Obtener productos
final result = await client.getProducts();

// Manejar resultado con Either
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (products) => print('Productos: ${products.length}'),
);

// Liberar recursos
client.dispose();
```

## Métodos disponibles

| Método | Descripción |
|--------|-------------|
| `getProducts()` | Obtiene todos los productos |
| `getProductById(int id)` | Obtiene un producto por ID |
| `getCategories()` | Obtiene todas las categorías |
| `getProductsByCategory(String category)` | Obtiene productos por categoría |
