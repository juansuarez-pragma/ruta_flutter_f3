# Fake Store API Client

Cliente Flutter para la [Fake Store API](https://fakestoreapi.com/) con Clean Architecture y manejo funcional de errores.

## Características

- Obtener todos los productos
- Obtener un producto por ID
- Obtener todas las categorías
- Obtener productos por categoría
- Manejo funcional de errores con `Either<Failure, Success>`
- Clean Architecture con separación de capas
- Modelos inmutables con Equatable
- Sin generación de código (parseo manual de JSON)

## Instalación

Agrega el paquete a tu `pubspec.yaml`:

```yaml
dependencies:
  fake_store_api_client:
    git:
      url: https://github.com/usuario/fake_store_api_client.git
      ref: main
```

O si tienes el paquete localmente:

```yaml
dependencies:
  fake_store_api_client:
    path: ../fake_store_api_client
```

## Uso Básico

```dart
import 'package:fake_store_api_client/fake_store_api_client.dart';

void main() async {
  // Crear el cliente
  final client = FakeStoreClient();

  // Obtener todos los productos
  final result = await client.getProducts();

  result.fold(
    (failure) => print('Error: ${failure.message}'),
    (products) {
      print('Se encontraron ${products.length} productos');
      for (final product in products) {
        print('- ${product.title}: \$${product.price}');
      }
    },
  );

  // Liberar recursos
  client.dispose();
}
```

## Métodos Disponibles

### getProducts()

Obtiene todos los productos de la tienda.

```dart
final result = await client.getProducts();
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (products) => print('Productos: ${products.length}'),
);
```

### getProductById(int id)

Obtiene un producto específico por su ID.

```dart
final result = await client.getProductById(1);
result.fold(
  (failure) {
    if (failure is NotFoundFailure) {
      print('Producto no encontrado');
    }
  },
  (product) => print('Encontrado: ${product.title}'),
);
```

### getCategories()

Obtiene todas las categorías disponibles.

```dart
final result = await client.getCategories();
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (categories) {
    print('Categorías:');
    for (final category in categories) {
      print('- $category');
    }
  },
);
```

### getProductsByCategory(String category)

Obtiene productos de una categoría específica.

```dart
final result = await client.getProductsByCategory('electronics');
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (products) => print('Productos en electronics: ${products.length}'),
);
```

## Configuración Personalizada

Puedes personalizar la URL base y el timeout:

```dart
final client = FakeStoreClient(
  config: FakeStoreConfig(
    baseUrl: 'https://fakestoreapi.com',
    timeout: Duration(seconds: 60),
  ),
);
```

## Manejo de Errores

El paquete usa el tipo `Either<FakeStoreFailure, T>` para manejo funcional de errores. Los tipos de errores posibles son:

| Tipo | Descripción |
|------|-------------|
| `ConnectionFailure` | Error de conexión de red |
| `ServerFailure` | Error del servidor (5xx) |
| `NotFoundFailure` | Recurso no encontrado (404) |
| `InvalidRequestFailure` | Solicitud inválida (4xx) |

### Ejemplo con Pattern Matching

```dart
final result = await client.getProductById(1);

switch (result) {
  case Left(value: final failure):
    switch (failure) {
      case ConnectionFailure():
        print('Sin conexión a internet');
      case ServerFailure():
        print('Error del servidor');
      case NotFoundFailure():
        print('Producto no encontrado');
      case InvalidRequestFailure():
        print('Solicitud inválida');
    }
  case Right(value: final product):
    print('Producto: ${product.title}');
}
```

## Modelos

### Product

```dart
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final ProductRating rating;
}
```

### ProductRating

```dart
class ProductRating {
  final double rate;  // 0.0 - 5.0
  final int count;    // Número de reseñas
}
```

## Ejemplo Completo

El paquete incluye un ejemplo completo en Flutter que demuestra:

- Listado de productos en grid
- Filtrado por categorías
- Detalle de producto
- Manejo de estados de carga y error

Para ejecutar el ejemplo:

```bash
cd example
flutter run
```

## Arquitectura

El paquete está construido con Clean Architecture:

```
lib/
├── fake_store_api_client.dart  # API pública
└── src/
    ├── client/                  # Fachada pública
    ├── domain/                  # Entidades y contratos
    ├── data/                    # Implementaciones
    └── core/                    # Utilidades compartidas
```

## Dependencias

- `http`: Cliente HTTP
- `dartz`: Tipo Either para manejo funcional de errores
- `equatable`: Comparación de objetos por valor

## Troubleshooting

### Error de TimeoutException en Android Emulator

Si la app muestra `TimeoutException` solo en el emulador Android (pero funciona en Chrome y dispositivos físicos), el problema es la resolución DNS del emulador.

**Solución**: Iniciar el emulador con DNS de Google:

```bash
emulator -avd <nombre-avd> -dns-server 8.8.8.8,8.8.4.4
```

**Diagnóstico**:
```bash
# Si esto falla, es problema de DNS
adb -s emulator-5554 shell ping -c 2 fakestoreapi.com
```

Ver [CLAUDE.md](CLAUDE.md) para más detalles de troubleshooting.

## Licencia

MIT License - ver archivo [LICENSE](LICENSE) para más detalles.
