# Fake Store API Client

[![Pub Points](https://img.shields.io/badge/pub%20points-160%2F160-brightgreen)](https://pub.dev/packages/fake_store_api_client)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Cliente Flutter para la [Fake Store API](https://fakestoreapi.com/) con Clean Architecture, patrón Ports & Adapters y manejo funcional de errores.

## Características

- Obtener todos los productos
- Obtener un producto por ID
- Obtener todas las categorías
- Obtener productos por categoría
- Manejo funcional de errores con `Either<Failure, Success>`
- Clean Architecture con separación de capas
- Patrón Ports & Adapters (Arquitectura Hexagonal)
- Sealed classes para pattern matching exhaustivo
- Sin dependencias externas innecesarias (solo `http`)
- Soporte multiplataforma: iOS, Android, Windows, macOS, Linux

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

### Usando el Repositorio Directamente

```dart
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:http/http.dart' as http;

void main() async {
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

  // Obtener todos los productos
  final result = await repository.getAllProducts();

  result.fold(
    (failure) => print('Error: ${failure.message}'),
    (products) {
      print('Se encontraron ${products.length} productos');
      for (final product in products) {
        print('- ${product.title}: \$${product.price}');
      }
    },
  );
}
```

### Usando el Patrón Ports & Adapters

Para aplicaciones con UI, usa `ApplicationController` con tu implementación de `UserInterface`:

```dart
final controller = ApplicationController(
  ui: MiUserInterface(), // Tu implementación
  repository: repository,
);

await controller.executeOption(MenuOption.getAllProducts);
```

## Métodos del Repositorio

### getAllProducts()

Obtiene todos los productos de la tienda.

```dart
final result = await repository.getAllProducts();
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (products) => print('Productos: ${products.length}'),
);
```

### getProductById(int id)

Obtiene un producto específico por su ID.

```dart
final result = await repository.getProductById(1);
result.fold(
  (failure) {
    if (failure is NotFoundFailure) {
      print('Producto no encontrado');
    }
  },
  (product) => print('Encontrado: ${product.title}'),
);
```

### getAllCategories()

Obtiene todas las categorías disponibles.

```dart
final result = await repository.getAllCategories();
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
final result = await repository.getProductsByCategory('electronics');
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (products) => print('Productos en electronics: ${products.length}'),
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
final result = await repository.getProductById(1);

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

- Patrón Ports & Adapters en acción
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

El paquete está construido con Clean Architecture y patrón Ports & Adapters:

```
lib/
├── fake_store_api_client.dart  # API pública
└── src/
    ├── presentation/            # Ports & Adapters
    ├── domain/                  # Entidades y contratos
    ├── data/                    # Implementaciones
    └── core/                    # Utilidades compartidas
```

## Dependencias

- `http`: Cliente HTTP

> **Nota:** Este paquete usa implementaciones propias de `Either` y comparación por valor, sin depender de paquetes externos como `dartz` o `equatable`.

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

## Documentación para Desarrolladores

Para contribuidores y agentes de IA, ver [CLAUDE.md](CLAUDE.md) que contiene:
- Arquitectura detallada del paquete
- Patrones de diseño utilizados
- Guía de mejores prácticas
- Instrucciones para extender el paquete

## Licencia

MIT License - ver archivo [LICENSE](LICENSE) para más detalles.
